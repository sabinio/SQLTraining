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
        //running a lot of backups so will makes sense to create method to combine filepaths
        private static string CombinePaths(string p1, string p2)
        {
            try {
                string combination = Path.Combine(p1, p2);
                return combination;
                }
            catch
            (Exception e) 
                {
                return e.Message;
            }
            
        }

        private static string GetBackupFilename(string b)
        {
            try
            {
                int i = b.LastIndexOf("=");
                if (i >= 0)
                {
                    string str = b.Substring(i + 1);
                    int u = str.LastIndexOf("\\");
                    if (u >= 0)
                    {
                        str = str.Substring(u + 1);
                        str = str.Trim();
                        str = str.TrimEnd(str[str.Length - 1]);
                        return str;
                    }
                    else { return "backup file probably doesn't exist in string"; }
                }
                else { return "backup file probably doesn't exist in string"; }
            }
            catch(Exception e)
            {
                return e.Message;
            }
        }


        private static void ConfirmBackupLocation (string expected, string actual)
        {
            expected = expected.Trim();
            int n = actual.LastIndexOf("=");
            if (n >= 0)
            {
                actual = actual.Substring(n + 1);
                int t = actual.LastIndexOf("\\");
                if (t >= 0)
                {
                    actual = actual.Substring(1, t);
                    actual.Trim();
                    Assert.AreEqual(expected, actual);
                }
            }
        }
        //as long as test is run against localdb, we cannot run the test on the build; this is because we cannot do tail of the log backups on localdb
        //so keep this commented out
        [TestMethod]
        public void TestPageRestore()
        {
            //string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.Recovery.PageRestore;Data Source=(localdb)\\ProjectsV12";
            //string masterconstring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=master;Data Source=(localdb)\\ProjectsV12";

            string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.Recovery.PageRestore;Data Source=.";
            string masterconstring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=master;Data Source=.";

            string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.Recovery.PageRestore\\Demos\\1. PageRestore.sql");
            string[] batches = Regex.Split(fileContent, "GO");
            string BackupDir = @"C:\Temp\";
            int CorruptPageId = 0;

            //create temp director if not exist, else purge all files out of temp
            if (!Directory.Exists(BackupDir)){Directory.CreateDirectory(BackupDir);}

            else{Array.ForEach(Directory.GetFiles(BackupDir),delegate (string path) { File.Delete(path); });}

            for (int i = 0; i < batches.Length; i++)
            {

                string _conn = "";
                string batch = batches[i];

                if (i <= 9) { _conn = constring; }
                else { _conn = masterconstring; }

                if (i == 15)
                {
                    batch = batch.Replace("77", Convert.ToString(CorruptPageId));
                }

                SqlDataAdapter da = new SqlDataAdapter(batch, _conn);
                DataSet ds = new DataSet();
                try
                {
                    da.Fill(ds);
                }
                catch (Exception e)
                {
                    //this is here for batches 9 and 16, that tries to select from corrupt table
                    //we just catch the message and move on to next batch
                    string err = e.Message;
                }
                da.Dispose();

                if (i == 3 || i == 6)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];

                    int RowCountActual = dti.Rows.Count;
                    if (@i == 3) { Assert.AreEqual(200, RowCountActual); }
                    if (@i == 6) { Assert.AreEqual(400, RowCountActual); }
                }

                if (i == 4 || i == 23)
                {
                    ConfirmBackupLocation(BackupDir, batch);
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];
                    DataRow[] MessageText = dti.Select(@"MessageText LIKE 'CHECKDB found 0 allocation errors and 0 consistency errors in database%'");
                    foreach (DataRow row in MessageText)
                    {
                        Assert.AreEqual("CHECKDB found 0 allocation errors and 0 consistency errors in database 'SabinIO.Recovery.PageRestore'.", row[3]);
                    }
                    if (i == 4)
                    {
                    string BackupFileName = GetBackupFilename(batch);
                    string path = CombinePaths(BackupDir, BackupFileName);
                    if (!File.Exists(path)) { Assert.Fail("Database was not backed up"); }
                    }
                }

                if (i == 7|| i == 14 || i == 19)
                {
                    ConfirmBackupLocation(BackupDir, batch);

                    string BackupFileName = GetBackupFilename(batch);
                    string path = CombinePaths(BackupDir, BackupFileName);
                    if (!File.Exists(path)) { Assert.Fail("Database log was not backed up"); }
                }

                if (i == 10)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];
                        Assert.AreEqual(1, (dti.Rows.Count), "multiple corrupt pages exist for this database. Re-create database and run test again.");
                        CorruptPageId = Convert.ToInt32(dti.Rows[0]["page_id"]);
                }

                if (i == 12)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];
                    DataRow[] MessageText = dti.Select(@"MessageText LIKE 'CHECKDB found 0 allocation errors and 4 consistency errors in database%'");
                    foreach (DataRow row in MessageText)
                    {
                        Assert.AreEqual("CHECKDB found 0 allocation errors and 4 consistency errors in database 'SabinIO.Recovery.PageRestore'.", row[3]);
                    }
                }
                if (i == 22)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];

                    int _TotalRows = Convert.ToInt32(dti.Rows[0]["Column1"]);
                    Assert.AreEqual(410, _TotalRows);

                }

                }
        }
    }
}
