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
    public class Parameterisation
    {
        [TestMethod]
        public void TestParameterisationDemo()
        {
            GetConnection u = new GetConnection();
            GetBatches b = new GetBatches();
            GetBatchResult r = new GetBatchResult();
            GetQueryPlanValues q = new GetQueryPlanValues();

            string constring_1 = u.GetConnectionString("AdventureWorks2014");
            string[] batches = b.GetFileContent(@"..\\..\\..\\SabinIO.Parameterisation\\demos\\Parameterisation.Demo1.sql");
            string XPath = "//sql:Batch/sql:Statements/sql:StmtSimple/" + "sql:QueryPlan[1]/sql:RelOp[1]/@EstimateRows";
            string SqlNamespace = "http://schemas.microsoft.com/sqlserver/2004/07/showplan";
            string ConvertQueryPlan;
            string Batch6EstimatedRows = String.Empty;
            string Batch9EstimatedRows = String.Empty;
            string Batch12EstimatedRows = String.Empty;
            string Batch15EstimatedRows = String.Empty;

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                DataSet ds = r.GetDataSet(batch, constring_1);

                if (i == 4)
                {
                    Assert.AreEqual(2, ds.Tables["Table"].Rows.Count);
                    DataRow[] adhoc = ds.Tables["Table"].Select(@"objtype = 'Adhoc'");
                    Assert.AreEqual(2, adhoc.Length);
                }
                if (i == 6)
                {
                    Assert.AreEqual(3, ds.Tables["Table"].Rows.Count);
                    DataRow[] Prepared = ds.Tables["Table"].Select(@"objtype = 'Prepared'");
                    Assert.AreEqual(1, Prepared.Length);
                    ConvertQueryPlan = Convert.ToString(Prepared[0]["query_plan"]);

                    Batch6EstimatedRows = q.GetSumOfValues(ConvertQueryPlan, SqlNamespace, XPath);
                }
                if (i == 9 || i == 12 || i == 15)
                {
                    Assert.AreEqual(1, ds.Tables["Table"].Rows.Count);
                    DataRow[] Prepared = ds.Tables["Table"].Select(@"objtype = 'Prepared'");
                    ConvertQueryPlan = Convert.ToString(Prepared[0]["query_plan"]);
                    if (i == 9)
                    {
                        Batch9EstimatedRows = q.GetSumOfValues(ConvertQueryPlan, SqlNamespace, XPath);
                        Assert.AreNotEqual(Batch6EstimatedRows, Batch9EstimatedRows);
                    }
                    if (i == 12)
                    {
                        Batch12EstimatedRows = q.GetSumOfValues(ConvertQueryPlan, SqlNamespace, XPath);
                        Assert.AreEqual(Batch6EstimatedRows, Batch12EstimatedRows);
                    }
                    if (i == 15)
                    {
                        Batch15EstimatedRows = q.GetSumOfValues(ConvertQueryPlan, SqlNamespace, XPath);
                        Assert.AreNotEqual(Batch12EstimatedRows, Batch15EstimatedRows);
                        Assert.AreNotEqual(Batch6EstimatedRows, Batch15EstimatedRows);
                    }
                }
            }
        }
    }
}
