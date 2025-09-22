using Newtonsoft.Json;
using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;

namespace ProjetoFinalPAP
{
    public partial class historico : System.Web.UI.Page
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
                CarregarHistorico();
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

        protected void CarregarHistorico()
        {
            string userId = Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(userId))
                return;

            int page = string.IsNullOrEmpty(Request.QueryString["page"]) ? 1 : int.Parse(Request.QueryString["page"]);
            int videosPerPage = 10;
            int offset = (page - 1) * videosPerPage;

            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
        SELECT 
            h.id AS historico_id, 
            v.id AS video_id, 
            v.titulo, 
            v.thumbnail, 
            h.data_visualizacao, 
            u.username AS criador, 
            c.nome AS categoria
        FROM historico_visualizacoes h
        JOIN videos v ON h.video_id = v.id
        JOIN utilizadores u ON v.utilizador_id = u.id
        JOIN categorias c ON v.categoria = c.id
        WHERE h.utilizador_id = @UserID
        ORDER BY h.data_visualizacao DESC
        OFFSET @Offset ROWS FETCH NEXT @Limit ROWS ONLY";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                cmd.Parameters.AddWithValue("@Offset", offset);
                cmd.Parameters.AddWithValue("@Limit", videosPerPage);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                historicoSection.InnerHtml = "";

                while (reader.Read())
                {
                    string historicoId = reader["historico_id"].ToString();
                    string videoId = reader["video_id"].ToString();
                    string titulo = reader["titulo"].ToString();
                    string thumbnail = reader["thumbnail"].ToString();
                    string dataVisualizacao = Convert.ToDateTime(reader["data_visualizacao"]).ToString("dd MMM yyyy HH:mm");
                    string criador = reader["criador"].ToString();
                    string categoria = reader["categoria"].ToString();

                    historicoSection.InnerHtml += $@"
            <div class='video-card'>
                <a href='watch.aspx?id={videoId}' class='video-thumbnail'>
                    <img src='{thumbnail}' alt='{titulo}' class='video-thumbnail' />
                </a>
                <div class='video-info'>
                    <h3 class='video-title'>{titulo}</h3>
                    <p>Criador: {criador}</p>
                    <p>Categoria: {categoria}</p>
                    <p>Visto pela última vez: {dataVisualizacao}</p>
                    <button class='delete-button' data-historico-id='{historicoId}'>Remover</button>
                </div>
            </div>";
                }

                conn.Close();
            }

        }



        [System.Web.Services.WebMethod]
        public static string removerDoHistorico(int historicoId)
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "DELETE FROM historico_visualizacoes WHERE id = @HistoricoID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@HistoricoID", historicoId);

                conn.Open();
                int rowsAffected = cmd.ExecuteNonQuery();
                conn.Close();

                if (rowsAffected > 0)
                {
                    return "Item removido do histórico com sucesso!";
                }
                else
                {
                    return "Erro ao remover item do histórico. Tente novamente.";
                }
            }
        }
    }
}
