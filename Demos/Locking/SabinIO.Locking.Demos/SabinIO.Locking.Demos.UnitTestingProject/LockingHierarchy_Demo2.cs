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
    public class LockingHierarchy_Demo2
    {

        private IAsyncResult batch_session_2_3_result;
        private static string GetConnectionString(string _database)
        {
            string _connection = string.Format(@"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog={0};Data Source=.", _database);
            return _connection;
        }

        private static DataTable GetDataTable(DataSet _dataSet, string table, string sortBy)
        {
            DataTable _datatable = new DataTable();
            _datatable = _dataSet.Tables[table];

            DataView _dataview = _datatable.DefaultView;

            _dataview.Sort = sortBy;
            _datatable = _dataview.ToTable();

            return _datatable;
        }

        [TestMethod]
        public void TestDemo2_LockingHierarchy()
        {

            string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.Locking.LockingHierarchy\\Demos\\Demo2_LockingHierarchy.sql");

            string[] batches = Regex.Split(fileContent, "GO", RegexOptions.IgnoreCase);

            string _connstring_1 = GetConnectionString("SabinIO.Locking.LockingHierarchy");
            string _connstring_2 = GetConnectionString("SabinIO.Locking.LockingHierarchy");
            string _connstring_3 = GetConnectionString("SabinIO.Locking.LockingHierarchy");

            using (SqlConnection _conn_1 = new SqlConnection(_connstring_1))
            using (SqlConnection _conn_2 = new SqlConnection(_connstring_2))
            using (SqlConnection _conn_3 = new SqlConnection(_connstring_3))


            using (SqlCommand batch_session_1_1 = new SqlCommand(batches[1], _conn_1))
            using (SqlCommand batch_session_1_2 = new SqlCommand(batches[2], _conn_1))
            using (SqlCommand batch_session_2_1 = new SqlCommand(batches[3], _conn_2))
            using (SqlCommand batch_session_1_3 = new SqlCommand(batches[4] + "SELECT @@TRANCOUNT AS TRANCOUNT", _conn_1))
            using (SqlCommand batch_session_2_2 = new SqlCommand(batches[5], _conn_2))
            using (SqlCommand batch_session_2_3 = new SqlCommand(batches[6], _conn_2))
            using (SqlCommand batch_session_3_1 = new SqlCommand(batches[7], _conn_3))
            using (SqlCommand batch_session_1_4 = new SqlCommand(batches[8], _conn_1))
            using (SqlCommand final_check_1 = new SqlCommand("SELECT * FROM [dbo].[Demo2_LockingHierarchy]", _conn_1))


            using (SqlDataAdapter da_1_1 = new SqlDataAdapter(batch_session_1_1))
            using (SqlDataAdapter da_1_2 = new SqlDataAdapter(batch_session_1_2))
            using (SqlDataAdapter da_2_1 = new SqlDataAdapter(batch_session_2_1))
            using (SqlDataAdapter da_1_3 = new SqlDataAdapter(batch_session_1_3))
            using (SqlDataAdapter da_2_2 = new SqlDataAdapter(batch_session_2_2))
            using (SqlDataAdapter da_3_1 = new SqlDataAdapter(batch_session_3_1))
            using (SqlDataAdapter da_final_check = new SqlDataAdapter(final_check_1))

            {
                _conn_1.Open();
                _conn_2.Open();

                DataSet ds_1_1 = new DataSet();
                DataSet ds_1_2 = new DataSet();
                DataSet ds_2_1 = new DataSet();
                DataSet ds_1_3 = new DataSet();
                DataSet ds_2_2 = new DataSet();
                DataSet ds_3_1 = new DataSet();
                DataSet ds_f_c = new DataSet();

                try
                {
                    da_1_1.Fill(ds_1_1);

                    DataTable dt_rid_slot_id_0 = GetDataTable(ds_1_1, "table", "resource_type asc");
                    DataTable dt_rid_slot_id_1 = GetDataTable(ds_1_1, "table1", "resource_type asc");

                    string rid_slot_id_0 = Convert.ToString(dt_rid_slot_id_0.Rows[3]["resource_description"]);
                    rid_slot_id_0 = rid_slot_id_0.Substring(rid_slot_id_0.LastIndexOf(':') + 1);
                    int o = Convert.ToInt32(rid_slot_id_0);

                    string rid_slot_id_1 = Convert.ToString(dt_rid_slot_id_1.Rows[3]["resource_description"]);
                    rid_slot_id_1 = rid_slot_id_1.Substring(rid_slot_id_1.LastIndexOf(':') + 1);
                    int i = Convert.ToInt32(rid_slot_id_1);

                    Assert.IsTrue(o < i);
                    Assert.IsTrue(i == (o + 1));

                }
                catch (Exception e)
                {
                    string Error = e.Message;
                    Assert.Fail(Error);
                }

                try
                {
                    da_1_2.Fill(ds_1_2);
                    DataTable dt_exclusive_lock = GetDataTable(ds_1_2, "table", "resource_type asc");
                    string rid_slot_request_mode = Convert.ToString(dt_exclusive_lock.Rows[3]["request_mode"]);
                    Assert.AreEqual("X", rid_slot_request_mode);
                }

                catch (Exception e)
                {
                    string Error = e.Message;
                    Assert.Fail(Error);
                }

                try
                {
                    da_2_1.Fill(ds_2_1);
                    DataTable dt_exclusive_lock_2_1 = GetDataTable(ds_2_1, "table", "resource_type asc");
                    DataRow[] dr_exclusive_lock_2_1 = dt_exclusive_lock_2_1.Select("request_mode = 'X'");
                    Assert.AreEqual(2, dr_exclusive_lock_2_1.Length);
                }

                catch (Exception e)
                {
                    string Error = e.Message;
                    Assert.Fail(Error);
                }

                try
                {
                    da_1_3.Fill(ds_1_3);
                    DataTable dt_paglock_1_3 = GetDataTable(ds_1_3, "table", "resource_type asc");
                    string exclusive_lock_page = Convert.ToString(dt_paglock_1_3.Rows[2]["request_mode"]);
                    DataTable dt_tran_count = GetDataTable(ds_1_3, "table1", "TRANCOUNT");

                    Assert.AreEqual(2, dt_tran_count.Rows[0]["TRANCOUNT"]);
                    Assert.AreEqual("X", exclusive_lock_page);
                }

                catch (Exception e)
                {
                    string Error = e.Message;
                    Assert.Fail(Error);
                }

                try
                {
                    da_2_2.Fill(ds_2_2);
                    DataTable dt_exclusive_lock_2_2 = GetDataTable(ds_2_2, "table", "resource_type asc");
                    DataRow[] dr_exclusive_lock_2_1 = dt_exclusive_lock_2_2.Select("resource_type = 'PAGE'");
                    Assert.AreEqual(2, dr_exclusive_lock_2_1.Length);
                }

                catch (Exception e)
                {
                    string Error = e.Message;
                    Assert.Fail(Error);
                }


                try
                {
                    batch_session_2_3_result = batch_session_2_3.BeginExecuteNonQuery();
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                    Assert.Fail(Error);
                }

                try
                {
                    da_3_1.Fill(ds_3_1);
                    DataTable dt_exclusive_intent_update = GetDataTable(ds_3_1, "table", "resource_type asc");

                    DataRow[] dr_exclusive_pagelock_3_1 = dt_exclusive_intent_update.Select("request_mode = 'X' AND resource_type = 'PAGE'");
                    DataRow[] dr_intent_update_pagelock_3_1 = dt_exclusive_intent_update.Select("request_mode = 'IU' AND resource_type = 'PAGE'");

                    //Assert.AreEqual(1, dr_intent_update_pagelock_3_1.Length,"number of intent update locks is not 1");
                    //Assert.AreEqual(1, dr_exclusive_pagelock_3_1.Length, "number of exclusive update locks is not 1");
                }

                catch (Exception e)
                {
                    string Error = e.Message;
                    Assert.Fail(Error);
                }
                try
                {
                    batch_session_1_4.ExecuteNonQuery();
                    batch_session_2_3.EndExecuteNonQuery(batch_session_2_3_result);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                    Assert.Fail(Error);
                }


                try
                {
                    da_final_check.Fill(ds_f_c);
                    DataTable dt_final_check = GetDataTable(ds_f_c, "table", "id asc");
                    Assert.AreEqual(6, dt_final_check.Rows.Count);
                    Assert.AreEqual("update", dt_final_check.Rows[2]["name"]);
                }

                catch (Exception e)
                {
                    string Error = e.Message;
                    Assert.Fail(Error);
                }
            }
        }
    }
}