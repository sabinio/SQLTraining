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

            string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.InsertPerformance.Demo;Data Source=(localdb)\\ProjectsV12";
            string fileContent = File.ReadAllText("..\\..\\..\\SabinIO.InsertPerformance.Demo\\Demos\\Demo1.sql");
            string[] batches = Regex.Split(fileContent, "GO", RegexOptions.IgnoreCase);


            int batchesCount = 1;
            foreach (string batch in batches)


            {
                SqlDataAdapter da = new SqlDataAdapter(batch, constring);
                DataSet ds = new DataSet();
                da.Fill(ds);
                da.Dispose();
                if (batchesCount == 3)
                {
                    DataTable dt = new DataTable();
                    DataTable dt2 = new DataTable();
                    dt = ds.Tables["Table"];
                    dt2 = ds.Tables["Table1"];
                    foreach (DataRow o in dt.Select("1=1"))
                    {
                        database_transaction_log_record_count_1 = Convert.ToInt32(o["database_transaction_log_record_count"]);
                        database_transaction_log_bytes_used_1 = Convert.ToInt32(o["database_transaction_log_bytes_used"]);
                        database_transaction_log_bytes_reserved_1 = Convert.ToInt32(o["database_transaction_log_bytes_reserved"]);
                    }

                    foreach (DataRow o in dt2.Select("1=1"))
                    {
                        page_count_1 = Convert.ToInt32(o["page_count"]);
                    }

                }

                if (batchesCount == 4)
                {
                    DataTable dt3 = new DataTable();
                    DataTable dt4 = new DataTable();
                    dt3 = ds.Tables["Table"];
                    dt4 = ds.Tables["Table1"];
                    foreach (DataRow o in dt3.Select("1=1"))
                    {
                        database_transaction_log_record_count_2 = Convert.ToInt32(o["database_transaction_log_record_count"]);
                        database_transaction_log_bytes_used_2 = Convert.ToInt32(o["database_transaction_log_bytes_used"]);
                        database_transaction_log_bytes_reserved_2 = Convert.ToInt32(o["database_transaction_log_bytes_reserved"]);

                    }
                    foreach (DataRow o in dt4.Select("1=1"))
                    {

                        page_count_2 = Convert.ToInt32(o["page_count"]);
                    }
                }

                if (batchesCount == 5)
                {
                    DataTable dt5 = new DataTable();
                    DataTable dt6 = new DataTable();
                    dt5 = ds.Tables["Table"];
                    dt6 = ds.Tables["Table1"];
                    foreach (DataRow o in dt5.Select("1=1"))
                    {
                        database_transaction_log_record_count_3 = Convert.ToInt32(o["database_transaction_log_record_count"]);
                        database_transaction_log_bytes_used_3 = Convert.ToInt32(o["database_transaction_log_bytes_used"]);
                        database_transaction_log_bytes_reserved_3 = Convert.ToInt32(o["database_transaction_log_bytes_reserved"]);

                    }
                    foreach (DataRow o in dt6.Select("1=1"))
                    {

                        page_count_3 = Convert.ToInt32(o["page_count"]);
                    }
                }

                if (batchesCount == 7)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];

                    foreach (DataRow o in dti.Select("1=1"))
                    {

                        page_count = Convert.ToInt32(o["page_count"]);
                    }
                }

                if (batchesCount == 8)
                {
                    DataTable dt7 = new DataTable();
                    DataTable dt8 = new DataTable();
                    dt7 = ds.Tables["Table"];
                    dt8 = ds.Tables["Table1"];
                    foreach (DataRow o in dt7.Select("1=1"))
                    {
                        database_transaction_log_record_count_4 = Convert.ToInt32(o["database_transaction_log_record_count"]);
                        database_transaction_log_bytes_used_4 = Convert.ToInt32(o["database_transaction_log_bytes_used"]);
                        database_transaction_log_bytes_reserved_4 = Convert.ToInt32(o["database_transaction_log_bytes_reserved"]);

                    }
                    foreach (DataRow o in dt8.Select("1=1"))
                    {

                        page_count_4 = Convert.ToInt32(o["page_count"]);
                    }
                }
                batchesCount++;
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
        public void TestMethodInsertPerformanceDemo2()
        {
            int page_count_1 = 0;
            int page_count_2 = 0;
            string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.InsertPerformance.Demo;Data Source=(localdb)\\ProjectsV12;";
            string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.InsertPerformance.Demo\\Demos\\Demo2.sql");
            string[] batches = Regex.Split(fileContent, "GO", RegexOptions.IgnoreCase);


            int batchesCount = 1;
            foreach (string batch in batches)


            {
                SqlDataAdapter da = new SqlDataAdapter(batch, constring);
                DataSet ds = new DataSet();
                da.Fill(ds);
                da.Dispose();
                if (batchesCount == 4)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];

                    foreach (DataRow o in dti.Select("1=1"))
                    {

                        page_count_1 = Convert.ToInt32(o["page_count"]);
                    }

                }

                if (batchesCount == 6)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];

                    foreach (DataRow o in dti.Select("1=1"))
                    {

                        page_count_2 = Convert.ToInt32(o["page_count"]);
                    }

                }
                batchesCount++;
                
            }
            Assert.IsTrue(page_count_1 < page_count_2);
        }

    }
}

