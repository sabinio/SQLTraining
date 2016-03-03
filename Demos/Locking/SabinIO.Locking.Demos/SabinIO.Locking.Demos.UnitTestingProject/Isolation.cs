using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data;
using System.IO;
using System.Text.RegularExpressions;
using System.Data.SqlClient;
using System.Collections.Generic;

namespace SabinIO.Locking.Demos.UnitTestingProject
{
    [TestClass]
    public class Isolation
    {
        private IAsyncResult batch_session_2_2_result;

        [TestMethod]
        public void TestReadingLockedRecords()
        {   //separate connections because trying to reuse same connection breaks the transaction we setup
            string constring_1 = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.Locking.Isolation;Data Source=.";

            //two separate files to read from
            string fileContent_session_1 = File.ReadAllText(@"..\\..\\..\\SabinIO.Locking.Isolation\\Demos\\Demo1 - Reading Locked Records - Session 1.sql");
            string fileContent_session_2 = File.ReadAllText(@"..\\..\\..\\SabinIO.Locking.Isolation\\Demos\\Demo1 - Reading Locked Records - Session 2.sql");

            //split two separate files into different batches... I suppose we could put in one array but then test would be more difficult to follow
            string[] batches_session_1 = Regex.Split(fileContent_session_1, "GO", RegexOptions.IgnoreCase);
            string[] batches_session_2 = Regex.Split(fileContent_session_2, "GO", RegexOptions.IgnoreCase);

            //expected error message from batch 2_4
            string fourth_batch_error_message = "Timeout expired.  The timeout period elapsed prior to completion of the operation or the server is not responding.";

            //same data table cleared and re-used for each test
            DataTable dti = new DataTable();

            //we only really care about the values in this column, so we build a list of the values in each batch that attempts to make a change
            List<String> Col1 = new List<String>();

            string _conn_1 = constring_1;
            string _conn_2 = constring_1;

            // the fill method of a data adaptor will open and close a connection each time it is called ONLY if the connection is not already open
            // seeing as we need to keep a connection open with a transaction not yet committed/rolled back, we need to open the connection and open a transaction to keep it open
            // we then close the connection at the end of the test

            using (SqlConnection _constring = new SqlConnection(_conn_1))
            using (SqlConnection _constring_2 = new SqlConnection(_conn_2))

            //declare the commands and specify which connection each batch/command will be using

            using (SqlCommand batch_session_1_1 = new SqlCommand(batches_session_1[1], _constring))
            using (SqlCommand batch_session_2_1 = new SqlCommand(batches_session_2[1], _constring_2))
            using (SqlCommand batch_session_2_2 = new SqlCommand(batches_session_2[2], _constring_2))
            using (SqlCommand batch_session_2_3 = new SqlCommand(batches_session_2[3], _constring_2))
            using (SqlCommand batch_session_2_4 = new SqlCommand(batches_session_2[4], _constring_2))
            using (SqlCommand batch_session_2_5 = new SqlCommand(batches_session_2[5], _constring_2))

            //fill data adaptors separately in a try catch as batch 2_4 is designed to fail
            //we can then run each test in each try/catch
            using (SqlDataAdapter da_1_1 = new SqlDataAdapter(batch_session_1_1))
            using (SqlDataAdapter da_2_1 = new SqlDataAdapter(batch_session_2_1))
            using (SqlDataAdapter da_2_2 = new SqlDataAdapter(batch_session_2_2))
            using (SqlDataAdapter da_2_3 = new SqlDataAdapter(batch_session_2_3))
            using (SqlDataAdapter da_2_4 = new SqlDataAdapter(batch_session_2_4))
            using (SqlDataAdapter da_2_5 = new SqlDataAdapter(batch_session_2_5))

            {
                _constring.Open();
                _constring_2.Open();
                DataSet ds_1_1 = new DataSet();
                DataSet ds_2_1 = new DataSet();
                DataSet ds_2_2 = new DataSet();
                DataSet ds_2_3 = new DataSet();
                DataSet ds_2_4 = new DataSet();
                DataSet ds_2_5 = new DataSet();

                try
                {
                    da_1_1.Fill(ds_1_1);
                    dti.Clear();
                    dti = ds_1_1.Tables["Table"];
                    for (int a = 0; a < dti.Rows.Count; a++)
                    {
                        Col1.Add(dti.Rows[a]["col1"].ToString());
                    }
                    Assert.AreEqual("aaaaaaaa", Col1[0]);
                    Assert.AreEqual("bbbbbbbb", Col1[1]);
                    Assert.AreEqual("cccccccc", Col1[2]);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }

                try
                {
                    da_2_1.Fill(ds_2_1);
                    dti.Clear();
                    dti = ds_2_1.Tables["Table"];
                    for (int a = 0; a < dti.Rows.Count; a++)
                    {
                        Col1.Add(dti.Rows[a]["col1"].ToString());
                    }
                    Assert.AreEqual("test", Col1[0]);
                    Assert.AreEqual("bbbbbbbb", Col1[1]);
                    Assert.AreEqual("cccccccc", Col1[2]);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }

                try
                {
                    da_2_2.Fill(ds_2_2);
                    dti.Clear();
                    dti = ds_2_2.Tables["Table"];
                    for (int a = 0; a < dti.Rows.Count; a++)
                    {
                        Col1.Add(dti.Rows[a]["col1"].ToString());
                    }
                    Assert.AreEqual("aaaaaaaa", Col1[0]);
                    Assert.AreEqual("bbbbbbbb", Col1[1]);
                    Assert.AreEqual("cccccccc", Col1[2]);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }

                try
                {
                    da_2_3.Fill(ds_2_3);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }

                try
                {
                    //4th batch is designed to fail, so set the timeout to 3 seconds so that it is manually stopped at 3 seconds instead of default 15
                    da_2_4.SelectCommand.CommandTimeout = 3;
                    da_2_4.Fill(ds_2_4);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                    Assert.AreEqual(fourth_batch_error_message, Error, "Batch 4 did not time out");
                }

                try
                {
                    da_2_5.Fill(ds_2_5);
                    dti.Clear();
                    dti = ds_2_2.Tables["Table"];
                    for (int a = 0; a < dti.Rows.Count; a++)
                    {
                        Col1.Add(dti.Rows[a]["col1"].ToString());
                    }
                    Assert.AreEqual("bbbbbbbb", Col1[0]);
                    Assert.AreEqual("cccccccc", Col1[1]);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }
                _constring.Close();
                _constring_2.Close();
            }

        }

