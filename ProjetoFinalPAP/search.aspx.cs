using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;

namespace ProjetoFinalPAP
{
    public partial class search : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string searchTerm = Request.QueryString["q"];
            int page = int.TryParse(Request.QueryString["page"], out int p) ? p : 1;
            int pageSize = 10; 
            int offset = (page - 1) * pageSize;

            if (!IsPostBack && !string.IsNullOrEmpty(searchTerm))
            {
                BuscarVideos(searchTerm, offset, pageSize);
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

        private void BuscarVideos(string termo, int offset, int pageSize)
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            string termoSingular = RemoverPlural(termo);

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = @"
                SELECT v.id, v.titulo, v.thumbnail, c.nome AS categoria_nome, 
                       v.visualizacoes, v.data_upload, u.username AS criador
                FROM videos v
                JOIN categorias c ON v.categoria = c.id
                JOIN utilizadores u ON v.utilizador_id = u.id
                WHERE v.titulo LIKE @Termo 
                   OR v.titulo LIKE @TermoSingular 
                   OR v.descricao LIKE @Termo 
                   OR v.descricao LIKE @TermoSingular
                   OR c.nome LIKE @Termo 
                   OR c.nome LIKE @TermoSingular
                   OR u.username LIKE @Termo 
                   OR u.username LIKE @TermoSingular
               ORDER BY 
                CASE 
                    WHEN v.titulo LIKE @Termo THEN 1
                    WHEN v.titulo LIKE @TermoSingular THEN 2
                    WHEN c.nome LIKE @Termo THEN 3
                    WHEN c.nome LIKE @TermoSingular THEN 4
                    ELSE 5
                END, 
                (v.visualizacoes * 0.6 + v.likes * 0.4) DESC
                OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Termo", $"%{termo}%");
                    cmd.Parameters.AddWithValue("@TermoSingular", $"%{termoSingular}%");
                    cmd.Parameters.AddWithValue("@Offset", offset);
                    cmd.Parameters.AddWithValue("@PageSize", pageSize);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        string videoId = reader["id"].ToString();
                        string titulo = reader["titulo"].ToString();
                        string thumbnail = !string.IsNullOrEmpty(reader["thumbnail"].ToString()) ? reader["thumbnail"].ToString() : "uploads/thumbnails/inovacao-e-tecnologia.jpg";
                        string categoria = reader["categoria_nome"].ToString();
                        string visualizacoes = reader["visualizacoes"].ToString();
                        string dataUpload = Convert.ToDateTime(reader["data_upload"]).ToString("dd MMM yyyy");
                        string criador = reader["criador"].ToString();

                        categoriasSection.InnerHtml += $@"
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
            catch (Exception ex)
            {
                categoriasSection.InnerHtml = $"<p>Ocorreu um erro ao buscar os vídeos: {ex.Message}</p>";
            }
        }

        private string RemoverPlural(string termo)
        {
            if (termo.EndsWith("ões", StringComparison.OrdinalIgnoreCase))
                return termo.Substring(0, termo.Length - 3) + "ão";
            if (termo.EndsWith("eis", StringComparison.OrdinalIgnoreCase))
                return termo.Substring(0, termo.Length - 3) + "el";
            if (termo.EndsWith("ais", StringComparison.OrdinalIgnoreCase))
                return termo.Substring(0, termo.Length - 3) + "al";
            if (termo.EndsWith("is", StringComparison.OrdinalIgnoreCase))
                return termo.Substring(0, termo.Length - 2);

            if (termo.Equals("tutoriais", StringComparison.OrdinalIgnoreCase))
                return "tutorial";

            if (termo.EndsWith("s", StringComparison.OrdinalIgnoreCase))
                return termo.Substring(0, termo.Length - 1);

            return termo;
        }



    }
}

