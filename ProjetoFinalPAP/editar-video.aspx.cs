using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoFinalPAP
{
    public partial class editar_video : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadVideoData();
            }
        }

        private void LoadVideoData()
        {
            LoadCategorias();

            string videoId = Request.QueryString["id"];
            if (string.IsNullOrEmpty(videoId))
            {
                Response.Write("<script>alert('Vídeo inválido.');</script>");
                Response.Redirect("canal.aspx");
                return;
            }

            string userId = Session["UserID"].ToString();
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT titulo, descricao, url, thumbnail, visibilidade, categoria FROM videos WHERE id = @VideoID AND utilizador_id = @UserID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@VideoID", videoId);
                cmd.Parameters.AddWithValue("@UserID", userId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    videoTitle.Text = reader["titulo"].ToString();
                    videoDescription.Text = reader["descricao"].ToString();
                    visibility.SelectedValue = reader["visibilidade"].ToString();
                    ViewState["VideoPath"] = reader["url"].ToString();
                    ViewState["ThumbnailPath"] = reader["thumbnail"].ToString();

                    string categoriaValue = reader["categoria"].ToString();
                    if (!string.IsNullOrEmpty(categoriaValue) && videoCategory.Items.FindByValue(categoriaValue) != null)
                    {
                        videoCategory.SelectedValue = categoriaValue;
                    }
                }
                else
                {
                    Response.Write("<script>alert('Vídeo não encontrado ou você não tem permissão para editá-lo.');</script>");
                    Response.Redirect("canal.aspx");
                }
                conn.Close();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string videoId = Request.QueryString["id"];
            if (string.IsNullOrEmpty(videoId))
            {
                Response.Write("<script>alert('ID do vídeo inválido.');</script>");
                return;
            }

            string userId = Session["UserID"].ToString();
            string title = videoTitle.Text.Trim();
            string description = string.IsNullOrWhiteSpace(videoDescription.Text) ? null : videoDescription.Text.Trim();
            string visibilityValue = visibility.SelectedValue;
            string categoryValue = videoCategory.SelectedValue;
            string thumbnailPath = ViewState["ThumbnailPath"] != null ? ViewState["ThumbnailPath"].ToString() : "";

            if (string.IsNullOrWhiteSpace(title))
            {
                Response.Write("<script>alert('O título é obrigatório.');</script>");
                return;
            }

            if (string.IsNullOrEmpty(categoryValue) || videoCategory.Items.FindByValue(categoryValue) == null)
            {
                Response.Write("<script>alert('Categoria inválida.');</script>");
                return;
            }

            try
            {
                if (videoThumbnail.HasFile)
                {
                    string extension = Path.GetExtension(videoThumbnail.FileName).ToLower();
                    string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif" };

                    if (Array.Exists(allowedExtensions, ext => ext == extension))
                    {
                        string thumbnailFolder = Server.MapPath("~/uploads/thumbnails/");
                        if (!Directory.Exists(thumbnailFolder))
                            Directory.CreateDirectory(thumbnailFolder);

                        string thumbnailFileName = Guid.NewGuid() + extension;
                        string newThumbnailPath = $"uploads/thumbnails/{thumbnailFileName}";
                        videoThumbnail.SaveAs(Server.MapPath("~/" + newThumbnailPath));

                        thumbnailPath = newThumbnailPath;
                    }
                    else
                    {
                        Response.Write("<script>alert('Formato de thumbnail inválido.');</script>");
                        return;
                    }
                }

                string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = @"
                    UPDATE videos 
                    SET titulo = @Titulo, descricao = @Descricao, thumbnail = @Thumbnail, visibilidade = @Visibilidade, categoria = @Categoria
                    WHERE id = @VideoID AND utilizador_id = @UserID";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Titulo", title);
                    cmd.Parameters.AddWithValue("@Descricao", (object)description ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Thumbnail", thumbnailPath);
                    cmd.Parameters.AddWithValue("@Visibilidade", visibilityValue);
                    cmd.Parameters.AddWithValue("@Categoria", categoryValue);
                    cmd.Parameters.AddWithValue("@VideoID", videoId);
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                Response.Write("<script>alert('Alterações salvas com sucesso!'); window.location='canal.aspx';</script>");
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Erro ao atualizar vídeo: {ex.Message}');</script>");
            }
        }

        private void LoadCategorias()
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT id, nome FROM categorias ORDER BY nome";
                SqlCommand cmd = new SqlCommand(query, conn);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                videoCategory.Items.Clear();
                while (reader.Read())
                {
                    videoCategory.Items.Add(new ListItem(reader["nome"].ToString(), reader["id"].ToString()));
                }
                conn.Close();
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            string videoId = Request.QueryString["id"];
            if (string.IsNullOrEmpty(videoId))
            {
                Response.Write("<script>alert('ID do vídeo inválido.');</script>");
                return;
            }

            string userId = Session["UserID"].ToString();

            try
            {
                string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();

                    string deleteHistoricoQuery = "DELETE FROM historico_visualizacoes WHERE video_id = @VideoID";
                    SqlCommand deleteHistoricoCmd = new SqlCommand(deleteHistoricoQuery, conn);
                    deleteHistoricoCmd.Parameters.AddWithValue("@VideoID", videoId);
                    deleteHistoricoCmd.ExecuteNonQuery();

                    string selectQuery = "SELECT url, thumbnail FROM videos WHERE id = @VideoID AND utilizador_id = @UserID";
                    SqlCommand selectCmd = new SqlCommand(selectQuery, conn);
                    selectCmd.Parameters.AddWithValue("@VideoID", videoId);
                    selectCmd.Parameters.AddWithValue("@UserID", userId);

                    SqlDataReader reader = selectCmd.ExecuteReader();
                    string videoPath = null;
                    string thumbnailPath = null;

                    if (reader.Read())
                    {
                        videoPath = reader["url"].ToString();
                        thumbnailPath = reader["thumbnail"].ToString();
                    }
                    reader.Close();

                    string deleteVideoQuery = "DELETE FROM videos WHERE id = @VideoID AND utilizador_id = @UserID";
                    SqlCommand deleteVideoCmd = new SqlCommand(deleteVideoQuery, conn);
                    deleteVideoCmd.Parameters.AddWithValue("@VideoID", videoId);
                    deleteVideoCmd.Parameters.AddWithValue("@UserID", userId);
                    deleteVideoCmd.ExecuteNonQuery();

                    if (!string.IsNullOrEmpty(videoPath))
                    {
                        string fullVideoPath = Server.MapPath("~/" + videoPath);
                        if (File.Exists(fullVideoPath))
                        {
                            File.Delete(fullVideoPath);
                        }
                    }

                    if (!string.IsNullOrEmpty(thumbnailPath))
                    {
                        string fullThumbnailPath = Server.MapPath("~/" + thumbnailPath);
                        if (File.Exists(fullThumbnailPath))
                        {
                            File.Delete(fullThumbnailPath);
                        }
                    }
                }

                Response.Write("<script>alert('Vídeo apagado com sucesso!'); window.location='canal.aspx';</script>");
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Erro ao apagar vídeo: {ex.Message}');</script>");
            }
        }
    }
}
