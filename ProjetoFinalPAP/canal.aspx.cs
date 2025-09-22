using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.Services;

namespace ProjetoFinalPAP
{
    public partial class canal : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string userId = Request.QueryString["userId"];
                if (string.IsNullOrEmpty(userId))
                {
                    userId = Session["UserID"]?.ToString();
                }

                if (string.IsNullOrEmpty(userId))
                {
                    Response.Redirect("login.aspx");
                }
                else
                {
                    ViewState["IsUserOwnChannel"] = (userId == Session["UserID"]?.ToString());

                    LoadUserData(userId);
                    LoadUserVideos(userId);

                    if (Session["UserID"] != null)
                    {
                        LoadSubscriptionStatus(userId);
                    }
                    else
                    {
                        ViewState["IsSubscribed"] = false;
                        btnSubscribe.Visible = true;
                        btnSubscribe.Text = "Subscrever";
                        btnSubscribe.Attributes["onclick"] = "showLoginPrompt();";
                    }

                    int subscriberCount = GetSubscriberCount(userId);
                    subscriberCountDiv.Text = $"{subscriberCount} Subscritores";
                }
            }
        }


        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("login.aspx");
            }
            else
            {
                Response.Redirect("upload.aspx");
            }
        }

        private void LoadUserData(string userId)
        {
            string connString = ConfigurationManager.ConnectionStrings["skillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT username, imagem_perfil, banner_url FROM utilizadores WHERE id = @UserID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    string username = reader["username"] != DBNull.Value ? reader["username"].ToString() : "User";
                    string imagePath = reader["imagem_perfil"] != DBNull.Value ? reader["imagem_perfil"].ToString() : "imagens/user-avatar.png";
                    string bannerPath = reader["banner_url"] != DBNull.Value ? reader["banner_url"].ToString() : "imagens/banners/banner-placeholder.png";

                    Page.Title = $"Skill Xec - {username}";

                    if (channelName != null)
                        channelName.InnerText = username;

                    if (imgProfile != null)
                        imgProfile.Src = imagePath;

                    if (bannerImage != null)
                        bannerImage.Src = bannerPath;

                    bool isUserOwnChannel = (userId == Session["UserID"]?.ToString());

                    btnChangeBanner.Visible = isUserOwnChannel;
                }
                conn.Close();
            }
        }

        private void LoadUserVideos(string userId)
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
                SELECT v.id, v.titulo, v.visualizacoes, v.data_upload, v.thumbnail, 
                       ISNULL(c.nome, 'Sem Categoria') AS categoria_nome
                FROM videos v
                LEFT JOIN categorias c ON v.categoria = c.id
                WHERE v.utilizador_id = @UserID 
                ORDER BY v.data_upload DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                videosContainer.InnerHtml = "";

                bool isUserOwnChannel = (bool)ViewState["IsUserOwnChannel"];

                while (reader.Read())
                {
                    string videoId = reader["id"].ToString();
                    string titulo = reader["titulo"].ToString();
                    int visualizacoes = Convert.ToInt32(reader["visualizacoes"]);
                    string dataUpload = Convert.ToDateTime(reader["data_upload"]).ToString("dd MMMM yyyy");
                    string thumbnailUrl = reader["thumbnail"].ToString();
                    string categoriaNome = reader["categoria_nome"]?.ToString() ?? "Sem Categoria";

                    string editButtonHtml = isUserOwnChannel
                        ? $@"<div class='video-actions'>
                                <a href='editar-video.aspx?id={videoId}' class='edit-btn'>Editar</a>
                           </div>"
                        : "";

                    videosContainer.InnerHtml += $@"
                    <div class='video-card'>
                        <a href='watch.aspx?id={videoId}'>
                            <img src='{thumbnailUrl}' alt='{titulo}' style='width:100%; height:auto;' />
                        </a>
                        <h4>{titulo}</h4>
                        <p>{visualizacoes} views | {dataUpload}</p>
                        <p><strong>Categoria:</strong> {categoriaNome}</p>
                        {editButtonHtml}
                    </div>";
                }
                conn.Close();
            }
        }

        protected void btnUploadBanner_Click(object sender, EventArgs e)
        {
            if (fileBanner.HasFile)
            {
                string fileExtension = Path.GetExtension(fileBanner.FileName).ToLower();
                string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif" };

                if (Array.Exists(allowedExtensions, ext => ext == fileExtension))
                {
                    try
                    {
                        string folderPath = Server.MapPath("~/imagens/banners/");
                        if (!Directory.Exists(folderPath))
                        {
                            Directory.CreateDirectory(folderPath);
                        }

                        string fileName = Path.GetFileName(fileBanner.FileName);
                        string filePath = folderPath + fileName;

                        fileBanner.SaveAs(filePath);

                        string userId = Session["UserID"].ToString();
                        string connString = ConfigurationManager.ConnectionStrings["skillXec"].ConnectionString;

                        using (SqlConnection conn = new SqlConnection(connString))
                        {
                            string query = "UPDATE utilizadores SET banner_url = @BannerPath WHERE id = @UserID";
                            SqlCommand cmd = new SqlCommand(query, conn);
                            cmd.Parameters.AddWithValue("@BannerPath", "imagens/banners/" + fileName);
                            cmd.Parameters.AddWithValue("@UserID", userId);

                            conn.Open();
                            cmd.ExecuteNonQuery();
                            conn.Close();
                        }

                        bannerImage.Src = "imagens/banners/" + fileName;
                        Response.Write("<script>alert('Banner atualizado com sucesso!');</script>");
                    }
                    catch (Exception ex)
                    {
                        Response.Write($"<script>alert('Erro ao salvar o banner: {ex.Message}');</script>");
                    }
                }
                else
                {
                    Response.Write("<script>alert('Por favor, selecione um arquivo válido (.jpg, .jpeg, .png, .gif).');</script>");
                }
            }
            else
            {
                Response.Write("<script>alert('Por favor, selecione uma imagem.');</script>");
            }
        }


        private void ManageSubscription(string userId)
        {
            if (string.IsNullOrEmpty(Session["UserID"]?.ToString()))
            {
                Response.Write("<script>alert('Por favor, inicie a sessão para subscrever este canal.');</script>");
                return;
            }

            string currentUserId = Session["UserID"].ToString();

            if (userId == currentUserId)
            {
                Response.Write("<script>alert('Não pode subscrever o seu próprio canal.');</script>");
                return;
            }

            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string checkQuery = "SELECT COUNT(*) FROM subscricoes WHERE subscritor_id = @CurrentUserId AND utilizador_id = @UserId";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@CurrentUserId", currentUserId);
                checkCmd.Parameters.AddWithValue("@UserId", userId);

                conn.Open();
                int isSubscribed = (int)checkCmd.ExecuteScalar();
                conn.Close();

                if (isSubscribed > 0)
                {
                    string deleteQuery = "DELETE FROM subscricoes WHERE subscritor_id = @CurrentUserId AND utilizador_id = @UserId";
                    SqlCommand deleteCmd = new SqlCommand(deleteQuery, conn);
                    deleteCmd.Parameters.AddWithValue("@CurrentUserId", currentUserId);
                    deleteCmd.Parameters.AddWithValue("@UserId", userId);

                    conn.Open();
                    deleteCmd.ExecuteNonQuery();
                    conn.Close();

                    Response.Write("<script>alert('Subscrição cancelada com sucesso.');</script>");
                }
                else
                {
                    string insertQuery = "INSERT INTO subscricoes (subscritor_id, utilizador_id, data_subscricao) VALUES (@CurrentUserId, @UserId, @DataSubscricao)";
                    SqlCommand insertCmd = new SqlCommand(insertQuery, conn);
                    insertCmd.Parameters.AddWithValue("@CurrentUserId", currentUserId);
                    insertCmd.Parameters.AddWithValue("@UserId", userId);
                    insertCmd.Parameters.AddWithValue("@DataSubscricao", DateTime.Now);

                    conn.Open();
                    insertCmd.ExecuteNonQuery();
                    conn.Close();

                    Response.Write("<script>alert('Subscrito com sucesso.');</script>");
                }
            }

            LoadSubscriptionStatus(userId);
        }


        private void LoadSubscriptionStatus(string userId)
        {
            string currentUserId = Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(currentUserId) || userId == currentUserId)
            {
                btnSubscribe.Visible = false;
                return;
            }

            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT COUNT(*) FROM subscricoes WHERE subscritor_id = @CurrentUserId AND utilizador_id = @UserId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@CurrentUserId", currentUserId);
                cmd.Parameters.AddWithValue("@UserId", userId);

                conn.Open();
                int isSubscribed = (int)cmd.ExecuteScalar();
                conn.Close();

                if (isSubscribed > 0)
                {
                    btnSubscribe.Text = "Cancelar Subscrição";
                    btnSubscribe.CssClass = "unsubscribe-btn";
                }
                else
                {
                    btnSubscribe.Text = "Subscrever";
                    btnSubscribe.CssClass = "subscribe-btn";
                }

                btnSubscribe.Visible = true;
            }
        }


        [WebMethod]
        public static string UpdateSubscriberCount(string userId)
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;
            int subscriberCount = 0;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT COUNT(*) FROM subscricoes WHERE utilizador_id = @UserId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);

                conn.Open();
                subscriberCount = (int)cmd.ExecuteScalar();
                conn.Close();
            }

            return subscriberCount.ToString();
        }

        protected void Subscribe_Click(object sender, EventArgs e)
        {
            string userId = Request.QueryString["userId"];
            if (!string.IsNullOrEmpty(userId))
            {
                ManageSubscription(userId);

                int subscriberCount = GetSubscriberCount(userId);
                subscriberCountDiv.Text = $"{subscriberCount} Subscritores";
            }
        }


        private int GetSubscriberCount(string userId)
        {
            int count = 0;
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT COUNT(*) FROM subscricoes WHERE utilizador_id = @UserId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);

                conn.Open();
                count = (int)cmd.ExecuteScalar();
                conn.Close();
            }

            return count;
        }


    }
}