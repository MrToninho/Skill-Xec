using Newtonsoft.Json;
using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Net;

namespace ProjetoFinalPAP
{
    public partial class watch : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Cache.SetNoStore();
            Response.Cache.SetExpires(DateTime.MinValue);
            Response.Cache.SetCacheability(HttpCacheability.NoCache);

            if (Request.HttpMethod == "POST" && Request.ContentType.Contains("application/json"))
            {
                string jsonResponse = string.Empty;

                try
                {
                    dynamic data = null;
                    string action = null;

                    using (var reader = new System.IO.StreamReader(Request.InputStream))
                    {
                        string json = reader.ReadToEnd();
                        data = JsonConvert.DeserializeObject(json);
                        action = data?.action;
                    }

                    if (string.IsNullOrEmpty(action))
                    {
                        throw new Exception("Ação inválida ou não especificada.");
                    }

                    if (action == "delete")
                    {
                        int commentId = data.comment_id;
                        DeleteComment(commentId);
                        jsonResponse = JsonConvert.SerializeObject(new { success = true });
                    }
                    else if (action == "react")
                    {
                        string reactVideoId = data.video_id;
                        string reactionType = data.reaction_type;

                        string userId = Session["UserID"]?.ToString();
                        if (string.IsNullOrEmpty(userId))
                        {
                            throw new Exception("Usuário não autenticado.");
                        }

                        ReactToVideo(reactVideoId, userId, reactionType);

                        int likes, dislikes;
                        GetReactions(reactVideoId, out likes, out dislikes);

                        jsonResponse = JsonConvert.SerializeObject(new { success = true, likes, dislikes });
                    }
                    else if (action == "getReactions")
                    {
                        string reactionVideoId = data.video_id;

                        int likes, dislikes;
                        GetReactions(reactionVideoId, out likes, out dislikes);

                        jsonResponse = JsonConvert.SerializeObject(new { success = true, likes, dislikes });
                    }
                    else if (action == "toggleFavorite")
                    {
                        string favoriteVideoId = data.video_id;

                        string userId = Session["UserID"]?.ToString();
                        if (string.IsNullOrEmpty(userId))
                        {
                            throw new Exception("Usuário não autenticado.");
                        }

                        ToggleFavorite(favoriteVideoId, userId);
                        jsonResponse = JsonConvert.SerializeObject(new { success = true });
                    }
                    else if (action == "checkFavorite")
                    {
                        string favoriteVideoId = data.video_id;

                        string userId = Session["UserID"]?.ToString();
                        if (string.IsNullOrEmpty(userId))
                        {
                            throw new Exception("Usuário não autenticado.");
                        }

                        bool isFavorite = CheckFavoriteStatus(favoriteVideoId, userId);
                        jsonResponse = JsonConvert.SerializeObject(new { success = true, isFavorite });
                    }
                    else
                    {
                        throw new Exception("Ação desconhecida.");
                    }
                }
                catch (Exception ex)
                {
                    Response.StatusCode = 500;
                    jsonResponse = JsonConvert.SerializeObject(new { success = false, message = ex.Message });
                }
                finally
                {
                    Response.ContentType = "application/json";
                    Response.Write(jsonResponse);
                    Response.End();
                }
            }

            string videoId = Request.QueryString["id"];
            if (string.IsNullOrEmpty(videoId))
            {
                Response.Redirect("index.aspx");
                return;
            }

            IncrementViewCount(videoId);
            if (Session["UserID"] != null)
            {
                int userId = int.Parse(Session["UserID"].ToString());
                int videoIdInt = int.Parse(videoId);
                RegistarNoHistorico(userId, videoIdInt);
            }

