using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SabinIO.Demos.UnitTestFrameWork;
using System.Text.RegularExpressions;

namespace SabinIO.Performance.UnitTesting
{
    [TestClass]
    public class TruncateDelete
    {
        [TestMethod]
        public void TestTruncateDeleteDemo1()
        {
            GetConnection u = new GetConnection();
            GetBatches b = new GetBatches();
            GetBatchResult r = new GetBatchResult();
            GetSqlInfo s = new GetSqlInfo();

            string constring_1 = u.GetConnectionString("SabinIO.Performance.TruncateDelete");
            string[] batches = b.GetFileContent(@"..\\..\\..\\SabinIO.Performance.TruncateDelete\\Demos\\TruncateDeleteDemo1.sql");

            SqlConnection _conn = new SqlConnection(constring_1);
            _conn.InfoMessage += new SqlInfoMessageEventHandler(s.Message);

            for (int i = 0; i < batches.Length; i++)
            {

                batches[1] = batches[1].Replace("1000", "100");
                batches[3] = batches[3].Replace("1000", "100");
                _conn.Open();
                SqlCommand cmd_1 = new SqlCommand(batches[i], _conn);
                cmd_1.CommandTimeout = 60;
                cmd_1.ExecuteNonQuery();
                _conn.Close();
            }

            MatchCollection q = Regex.Matches(s.SqlInfoMessages[1], @"\d+");

            Assert.IsTrue(Convert.ToInt32(q[0].ToString())<= 10);
            Assert.IsTrue(Convert.ToInt32(q[1].ToString()) <= 10);

            MatchCollection w = Regex.Matches(s.SqlInfoMessages[2], @"\d+");

            Assert.IsTrue(Convert.ToInt32(w[0].ToString()) <= 10);
            Assert.IsTrue(Convert.ToInt32(w[1].ToString()) <= 22);
            Assert.IsTrue(Convert.ToInt32(w[2].ToString()) <= 10);
            Assert.IsTrue(Convert.ToInt32(w[3].ToString()) <= 10);
            Assert.IsTrue(Convert.ToInt32(w[4].ToString()) <= 10);
            Assert.IsTrue(Convert.ToInt32(w[5].ToString()) <= 10);
            Assert.IsTrue(Convert.ToInt32(w[6].ToString()) <= 10);
        }
    }
}
