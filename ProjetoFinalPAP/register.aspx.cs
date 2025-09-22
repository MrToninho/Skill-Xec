using ASPSnippets.GoogleAPI;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net.Mail;
using System.Web.Script.Serialization;

namespace ProjetoFinalPAP
{
    public partial class register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            GoogleConnect.ClientId = "client_id";
            GoogleConnect.ClientSecret = "client_secret";
            GoogleConnect.RedirectUri = Request.Url.AbsoluteUri.Split('?')[0];

            if (!string.IsNullOrEmpty(Request.QueryString["code"]))
            {
                string code = Request.QueryString["code"];
                string json = GoogleConnect.Fetch("me", code);
                GoogleProfile profile = new JavaScriptSerializer().Deserialize<GoogleProfile>(json);

                SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString);
                SqlCommand myCommand = new SqlCommand("google_login_register", myConn);
                myCommand.CommandType = CommandType.StoredProcedure;

                myCommand.Parameters.AddWithValue("@Email", profile.Email);
                myCommand.Parameters.AddWithValue("@Nome", profile.Name);

                SqlParameter userExists = new SqlParameter
                {
                    ParameterName = "@userExists",
                    Direction = ParameterDirection.Output,
                    SqlDbType = SqlDbType.Bit
                };
                myCommand.Parameters.Add(userExists);

                SqlParameter util_id = new SqlParameter
                {
                    ParameterName = "@user_id",
                    Direction = ParameterDirection.Output,
                    SqlDbType = SqlDbType.Int
                };
                myCommand.Parameters.Add(util_id);

