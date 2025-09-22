using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ProjetoFinalPAP
{
    public partial class reportHandler : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.StatusCode = 401; 
                Response.End();
                return;
            }

            if (Request.HttpMethod == "POST" && Request.ContentType.Contains("application/json"))
            {
                using (var reader = new System.IO.StreamReader(Request.InputStream))
                {
                    var json = reader.ReadToEnd();
                    dynamic data = Newtonsoft.Json.JsonConvert.DeserializeObject(json);

                    string type = data?.type;
                    string id = data?.id;
                    string reason = data?.reason;

                    if (type != null && id != null && reason != null)
                    {
                        SaveReport(Session["UserID"].ToString(), type, id, reason);
                        Response.ContentType = "application/json";
                        Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(new { success = true }));
                        Response.End();
                    }
                }
            }
        }

        private void SaveReport(string reporterId, string targetType, string targetId, string reason)
        {
            string connString = ConfigurationManager.ConnectionStrings["SkillXec"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
            INSERT INTO Reports (reporter_id, target_type, target_id, reason, timestamp, resolved) 
            VALUES (@ReporterId, @TargetType, @TargetId, @Reason, @Timestamp, 0)";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ReporterId", reporterId);
                cmd.Parameters.AddWithValue("@TargetType", targetType);
                cmd.Parameters.AddWithValue("@TargetId", targetId); 
                cmd.Parameters.AddWithValue("@Reason", reason);
                cmd.Parameters.AddWithValue("@Timestamp", DateTime.Now);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
}
