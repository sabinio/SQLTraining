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
    public class LogOverhead
    {
        [TestCategory("RunOnBuild")]
        [TestMethod]
        public void LogOverheadDemo1()
        {
            string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.LogOverhead.Demo;Data Source=(localdb)\\ProjectsV12";
            string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.LogOverhead.Demo\\Demos\\Demo1.sql");

            //name of database includes "gO", so removed case sensitivity from regex
            //all demo scripts must use keyword GO in uppercase only
            string[] batches = Regex.Split(fileContent, "GO");

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                SqlDataAdapter da = new SqlDataAdapter(batch, constring);
                DataSet ds = new DataSet();
                da.Fill(ds);
                da.Dispose();

                if (i == 2)
                {
                    DataTable dt_singleValue = new DataTable();
                    DataTable dt_multipleValues = new DataTable();
                    dt_singleValue = ds.Tables["Table"];
                    dt_multipleValues = ds.Tables["Table1"];

                    int session_id_1 = Convert.ToInt32(dt_singleValue.Rows[0]["session_id"]);
                    int database_transaction_log_record_count_1 = Convert.ToInt32(dt_singleValue.Rows[0]["database_transaction_log_record_count"]);
                    int database_transaction_log_bytes_used_1 = Convert.ToInt32(dt_singleValue.Rows[0]["database_transaction_log_bytes_used"]);
                    int database_transaction_log_bytes_reserved_1 = Convert.ToInt32(dt_singleValue.Rows[0]["database_transaction_log_bytes_reserved"]);

                    int session_id_2 = Convert.ToInt32(dt_multipleValues.Rows[0]["session_id"]);
                    int database_transaction_log_record_count_2 = Convert.ToInt32(dt_multipleValues.Rows[0]["database_transaction_log_record_count"]);
                    int database_transaction_log_bytes_used_2 = Convert.ToInt32(dt_multipleValues.Rows[0]["database_transaction_log_bytes_used"]);
                    int database_transaction_log_bytes_reserved_2 = Convert.ToInt32(dt_multipleValues.Rows[0]["database_transaction_log_bytes_reserved"]);

                    Assert.IsTrue(session_id_1 == session_id_2);
                    Assert.IsTrue(database_transaction_log_bytes_reserved_1 < database_transaction_log_bytes_reserved_2);
                    Assert.IsTrue(database_transaction_log_bytes_used_1 < database_transaction_log_bytes_used_2);
                    Assert.IsTrue(database_transaction_log_record_count_1 < database_transaction_log_record_count_2);

                    Assert.IsTrue(dt_singleValue.Rows.Count == 1);
                    Assert.IsTrue(dt_multipleValues.Rows.Count == 1);
                }
            }
        }

        [TestCategory("RunOnBuild")]
        [TestMethod]
        public void LogOverheadDemo2()
        {
            string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.LogOverhead.Demo;Data Source=(localdb)\\ProjectsV12";
            string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.LogOverhead.Demo\\Demos\\Demo2.sql");

            //name of database includes "gO", so removed case sensitivity from regex
            //all demo scripts must use keyword GO in uppercase only
            string[] batches = Regex.Split(fileContent, "GO");

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                SqlDataAdapter da = new SqlDataAdapter(batch, constring);
                DataSet ds = new DataSet();
                da.Fill(ds);
                da.Dispose();

                if (i == 2)
                {
                    DataTable dt_singleValue = new DataTable();
                    DataTable dt_multipleValues = new DataTable();
                    dt_singleValue = ds.Tables["Table"];
                    dt_multipleValues = ds.Tables["Table1"];

                    int session_id_1 = Convert.ToInt32(dt_singleValue.Rows[0]["session_id"]);
                    int database_transaction_log_record_count_1 = Convert.ToInt32(dt_singleValue.Rows[0]["database_transaction_log_record_count"]);
                    int database_transaction_log_bytes_used_1 = Convert.ToInt32(dt_singleValue.Rows[0]["database_transaction_log_bytes_used"]);
                    int database_transaction_log_bytes_reserved_1 = Convert.ToInt32(dt_singleValue.Rows[0]["database_transaction_log_bytes_reserved"]);

                    int session_id_2 = Convert.ToInt32(dt_multipleValues.Rows[0]["session_id"]);
                    int database_transaction_log_record_count_2 = Convert.ToInt32(dt_multipleValues.Rows[0]["database_transaction_log_record_count"]);
                    int database_transaction_log_bytes_used_2 = Convert.ToInt32(dt_multipleValues.Rows[0]["database_transaction_log_bytes_used"]);
                    int database_transaction_log_bytes_reserved_2 = Convert.ToInt32(dt_multipleValues.Rows[0]["database_transaction_log_bytes_reserved"]);

                    Assert.IsTrue(session_id_1 == session_id_2);
                    Assert.IsTrue(database_transaction_log_bytes_reserved_1 < database_transaction_log_bytes_reserved_2);
                    Assert.IsTrue(database_transaction_log_bytes_used_1 < database_transaction_log_bytes_used_2);
                    Assert.IsTrue(database_transaction_log_record_count_1 < database_transaction_log_record_count_2);

                    Assert.IsTrue(dt_singleValue.Rows.Count == 1);
                    Assert.IsTrue(dt_multipleValues.Rows.Count == 1);
                }
            }
        }

        [TestCategory("RunOnBuild")]
        [TestMethod]
        public void LogOverheadDemo3()
        {
            int LogSize_MB_PreRun = 0;
            int LogSize_MB_PostRun = 0;
            int rows_prerun = 0;
            string data_prerun = "";
            string index_prerun = "";

            int rows_postrun = 0;
            string data_postrun = "";
            string index_postrun = "";
            string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.LogOverhead.Demo;Data Source=(localdb)\\ProjectsV12";
            string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.LogOverhead.Demo\\Demos\\Demo3.sql");

            //name of database includes "gO", so removed case sensitivity from regex
            //all demo scripts must use keyword GO in uppercase only
            string[] batches = Regex.Split(fileContent, "GO");

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                SqlDataAdapter da = new SqlDataAdapter(batch, constring);
                da.SelectCommand.CommandTimeout = 120;
                DataSet ds = new DataSet();
                da.Fill(ds);
                da.Dispose();
                //shrink log file batches
                if (i == 2 || i == 5)
                {
                    DataTable shrinkFile = new DataTable();
                    shrinkFile = ds.Tables["Table"];
                    int CurrentSize = Convert.ToInt32(shrinkFile.Rows[0]["CurrentSize"]);
                    Assert.IsTrue(CurrentSize < 1024);
                }
                //rows still exist from previous 2 tes runs; this is expected
                if (i == 3)
                {
                    DataTable TableSize_PreRun = new DataTable();
                    TableSize_PreRun = ds.Tables["Table"];

                    rows_prerun = Convert.ToInt32(TableSize_PreRun.Rows[0]["rows"]);
                    data_prerun = Convert.ToString(TableSize_PreRun.Rows[0]["data"]);
                    index_prerun = Convert.ToString(TableSize_PreRun.Rows[0]["index_size"]);

                    Assert.IsTrue(rows_prerun == 5);
                    Assert.AreEqual("8 KB", data_prerun);
                    Assert.AreEqual("8 KB", index_prerun);
                }
                //insert 250,000 rows on batch 4 into logoverhead table, inseert 250,000 rows on batch 7 into logoverhead2 table
                if (i == 4 || i == 7)
                {
                    DataTable LogSize_PreRun = new DataTable();
                    LogSize_PreRun = ds.Tables["Table"];
                    LogSize_MB_PreRun = Convert.ToInt32(LogSize_PreRun.Rows[0]["LogSize_MB"]);

                    DataTable LogSize_PostRun = new DataTable();
                    LogSize_PostRun = ds.Tables["Table1"];
                    LogSize_MB_PostRun = Convert.ToInt32(LogSize_PostRun.Rows[0]["LogSize_MB"]);

                    DataTable TableSize_PostRun = new DataTable();
                    TableSize_PostRun = ds.Tables["Table2"];
                    rows_postrun = Convert.ToInt32(TableSize_PostRun.Rows[0]["rows"]);
                    data_postrun = Convert.ToString(TableSize_PostRun.Rows[0]["data"]);
                    index_postrun = Convert.ToString(TableSize_PostRun.Rows[0]["index_size"]);

                    if (i == 4)
                    {
                        //Assert.AreEqual(2, LogSize_MB_PreRun);
                        Assert.AreEqual(82, LogSize_MB_PostRun, "error on batch 4 post load mb check");
                        Assert.AreEqual(250006, rows_postrun);
                        Assert.AreEqual("3384 KB", data_postrun);
                        Assert.AreEqual("8 KB", index_postrun);
                    }

                    if (i == 7)
                    {
                        //Assert.AreEqual(2, LogSize_MB_PreRun);
                        Assert.AreEqual(74, LogSize_MB_PostRun);
                        Assert.AreEqual(250006, rows_postrun);
                        Assert.AreEqual("3216 KB", data_postrun);
                        Assert.AreEqual("8 KB", index_postrun);
                    }

                }
            }
        }

        [TestCategory("RunOnBuild")]
        [TestMethod]
        public void LogOverheadDemo4()
        {
            int LogSize_MB_PreRun = 0;
            int LogSize_MB_PostRun = 0;
            string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.LogOverhead.Demo;Data Source=(localdb)\\ProjectsV12";
            string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.LogOverhead.Demo\\Demos\\Demo4.sql");

            //name of database includes "gO", so removed case sensitivity from regex
            //all demo scripts must use keyword GO in uppercase only
            string[] batches = Regex.Split(fileContent, "GO");

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                SqlDataAdapter da = new SqlDataAdapter(batch, constring);
                da.SelectCommand.CommandTimeout = 120;
                DataSet ds = new DataSet();
                da.Fill(ds);
                da.Dispose();
                //shrink log file batches
                if (i == 2)
                {
                    DataTable shrinkFile = new DataTable();
                    shrinkFile = ds.Tables["Table"];
                    int shrinkInt = Convert.ToInt32(shrinkFile.Rows[0]["CurrentSize"]);
                    Assert.IsTrue(shrinkInt < 1024);
                }

                if (i == 4)
                {
                    DataTable LogSize_PreRun = new DataTable();
                    LogSize_PreRun = ds.Tables["Table"];
                    LogSize_MB_PreRun = Convert.ToInt32(LogSize_PreRun.Rows[0]["LogSize_MB"]);
                    Assert.AreEqual(2, LogSize_MB_PreRun);

                    DataTable LogSize_PostRun = new DataTable();
                    LogSize_PostRun = ds.Tables["Table1"];
                    LogSize_MB_PostRun = Convert.ToInt32(LogSize_PostRun.Rows[0]["LogSize_MB"]);
                    Assert.AreEqual(109, LogSize_MB_PostRun);
                }
            }
        }


        [TestCategory("RunOnBuild")]
        [TestMethod]
        public void LogOverheadDemo5()
        {
            int LogSize_MB_PreRun = 0;
            int LogSize_MB_PostRun = 0;
            string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.LogOverhead.Demo;Data Source=(localdb)\\ProjectsV12";
            string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.LogOverhead.Demo\\Demos\\Demo5.sql");

            //name of database includes "gO", so removed case sensitivity from regex
            //all demo scripts must use keyword GO in uppercase only
            string[] batches = Regex.Split(fileContent, "GO");

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                SqlDataAdapter da = new SqlDataAdapter(batch, constring);
                da.SelectCommand.CommandTimeout = 120;
                DataSet ds = new DataSet();
                da.Fill(ds);
                da.Dispose();
                //shrink log file batches
                if (i == 2 || i == 5)
                {
                    DataTable shrinkFile = new DataTable();
                    shrinkFile = ds.Tables["Table"];
                    int shrinkInt = Convert.ToInt32(shrinkFile.Rows[0]["CurrentSize"]);
                    Assert.IsTrue(shrinkInt < 1024);
                }
                if (i == 4 || i == 7)
                {
                    DataTable LogSize_PreRun = new DataTable();
                    LogSize_PreRun = ds.Tables["Table"];
                    LogSize_MB_PreRun = Convert.ToInt32(LogSize_PreRun.Rows[0]["LogSize_MB"]);
                    Assert.AreEqual(2, LogSize_MB_PreRun);

                    DataTable LogSize_PostRun = new DataTable();
                    LogSize_PostRun = ds.Tables["Table1"];
                    LogSize_MB_PostRun = Convert.ToInt32(LogSize_PostRun.Rows[0]["LogSize_MB"]);

                    if (i == 4)
                    {
                        Assert.AreEqual(109, LogSize_MB_PostRun);
                    }
                    if (i == 6)
                    {
                        Assert.AreEqual(LogSize_MB_PreRun, LogSize_MB_PostRun);
                    }
                }
            }
        }
    }
}