            if (!IsPostBack)
            {
                LoadVideoDetails();

                string userId = Session["UserID"]?.ToString();
                string queryVideoId = Request.QueryString["id"];

                if (!string.IsNullOrEmpty(userId) && !string.IsNullOrEmpty(queryVideoId))
                {
                    string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

                    using (SqlConnection conn = new SqlConnection(connString))
                    {
                        string reactionQuery = @"
                    SELECT 
                        CASE 
                            WHEN likes > 0 THEN 'like'
                            WHEN dislikes > 0 THEN 'dislike'
                            ELSE NULL 
                        END AS tipo_reacao
                    FROM videos 
                    WHERE id = @VideoID";

                        SqlCommand cmd = new SqlCommand(reactionQuery, conn);
                        cmd.Parameters.AddWithValue("@VideoID", queryVideoId);

                        conn.Open();
                        string userReaction = cmd.ExecuteScalar()?.ToString();
                        conn.Close();

                        Session["UserReaction"] = userReaction;
                    }
                }

                if (!string.IsNullOrEmpty(userId) && !string.IsNullOrEmpty(videoId))
                {
                    bool isFavorite = CheckFavoriteStatus(videoId, userId);

                    ClientScript.RegisterStartupScript(this.GetType(), "SetFavoriteState",
                        $"document.getElementById('favoriteButton').classList.toggle('active', {isFavorite.ToString().ToLower()});", true);
                }

                LoadComments();
            }
        }




        protected void IncrementViewCount(string videoId)
            {
            if (string.IsNullOrEmpty(videoId)) return;

            string userId = Session["UserID"]?.ToString();
            string userIdentifier;

            if (!string.IsNullOrEmpty(userId))
            {
                userIdentifier = "UserID_" + userId;
            }
            else
            {
                string userIP = GetUserIP();
                userIdentifier = "IP_" + userIP;
            }

            HttpCookie cookie = Request.Cookies["VideoViewed_" + videoId + "_" + userIdentifier];
            if (cookie == null)
            {
                string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = "UPDATE videos SET visualizacoes = visualizacoes + 1 WHERE id = @VideoID";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@VideoID", videoId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }

                HttpCookie viewCookie = new HttpCookie("VideoViewed_" + videoId + "_" + userIdentifier, "true");
                viewCookie.Expires = DateTime.Now.AddMinutes(30);
                Response.Cookies.Add(viewCookie);
            }
        }

        private string GetUserIP()
        {
            string ip = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (string.IsNullOrEmpty(ip))
            {
                ip = Request.ServerVariables["REMOTE_ADDR"];
            }
            return ip;
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

        private void LoadVideoDetails()
        {
            string videoId = Request.QueryString["id"];
            if (string.IsNullOrEmpty(videoId))
            {
                Response.Redirect("index.aspx");
                return;
            }

            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
                    SELECT v.titulo, v.url, v.visualizacoes, v.data_upload, 
                           c.nome AS categoria_nome, v.descricao, u.username AS canal_nome, 
                           u.imagem_perfil, v.utilizador_id AS video_owner_id,
                           (SELECT COUNT(*) FROM subscricoes WHERE utilizador_id = u.id) AS total_subscribers
                    FROM videos v
                    LEFT JOIN categorias c ON v.categoria = c.id
                    LEFT JOIN utilizadores u ON v.utilizador_id = u.id
                    WHERE v.id = @VideoID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@VideoID", videoId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    videoPlayer.Attributes["src"] = reader["url"].ToString();
                    videoTitle.InnerText = reader["titulo"].ToString();
                    videoStats.InnerHtml = $"{reader["visualizacoes"]} views | Publicado em {Convert.ToDateTime(reader["data_upload"]):dd MMM yyyy HH:mm}";
                    channelName.InnerHtml = $"<a href='canal.aspx?userId={reader["video_owner_id"]}'>{reader["canal_nome"].ToString()}</a>";
                    profileImage.Attributes["onclick"] = $"location.href='canal.aspx?userId={reader["video_owner_id"]}'";
                    description.InnerText = reader["descricao"].ToString();
                    category.InnerText = reader["categoria_nome"].ToString();

                    Page.Title = reader["titulo"].ToString();

                    Session["VideoOwnerID"] = reader["video_owner_id"]?.ToString() ?? "";
                    if (!string.IsNullOrEmpty(reader["imagem_perfil"].ToString()))
                    {
                        profileImage.Attributes["src"] = reader["imagem_perfil"].ToString();
                    }
                    else
                    {
                        profileImage.Attributes["src"] = "imagens/user-avatar.png";
                    }

                    int totalSubscribers = reader["total_subscribers"] != DBNull.Value ? Convert.ToInt32(reader["total_subscribers"]) : 0;
                    Session["TotalSubscribers"] = totalSubscribers;
                }
                conn.Close();
            }
        }

        protected void ReactToVideo(string videoId, string userId, string reactionType)
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                string userReactionKey = $"VideoReaction_{videoId}_{userId}";
                string currentReaction = Session[userReactionKey]?.ToString();

                if (currentReaction == reactionType)
                {
                    string updateQuery = reactionType == "like"
                        ? "UPDATE videos SET likes = likes - 1 WHERE id = @VideoID AND likes > 0"
                        : "UPDATE videos SET dislikes = dislikes - 1 WHERE id = @VideoID AND dislikes > 0";

                    SqlCommand cmd = new SqlCommand(updateQuery, conn);
                    cmd.Parameters.AddWithValue("@VideoID", videoId);
                    cmd.ExecuteNonQuery();

                    Session.Remove(userReactionKey); 
                }
                else
                {
                    if (!string.IsNullOrEmpty(currentReaction))
                    {
                        string removeReactionQuery = currentReaction == "like"
                            ? "UPDATE videos SET likes = likes - 1 WHERE id = @VideoID AND likes > 0"
                            : "UPDATE videos SET dislikes = dislikes - 1 WHERE id = @VideoID AND dislikes > 0";

                        SqlCommand removeCmd = new SqlCommand(removeReactionQuery, conn);
                        removeCmd.Parameters.AddWithValue("@VideoID", videoId);
                        removeCmd.ExecuteNonQuery();
                    }

                    string addReactionQuery = reactionType == "like"
                        ? "UPDATE videos SET likes = likes + 1 WHERE id = @VideoID"
                        : "UPDATE videos SET dislikes = dislikes + 1 WHERE id = @VideoID";

                    SqlCommand addCmd = new SqlCommand(addReactionQuery, conn);
                    addCmd.Parameters.AddWithValue("@VideoID", videoId);
                    addCmd.ExecuteNonQuery();

                    Session[userReactionKey] = reactionType;
                }
            }
        }





        protected void GetReactions(string videoId, out int likes, out int dislikes)
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT likes, dislikes FROM videos WHERE id = @VideoID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@VideoID", videoId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                likes = 0;
                dislikes = 0;

                if (reader.Read())
                {
                    likes = reader["likes"] != DBNull.Value ? Convert.ToInt32(reader["likes"]) : 0;
                    dislikes = reader["dislikes"] != DBNull.Value ? Convert.ToInt32(reader["dislikes"]) : 0;
                }
            }
        }





        protected void LoadComments()
        {
            string videoId = Request.QueryString["id"];
            string currentUserId = Session["userId"]?.ToString();
            string videoOwnerId = Session["VideoOwnerID"]?.ToString();
            string userType = Session["tipoUsuario"]?.ToString();
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            commentsSection.InnerHtml = "";

            int page = string.IsNullOrEmpty(Request.QueryString["page"]) ? 1 : int.Parse(Request.QueryString["page"]);
            int commentsPerPage = 10;
            int offset = (page - 1) * commentsPerPage;

            int totalComments = 0;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string countQuery = "SELECT COUNT(*) FROM comentarios WHERE video_id = @VideoID";
                SqlCommand countCmd = new SqlCommand(countQuery, conn);
                countCmd.Parameters.AddWithValue("@VideoID", videoId);
                conn.Open();
                totalComments = (int)countCmd.ExecuteScalar();
                conn.Close();

                string query = @"SELECT c.id AS comment_id, c.texto, c.data_comentario, u.username, u.imagem_perfil, c.utilizador_id AS comment_owner_id
                         FROM comentarios c
                         JOIN utilizadores u ON c.utilizador_id = u.id
                         WHERE c.video_id = @VideoID
                         ORDER BY c.data_comentario DESC
                         OFFSET @Offset ROWS FETCH NEXT @Limit ROWS ONLY";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@VideoID", videoId);
                cmd.Parameters.AddWithValue("@Offset", offset);
                cmd.Parameters.AddWithValue("@Limit", commentsPerPage);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    string commentId = reader["comment_id"].ToString();
                    string commentOwnerId = reader["comment_owner_id"].ToString();
                    string username = reader["username"].ToString();
                    string userAvatar = reader["imagem_perfil"].ToString();
                    string commentText = reader["texto"].ToString();
                    string commentDate = Convert.ToDateTime(reader["data_comentario"]).ToString("dd MMM yyyy HH:mm");

                    bool canDelete = currentUserId == commentOwnerId || currentUserId == videoOwnerId || userType == "admin";

                    commentsSection.InnerHtml += $@"
                    <div class='comment' id='comment-{commentId}'>
                        <div class='comment-header'>
                            <a href='canal.aspx?userId={commentOwnerId}'>
                                <img src='{userAvatar}' alt='User Avatar'>
                            </a>
                            <strong><a href='canal.aspx?userId={commentOwnerId}'>{username}</a></strong>
                            <span>{commentDate}</span>
                        </div>
                        <div class='comment-body'>{commentText}</div>
                        {(canDelete ? $"<button class='delete-comment-btn' data-comment-id='{commentId}'>Remover</button>" : "")}
                    </div>";
                }
                conn.Close();
            }

            int totalPages = (int)Math.Ceiling(totalComments / (double)commentsPerPage);

            commentsSection.InnerHtml += "<div class='pagination'>";

            if (page > 1)
            {
                commentsSection.InnerHtml += $"<a href='watch.aspx?id={videoId}&page={page - 1}' class='pagination-btn'>Anterior</a>";
            }
            else
            {
                commentsSection.InnerHtml += "<span class='pagination-btn disabled'>Anterior</span>";
            }

            for (int i = 1; i <= totalPages; i++)
            {
                if (i == page)
                {
                    commentsSection.InnerHtml += $"<span class='pagination-btn active'>{i}</span>";
                }
                else
                {
                    commentsSection.InnerHtml += $"<a href='watch.aspx?id={videoId}&page={i}' class='pagination-btn'>{i}</a>";
                }
            }

            if (page < totalPages)
            {
                commentsSection.InnerHtml += $"<a href='watch.aspx?id={videoId}&page={page + 1}' class='pagination-btn'>Próxima</a>";
            }
            else
            {
                commentsSection.InnerHtml += "<span class='pagination-btn disabled'>Próxima</span>";
            }

            commentsSection.InnerHtml += "</div>";
        }

        protected void PostComment_Click(object sender, EventArgs e)
        {
            string videoId = Request.QueryString["id"];
            string userId = Session["UserID"]?.ToString();
            string commentText = commentTextBox.Text.Trim();

            if (string.IsNullOrEmpty(userId))
            {
                Response.Write("<script>alert('Inicie a sessão para comentar.');</script>");
                return;
            }

            if (string.IsNullOrWhiteSpace(commentText))
            {
                Response.Write("<script>alert('O comentário não pode estar vazio.');</script>");
                return;
            }

            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "INSERT INTO comentarios (video_id, utilizador_id, texto, data_comentario) VALUES (@VideoID, @UserID, @Texto, @DataComentario)";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@VideoID", videoId);
                cmd.Parameters.AddWithValue("@UserID", userId);
                cmd.Parameters.AddWithValue("@Texto", commentText);
                cmd.Parameters.AddWithValue("@DataComentario", DateTime.Now);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

            commentTextBox.Text = string.Empty;

            Response.Redirect(Request.Url.AbsoluteUri);
        }


        private void DeleteComment(int commentId)
        {
            try
            {
                string currentUserId = Session["userId"]?.ToString();
                string videoOwnerId = Session["VideoOwnerID"]?.ToString();
                string userType = Session["tipoUsuario"]?.ToString();

                if (string.IsNullOrEmpty(currentUserId) || string.IsNullOrEmpty(videoOwnerId))
                {
                    throw new Exception("Permissões insuficientes para deletar o comentário.");
                }

                string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query;

                    if (userType == "admin")
                    {
                        query = "DELETE FROM comentarios WHERE id = @CommentID";
                    }
                    else
                    {
                        query = @"DELETE FROM comentarios
                          WHERE id = @CommentID AND (
                              utilizador_id = @CurrentUserID OR
                              @CurrentUserID = @VideoOwnerID
                          )";
                    }

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@CommentID", commentId);

                    if (userType != "admin")
                    {
                        cmd.Parameters.AddWithValue("@CurrentUserID", currentUserId);
                        cmd.Parameters.AddWithValue("@VideoOwnerID", videoOwnerId);
                    }

                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    conn.Close();

                    if (rowsAffected == 0)
                    {
                        throw new Exception("Comentário não encontrado ou permissões insuficientes.");
                    }
                }

                Response.Redirect(Request.Url.AbsoluteUri);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Erro ao remover comentário: " + ex.Message);
                throw;
            }
        }


        public static void RegistarNoHistorico(int userId, int videoId)
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
        IF EXISTS (SELECT 1 FROM historico_visualizacoes WHERE utilizador_id = @UserId AND video_id = @VideoId)
        BEGIN
            UPDATE historico_visualizacoes
            SET data_visualizacao = GETDATE()
            WHERE utilizador_id = @UserId AND video_id = @VideoId
        END
        ELSE
        BEGIN
            INSERT INTO historico_visualizacoes (utilizador_id, video_id, data_visualizacao)
            VALUES (@UserId, @VideoId, GETDATE())
        END";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@VideoId", videoId);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
        }


        private void ToggleFavorite(string videoId, string userId)
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                string checkQuery = @"
        SELECT COUNT(*)
        FROM favoritos
        WHERE video_id = @VideoID AND utilizador_id = @UserID";

                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@VideoID", videoId);
                checkCmd.Parameters.AddWithValue("@UserID", userId);

                int isFavorite = (int)checkCmd.ExecuteScalar();

                if (isFavorite > 0)
                {
                    string removeQuery = "DELETE FROM favoritos WHERE video_id = @VideoID AND utilizador_id = @UserID";
                    SqlCommand removeCmd = new SqlCommand(removeQuery, conn);
                    removeCmd.Parameters.AddWithValue("@VideoID", videoId);
                    removeCmd.Parameters.AddWithValue("@UserID", userId);
                    removeCmd.ExecuteNonQuery();
                }
                else
                {
                    string addQuery = "INSERT INTO favoritos (video_id, utilizador_id, data_favorito) VALUES (@VideoID, @UserID, GETDATE())";
                    SqlCommand addCmd = new SqlCommand(addQuery, conn);
                    addCmd.Parameters.AddWithValue("@VideoID", videoId);
                    addCmd.Parameters.AddWithValue("@UserID", userId);
                    addCmd.ExecuteNonQuery();
                }

                conn.Close();
            }
        }


        private bool CheckFavoriteStatus(string videoId, string userId)
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
        SELECT COUNT(*)
        FROM favoritos
        WHERE video_id = @VideoID AND utilizador_id = @UserID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@VideoID", videoId);
                cmd.Parameters.AddWithValue("@UserID", userId);

                conn.Open();
                int isFavorite = (int)cmd.ExecuteScalar();
                conn.Close();

                return isFavorite > 0;
            }
        }


        private string GetUserIPAddress()
        {
            string ip = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (string.IsNullOrEmpty(ip))
            {
                ip = Request.ServerVariables["REMOTE_ADDR"];
            }
            return ip;
        }
    }
}