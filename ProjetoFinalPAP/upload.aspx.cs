using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoFinalPAP
{
    public partial class upload : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("login.aspx");
            }

            if (!IsPostBack)
            {
                LoadCategorias();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                if (!videoFile.HasFile)
                {
                    ShowAlert("Selecione um vídeo para carregar.");
                    return;
                }

                string[] allowedExtensions = { ".mp4", ".avi", ".mov", ".wmv", ".mkv" };
                string fileExtension = Path.GetExtension(videoFile.FileName).ToLower();

                if (!Array.Exists(allowedExtensions, ext => ext == fileExtension))
                {
                    ShowAlert("O arquivo selecionado não é um tipo de vídeo válido.");
                    return;
                }

                if (!videoThumbnail.HasFile)
                {
                    ShowAlert("Selecione uma thumbnail para carregar.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(videoTitle.Text))
                {
                    ShowAlert("O título é obrigatório.");
                    return;
                }

                if (videoCategory.SelectedValue == "0")
                {
                    ShowAlert("Por favor, selecione uma categoria.");
                    return;
                }


                string userId = Session["UserID"].ToString();
                string title = videoTitle.Text.Trim();
                string description = string.IsNullOrWhiteSpace(videoDescription.Text) ? null : videoDescription.Text.Trim();
                string visibilityValue = visibility.SelectedValue;
                string categoryValue = videoCategory.SelectedValue;

                string videoPath = SaveFile(videoFile, "~/uploads/videos/");
                string thumbnailPath = SaveFile(videoThumbnail, "~/uploads/thumbnails/");

                SaveToDatabase(userId, title, description, videoPath, thumbnailPath, visibilityValue, categoryValue);

                ShowAlert("Vídeo carregado com sucesso!", "canal.aspx");
            }
            catch (Exception ex)
            {
                ShowAlert($"Erro ao carregar vídeo: {ex.Message}");
            }
        }

        private void LoadCategorias()
        {
            videoCategory.Items.Clear();
            videoCategory.Items.Add(new ListItem("Selecione uma categoria", "0")); 
            videoCategory.Items.Add(new ListItem("Tutorial", "1")); 
            videoCategory.Items.Add(new ListItem("Gameplay", "2")); 
            videoCategory.Items.Add(new ListItem("Review", "3"));  
        }


        private string SaveFile(FileUpload fileUpload, string folderPath)
        {
            string serverFolder = Server.MapPath(folderPath);
            if (!Directory.Exists(serverFolder))
            {
                Directory.CreateDirectory(serverFolder);
            }

            string fileName = Guid.NewGuid() + Path.GetExtension(fileUpload.FileName);
            string filePath = Path.Combine(serverFolder, fileName);
            fileUpload.SaveAs(filePath);

            return $"{folderPath.TrimStart('~')}/{fileName}";
        }

        private void SaveToDatabase(string userId, string title, string description, string videoPath, string thumbnailPath, string visibilityValue, string categoryValue)
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
                INSERT INTO videos (utilizador_id, titulo, descricao, url, thumbnail, visibilidade, data_upload, categoria) 
                VALUES (@UserID, @Titulo, @Descricao, @Url, @Thumbnail, @Visibilidade, @DataUpload, @Categoria)";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                cmd.Parameters.AddWithValue("@Titulo", title);
                cmd.Parameters.AddWithValue("@Descricao", (object)description ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Url", videoPath);
                cmd.Parameters.AddWithValue("@Thumbnail", thumbnailPath);
                cmd.Parameters.AddWithValue("@Visibilidade", visibilityValue);
                cmd.Parameters.AddWithValue("@DataUpload", DateTime.Now);
                cmd.Parameters.AddWithValue("@Categoria", categoryValue);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void ShowAlert(string message, string redirectUrl = null)
        {
            if (string.IsNullOrEmpty(redirectUrl))
            {
                Response.Write($"<script>alert('{message}');</script>");
            }
            else
            {
                Response.Write($"<script>alert('{message}'); window.location='{redirectUrl}';</script>");
            }
        }
    }
}
