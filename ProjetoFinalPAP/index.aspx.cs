using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ProjetoFinalPAP
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CarregarPopulares();

                if (Session["UserID"] != null)
                {
                    CarregarRecomendacoes();

                    
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

        private void CarregarPopulares()
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
                SELECT TOP 5 v.id, v.titulo, v.thumbnail, c.nome AS categoria_nome, 
                       v.visualizacoes, v.data_upload, u.username AS criador,
                       ISNULL(SUM(v.likes), 0) AS total_likes,
                       ISNULL(COUNT(com.id), 0) AS total_comentarios
                FROM videos v
                JOIN utilizadores u ON v.utilizador_id = u.id
                JOIN categorias c ON v.categoria = c.id
                LEFT JOIN comentarios com ON com.video_id = v.id
                GROUP BY v.id, v.titulo, v.thumbnail, c.nome, v.visualizacoes, v.data_upload, u.username
                ORDER BY 
                    (v.visualizacoes * 0.5 + SUM(v.likes) * 0.3 + COUNT(com.id) * 0.2) DESC";

                SqlCommand cmd = new SqlCommand(query, conn);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                popularesSection.InnerHtml = "<h2>Vídeos Populares</h2>";

                while (reader.Read())
                {
                    string videoId = reader["id"].ToString();
                    string titulo = reader["titulo"].ToString();
                    string thumbnail = !string.IsNullOrEmpty(reader["thumbnail"].ToString()) ? reader["thumbnail"].ToString() : "imagens/default-thumbnail.png";
                    string categoria = reader["categoria_nome"].ToString();
                    string visualizacoes = reader["visualizacoes"].ToString();
                    string dataUpload = Convert.ToDateTime(reader["data_upload"]).ToString("dd MMM yyyy");
                    string criador = reader["criador"].ToString();

                    popularesSection.InnerHtml += $@"
                    <div class='video-card'>
                        <a href='watch.aspx?id={videoId}' class='video-thumbnail'>
                            <img src='{thumbnail}' alt='{titulo}' />
                        </a>
                        <div class='video-info'>
                            <h3 class='video-title'>{titulo}</h3>
                            <p>Criador: {criador}</p>
                            <p>Categoria: {categoria}</p>
                            <p>{visualizacoes} visualizações | {dataUpload}</p>
                        </div>
                    </div>";
                }

                conn.Close();
            }
        }

        private void CarregarRecomendacoes()
        {
            string userId = Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(userId)) return;

            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
                SELECT TOP 1 c.nome AS categoria_nome
                FROM historico_visualizacoes h
                JOIN videos v ON h.video_id = v.id
                JOIN categorias c ON v.categoria = c.id
                WHERE h.utilizador_id = @UserID
                GROUP BY c.nome
                ORDER BY COUNT(c.nome) DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);

                conn.Open();
                string categoriaMaisVista = cmd.ExecuteScalar()?.ToString();
                conn.Close();

                if (!string.IsNullOrEmpty(categoriaMaisVista))
                {
                    MostrarRecomendacoes(categoriaMaisVista);
                }
            }
        }

        private void MostrarRecomendacoes(string categoria)
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
                SELECT TOP 10 v.id, v.titulo, v.thumbnail, c.nome AS categoria_nome, 
                       v.visualizacoes, v.data_upload, u.username AS criador,
                       ISNULL(SUM(v.likes), 0) AS total_likes,
                       ISNULL(COUNT(com.id), 0) AS total_comentarios
                FROM videos v
                JOIN utilizadores u ON v.utilizador_id = u.id
                JOIN categorias c ON v.categoria = c.id
                LEFT JOIN comentarios com ON com.video_id = v.id
                WHERE c.nome = @Categoria
                GROUP BY v.id, v.titulo, v.thumbnail, c.nome, v.visualizacoes, v.data_upload, u.username
                ORDER BY 
                    (v.visualizacoes * 0.5 + SUM(v.likes) * 0.3 + COUNT(com.id) * 0.2) DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Categoria", categoria);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                recomendacoesSection.InnerHtml = $"<h2>Recomendações Baseadas em '{categoria}'</h2>";

                while (reader.Read())
                {
                    string videoId = reader["id"].ToString();
                    string titulo = reader["titulo"].ToString();
                    string thumbnail = !string.IsNullOrEmpty(reader["thumbnail"].ToString()) ? reader["thumbnail"].ToString() : "imagens/default-thumbnail.png";
                    string categoriaNome = reader["categoria_nome"].ToString();
                    string visualizacoes = reader["visualizacoes"].ToString();
                    string dataUpload = Convert.ToDateTime(reader["data_upload"]).ToString("dd MMM yyyy");
                    string criador = reader["criador"].ToString();

                    recomendacoesSection.InnerHtml += $@"
                    <div class='video-card'>
                        <a href='watch.aspx?id={videoId}' class='video-thumbnail'>
                            <img src='{thumbnail}' alt='{titulo}' />
                        </a>
                        <div class='video-info'>
                            <h3 class='video-title'>{titulo}</h3>
                            <p>Criador: {criador}</p>
                            <p>Categoria: {categoriaNome}</p>
                            <p>{visualizacoes} visualizações | {dataUpload}</p>
                        </div>
                    </div>";
                }

                conn.Close();
            }
        }

    }
}
