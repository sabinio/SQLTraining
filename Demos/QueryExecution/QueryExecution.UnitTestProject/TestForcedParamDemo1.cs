using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data;
using System.IO;
using System.Text.RegularExpressions;
using System.Data.SqlClient;

namespace QueryExecution.UnitTestProject
{
    [TestClass]
    public class TestForcedParamDemo1
    {
        //     [TestMethod]
        //public void LogOverheadDemo1()
        //{
        //    string constring = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SabinIO.LogOverhead.Demo;Data Source=(localdb)\\ProjectsV12";
        //    string fileContent = File.ReadAllText(@"..\\..\\..\\SabinIO.LogOverhead.Demo\\Demos\\Demo1.sql");

        //    //name of database includes "gO", so removed case sensitivity from regex
        //    //all demo scripts must use keyword GO in uppercase only
        //    string[] batches = Regex.Split(fileContent, "GO");

        //    for (int i = 0; i < batches.Length; i++)
        //    {
        //        string batch = batches[i];
        //        SqlDataAdapter da = new SqlDataAdapter(batch, constring);
        //        DataSet ds = new DataSet();
        //        da.Fill(ds);
        //        da.Dispose();

        //        if (i == 2)
        //        {
        //            DataTable dti = new DataTable();
        //            dti = ds.Tables["Table"];
                   
        //        }
        //    }
        //}
    }
}
