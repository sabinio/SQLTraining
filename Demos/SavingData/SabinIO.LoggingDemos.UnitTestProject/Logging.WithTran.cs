using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data;
using System.IO;
using System.Text.RegularExpressions;
using System.Data.SqlClient;
using SabinIO.LoggingDemos.UnitTestProject;

namespace SabinIO.LoggingDemos.UnitTestProject
{
    [TestClass]
    
    public class Logging
    {
        [TestMethod]
        [TestCategory("RunOnBuild")]
        public void TestLoggingWithTranWithOrWithout()
        {
            int NoTran = 0;
            int ExplicitTran = 0;
            //must express initial catalogue as correct db as each batch will default to this database
            string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.Logging.WithTran;Data Source=.";
            //relative path in solution; test will not run on the build if we change this
            string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.Logging.WithTran\\Demos\\1. WithorWithout.sql");
            //regex means we can ignore changes in GO casing
            string[] batches = Regex.Split(fileContent, "GO", RegexOptions.IgnoreCase);

            //for loop neater than a foreach loop
            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                SqlDataAdapter da = new SqlDataAdapter(batch, constring);
                da.SelectCommand.CommandTimeout = 120;
                DataSet ds = new DataSet();
                da.Fill(ds);
                da.Dispose();
                //array starts at 0, so whatever the batch number that we want to "test", we have to subtract 1 from the batch count
                if (i == 1)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];
                    NoTran = Convert.ToInt32(dti.Rows[0]["RunTime"]);
                }

                if (i == 2)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];
                    ExplicitTran = Convert.ToInt32(dti.Rows[0]["RunTime"]);
                }
            }
            Assert.IsTrue(NoTran >= ExplicitTran, "Results are: no transaction; {0}, Explicit Tran; {1}", NoTran, ExplicitTran);
        }

        [TestMethod]
        public void LoggingWithTranDemosViewCounters()
        {
            //this test will not run on a localdb instance of SQL Server
            //this is because performance counters are not logged as part of localdb in either the table or via perfmon

            //must express initial catalogue as correct db as each batch will default to this database
            string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.Logging.WithTran;Data Source=.";
            //relative path in solution; test will not run on the build if we change this
            string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.Logging.WithTran\\Demos\\2. ViewCounters.sql");
            //regex means we can ignore changes in GO casing
            string[] batches = Regex.Split(fileContent, "GO", RegexOptions.IgnoreCase);
            int noTranFlushes = 0;

            //for loop neater than a foreach loop
            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];

                if (i > 1)
                {
                    batch = batch.Replace("2000", "200");
                }
                SqlDataAdapter da = new SqlDataAdapter(batch, constring);
                DataSet ds = new DataSet();
                da.Fill(ds);
                da.Dispose();

                if (i == 2)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];
                    noTranFlushes = Convert.ToInt32(dti.Rows[0]["Flushes"]);
                    Assert.IsTrue(noTranFlushes >= 200);
                }

                if (i == 3)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];
                    noTranFlushes = Convert.ToInt32(dti.Rows[0]["Flushes"]);
                    Assert.IsTrue(noTranFlushes >=30);
                }
            }
        }
    }
}