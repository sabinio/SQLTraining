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
    }
}
