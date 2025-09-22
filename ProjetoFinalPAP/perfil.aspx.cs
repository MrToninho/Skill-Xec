using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;

namespace ProjetoFinalPAP
{
    public partial class perfil : System.Web.UI.Page
    {
        private const string DefaultImagePath = "imagens/imagensPerfil/User-avatar.png";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userId"] == null)
            {
                Response.Redirect("login.aspx");
            }

            if (!IsPostBack)
            {
                CarregarPerfil();
            }
        }

        private void CarregarPerfil()
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT nome, username, email, tipo_usuario, ISNULL(imagem_perfil, @DefaultImage) AS imagem_perfil " +
                               "FROM Utilizadores WHERE id = @UserId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
                cmd.Parameters.AddWithValue("@DefaultImage", DefaultImagePath);

                try
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        txtName.Text = reader["nome"].ToString();
                        txtUsername.Text = reader["username"].ToString();
                        txtEmail.Text = reader["email"].ToString();
                        imgProfile.ImageUrl = string.IsNullOrEmpty(reader["imagem_perfil"].ToString())
                            ? DefaultImagePath
                            : reader["imagem_perfil"].ToString();

                        string tipoUsuario = reader["tipo_usuario"].ToString();
                        btnAdminPanel.Visible = tipoUsuario.Equals("admin", StringComparison.OrdinalIgnoreCase);
                    }
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Erro ao carregar perfil. Por favor, tente novamente.');</script>");
                }
            }
        }

        protected void btnAdminPanel_Click(object sender, EventArgs e)
        {
            Response.Redirect("admin.aspx");
        }


        protected void btnSave_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string name = txtName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            lblMensagem.Visible = true; 

            if (password != confirmPassword)
            {
                lblMensagem.Text = "As passwords não coincidem.";
                lblMensagem.ForeColor = System.Drawing.Color.Red;
                return;
            }

            if (!string.IsNullOrEmpty(password) && !ValidarPassword(password))
            {
                lblMensagem.Text = "A password deve ter entre 8-20 caracteres, incluir maiúsculas, minúsculas, números e símbolos.";
                lblMensagem.ForeColor = System.Drawing.Color.Red;
                return;
            }

            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();

                    string checkQuery = "SELECT COUNT(*) FROM Utilizadores WHERE username = @Username AND id != @UserId";
                    SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                    checkCmd.Parameters.AddWithValue("@Username", username);
                    checkCmd.Parameters.AddWithValue("@UserId", Session["userId"]);

                    int count = (int)checkCmd.ExecuteScalar();
                    if (count > 0)
                    {
                        lblMensagem.Text = "Nome de utilizador em uso. Por favor, escolha outro.";
                        lblMensagem.ForeColor = System.Drawing.Color.Red;
                        return;
                    }

                    string updateQuery = "UPDATE Utilizadores SET nome = @Name, username = @Username, email = @Email";
                    if (!string.IsNullOrEmpty(password))
                    {
                        updateQuery += ", password = @Password";
                    }
                    updateQuery += " WHERE id = @UserId";

                    SqlCommand cmd = new SqlCommand(updateQuery, conn);
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@UserId", Session["userId"]);

                    if (!string.IsNullOrEmpty(password))
                    {
                        cmd.Parameters.AddWithValue("@Password", password);
                    }

                    cmd.ExecuteNonQuery();

                    lblMensagem.Text = "Perfil atualizado com sucesso.";
                    lblMensagem.ForeColor = System.Drawing.Color.Green;
                }
                catch (Exception ex)
                {
                    lblMensagem.Text = "Erro ao atualizar perfil. Por favor, tente novamente.";
                    lblMensagem.ForeColor = System.Drawing.Color.Red;
                    System.Diagnostics.Debug.WriteLine("Erro: " + ex.Message);
                }
            }
        }

        private bool ValidarPassword(string password)
        {
            if (password.Length < 8 || password.Length > 20) return false;
            if (!System.Text.RegularExpressions.Regex.IsMatch(password, @"[A-Z]")) return false;
            if (!System.Text.RegularExpressions.Regex.IsMatch(password, @"[a-z]")) return false;
            if (!System.Text.RegularExpressions.Regex.IsMatch(password, @"[0-9]")) return false;
            if (!System.Text.RegularExpressions.Regex.IsMatch(password, @"[\W_]")) return false;
            return true;
        }


        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (fileUpload.HasFile)
            {
                string[] validExtensions = { ".jpg", ".jpeg", ".png" };
                string fileExtension = Path.GetExtension(fileUpload.FileName).ToLower();

                if (!Array.Exists(validExtensions, ext => ext == fileExtension))
                {
                    Response.Write("<script>alert('Por favor, selecione um tipo de imagem válido (JPG, JPEG, ou PNG).');</script>");
                    return;
                }

                try
                {
                    string fileName = Path.GetFileName(fileUpload.FileName);
                    string folderPath = Server.MapPath("~/imagens/imagensPerfil/");
                    string filePath = Path.Combine(folderPath, fileName);

                    if (!Directory.Exists(folderPath))
                    {
                        Directory.CreateDirectory(folderPath);
                    }

                    fileUpload.SaveAs(filePath);

                    string relativePath = "imagens/imagensPerfil/" + fileName;

                    string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;
                    using (SqlConnection conn = new SqlConnection(connString))
                    {
                        string updateQuery = "UPDATE Utilizadores SET imagem_perfil = @ImagePath WHERE id = @UserId";
                        SqlCommand cmd = new SqlCommand(updateQuery, conn);
                        cmd.Parameters.AddWithValue("@ImagePath", relativePath);
                        cmd.Parameters.AddWithValue("@UserId", Session["userId"]);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }

                    imgProfile.ImageUrl = relativePath;
                    Response.Write("<script>alert('Imagem de perfil atualizada com sucesso.');</script>");
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Erro ao atualizar a imagem. Por favor, tente novamente.');</script>");
                    System.Diagnostics.Debug.WriteLine("Erro: " + ex.Message);
                }
            }
            else
            {
                Response.Write("<script>alert('Por favor, selecione uma imagem para dar upload.');</script>");
            }
        }

        protected void btnRemoveImage_Click(object sender, EventArgs e)
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "UPDATE Utilizadores SET imagem_perfil = @DefaultImage WHERE id = @UserId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@DefaultImage", DefaultImagePath);
                cmd.Parameters.AddWithValue("@UserId", Session["userId"]);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    imgProfile.ImageUrl = DefaultImagePath;
                    Response.Write("<script>alert('A imagem de perfil foi removida com sucesso.');</script>");
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Erro ao remover a imagem. Por favor, tente novamente.');</script>");
                    System.Diagnostics.Debug.WriteLine("Erro: " + ex.Message);
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("login.aspx");
        }
    }
}