        [TestMethod]
        public void TestSnapshotDataChange()
        {
            //separate connections because trying to reuse same connection breaks the transaction we setup
            string constring_1 = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.Locking.Isolation;Data Source=.";

            //two separate files to read from
            string fileContent_session_1 = File.ReadAllText(@"..\\..\\..\\SabinIO.Locking.Isolation\\Demos\\Demo2 - Snapshot Data Change - Session 1.sql");
            string fileContent_session_2 = File.ReadAllText(@"..\\..\\..\\SabinIO.Locking.Isolation\\Demos\\Demo2 - Snapshot Data Change - Session 2.sql");

            //split two separate files into different batches... I suppose we could put in one array but then test would be more difficult to follow
            string[] batches_session_1 = Regex.Split(fileContent_session_1, "GO", RegexOptions.IgnoreCase);
            string[] batches_session_2 = Regex.Split(fileContent_session_2, "GO", RegexOptions.IgnoreCase);

            string session_1_3_error_message = @"Snapshot isolation transaction aborted due to update conflict. You cannot use snapshot isolation to access table 'dbo.TableA' directly or indirectly in database 'SabinIO.Locking.Isolation' to update, delete, or insert the row that has been modified or deleted by another transaction. Retry the transaction or change the isolation level for the update/delete statement.";
            //same data table cleared and re-used for each test
            DataTable dti = new DataTable();

            //we only really care about the values in this column, so we build a list of the values in each batch that attempts to make a change
            List<String> Col1 = new List<String>();

            string _conn_1 = constring_1;
            string _conn_2 = constring_1;

            // the fill method of a data adaptor will open and close a connection each time it is called ONLY if the connection is not already open
            // seeing as we need to keep a connection open with a transaction not yet committed/rolled back, we need to open the connection and open a transaction to keep it open
            // we then close the connection at the end of the test

            using (SqlConnection _constring = new SqlConnection(_conn_1))
            using (SqlConnection _constring_2 = new SqlConnection(_conn_2))

            //the order of the batches declared below reflect the order in which they are run
            using (SqlCommand batch_session_1_1 = new SqlCommand(batches_session_1[1], _constring))
            using (SqlCommand batch_session_1_2 = new SqlCommand(batches_session_1[2], _constring))
            using (SqlCommand batch_session_2_1 = new SqlCommand(batches_session_2[1], _constring_2))
            using (SqlCommand batch_session_1_3 = new SqlCommand(batches_session_1[3], _constring))
            using (SqlCommand batch_session_1_4 = new SqlCommand(batches_session_1[4], _constring))


            using (SqlDataAdapter da_1_1 = new SqlDataAdapter(batch_session_1_1))
            using (SqlDataAdapter da_1_2 = new SqlDataAdapter(batch_session_1_2))
            using (SqlDataAdapter da_1_3 = new SqlDataAdapter(batch_session_1_3))
            using (SqlDataAdapter da_1_4 = new SqlDataAdapter(batch_session_1_4))
            using (SqlDataAdapter da_2_1 = new SqlDataAdapter(batch_session_2_1))
            {
                _constring.Open();
                _constring_2.Open();
                DataSet ds_1_1 = new DataSet();
                DataSet ds_1_2 = new DataSet();
                DataSet ds_1_3 = new DataSet();
                DataSet ds_1_4 = new DataSet();
                DataSet ds_2_1 = new DataSet();

                try
                {
                    da_1_1.Fill(ds_1_1);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }

                try
                {
                    da_1_2.Fill(ds_1_2);
                    dti.Clear();
                    dti = ds_1_2.Tables["Table"];
                    for (int a = 0; a < dti.Rows.Count; a++)
                    {
                        Col1.Add(dti.Rows[a]["col1"].ToString());
                    }
                    Assert.AreEqual("aaaaaaaa", Col1[0]);
                    Assert.AreEqual("bbbbbbbb", Col1[1]);
                    Assert.AreEqual("cccccccc", Col1[2]);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }

                try
                {
                    da_2_1.Fill(ds_2_1);
                    dti.Clear();
                    dti = ds_2_1.Tables["Table"];
                    for (int a = 0; a < dti.Rows.Count; a++)
                    {
                        Col1.Add(dti.Rows[a]["col1"].ToString());
                    }
                    Assert.AreEqual("aaaaaaaa", Col1[0]);
                    Assert.AreEqual("test2", Col1[1]);
                    Assert.AreEqual("cccccccc", Col1[2]);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }

                try
                {
                    da_1_3.Fill(ds_1_3);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                    Assert.AreEqual(session_1_3_error_message, Error, "The 3rd batch from session 1 did not fail as expected. Please investigate.");
                }

                try
                {
                    da_1_4.Fill(ds_1_4);
                    dti.Clear();
                    dti = ds_1_4.Tables["Table"];
                    for (int a = 0; a < dti.Rows.Count; a++)
                    {
                        Col1.Add(dti.Rows[a]["col1"].ToString());
                    }
                    Assert.AreEqual("aaaaaaaa", Col1[0]);
                    Assert.AreEqual("test2", Col1[1]);
                    Assert.AreEqual("cccccccc", Col1[2]);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }
                _constring.Close();
                _constring_2.Close();
            }
        }

