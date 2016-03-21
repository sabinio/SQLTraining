using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace SabinIO.Demos.UnitTestFrameWork
{
    public class GetQueryPlan
    {
        public string GetQueryPlanForQuery(string conn, string batch)
        {
            SqlConnection _conn = new SqlConnection(conn);
            _conn.Open();
            SqlCommand cmd = _conn.CreateCommand();

            cmd.CommandText = "SET SHOWPLAN_XML ON";
            cmd.ExecuteNonQuery();
            cmd.CommandText = batch;
            try
            {
                String QueryPlan = String.Empty;
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read()) QueryPlan += sdr.GetSqlString(0).ToString();
                sdr.Close();
                cmd.CommandText = "SET SHOWPLAN_XML OFF";
                cmd.ExecuteNonQuery();
                return QueryPlan;
            }

            catch (SqlException)
            {
                string e = "Query plan could not be returned.";
                return e;
            }
        }
    }
}