                try
                {
                    myConn.Open();
                    myCommand.ExecuteNonQuery();

                    bool UserExists = Convert.ToBoolean(myCommand.Parameters["@userExists"].Value);
                    int utilizador_id = Convert.ToInt32(myCommand.Parameters["@user_id"].Value);

                    myConn.Close();

                    Session["UserID"] = utilizador_id;

                    if (!UserExists)
                    {
                        Response.Redirect("completarConta.aspx", false);
                    }
                    else
                    {
                        lblMensagem.Text = "Bem-vindo de volta!";
                        Response.Redirect("index.aspx", false);
                    }
                }
                catch (Exception ex)
                {
                    lblMensagem.Text = "Erro: " + ex.Message;
                }
            }
        }

        public class GoogleProfile
        {
            public string Id { get; set; }
            public string Name { get; set; }
            public string Picture { get; set; }
            public string Email { get; set; }
            public string Verified_Email { get; set; }
        }

        protected void btnRegisterGoogle_Click(object sender, EventArgs e)
        {
            try
            {
                GoogleConnect.Authorize("profile", "email");
            }
            catch (Exception ex)
            {
                lblMensagem.Text = "Erro: " + ex.Message;
            }
        }

        protected void btnCriarConta_Click(object sender, EventArgs e)
        {
            try
            {
                string firstName = txtFirstName.Text.Trim();
                string lastName = txtLastName.Text.Trim();
                string username = txtUsername.Text.Trim();
                string email = txtEmail.Text.Trim();
                string password = txtPassword.Text.Trim();
                string confirmPassword = txtConfirmPassword.Text.Trim();

                if (password != confirmPassword)
                {
                    lblMensagem.Text = "As palavras-passe não coincidem.";
                    lblMensagem.Visible = true;
                    return;
                }

                var passwordRegex = new System.Text.RegularExpressions.Regex(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,20}$");
                if (!passwordRegex.IsMatch(password))
                {
                    lblMensagem.Text = "A palavra-passe deve ter entre 8-20 caracteres, incluir pelo menos uma letra maiúscula, uma letra minúscula, um número e um símbolo.";
                    lblMensagem.Visible = true;
                    return;
                }

                string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();

                    string checkUsernameQuery = "SELECT COUNT(*) FROM Utilizadores WHERE username = @Username";
                    SqlCommand checkUsernameCmd = new SqlCommand(checkUsernameQuery, conn);
                    checkUsernameCmd.Parameters.AddWithValue("@Username", username);
                    int usernameCount = (int)checkUsernameCmd.ExecuteScalar();

                    if (usernameCount > 0)
                    {
                        lblMensagem.Text = "O nome de utilizador já está em uso. Escolha outro.";
                        lblMensagem.Visible = true;
                        return;
                    }

                    string checkEmailQuery = "SELECT COUNT(*) FROM Utilizadores WHERE email = @Email";
                    SqlCommand checkEmailCmd = new SqlCommand(checkEmailQuery, conn);
                    checkEmailCmd.Parameters.AddWithValue("@Email", email);
                    int emailCount = (int)checkEmailCmd.ExecuteScalar();

                    if (emailCount > 0)
                    {
                        lblMensagem.Text = "O e-mail já está em uso.";
                        lblMensagem.Visible = true;
                        return;
                    }

                    string activationToken = Guid.NewGuid().ToString();

                    string insertQuery = @"
                INSERT INTO Utilizadores (nome, email, password, username, data_registo, ativo, tipo_usuario, activation_token) 
                VALUES (@Nome, @Email, @Password, @Username, @DataRegisto, @Ativo, @TipoUsuario, @ActivationToken)";
                    SqlCommand insertCmd = new SqlCommand(insertQuery, conn);
                    insertCmd.Parameters.AddWithValue("@Nome", $"{firstName} {lastName}");
                    insertCmd.Parameters.AddWithValue("@Email", email);
                    insertCmd.Parameters.AddWithValue("@Password", password);
                    insertCmd.Parameters.AddWithValue("@Username", username);
                    insertCmd.Parameters.AddWithValue("@DataRegisto", DateTime.Now);
                    insertCmd.Parameters.AddWithValue("@Ativo", false); 
                    insertCmd.Parameters.AddWithValue("@TipoUsuario", "user"); 
                    insertCmd.Parameters.AddWithValue("@ActivationToken", activationToken);
                    insertCmd.ExecuteNonQuery();

                    string activationLink = $"http://localhost:63223/ativarConta.aspx?token={activationToken}";
                    EnviarEmailAtivacao(email, activationLink);

                    lblMensagem.Text = "Conta criada com sucesso! Por favor, verifique o seu e-mail para ativar a conta.";
                    lblMensagem.ForeColor = System.Drawing.Color.Green;
                    lblMensagem.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblMensagem.Text = "Erro ao criar conta: " + ex.Message;
                lblMensagem.ForeColor = System.Drawing.Color.Red;
                lblMensagem.Visible = true;
            }
        }
        private void EnviarEmailAtivacao(string email, string activationLink)
        {
            try
            {
                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("antonio.xavier.t0127771@edu.atec.pt", "Skill Xec");
                mail.To.Add(email);
                mail.Subject = "Ative sua conta no Skill Xec";
                mail.Body = $@"
            Olá,<br><br>
            Obrigado por se registar no Skill Xec!<br><br>
            Por favor, clique no link abaixo para ativar a sua conta:<br>
            <a href='{activationLink}'>Ativar Conta</a><br><br>
            Se você não fez este registo, ignore este email.<br><br>
            Cumprimentos,<br>Equipe Skill Xec";
                mail.IsBodyHtml = true;

                SmtpClient smtp = new SmtpClient("smtp.office365.com", 587);
                smtp.Credentials = new System.Net.NetworkCredential("antonio.xavier.t0127771@edu.atec.pt", "Xavi1234");
                smtp.EnableSsl = true;

                smtp.Send(mail);
            }
            catch (Exception ex)
            {
                lblMensagem.Text = "Erro ao enviar o e-mail de ativação: " + ex.Message;
                lblMensagem.ForeColor = System.Drawing.Color.Red;
                lblMensagem.Visible = true;
            }
        }


    }
}

