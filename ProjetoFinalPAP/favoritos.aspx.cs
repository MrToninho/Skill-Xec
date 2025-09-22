using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace ProjetoFinalPAP
{
    public partial class favoritos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verifica se o utilizador está autenticado
            if (Session["UserID"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            if (Request.HttpMethod == "POST" && Request.ContentType.Contains("application/json"))
            {
                string jsonResponse = string.Empty;

                try
                {
                    using (var reader = new System.IO.StreamReader(Request.InputStream))
                    {
                        string json = reader.ReadToEnd();
                        dynamic data = Newtonsoft.Json.JsonConvert.DeserializeObject(json);

                        if (data?.action == "fetchFavorites")
                        {
                            int userId = int.Parse(Session["UserID"].ToString());
                            jsonResponse = GetFavorites(userId);
                        }
                        else
                        {
                            throw new Exception("Ação desconhecida.");
                        }
                    }
                }
                catch (Exception ex)
                {
                    Response.StatusCode = 500;
                    jsonResponse = Newtonsoft.Json.JsonConvert.SerializeObject(new { success = false, message = ex.Message });
                }
                finally
                {
                    Response.ContentType = "application/json";
                    Response.Write(jsonResponse);
                    Response.End();
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

        private string GetFavorites(int userId)
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;
            var favorites = new List<object>();

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = @"
                        SELECT v.id, v.titulo AS title, v.visualizacoes AS views, v.thumbnail,
                               c.nome AS category, u.username AS creator
                        FROM favoritos f
                        INNER JOIN videos v ON f.video_id = v.id
                        INNER JOIN categorias c ON v.categoria = c.id
                        INNER JOIN utilizadores u ON v.utilizador_id = u.id
                        WHERE f.utilizador_id = @UserId";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        favorites.Add(new
                        {
                            id = reader["id"].ToString(),
                            title = reader["title"].ToString(),
                            views = Convert.ToInt32(reader["views"]),
                            thumbnail = reader["thumbnail"] != DBNull.Value ? reader["thumbnail"].ToString() : "imagens/default-thumbnail.png",
                            category = reader["category"].ToString(),
                            creator = reader["creator"].ToString()
                        });
                    }

                    conn.Close();
                }

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { success = true, favorites });
            }
            catch (Exception ex)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { success = false, message = ex.Message });
            }
        }
    }
}
