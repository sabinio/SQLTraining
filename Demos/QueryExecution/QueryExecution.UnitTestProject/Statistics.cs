using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data;
using System.Data.SqlClient;
using SabinIO.Demos.UnitTestFrameWork;

namespace QueryExecution.UnitTestProject
{
    [TestClass]
    public class Statistics
    {
        [TestMethod]
        public void TestOutOfDateStatistics_Demo1()
        {
            GetConnection u = new GetConnection();
            GetBatches b = new GetBatches();
            GetBatchResult r = new GetBatchResult();
            GetQueryPlan qp = new GetQueryPlan();
            GetQueryPlanValues qv = new GetQueryPlanValues();

            string constring_1 = u.GetConnectionString("SabinIO.Statistics.OutOfDate");
            string[] batches = b.GetFileContent(@"..\\..\\..\\SabinIO.Statistics.OutOfDate\\demos\\OutOfDateStatistics_Demo1.sql");
            string SqlNamespace = "http://schemas.microsoft.com/sqlserver/2004/07/showplan";
            string XPath = "//sql:Batch/sql:Statements/sql:StmtSimple/sql:QueryPlan[1]/sql:RelOp[1]/@EstimateRows";
            string XPathForSproc = "//sql:Batch/sql:Statements/sql:StmtSimple/sql:StoredProc/sql:Statements/sql:StmtSimple[2]/sql:QueryPlan[1]/sql:RelOp[1]/@EstimateRows";
            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                DataSet ds = r.GetDataSet(batch, constring_1);

                if (i == 6)
                {
                    Assert.AreEqual(0, Convert.ToInt32(ds.Tables["table"].Rows[0]["Column1"]));
                    string QueryPlan = qp.GetQueryPlanForQuery(constring_1, batch);
                    string RowEstimate = qv.GetSumOfValues(QueryPlan, SqlNamespace, XPath);
                    Assert.AreEqual("1", RowEstimate);
                }

                if (i == 7)
                {
                    Assert.AreEqual(0, Convert.ToInt32(ds.Tables["table"].Rows[0]["RowsAffected"]));
                    string QueryPlan = qp.GetQueryPlanForQuery(constring_1, batch);
                    string RowEstimate = qv.GetSumOfValues(QueryPlan, SqlNamespace, XPathForSproc);
                    Assert.AreEqual("1", RowEstimate);
                }
                if (i == 9 || i == 11)
                {
                    Assert.AreEqual(100, Convert.ToInt32(ds.Tables["table"].Rows[0]["RowsAffected"]));
                    string QueryPlan = qp.GetQueryPlanForQuery(constring_1, batch);
                    string RowEstimate = qv.GetSumOfValues(QueryPlan, SqlNamespace, XPathForSproc);
                    Assert.AreEqual("1", RowEstimate);
                }

                if (i == 4 || i == 12)
                {
                    DateTime d = new DateTime(2016, 01, 10, 23, 45, 36);
                    DateTime t = Convert.ToDateTime(ds.Tables["table"].Rows[199]["RANGE_HI_KEY"]);
                    Assert.AreEqual(200, ds.Tables["table"].Rows.Count);
                    Assert.AreEqual(d, t);
                }

                if (i == 14)
                {
                    DateTime d = new DateTime(2016, 01, 11, 23, 45, 36);
                    DateTime t = Convert.ToDateTime(ds.Tables["table"].Rows[199]["RANGE_HI_KEY"]);
                    Assert.AreEqual(200, ds.Tables["table"].Rows.Count);
                    Assert.AreEqual(d, t);
                }

                if (i == 15)
                {
                    Assert.AreEqual(100, Convert.ToInt32(ds.Tables["table"].Rows[0]["RowsAffected"]));
                    string QueryPlan = qp.GetQueryPlanForQuery(constring_1, batch);
                    string RowEstimate = qv.GetSumOfValues(QueryPlan, SqlNamespace, XPathForSproc);
                    Assert.AreEqual("99.125", RowEstimate);
                }
            }
        }
        [TestMethod]
        public void TestOutOfDateStatistics_Demo2()
        {
            GetConnection u = new GetConnection();
            GetBatches b = new GetBatches();
            GetBatchResult r = new GetBatchResult();

            string constring_1 = u.GetConnectionString("SabinIO.Statistics.OutOfDate");
            string[] batches = b.GetFileContent(@"..\\..\\..\\SabinIO.Statistics.OutOfDate\\demos\\OutOfDateStatistics_Demo2.sql");
            int Rows = 0;
            string StatsDate = string.Empty; 


            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                DataSet ds = r.GetDataSet(batch, constring_1);

                if (i==1)
                {
                    Rows = Convert.ToInt32(ds.Tables["table"].Rows[0]["rows"]);
                    StatsDate = Convert.ToString(ds.Tables["table"].Rows[0]["column1"]);
                }

                if (i == 4 || i == 7 || i == 10)
                {
                    Assert.IsTrue (Convert.ToInt32(ds.Tables["table"].Rows[0]["rows"]) > Rows);
                    Assert.AreEqual(Convert.ToString(ds.Tables["table"].Rows[0]["column1"]), StatsDate);
                    //increase row count for next test in this loop
                    Rows = Convert.ToInt32(ds.Tables["table"].Rows[0]["rows"]);
                }

                if (i == 13)
                {
                    Assert.IsTrue(Convert.ToInt32(ds.Tables["table"].Rows[0]["rows"]) > Rows);
                    Assert.AreNotEqual(Convert.ToString(ds.Tables["table"].Rows[0]["column1"]), StatsDate);
                }
            }
        }
    }
}