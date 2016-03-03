using System;
using System.Data.SqlClient;
using System.Data;

namespace SabinIO.Demos.UnitTestFrameWork
{
    public class GetBatchResult
    {
        public DataSet GetDataSet(string _batch, string _connstring)
        {
            SqlDataAdapter da = new SqlDataAdapter(_batch, _connstring);
            DataSet ds = new DataSet();
            try
            {
                da.Fill(ds);
            }

            catch (Exception e)
            {
                string error = e.Message;
                new ApplicationException(error);
            }
            return ds;
        }
    }
}
