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
        public List<string> stringlist = new List<string>();
        public List<int> bacon = new List<int>();
        public void Message(object sender, SqlInfoMessageEventArgs e)
        {
            
            int i;
            for (i = 0; i < e.Errors.Count; i++)
            {
                stringlist.Add(e.Errors[i].Message);
            }
        }
        [TestMethod]
        public void TestTruncateDeleteDemo1()
        {
            GetConnection u = new GetConnection();
            GetBatches b = new GetBatches();
            GetBatchResult r = new GetBatchResult();

            string constring_1 = u.GetConnectionString("SabinIO.Performance.TruncateDelete");
            string[] batches = b.GetFileContent(@"..\\..\\..\\SabinIO.Performance.TruncateDelete\\Demos\\TruncateDeleteDemo1.sql");

            SqlConnection _conn = new SqlConnection(constring_1);
            _conn.InfoMessage += new SqlInfoMessageEventHandler(Message);

            for (int i = 0; i < batches.Length; i++)
            {
                _conn.Open();
                SqlCommand cmd_1 = new SqlCommand(batches[i], _conn);
                cmd_1.ExecuteNonQuery();
                _conn.Close();
            }

            MatchCollection q = Regex.Matches(stringlist[1], @"\d+");

            Assert.IsTrue(Convert.ToInt32(q[0].ToString()) == 0);
            Assert.IsTrue(Convert.ToInt32(q[1].ToString()) <= 2);

            MatchCollection w = Regex.Matches(stringlist[2], @"\d+");

            Assert.IsTrue(Convert.ToInt32(w[0].ToString()) <= 1);
            Assert.IsTrue(Convert.ToInt32(w[1].ToString()) <= 11);
            Assert.IsTrue(Convert.ToInt32(w[2].ToString()) <= 2);
            Assert.IsTrue(Convert.ToInt32(w[3].ToString()) <= 2);
            Assert.IsTrue(Convert.ToInt32(w[4].ToString()) <= 2);
            Assert.IsTrue(Convert.ToInt32(w[5].ToString()) <= 2);
            Assert.IsTrue(Convert.ToInt32(w[6].ToString()) <= 2);
            
        }
    }
}
