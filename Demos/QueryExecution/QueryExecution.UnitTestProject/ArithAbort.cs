using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data;
using System.IO;
using System.Text.RegularExpressions;
using System.Data.SqlClient;
using System.Collections.Generic;
using SabinIO.Demos.UnitTestFrameWork;

namespace QueryExecution.UnitTestProject
{
    [TestClass]
    public class ArithAbort
    {
        [TestMethod]
        public void TestArithAbortDemo1()
        {
            GetConnection u = new GetConnection();
            GetBatches b = new GetBatches();
            GetBatchResult r = new GetBatchResult();

            string constring_1 = u.GetConnectionString("SabinIO.ArithAbort.PlanCache");
            string[] batches = b.GetFileContent(@"..\\..\\..\\SabinIO.ArithAbort.PlanCache\\demos\\ArithAbortDemo1.sql");
            List<String> value = new List<String>();
            List<String> exec = new List<String>();

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                if (i == 0){ batch = batch.Replace("100", "5"); }
                if (i == 1) { batch = batch.Replace("50", "2"); }
                DataSet ds = r.GetDataSet(batch, constring_1);

                if (@i == 1)
                {
                    for (int a = 0; a < ds.Tables["Table"].Rows.Count; a++)
                    {
                        value.Add(ds.Tables["Table"].Rows[a]["value"].ToString());
                        exec.Add(ds.Tables["Table"].Rows[a]["execution_count"].ToString());
                    }
                    Assert.AreEqual("251", value[0]);
                    Assert.AreEqual("4347", value[1]);
                    Assert.AreEqual("10", exec[0]);
                    Assert.AreEqual("2", exec[1]);
                }
            }
        }
    }
}

