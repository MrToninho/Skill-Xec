using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ProjetoFinalPAP
{
    public partial class admin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userId"] == null)
            {
                Response.Redirect("login.aspx");
            }

            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT tipo_usuario FROM Utilizadores WHERE id = @UserId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", Session["userId"]);

                try
                {
                    conn.Open();
                    string tipoUsuario = cmd.ExecuteScalar()?.ToString();

                    if (tipoUsuario != "admin")
                    {
                        Response.Redirect("perfil.aspx");
                    }
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "Error", $"alert('Erro ao verificar permissões: {ex.Message}');", true);
                }
            }

            if (!IsPostBack)
            {
                CarregarUtilizadores();
                CarregarReports();
                CarregarUsuariosParaVideos();
            }
        }

        private void CarregarUtilizadores()
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT id, nome, email, username, ativo FROM Utilizadores WHERE tipo_usuario != 'admin'";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();

                try
                {
                    conn.Open();
                    da.Fill(dt);

                    GridViewUsers.DataSource = dt;
                    GridViewUsers.DataBind();
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "Error", $"alert('Erro ao carregar utilizadores: {ex.Message}');", true);
                }
            }
        }

        private void CarregarReports()
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
        SELECT 
            r.id AS ReportID, 
            u_reporter.username AS ReporterName, 
            u_target.username AS TargetName,
            r.reason, 
            r.timestamp, 
            r.resolved
        FROM 
            Reports r
        INNER JOIN 
            Utilizadores u_reporter ON r.reporter_id = u_reporter.id
        INNER JOIN
            Utilizadores u_target ON r.target_id = u_target.id
        WHERE 
            r.resolved = 0
        ORDER BY 
            r.timestamp DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();

                try
                {
                    conn.Open();
                    da.Fill(dt);

                    GridViewReports.DataSource = dt;
                    GridViewReports.DataBind();
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "Error", $"alert('Erro ao carregar reports: {ex.Message}');", true);
                }
            }
        }





        protected void GridViewUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string userId = e.CommandArgument.ToString();

            if (e.CommandName == "Suspend" || e.CommandName == "Remove")
            {
                HandleUserActions(userId, e.CommandName);
            }
        }

        private void HandleUserActions(string userId, string commandName)
        {
            string message = "";
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = commandName == "Suspend"
                        ? "UPDATE Utilizadores SET ativo = CASE WHEN ativo = 1 THEN 0 ELSE 1 END WHERE id = @UserId"
                        : "DELETE FROM Utilizadores WHERE id = @UserId";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    message = commandName == "Suspend"
                        ? "Estado da conta alterado com sucesso."
                        : "Utilizador removido com sucesso.";
                }

                CarregarUtilizadores();
                ClientScript.RegisterStartupScript(this.GetType(), "SuccessMessage", $"alert('{message}');", true);
            }
            catch (Exception ex)
            {
                message = "Ocorreu um erro: " + ex.Message;
                ClientScript.RegisterStartupScript(this.GetType(), "ErrorMessage", $"alert('{message}');", true);
            }
        }




        protected void GridViewReports_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "MarkResolved")
            {
                string reportId = e.CommandArgument.ToString();

                string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = "UPDATE Reports SET resolved = 1 WHERE id = @ReportId";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@ReportId", reportId);

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();

                        CarregarReports();

                        ClientScript.RegisterStartupScript(this.GetType(), "Success", "alert('Denúncia marcada como resolvida.');", true);
                    }
                    catch (Exception ex)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "Error", $"alert('Erro ao marcar report como resolvido: {ex.Message}');", true);
                    }
                }
            }
        }

        private void CarregarUsuariosParaVideos()
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT id AS UserId, username FROM Utilizadores WHERE tipo_usuario != 'admin'";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();

                try
                {
                    conn.Open();
                    da.Fill(dt);

                    GridViewVideoUsers.DataSource = dt;
                    GridViewVideoUsers.DataBind();
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "Error", $"alert('Erro ao carregar usuários para vídeos: {ex.Message}');", true);
                }
            }
        }

        private void CarregarVideosDoUsuario(int userId)
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
        SELECT 
            v.id AS VideoId, 
            v.titulo AS Title, 
            c.nome AS CategoryName, 
            v.data_upload AS UploadDate
        FROM 
            Videos v
        INNER JOIN 
            Categorias c ON v.categoria = c.id
        WHERE 
            v.utilizador_id = @UserId";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                da.SelectCommand.Parameters.AddWithValue("@UserId", userId);
                DataTable dt = new DataTable();

                try
                {
                    conn.Open();
                    da.Fill(dt);

                    GridViewUserVideos.DataSource = dt;
                    GridViewUserVideos.DataBind();
                    PanelUserVideos.Visible = true;

                    ViewState["SelectedUserId"] = userId;
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "Error", $"alert('Erro ao carregar vídeos do usuário: {ex.Message}');", true);
                }
            }
        }



        protected void GridViewVideoUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewVideos")
            {
                int userId = Convert.ToInt32(e.CommandArgument);

                GridViewRow row = ((Button)e.CommandSource).NamingContainer as GridViewRow;

                string username = row.Cells[1].Text;

                SelectedUsernameLabel.Text = username;
                CarregarVideosDoUsuario(userId);

                PanelUserVideos.Visible = true;
            }
        }




        protected void GridViewUserVideos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewUserVideos.PageIndex = e.NewPageIndex;
            int userId = Convert.ToInt32(ViewState["SelectedUserId"]);
            CarregarVideosDoUsuario(userId);
        }




    }
}
