using System;
using System.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SabinIO.Demos.UnitTestFrameWork;

namespace SabinIO.Performance.UnitTesting
{
    [TestClass]
    public class UnionUnionAll
    {
        [TestMethod]
        public void TestUnionUnionAllDemo1()
        {
            GetConnection u = new GetConnection();
            GetBatches b = new GetBatches();
            GetBatchResult r = new GetBatchResult();
            GetQueryPlan qp = new GetQueryPlan();
            GetQueryPlanValues qv = new GetQueryPlanValues();

            string constring_1 = u.GetConnectionString("SabinIO.Performance.UnionUnionAll");
            string[] batches = b.GetFileContent(@"..\\..\\..\\SabinIO.Performance.UnionUnionAll\\Demos\\UnionUnionAllDemo1.sql");
            string SqlNamespace = "http://schemas.microsoft.com/sqlserver/2004/07/showplan";
            string XPath = "//sql:Batch/sql:Statements/sql:StmtSimple/sql:QueryPlan[1]/sql:RelOp[1]/@LogicalOp";

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                DataSet ds = r.GetDataSet(batch, constring_1);

                if (i == 3)
                {
                    Assert.AreEqual(8, Convert.ToInt32(ds.Tables["table"].Rows.Count));
                }

                if (i == 4)
                {
                    Assert.AreEqual(5, Convert.ToInt32(ds.Tables["table"].Rows.Count));
                    string QueryPlan = qp.GetQueryPlanForQuery(constring_1, batch);
                    string _operator = qv.GetSingleValue(QueryPlan, SqlNamespace, XPath);
                    Assert.AreEqual("Distinct Sort", _operator);
                }
            }
        }
        [TestMethod]
        public void TestUnionUnionAllDemo2()
        {
            GetConnection u = new GetConnection();
            GetBatches b = new GetBatches();
            GetBatchResult r = new GetBatchResult();
            GetQueryPlan qp = new GetQueryPlan();
            GetQueryPlanValues qv = new GetQueryPlanValues();

            string constring_1 = u.GetConnectionString("AdventureWorks2014");
            string[] batches = b.GetFileContent(@"..\\..\\..\\SabinIO.Performance.UnionUnionAll\\Demos\\UnionUnionAllDemo2.sql");
            string SqlNamespace = "http://schemas.microsoft.com/sqlserver/2004/07/showplan";
            string XPath = "//sql:Batch/sql:Statements/sql:StmtSimple/sql:QueryPlan[1]/sql:RelOp[1]/@LogicalOp";

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                DataSet ds = r.GetDataSet(batch, constring_1);

                if (i == 4)
                {
                    string QueryPlan = qp.GetQueryPlanForQuery(constring_1, batch);
                    string _operator = qv.GetSingleValue(QueryPlan, SqlNamespace, XPath);
                    Assert.AreEqual("Distinct Sort", _operator);
                }
            }
        }
    }
}
