using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net.Mail;
using System.Text.RegularExpressions;

namespace ProjetoFinalPAP
{
    public partial class recuperarPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string token = Request.QueryString["token"];
                if (!string.IsNullOrEmpty(token))
                {
                    recuperarPasswordEmailForm.Visible = false;
                    redefinirPasswordForm.Visible = true;
                }
            }
        }

        protected void btnRecuperar_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();

            if (!string.IsNullOrEmpty(email))
            {
                string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    try
                    {
                        conn.Open();

                        string checkQuery = "SELECT COUNT(*) FROM Utilizadores WHERE email = @Email";
                        using (SqlCommand cmd = new SqlCommand(checkQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@Email", email);
                            int count = (int)cmd.ExecuteScalar();

                            if (count == 0)
                            {
                                lblMensagemRecuperar.Text = "Este email não está registado.";
                                lblMensagemRecuperar.ForeColor = System.Drawing.Color.Red;
                                lblMensagemRecuperar.Visible = true;
                                return;
                            }
                        }

                        string token = Guid.NewGuid().ToString();
                        string insertTokenQuery = "INSERT INTO tokens_recuperacao (email, token, data_expiracao) VALUES (@Email, @Token, @DataExpiracao)";
                        using (SqlCommand cmd = new SqlCommand(insertTokenQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@Email", email);
                            cmd.Parameters.AddWithValue("@Token", token);
                            cmd.Parameters.AddWithValue("@DataExpiracao", DateTime.Now.AddHours(1));
                            cmd.ExecuteNonQuery();
                        }

                        string recoveryLink = $"http://localhost:63223/recuperarPassword.aspx?token={token}";
                        EnviarEmailRecuperacao(email, recoveryLink);

                        lblMensagemRecuperar.Text = "Um email de recuperação foi enviado. Por favor, verifique a sua caixa de entrada.";
                        lblMensagemRecuperar.ForeColor = System.Drawing.Color.Green;
                        lblMensagemRecuperar.Visible = true;
                    }
                    catch (Exception ex)
                    {
                        lblMensagemRecuperar.Text = "Erro ao tentar recuperar a palavra-passe: " + ex.Message;
                        lblMensagemRecuperar.ForeColor = System.Drawing.Color.Red;
                        lblMensagemRecuperar.Visible = true;
                    }
                }
            }
            else
            {
                lblMensagemRecuperar.Text = "Por favor, insira o seu email.";
                lblMensagemRecuperar.ForeColor = System.Drawing.Color.Red;
                lblMensagemRecuperar.Visible = true;
            }
        }

        protected void btnAlterarPassword_Click(object sender, EventArgs e)
        {
            string token = Request.QueryString["token"];
            string novaPassword = txtNovaPassword.Text.Trim();
            string confirmarPassword = txtConfirmarPassword.Text.Trim();

            lblMensagemRedefinir.Visible = false;

            if (string.IsNullOrEmpty(token))
            {
                lblMensagemRedefinir.Text = "Token inválido ou ausente.";
                lblMensagemRedefinir.ForeColor = System.Drawing.Color.Red;
                lblMensagemRedefinir.Visible = true;
                return;
            }

            if (novaPassword != confirmarPassword)
            {
                lblMensagemRedefinir.Text = "As palavras-passe não coincidem. Por favor, tente novamente.";
                lblMensagemRedefinir.ForeColor = System.Drawing.Color.Red;
                lblMensagemRedefinir.Visible = true;
                return;
            }

            if (!ValidarPassword(novaPassword))
            {
                lblMensagemRedefinir.Text = "A palavra-passe deve ter entre 8-20 caracteres. <br>Incluir pelo menos uma letra maiúscula, uma letra minúscula, um número e um símbolo.";
                lblMensagemRedefinir.ForeColor = System.Drawing.Color.Red;
                lblMensagemRedefinir.Visible = true;
                return;
            }


            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();

                    string queryEmail = "SELECT Email FROM tokens_recuperacao WHERE Token = @Token AND data_expiracao > GETDATE()";
                    string email = null;

                    using (SqlCommand cmd = new SqlCommand(queryEmail, conn))
                    {
                        cmd.Parameters.AddWithValue("@Token", token);
                        email = cmd.ExecuteScalar()?.ToString();
                    }

                    if (string.IsNullOrEmpty(email))
                    {
                        lblMensagemRedefinir.Text = "Token inválido ou expirado.";
                        lblMensagemRedefinir.ForeColor = System.Drawing.Color.Red;
                        lblMensagemRedefinir.Visible = true;
                        return;
                    }

                    string queryUpdate = "UPDATE Utilizadores SET password = @NovaPassword WHERE email = @Email";
                    using (SqlCommand cmd = new SqlCommand(queryUpdate, conn))
                    {
                        cmd.Parameters.AddWithValue("@NovaPassword", novaPassword);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.ExecuteNonQuery();
                    }

                    string queryDeleteToken = "DELETE FROM tokens_recuperacao WHERE Token = @Token";
                    using (SqlCommand cmd = new SqlCommand(queryDeleteToken, conn))
                    {
                        cmd.Parameters.AddWithValue("@Token", token);
                        cmd.ExecuteNonQuery();
                    }

                    lblMensagemRedefinir.Text = "Palavra-passe alterada com sucesso!";
                    lblMensagemRedefinir.ForeColor = System.Drawing.Color.Green;
                    lblMensagemRedefinir.Visible = true;

                    Response.AddHeader("REFRESH", "1;URL=login.aspx");
                }
                catch (Exception ex)
                {
                    lblMensagemRedefinir.Text = "Erro ao alterar a palavra-passe: " + ex.Message;
                    lblMensagemRedefinir.ForeColor = System.Drawing.Color.Red;
                    lblMensagemRedefinir.Visible = true;
                }
            }
        }

        private bool ValidarPassword(string password)
        {
            var regex = new System.Text.RegularExpressions.Regex(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,20}$");
            return regex.IsMatch(password);
        }



        private void EnviarEmailRecuperacao(string email, string recoveryLink)
        {
            try
            {
                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("antonio.xavier.t0127771@edu.atec.pt", "Skill Xec");
                mail.To.Add(email);
                mail.Subject = "Recuperação de Palavra-Passe - Skill Xec";
                mail.Body = $@"
                    Olá,<br><br>
                    Recebemos um pedido para redefinir a sua palavra-passe.<br>
                    Clique no link abaixo para redefinir:<br><br>
                    <a href='{recoveryLink}'>Redefinir Palavra-Passe</a><br><br>
                    Se não fez este pedido, por favor ignore este email.<br><br>
                    Cumprimentos,<br>Equipa Skill Xec";
                mail.IsBodyHtml = true;

                SmtpClient smtp = new SmtpClient("smtp.office365.com", 587);
                smtp.Credentials = new System.Net.NetworkCredential("antonio.xavier.t0127771@edu.atec.pt", "Xavi1234");
                smtp.EnableSsl = true;

                smtp.Send(mail);
            }
            catch (Exception ex)
            {
                lblMensagemRecuperar.Text = "Erro ao enviar o email de recuperação: " + ex.Message;
                lblMensagemRecuperar.ForeColor = System.Drawing.Color.Red;
                lblMensagemRecuperar.Visible = true;
            }
        }

        
    }
}
