using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data;
using System.IO;
using System.Text.RegularExpressions;
using System.Data.SqlClient;
using SabinIO.LoggingDemos.UnitTestProject;
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Generic;


namespace SabinIO.LoggingDemos.UnitTestProject
{
    [TestClass]
    public class LoggingVLF

    {
        [TestMethod]
        public void TestLoggingVLFs()
        {
            //constrings  must use different databases to keep different sessions open and therefore uncommitted transactions!
            string constring = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.Logging.VLFs;Data Source=.";
            string constring_2 = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=master;Data Source=.";
            string constring_3 = @"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=model;Data Source=.";

            string fileContent = File.ReadAllText(@"..\\..\\..\\\SabinIO.Logging.VLFs\\Demos\\1. Main.sql");
            string[] batches = Regex.Split(fileContent, "GO", RegexOptions.IgnoreCase);

            string session_2 = File.ReadAllText(@"..\\..\\..\\SabinIO.Logging.VLFs\\Demos\\2. Session 2.sql");
            string[] session_2_batches = Regex.Split(session_2, "GO", RegexOptions.IgnoreCase);
            string session_2_spid = "";

            string session_3 = File.ReadAllText(@"..\\..\\..\\SabinIO.Logging.VLFs\\Demos\\3. Session 3.sql");
            string[] session_3_batches = Regex.Split(session_3, "GO", RegexOptions.IgnoreCase);
            string session_3_spid = "";

            string spid_query = "select @@SPID AS SPID";
            string kill_spid = "KILL";
            for (int i = 0; i < batches.Length; i++)
            {
                
                string _conn = constring;
                string _conn2 = constring_2;
                string _conn3 = constring_3;
                string batch = batches[i];
                string session_2_batch = session_2_batches[2];
                string session_3_batch = session_3_batches[2];
                //session_2_batch = session_2_batch.Replace("-", string.Empty);
                session_2_batch = session_2_batch + spid_query;
                session_3_batch = session_3_batch + spid_query;
                if (@i == 7)
                {
                    SqlDataAdapter da_2 = new SqlDataAdapter(session_2_batch, _conn2);
                    DataSet ds_2 = new DataSet();
                    da_2.Fill(ds_2);
                    session_2_spid = Convert.ToString(ds_2.Tables["Table"].Rows[0]["SPID"]);
                }
                
                if (@i == 13)
                {
                    SqlDataAdapter da_3 = new SqlDataAdapter(session_3_batch, _conn3);
                    DataSet ds_3 = new DataSet();
                    da_3.Fill(ds_3);
                    session_3_spid = Convert.ToString(ds_3.Tables["Table"].Rows[0]["SPID"]);
                }
            
                batch = batches[i];
                if (@i == 15)
                {   batch = kill_spid + ' ' + session_2_spid + ' ' + batch; }

                if (@i == 17)
                { batch = kill_spid + ' ' + session_3_spid + ' ' + batch; }

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

                if (@i == 2 || @i == 4 || @i == 6 || @i == 8 || @i == 10 || @i == 12 || @i == 14 || @i == 16 || @i == 18)
                {
                    DataTable dti = new DataTable();
                    dti = ds.Tables["Table"];

                    //first condition we test is that the active number of vlfs correspond to the expected number per batch
                    DataRow[] r = dti.Select(@"Status = '2'");
                    if (@i == 2 || @i == 6|| @i == 18)
                    {
                        Assert.AreEqual(1, r.Length, string.Format("There are an incorrect number of active VLF's for batch {0}", @i));
                    }
                    if (@i == 4 || @i == 16)
                    {
                        Assert.AreEqual(2, r.Length, string.Format("There are an incorrect number of active VLF's for batch {0}", @i));
                    }
                    if (@i == 8 || @i == 10 )
                    {
                        Assert.AreEqual(3, r.Length, string.Format("There are an incorrect number of active VLF's for batch {0}", @i));
                    }
                    if (@i == 12)
                    {
                        Assert.AreEqual( 4, r.Length, string.Format("There are an incorrect number of active VLF's for batch {0}", @i));
                    }
                    if (@i == 14)
                    {
                        Assert.AreEqual(5, r.Length, string.Format("There are an incorrect number of active VLF's for batch {0}", @i));
                    }

                    //second condition is that we test that the total number of vlfs, active or not, are as expected per batch
                    //from this we can infer that the remaining vlfs status is at 0, and that the demo is working as expected
                    int sumOfRows = Convert.ToInt32(dti.Select(@"1=1").Length);
                    if (@i == 2 || @i == 4 || @i == 6 || @i == 8 || @i == 10)
                    {
                        Assert.AreEqual(4, sumOfRows, string.Format("There are an incorrect number of VLF's for batch {0}", @i));
                    }
                    if (@i == 12)
                    {
                        Assert.AreEqual(5, sumOfRows, string.Format("There are an incorrect number of VLF's for batch {0}", @i));
                    }
                    if (@i == 14 || @i == 16 || @i == 18)
                    {
                        Assert.AreEqual(6, sumOfRows, string.Format("There are an incorrect number of VLF's for batch {0}", @i));
                    }
                }
            }
        }
    }
}
