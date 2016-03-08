using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SabinIO.Demos.UnitTestFrameWork;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

namespace SabinIO.Performance.UnitTesting
{
    [TestClass]
    public class StatisticsTimeIO
    {
        [TestMethod]
        public void TestDemoStatisticsTimeIO()
        {
            GetConnection u = new GetConnection();
            GetBatches b = new GetBatches();
            GetBatchResult r = new GetBatchResult();
            GetSqlInfo s = new GetSqlInfo();

            string constring_1 = u.GetConnectionString("AdventureWorks2014");
            string[] batches = b.GetFileContent(@"..\\..\\..\\SabinIO.Performance.StatisticsTimeIO\\Demos\\DemoStatisticsTimeIO.sql");

            SqlConnection _conn = new SqlConnection(constring_1);
            _conn.InfoMessage += new SqlInfoMessageEventHandler(s.Message);


            for (int i = 0; i < batches.Length; i++)
            {
                _conn.Open();
                SqlCommand cmd_1 = new SqlCommand(batches[i], _conn);
                cmd_1.ExecuteNonQuery();
                _conn.Close();
            }

            MatchCollection q = Regex.Matches(s.SqlInfoMessages[1], @"\d+");
            Assert.IsTrue(Convert.ToInt32(q[1].ToString()) <= 1246);

            MatchCollection w = Regex.Matches(s.SqlInfoMessages[2], @"\d+");
            Assert.IsTrue(Convert.ToInt32(q[0].ToString()) <= 200);
        }
    }
}
