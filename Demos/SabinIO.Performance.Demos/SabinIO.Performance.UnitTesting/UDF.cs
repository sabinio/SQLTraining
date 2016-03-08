using System;
using System.Data;
using System.Diagnostics;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SabinIO.Demos.UnitTestFrameWork;

namespace SabinIO.Performance.UnitTesting
{
    [TestClass]
    public class UDF
    {
        [TestMethod]
        public void TestUDFDemo1()
        {
            GetConnection u = new GetConnection();
            GetBatches b = new GetBatches();
            GetBatchResult r = new GetBatchResult();

            string constring_1 = u.GetConnectionString("SabinIO.Performance.UDF");
            string[] batches = b.GetFileContent(@"..\\..\\..\\SabinIO.Performance.UDF\\Demos\\Udf_Demo1.sql");

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                DataSet ds = r.GetDataSet(batch, constring_1);

                if (i == 2)
                {
                    DataView v = new DataView(ds.Tables["table"]);
                    DataTable distinctValues = v.ToTable(true, "CurDate");
                    //Ive seen cases of values looking identical but not being handled as identical, so the count just confirms that everything is identical
                    int count = Convert.ToInt32(distinctValues.Rows.Count);
                    if (count == 1)
                    {
                        Assert.AreEqual(1, Convert.ToInt32(distinctValues.Rows.Count));
                    }

                    if (count == 2)
                    {
                        Assert.AreEqual(ds.Tables["Table"].Rows[0]["CurDate"], ds.Tables["Table"].Rows[1]["CurDate"]);
                    }
                }
                if (i == 4)
                {
                    Assert.IsTrue(ds.Tables["Table"].Rows.Count >= 2);
                }
            }
        }

        [TestMethod]
        public void TestUDFDemo2()
        {
            GetConnection u = new GetConnection();
            GetBatches b = new GetBatches();
            GetBatchResult r = new GetBatchResult();
            GetQueryPlan qp = new GetQueryPlan();
            GetQueryPlanValues qv = new GetQueryPlanValues();

            string constring_1 = u.GetConnectionString("AdventureWorks2014");
            string[] batches = b.GetFileContent(@"..\\..\\..\\SabinIO.Performance.UDF\\Demos\\Udf_Demo2.sql");
            string SqlNamespace = "http://schemas.microsoft.com/sqlserver/2004/07/showplan";
            string XPath = "//sql:Batch/sql:Statements/sql:StmtSimple/sql:QueryPlan[1]/sql:RelOp/sql:StreamAggregate/sql:RelOp/sql:Top/sql:RelOp/@LogicalOp";
            long batchFiveDuration = 0;
            long batchSixDuration = 0;
            long batchTwelveDuration = 0;
            long batchThirteenDuration = 0;

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                DataSet ds = r.GetDataSet(batch, constring_1);

                if (i == 5)
                {
                    Stopwatch sw = new Stopwatch();
                    sw.Start();
                    DataSet ds_5 = r.GetDataSet(batch, constring_1);
                    sw.Stop();
                    batchFiveDuration = sw.ElapsedMilliseconds;

                    string QueryPlan = qp.GetQueryPlanForQuery(constring_1, batch);
                    string _operator = qv.GetSingleValue(QueryPlan, SqlNamespace, XPath);
                    Assert.AreEqual("Compute Scalar", _operator);
                }

                if (i == 6)
                {
                    Stopwatch sw = new Stopwatch();
                    sw.Start();
                    DataSet ds_6 = r.GetDataSet(batch, constring_1);
                    sw.Stop();
                    batchSixDuration = sw.ElapsedMilliseconds;
                    Assert.IsTrue(batchFiveDuration < batchSixDuration);
                }

                if (i == 12)
                {
                    Stopwatch sw = new Stopwatch();
                    sw.Start();
                    DataSet ds_5 = r.GetDataSet(batch, constring_1);
                    sw.Stop();
                    batchTwelveDuration = sw.ElapsedMilliseconds;
                    Assert.IsTrue(batchTwelveDuration < batchSixDuration);
                }

                if (i == 13)
                {
                    Stopwatch sw = new Stopwatch();
                    sw.Start();
                    DataSet ds_6 = r.GetDataSet(batch, constring_1);
                    sw.Stop();
                    batchThirteenDuration = sw.ElapsedMilliseconds;
                    Assert.IsTrue(batchTwelveDuration <= batchThirteenDuration);
                }
            }
        }

        [TestMethod]
        public void TestUDFDemo3()
        {
            GetConnection u = new GetConnection();
            GetBatches b = new GetBatches();
            GetBatchResult r = new GetBatchResult();

            string constring_1 = u.GetConnectionString("AdventureWorks2014");
            string[] batches = b.GetFileContent(@"..\\..\\..\\SabinIO.Performance.UDF\\Demos\\Udf_Demo3.sql");
            long batchThreeDuration = 0;
            long batchSixDuration = 0;

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                DataSet ds = r.GetDataSet(batch, constring_1);

                if (i == 3)
                {
                    Stopwatch sw = new Stopwatch();
                    sw.Start();
                    DataSet ds_5 = r.GetDataSet(batch, constring_1);
                    sw.Stop();
                    batchThreeDuration = sw.ElapsedMilliseconds;
                }

                if (i == 6)
                {
                    Stopwatch sw = new Stopwatch();
                    sw.Start();
                    DataSet ds_5 = r.GetDataSet(batch, constring_1);
                    sw.Stop();
                    batchSixDuration = sw.ElapsedMilliseconds;

                    Assert.IsTrue(batchThreeDuration > batchSixDuration);
                }
            }
        }
    }
}
