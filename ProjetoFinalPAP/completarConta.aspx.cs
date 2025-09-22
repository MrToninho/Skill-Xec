using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

namespace ProjetoFinalPAP
{
    public partial class completarConta : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("login.aspx");
            }
        }

        protected void btnCompleteAccount_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            if (password != confirmPassword)
            {
                lblMensagem.Text = "As palavras-passe não coincidem.";
                lblMensagem.Visible = true;
                return;
            }

            var passwordRegex = new Regex(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=[\]{};':\\|,.<>/?]).{8,20}$");
            if (!passwordRegex.IsMatch(password))
            {
                lblMensagem.Text = "A palavra-passe deve ter entre 8-20 caracteres, incluir pelo menos uma letra maiúscula, uma letra minúscula, um número e um símbolo.";
                lblMensagem.Visible = true;
                return;
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
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

                    string updateQuery = "UPDATE Utilizadores SET username = @Username, password = HASHBYTES('SHA2_256', @Password), ativo = 1 WHERE id = @UserId";
                    SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
                    updateCmd.Parameters.AddWithValue("@Username", username);
                    updateCmd.Parameters.AddWithValue("@Password", password);
                    updateCmd.Parameters.AddWithValue("@UserId", Session["UserID"]);

                    updateCmd.ExecuteNonQuery();

                    lblMensagem.Text = "Conta atualizada com sucesso!";
                    lblMensagem.Visible = true;

                    Response.Redirect("perfil.aspx", false);
                }
                catch (Exception ex)
                {
                    lblMensagem.Text = "Erro ao atualizar a conta: " + ex.Message;
                    lblMensagem.Visible = true;
                }
            }
        }
    }
}
