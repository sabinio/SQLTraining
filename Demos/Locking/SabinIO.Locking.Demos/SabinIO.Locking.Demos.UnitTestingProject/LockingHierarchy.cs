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
    public class LockingHierarchy
    {
        [TestMethod]
        public void TestDemo1_LockingHierarchy()
        {

            string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.Locking.LockingHierarchy;Data Source=.";
            string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.Locking.LockingHierarchy\\Demos\\Demo1_LockingHierarchy.sql");
            string[] batches = Regex.Split(fileContent, "GO", RegexOptions.IgnoreCase);
            List<String> resource_associated_entity_id_array = new List<String>();
            List<String> request_mode_array = new List<String>();

            for (int i = 0; i < batches.Length; i++)
            {
                string _conn = constring;
                string batch = batches[i];
                if (i == 2) { batch = batch.Replace("/*insert here*/", resource_associated_entity_id_array[1]); }
                if (i == 3) { batch = batch.Replace("/*insert here*/", resource_associated_entity_id_array[2]); }
                SqlDataAdapter da = new SqlDataAdapter(batch, _conn);
                DataSet ds = new DataSet();
                try
                {
                    da.Fill(ds);
                }
                catch (Exception e)
                {
                    string Error = e.Message;
                }
                da.Dispose();

                if (i == 1 || i == 5)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];
                    DataView dvi = dti.DefaultView;
                    dvi.Sort = "resource_type asc";
                    dti = dvi.ToTable();

                    for (int a = 0; a < dti.Rows.Count; a++)
                    {
                        resource_associated_entity_id_array.Add(dti.Rows[a]["resource_associated_entity_id"].ToString());
                        request_mode_array.Add(dti.Rows[a]["request_mode"].ToString());
                    }
                    Assert.AreEqual("S", request_mode_array[0]);
                    Assert.AreEqual("IX", request_mode_array[1]);
                    Assert.AreEqual("IX", request_mode_array[2]);
                    Assert.AreEqual("X", request_mode_array[3]);
                }
                if (i == 2)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];
                    foreach (DataRow r in dti.Select(@"name = 'Demo1_LockingHierarchy'"))
                    {
                        Assert.AreEqual("Demo1_LockingHierarchy", r.ItemArray[0], "The expected and actual tables for batch 2 are not correct");
                    }
                }

                if (i == 3)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];
                    foreach (DataRow r in dti.Select(@"partition_number = 1"))
                    {
                        Assert.AreEqual(1, r.ItemArray[3], "The expected and actual number of partitions for batch 3 do not match");
                    }
                }
            }
        }

        //[TestMethod]
        //public void TestDemo2_LockingHierarchy()
        //{
        //    string constring = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.Locking.LockingHierarchy;Data Source=.";
        //    string constring_2 = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=master;Data Source=.";
        //    string constring_3 = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=model;Data Source=.";
        //    string constring_4 = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=tempdb;Data Source=.";
        //    string constring_5 = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=msdb;Data Source=.";
        //    string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.Locking.LockingHierarchy\\Demos\\Demo2_LockingHierarchy.sql");

        //    string[] batches = Regex.Split(fileContent, "GO", RegexOptions.IgnoreCase);

        //    string _conn = "";

        //    DataSet ds = new DataSet();
        //    DataSet ds2 = new DataSet();
        //    DataSet dsx = new DataSet();

        //    //for (int a = 0; a < batches.Length; a++)
        //    //{

        //    //}

        //    for (int i = 0; i < batches.Length; i++)
        //    {
        //        if (i <= 1)
        //        {
        //            _conn = constring;

        //            using (SqlConnection _constring = new SqlConnection(_conn))
        //            using (SqlCommand batch = new SqlCommand(batches[i], _constring))
        //            using (SqlDataAdapter da = new SqlDataAdapter(batch))
        //            {
        //                _constring.Open();
        //                try
        //                {
        //                    ds.Clear();
        //                    da.Fill(ds);
        //                }
        //                catch (Exception e)
        //                {
        //                    string Error = e.Message;
        //                }
        //            }
        //        }

        //        if (i == 2)
        //        {
        //            _conn = constring;

        //            using (SqlConnection _constring = new SqlConnection(_conn))
        //            using (SqlCommand batch = new SqlCommand(batches[i], _constring))
        //            using (SqlDataAdapter da = new SqlDataAdapter(batch))
        //            {
        //                _constring.Open();
        //                SqlTransaction tra;
        //                tra = _constring.BeginTransaction();
        //                batch.Transaction = tra;
        //                try
        //                {
        //                    ds.Clear();
        //                    da.Fill(ds);
        //                    //adding 2nd begin tran kills previous, need to fix this....somehow
        //                }
        //                catch (Exception e)
        //                {
        //                    string Error = e.Message;
        //                }
        //                //inside this here
        //            }
        //        }

        //        if (i == 4)
        //        {
        //            _conn = constring;

        //            using (SqlConnection _constring = new SqlConnection(_conn))
        //            using (SqlCommand batch = new SqlCommand(batches[i], _constring ))
        //            using (SqlDataAdapter dax = new SqlDataAdapter(batch))
        //            {
        //                _constring.Open();
        //                SqlTransaction tra;
        //                tra = _constring.BeginTransaction();
        //                batch.Transaction = tra;
        //                try
        //                {
        //                    dsx.Clear();
        //                    dax.Fill(dsx);
        //                    //adding 2nd begin tran kills previous, need to fix this....somehow
        //                }
        //                catch (Exception e)
        //                {
        //                    string Error = e.Message;
        //                }
        //            }
        //        }
        //        if (i == 3 || i == 5)
        //        {
        //            _conn = constring_2;
        //            using (SqlConnection _constring = new SqlConnection(_conn))
        //            using (SqlCommand batch = new SqlCommand(batches[i], _constring))
        //            using (SqlDataAdapter da2 = new SqlDataAdapter(batch))
        //            {
        //                _constring.Open();
        //                try
        //                {
        //                    ds2.Clear();
        //                    da2.Fill(ds2);
        //                }
        //                catch (Exception e)
        //                {
        //                    string Error = e.Message;
        //                }
        //            }
        //        }
        //        string _conn3 = constring_3;
        //        string _conn4 = constring_4;
        //        string _conn5 = constring_5;

        //        //string batch = batches[i];
        //        //SqlDataAdapter da = new SqlDataAdapter(batch, _conn);
        //        //DataSet ds = new DataSet();
        //        //try
        //        //{
        //        //    da.Fill(ds);
        //        //}
        //        //catch (Exception e)
        //        //{
        //        //    string Error = e.Message;
        //        //}

        //        if (i == 1)
        //        {
        //            DataTable dt_rid_slot_id_0 = new DataTable();
        //            DataTable dt_rid_slot_id_1 = new DataTable();
        //            dt_rid_slot_id_0 = ds.Tables["Table"];
        //            dt_rid_slot_id_1 = ds.Tables["Table1"];

        //            //test here that slot id's from the rids are 0 and 1(the clues are in the name!)
        //        }

        //        if (i == 2)
        //        {
        //            DataTable dt_rid_xclusive_lock = new DataTable();
        //            dt_rid_xclusive_lock = ds.Tables["Table"];
        //            //test here that 2 exclusive locks exist on rids
        //        }

        //        if (i == 3)
        //        {
        //            DataTable dt_rid_xclusive_locks = new DataTable();
        //            dt_rid_xclusive_locks = ds2.Tables["Table"];
        //            //test here that 2 exclusive locks exist on rids
        //        }

        //        if (i == 4)
        //        {
        //            DataTable dt_page_exclusive_lock = new DataTable();
        //            dt_page_exclusive_lock = ds.Tables["Table"];
        //            //test here that exclusive lock exists on page

        //            DataTable trancount = new DataTable();
        //            trancount = ds.Tables["Table1"];

        //        }

        //        if (i == 5)
        //        {
        //            DataTable dt_page_exclusive_lock = new DataTable();
        //            dt_page_exclusive_lock = ds2.Tables["Table"];
        //            //test we insert into a different page as the other page is locked
        //        }
        //    }
        //}
    }
}
