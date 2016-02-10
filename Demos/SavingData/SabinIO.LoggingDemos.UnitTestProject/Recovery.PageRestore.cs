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
    public class Recovery
    {
        [TestMethod]
        public void TestPageRestore()
        {
            string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.dirtyPage.Demo;Data Source=(localdb)\\ProjectsV12";
            string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.Recovery.PageRestore\\Demos\\1. PageRestore.sql");
            string[] batches = Regex.Split(fileContent, "GO", RegexOptions.IgnoreCase);
            string BackupDir = @"C:\\bob\\";

            //create temp director if not exist, else purge all files out of temp
            if (!Directory.Exists(BackupDir)){Directory.CreateDirectory(BackupDir);}

            else{Array.ForEach(Directory.GetFiles(BackupDir),delegate (string path) { File.Delete(path); });}

            //for (int i = 0; i < batches.Length; i++)
            //{
            //    string batch = batches[i];
            //    SqlDataAdapter da = new SqlDataAdapter(batch, constring);
            //    DataSet ds = new DataSet();
            //    da.Fill(ds);
            //    da.Dispose();

            //    if (i == 3)
            //    {
            //        DataTable dti = new DataTable();
            //        dti = ds.Tables["Table"];

            //        var WriteLogTest = dti.Rows[0]["StringColumn"];
            //        Assert.AreEqual("CleanPage", WriteLogTest);
            //    }
            //}
        }
    }
}
