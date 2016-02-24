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
    public class DirtyPage
    {
        [TestMethod]
        [TestCategory("RunOnBuild")]
        public void TestDemo1WriteLogToTest()
        {
            string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.dirtyPage.Demo;Data Source=.";
            string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.DirtyPage.Demo\\Demos\\Demo1-WriteLogTest.sql");
            string[] batches = Regex.Split(fileContent, "GO", RegexOptions.IgnoreCase);

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                SqlDataAdapter da = new SqlDataAdapter(batch, constring);
                DataSet ds = new DataSet();
                da.Fill(ds);
                da.Dispose();

                if (i == 3)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];

                    var WriteLogTest = dti.Rows[0]["StringColumn"];
                    Assert.AreEqual("CleanPage", WriteLogTest);
                }
                if (i == 4)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];

                   var WriteLogTest = dti.Rows[0]["StringColumn"];
                   Assert.AreEqual("DirtyPage", WriteLogTest);
                }
            }
        }

        [TestMethod]
        [TestCategory("RunOnBuild")]
        public void TestDemo2IncompleteWriteLogToTest()
        {
            string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.dirtyPage.Demo;Data Source=.";
            string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.DirtyPage.Demo\\Demos\\Demo2-IncompleteTransactionWriteLogTest.sql");
            string[] batches = Regex.Split(fileContent, "GO", RegexOptions.IgnoreCase);

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                SqlDataAdapter da = new SqlDataAdapter(batch, constring);
                DataSet ds = new DataSet();
                da.Fill(ds);
                da.Dispose();

                if (i == 2)
                {
                   DataTable dti = new DataTable();
                   dti = ds.Tables["Table"];

                   var WriteLogTest = dti.Rows[0]["StringColumn"];
                   Assert.AreEqual("DirtyPageTran", WriteLogTest);

                   System.Diagnostics.Process stop = new System.Diagnostics.Process();
                   stop.StartInfo.FileName = "cmd.exe";
                   stop.StartInfo.Arguments = "/C SqlLocalDB.exe stop ProjectsV12";
                   stop.Start();
                   stop.WaitForExit();
                   int stopResult = stop.ExitCode;

                   System.Diagnostics.Process strt = new System.Diagnostics.Process();
                   strt.StartInfo.FileName = "cmd.exe";
                   strt.StartInfo.Arguments = "/C SqlLocalDB.exe start ProjectsV12";
                   strt.Start();
                   strt.WaitForExit();
                   int strtResult = strt.ExitCode;
                }
                if (i == 3)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];
                    Assert.AreEqual(0, dti.Rows.Count);
                }
            }
        }
    }
}
