﻿using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data;
using System.IO;
using System.Text.RegularExpressions;
using System.Data.SqlClient;
using SabinIO.LoggingDemos.UnitTestProject;

namespace SabinIO.LoggingDemos.UnitTestProject
{
    [TestClass]
    public class PageVerify
    {
        [TestMethod]

        public void TestPageVerify()
        {
            string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.Recovery.PageVerify;Data Source=.";
            string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.Recovery.PageVerify\\Demos\\1. PageVerify.sql");
            string actualError = "";
            string[] batches = Regex.Split(fileContent, "GO", RegexOptions.IgnoreCase);


            for (int i = 0; i < batches.Length; i++)
            {

                string _conn = constring;
                string batch = batches[i];

                SqlDataAdapter da = new SqlDataAdapter(batch, _conn);
                DataSet ds = new DataSet();
                try
                {
                    da.Fill(ds);
                }
                catch (Exception e)
                {
                    //this is here for batch 27, that tries to select from corrupt table
                    //we just catch the message ensure it contains 166 which is the page we are corrupting
                    actualError = e.Message;
                }
                da.Dispose();
                if (@i == 2 || @i == 16)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];

                    int RowCountActual = dti.Rows.Count;
                    if (@i == 2) { Assert.AreEqual(2000, RowCountActual); }
                    if (@i == 16) { Assert.AreEqual(6000, RowCountActual); }
                }

                if (@i == 6)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];
                    foreach (DataRow r in dti.Select(@"Field = 'm_tornBits'"))
                    {
                        Assert.AreEqual(0, Convert.ToInt32(r.ItemArray[3]),"m_tornbits is greater than 0" );
                    }
                }

                if (@i == 7 || @i == 21)
                {
                    int RowCountActual = ds.Tables["Table"].Rows.Count;
                    Assert.AreEqual(1, RowCountActual);
                }
                if (@i == 8 || @i  == 22)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];
                    foreach (DataRow r in dti.Select(@"ParentObject LIKE 'DATA:%' AND Object LIKE 'OFFSET TABLE:%' AND VALUE LIKE '1 (0x1)%'"))
                    {
                        Assert.AreEqual("1 (0x1) - 119 (0x77) ", r.ItemArray[3], "slot starting place is different for batch 8");
                    }
                }
                if (@i == 12)
                {
                    int RowCountActual = ds.Tables["Table"].Rows.Count;
                    Assert.AreEqual(10, RowCountActual);
                }

                if (@i == 19)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];
                    DataRow[] r = dti.Select(@"PagePid = 166");
                    Assert.AreEqual(1, r.Length);
                }

                if (@i == 27)
                {
                    Assert.IsNotNull(actualError.Contains("166"));
                }
            }

        }
    }
}
