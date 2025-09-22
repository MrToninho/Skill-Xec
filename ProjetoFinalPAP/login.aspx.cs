using ASPSnippets.GoogleAPI;
using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Data;

namespace ProjetoFinalPAP
{
    public partial class login : System.Web.UI.Page
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

                SqlParameter userExists = new SqlParameter();
                userExists.ParameterName = "@userExists";
                userExists.Direction = ParameterDirection.Output;
                userExists.SqlDbType = SqlDbType.Bit;
                myCommand.Parameters.Add(userExists);

                SqlParameter util_id = new SqlParameter();
                util_id.ParameterName = "@user_id";
                util_id.Direction = ParameterDirection.Output;
                util_id.SqlDbType = SqlDbType.Int;
                myCommand.Parameters.Add(util_id);

                myCommand.Connection = myConn;

                myConn.Open();
                myCommand.ExecuteNonQuery();

                bool UserExists = Convert.ToBoolean(myCommand.Parameters["@userExists"].Value);
                int utilizador_id = Convert.ToInt32(myCommand.Parameters["@user_id"].Value);

                myConn.Close();

                if (!UserExists)
                {
                    lblMensagem.Text = "Utilizador registado e login efetuado com sucesso!";
                }
                else
                {
                    lblMensagem.Text = "Bem-vindo de volta!";
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

        protected void btnLoginGoogle_Click(object sender, EventArgs e)
        {
            try
            {
                GoogleConnect.Authorize("profile", "email");
            }
            catch (Exception ex)
            {
                lblMensagem.Text = "An error occurred: " + ex.Message;
            }
        }


        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT id, nome, tipo_usuario, ativo FROM utilizadores WHERE email = @Email AND password = @Password";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        bool isAtivo = Convert.ToBoolean(reader["ativo"]);
                        if (!isAtivo)
                        {
                            lblMensagem.Text = "A sua conta ainda não foi ativada. <br> Verifique o seu e-mail para ativar a conta.";
                            lblMensagem.Visible = true;
                            return;
                        }

                        Session["userId"] = reader["id"];
                        Session["userName"] = reader["nome"];
                        Session["tipoUsuario"] = reader["tipo_usuario"].ToString();

                        Response.Redirect("index.aspx", false);
                    }
                    else
                    {
                        lblMensagem.Text = "E-mail ou palavra-passe incorretos.";
                        lblMensagem.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    lblMensagem.Text = "Erro ao fazer login: " + ex.Message;
                    lblMensagem.Visible = true;
                }
            }
        }

    }
}
