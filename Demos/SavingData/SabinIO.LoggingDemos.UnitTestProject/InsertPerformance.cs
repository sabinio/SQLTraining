using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data;
using System.IO;
using System.Text.RegularExpressions;
using System.Data.SqlClient;

namespace SabinIO.LoggingDemos.UnitTestProject
{
    [TestClass]
    public class InsertPerformance
    {

        [TestMethod]
        [TestCategory("RunOnBuild")]
        public void TestMethodInsertPerformanceDemo1()
        {
            int database_transaction_log_record_count_1 = 0;
            int database_transaction_log_bytes_used_1 = 0;
            int database_transaction_log_bytes_reserved_1 = 0;

            int database_transaction_log_record_count_2 = 0;
            int database_transaction_log_bytes_used_2 = 0;
            int database_transaction_log_bytes_reserved_2 = 0;

            int database_transaction_log_record_count_3 = 0;
            int database_transaction_log_bytes_used_3 = 0;
            int database_transaction_log_bytes_reserved_3 = 0;

            int database_transaction_log_record_count_4 = 0;
            int database_transaction_log_bytes_used_4 = 0;
            int database_transaction_log_bytes_reserved_4 = 0;

            int page_count_1 = 0;
            int page_count_2 = 0;

            int page_count_3 = 0;
            int page_count_4 = 0;

            int page_count = 0;

            string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.InsertPerformance.Demo;Data Source=.";
            string fileContent = File.ReadAllText("..\\..\\..\\SabinIO.InsertPerformance.Demo\\Demos\\Demo1.sql");
            string[] batches = Regex.Split(fileContent, "GO", RegexOptions.IgnoreCase);

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];

                if (i >= 2)
                {
                    batch = batch.Replace("200", "20");
                }
                SqlDataAdapter da = new SqlDataAdapter(batch, constring);
                DataSet ds = new DataSet();
                da.Fill(ds);
                da.Dispose();
                if (i == 2)
                {
                    DataTable dt = new DataTable();
                    DataTable dt2 = new DataTable();
                    dt = ds.Tables["Table"];
                    dt2 = ds.Tables["Table1"];
                        
                    database_transaction_log_record_count_1 = Convert.ToInt32(dt.Rows[0]["database_transaction_log_record_count"]);
                    database_transaction_log_bytes_used_1 = Convert.ToInt32(dt.Rows[0]["database_transaction_log_bytes_used"]);
                    database_transaction_log_bytes_reserved_1 = Convert.ToInt32(dt.Rows[0]["database_transaction_log_bytes_reserved"]);
                   
                    page_count_1 = Convert.ToInt32(dt2.Rows[0]["page_count"]);
                }

                if (i == 3)
                {
                    DataTable dt3 = new DataTable();
                    DataTable dt4 = new DataTable();
                    dt3 = ds.Tables["Table"];
                    dt4 = ds.Tables["Table1"];
                    database_transaction_log_record_count_2 = Convert.ToInt32(dt3.Rows[0]["database_transaction_log_record_count"]);
                    database_transaction_log_bytes_used_2 = Convert.ToInt32(dt3.Rows[0]["database_transaction_log_bytes_used"]);
                    database_transaction_log_bytes_reserved_2 = Convert.ToInt32(dt3.Rows[0]["database_transaction_log_bytes_reserved"]);

                    page_count_2 = Convert.ToInt32(dt4.Rows[0]["page_count"]);
                }

                if (i == 4)
                {
                    DataTable dt5 = new DataTable();
                    DataTable dt6 = new DataTable();
                    dt5 = ds.Tables["Table"];
                    dt6 = ds.Tables["Table1"];
                    database_transaction_log_record_count_3 = Convert.ToInt32(dt5.Rows[0]["database_transaction_log_record_count"]);
                    database_transaction_log_bytes_used_3 = Convert.ToInt32(dt5.Rows[0]["database_transaction_log_bytes_used"]);
                    database_transaction_log_bytes_reserved_3 = Convert.ToInt32(dt5.Rows[0]["database_transaction_log_bytes_reserved"]);

                    page_count_3 = Convert.ToInt32(dt6.Rows[0]["page_count"]);
                }

                if (i == 6)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];
                    page_count = Convert.ToInt32(dti.Rows[0]["page_count"]);
                }

                if (i == 7)
                {
                    DataTable dt7 = new DataTable();
                    DataTable dt8 = new DataTable();
                    dt7 = ds.Tables["Table"];
                    dt8 = ds.Tables["Table1"];
                   database_transaction_log_record_count_4 = Convert.ToInt32(dt7.Rows[0]["database_transaction_log_record_count"]);
                   database_transaction_log_bytes_used_4 = Convert.ToInt32(dt7.Rows[0]["database_transaction_log_bytes_used"]);
                   database_transaction_log_bytes_reserved_4 = Convert.ToInt32(dt7.Rows[0]["database_transaction_log_bytes_reserved"]);

                   page_count_4 = Convert.ToInt32(dt8.Rows[0]["page_count"]);

                }
            }
            Assert.IsTrue(database_transaction_log_record_count_1 > database_transaction_log_record_count_2);
            Assert.IsTrue(database_transaction_log_bytes_used_1 > database_transaction_log_bytes_used_2);
            Assert.IsTrue(database_transaction_log_bytes_reserved_1 > database_transaction_log_bytes_reserved_2);
            Assert.IsTrue(page_count_1 < page_count_2);

            Assert.IsTrue(database_transaction_log_record_count_3 > database_transaction_log_record_count_4);
            Assert.IsTrue(database_transaction_log_bytes_used_3 > database_transaction_log_bytes_used_4);
            Assert.IsTrue(database_transaction_log_bytes_reserved_3 > database_transaction_log_bytes_reserved_4);
            Assert.IsTrue(page_count_3 < page_count_4);
            Assert.IsTrue(page_count == page_count_4);
        }

        [TestMethod]
        [TestCategory("RunOnBuild")]
        public void TestMethodInsertPerformanceDemo2()
        {
            int page_count_1 = 0;
            int page_count_2 = 0;
            string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.InsertPerformance.Demo;Data Source=.;";
            string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.InsertPerformance.Demo\\Demos\\Demo2.sql");
            string[] batches = Regex.Split(fileContent, "GO", RegexOptions.IgnoreCase);

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i];
                if (i >= 1)
                {
                    batch = batch.Replace("200", "20");
                }
                SqlDataAdapter da = new SqlDataAdapter(batch, constring);
                DataSet ds = new DataSet();
                da.Fill(ds);
                da.Dispose();
                if (i == 3)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];
                    page_count_1 = Convert.ToInt32(dti.Rows[0]["page_count"]);
                }

                if (i == 5)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];
                    page_count_2 = Convert.ToInt32(dti.Rows[0]["page_count"]);
                }
            }
            Assert.IsTrue(page_count_1 < page_count_2);
        }
    }
}

