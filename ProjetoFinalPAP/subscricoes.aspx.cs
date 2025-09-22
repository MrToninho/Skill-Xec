using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace ProjetoFinalPAP
{
    public partial class subscricoes : Page
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
                CarregarSubscricoes();
            }
        }

        private void CarregarSubscricoes()
        {
            string userId = Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(userId))
                return;

            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
                    SELECT s.id AS subscricao_id, u.id AS canal_id, u.username AS nome_canal, 
                           ISNULL(u.imagem_perfil, 'imagens/user-avatar.png') AS imagem_perfil,
                           (SELECT COUNT(*) FROM subscricoes WHERE utilizador_id = u.id) AS total_subs
                    FROM subscricoes s
                    JOIN utilizadores u ON s.utilizador_id = u.id
                    WHERE s.subscritor_id = @SubscritorID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@SubscritorID", userId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                subscricoesSection.InnerHtml = "";

                while (reader.Read())
                {
                    string subscriptionId = reader["subscricao_id"].ToString();
                    string canalId = reader["canal_id"].ToString();
                    string nomeCanal = reader["nome_canal"].ToString();
                    string imagemPerfil = reader["imagem_perfil"].ToString();
                    string totalSubs = reader["total_subs"].ToString();

                    subscricoesSection.InnerHtml += $@"
                        <a href='canal.aspx?userId={canalId}' class='subscription-card'>
                            <div class='subscription-avatar'>
                                <img src='{imagemPerfil}' alt='{nomeCanal}' />
                            </div>
                            <div class='subscription-info'>
                                <h3>{nomeCanal}</h3>
                                <p>{totalSubs} subscritores</p>
                            </div>
                            <button type='button' class='unsubscribe-btn' data-subscription-id='{subscriptionId}'>Cancelar Subscrição</button>
                        </a>";
                }

                conn.Close();
            }
        }

        [WebMethod]
        public static string CancelarSubscricao(int id)
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "DELETE FROM subscricoes WHERE id = @ID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ID", id);

                conn.Open();
                int rows = cmd.ExecuteNonQuery();
                conn.Close();

                return rows > 0 ? "Sucesso" : "Erro";
            }
        }
    }
}
