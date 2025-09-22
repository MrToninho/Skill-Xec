using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ProjetoFinalPAP
{
    public partial class ativarConta : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string token = Request.QueryString["token"];

            if (!string.IsNullOrEmpty(token))
            {
                string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    try
                    {
                        conn.Open();
                        string query = "UPDATE Utilizadores SET ativo = 1, activation_token = NULL WHERE activation_token = @Token AND ativo = 0";
                        SqlCommand cmd = new SqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@Token", token);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            lblSucesso.Text = "Conta ativada com sucesso! Você pode agora fazer login.";
                            lblSucesso.Visible = true;
                            btnVoltarLogin.Visible = true;
                        }
                        else
                        {
                            lblMensagem.Text = "Token inválido ou conta já ativada.";
                            lblMensagem.Visible = true;
                        }
                    }
                    catch (Exception ex)
                    {
                        lblMensagem.Text = "Erro ao ativar a conta: " + ex.Message;
                        lblMensagem.Visible = true;
                    }
                }
            }
            else
            {
                lblMensagem.Text = "Token não encontrado.";
                lblMensagem.Visible = true;
            }
        }

        protected void btnVoltarLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("login.aspx");
        }
    }
}
