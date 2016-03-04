using System;
using System.Data;
using System.Data.SqlClient;

namespace SabinIO.Demos.UnitTestFrameWork
{
    public class GetConnection
    {
        public string GetConnectionString(string database)
        {
            string connection = String.Format("Integrated Security=SSPI;Persist Security Info=False;Initial Catalog={0};Data Source=.", database);
            try
            {
                using (SqlConnection _connection = new SqlConnection(connection))
                {
                    try
                    {
                        _connection.Open();
                        //tested we can connect, now we close
                        _connection.Close();
                        return connection;
                        
                    }
                    catch (SqlException e)
                    {
                        string error = e.Message;
                        return error;
                    }
                }
            }
            catch (SqlException e)
            {
                string error = e.Message;
                return error;
            }
        }
    }
}