        [TestMethod]
        public void TestRepeatableRead()
        {

            //separate connections because trying to reuse same connection breaks the transaction we setup
            string constring_1 = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.Locking.Isolation;Data Source=.";

            //two separate files to read from
            string fileContent_session_1 = File.ReadAllText(@"..\\..\\..\\SabinIO.Locking.Isolation\\Demos\\Demo3 - RepeatbleRead - Session 1.sql");
            string fileContent_session_2 = File.ReadAllText(@"..\\..\\..\\SabinIO.Locking.Isolation\\Demos\\Demo3 - RepeatbleRead - Session 2.sql");

            //split two separate files into different batches... I suppose we could put in one array but then test would be more difficult to follow
            string[] batches_session_1 = Regex.Split(fileContent_session_1, "GO", RegexOptions.IgnoreCase);
            string[] batches_session_2 = Regex.Split(fileContent_session_2, "GO", RegexOptions.IgnoreCase);

            //same data table cleared and re-used for each test
            //DataTable dti = new DataTable();

            //we only really care about the values in this column, so we build a list of the values in each batch that attempts to make a change
            //List<String> Col1 = new List<String>();

            string _conn_1 = constring_1;
            string _conn_2 = constring_1;

            // the fill method of a data adaptor will open and close a connection each time it is called ONLY if the connection is not already open
            // seeing as we need to keep a connection open with a transaction not yet committed/rolled back, we need to open the connection and open a transaction to keep it open
            // we then close the connection at the end of the test

            using (SqlConnection _constring = new SqlConnection(_conn_1))
            using (SqlConnection _constring_2 = new SqlConnection(_conn_2))



            //the order of the batches declared below reflect the order in which they are run
            using (SqlCommand batch_session_1_1 = new SqlCommand(batches_session_1[1], _constring))
            using (SqlCommand batch_session_1_2 = new SqlCommand(batches_session_1[2], _constring))
            using (SqlCommand batch_session_2_1 = new SqlCommand(batches_session_2[1], _constring_2))
            using (SqlCommand batch_session_2_2 = new SqlCommand(batches_session_2[2], _constring_2))
            using (SqlCommand batch_session_1_3 = new SqlCommand(batches_session_1[3], _constring))
            using (SqlCommand batch_session_2_3 = new SqlCommand(batches_session_2[3], _constring_2))
            using (SqlCommand batch_session_1_4 = new SqlCommand(batches_session_1[4], _constring))
            using (SqlCommand batch_session_1_5 = new SqlCommand(batches_session_1[5], _constring))
            using (SqlCommand batch_session_2_4 = new SqlCommand(batches_session_2[4], _constring_2))
            using (SqlCommand batch_session_1_6 = new SqlCommand(batches_session_1[6], _constring))

            using (SqlDataAdapter da_1_2 = new SqlDataAdapter(batch_session_1_2))
            using (SqlDataAdapter da_1_3 = new SqlDataAdapter(batch_session_1_3))
            using (SqlDataAdapter da_1_5 = new SqlDataAdapter(batch_session_1_5))
            using (SqlDataAdapter da_1_6 = new SqlDataAdapter(batch_session_1_6))

            using (SqlDataAdapter da_2_3 = new SqlDataAdapter(batch_session_2_3))
            using (SqlDataAdapter da_2_4 = new SqlDataAdapter(batch_session_2_4))

            {
                _constring.Open();
                _constring_2.Open();

                DataSet ds_1_2 = new DataSet();
                DataSet ds_1_3 = new DataSet();

                DataSet ds_1_4 = new DataSet();

                DataSet ds_1_5 = new DataSet();
                DataSet ds_1_6 = new DataSet();
                DataSet ds_2_3 = new DataSet();
                DataSet ds_2_4 = new DataSet();

                try
                {
                    batch_session_1_1.ExecuteNonQuery();
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }

                try
                {
                    da_1_2.Fill(ds_1_2);
                    string result_1_2 = Convert.ToString(ds_1_2.Tables["Table"].Rows[0]["Col1"]);
                    Assert.AreEqual("cccccccc", result_1_2);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }

                try
                {
                    batch_session_2_1.ExecuteNonQuery();
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }

                try
                {
                    batch_session_2_2_result = batch_session_2_2.BeginExecuteNonQuery();
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }

                try
                {
                    da_1_3.Fill(ds_1_3);
                    string result_1_3 = Convert.ToString(ds_1_3.Tables["Table"].Rows[0]["Col1"]);
                    Assert.AreEqual("cccccccc", result_1_3);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }

                try
                {
                    batch_session_2_2.EndExecuteNonQuery(batch_session_2_2_result);
                    da_2_3.Fill(ds_2_3);
                    string result_2_3 = Convert.ToString(ds_2_3.Tables["Table"].Rows[2]["Col1"]);
                    Assert.AreEqual("test3", result_2_3);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }

                try
                {
                    batch_session_1_4.ExecuteNonQuery();
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }

                try
                {
                    da_1_5.Fill(ds_1_5);
                    string result_1_5 = Convert.ToString(ds_1_5.Tables["Table"].Rows[0]["COUNT"]);
                    Assert.AreEqual("3", result_1_5);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }

                try
                {
                    batch_session_2_4.BeginExecuteNonQuery();
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }

                try
                {
                    da_1_6.Fill(ds_1_6);
                    string result_1_6 = Convert.ToString(ds_1_6.Tables["Table"].Rows[0]["COUNT"]);
                    Assert.AreEqual("4", result_1_6);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }
            }
        }
    }
}
