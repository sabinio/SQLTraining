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
    public class TestForcedParamDemo
    {
        [TestMethod]
        public void TestForcedParamDemo1()
        {
            GetConnection u = new GetConnection();
            GetBatches b = new GetBatches();
            GetBatchResult r = new GetBatchResult();

            List<String> simpleExec = new List<String>();
            List<String> forcedExec = new List<String>();

            string constring_1 = u.GetConnectionString("SabinIO.ForcedParameterisation.Demo");
            string[] batches = b.GetFileContent(@"..\\..\\..\\QueryExecution\\demos\\ForcedParamDemo1.sql");

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                DataSet ds = r.GetDataSet(batch, constring_1);

                if (i == 1)
                {
                    string t = ds.Tables["Table"].Rows[0]["is_parameterization_forced"].ToString();
                    Assert.AreEqual("False", t);
                }

                if (i == 7)
                {
                    for (int a = 0; a < ds.Tables["Table"].Rows.Count; a++)
                    {
                        simpleExec.Add(ds.Tables["Table"].Rows[a]["execution_count"].ToString());
                    }

                    Assert.AreEqual("10", simpleExec[0]);
                    Assert.AreEqual("10", simpleExec[1]);
                    Assert.AreEqual("10", simpleExec[2]);
                    Assert.AreEqual("1", simpleExec[3]);
                }

                if (i == 9)
                {
                    string t = ds.Tables["Table"].Rows[0]["is_parameterization_forced"].ToString();
                    Assert.AreEqual("True", t);
                }

                if (i == 15)
                {
                    for (int a = 0; a < ds.Tables["Table"].Rows.Count; a++)
                    {
                        forcedExec.Add(ds.Tables["Table"].Rows[a]["execution_count"].ToString());
                    }

                    Assert.AreEqual("20", forcedExec[0]);
                    Assert.AreEqual("10", forcedExec[1]);
                    Assert.AreEqual("1", forcedExec[2]);
                }
            }
        }
        [TestMethod]
        public void TestForcedParamDemo2()
        {
            GetConnection u = new GetConnection();
            GetBatches b = new GetBatches();
            GetBatchResult r = new GetBatchResult();

            string constring_1 = u.GetConnectionString("AdventureWorks2014");
            string[] batches = b.GetFileContent(@"..\\..\\..\\QueryExecution\\demos\\ForcedParamDemo2.sql");

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                DataSet ds = r.GetDataSet(batch, constring_1);

                if (i == 5)
                {
                    DataRow[] adhoc = ds.Tables["Table"].Select(@"objtype = 'Adhoc'");
                    Assert.AreEqual(2, adhoc.Length);
                    Assert.AreEqual(1, Convert.ToInt32(adhoc[0]["usecounts"]));
                    Assert.AreEqual(1, Convert.ToInt32(adhoc[1]["usecounts"]));

                    DataRow[] Prepared = ds.Tables["Table"].Select(@"objtype = 'Prepared'");
                    Assert.AreEqual(1, Prepared.Length);
                    Assert.AreEqual(2, Convert.ToInt32(Prepared[0]["usecounts"]));
                    Assert.AreNotEqual(Convert.ToString(adhoc[0]["query_plan"]), Convert.ToString(Prepared[0]["query_plan"]));
                    Assert.AreNotEqual(Convert.ToString(adhoc[1]["query_plan"]), Convert.ToString(Prepared[0]["query_plan"]));

                }

                if (i == 10)
                {
                    DataRow[] adhoc = ds.Tables["Table"].Select(@"objtype = 'Adhoc'");
                    Assert.AreEqual(2, adhoc.Length);
                    Assert.AreEqual(1, Convert.ToInt32(adhoc[0]["usecounts"]));
                    Assert.AreEqual(1, Convert.ToInt32(adhoc[1]["usecounts"]));

                }
            }
        }
    }
}
