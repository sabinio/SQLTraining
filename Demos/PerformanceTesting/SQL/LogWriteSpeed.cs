using System;
using System.CodeDom;
using System.Data;
using System.Data.SqlClient;
using System.Transactions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SQL
{
    [TestClass]
    public class LogWriteSpeed
    {
        private static string ConnectionString = "data source=.\\ss2012;trusted_connection=Yes;initial catalog=logtest";

        //used to call the base methods of TestContext

        TestContext testContextInstance1;
        public TestContext TestContext
        {
            get { return testContextInstance1; }
            set { testContextInstance1 = value; }
        }


        [TestMethod]
        public void SmallTableInsert()
        {

            var t = testContextInstance1.Properties;
            int index = 0;
            for (int i = 0; i < 4000; i++)
            {
                InsertIntoSmallTable(index);
            }
            
        }

        [TestMethod]
        public void SmallTableInsertBatch()
        {
            int index = 0;

            using (TransactionScope scope = new TransactionScope())
            {
                for (int i = 0; i < 4000; i++)
                {
                    InsertIntoSmallTable(index);
                }
                
            }
        }
        [TestMethod]
        public void LargeTableInsert()
        {
            int index = 0;
            for (int i = 0; i < 4000; i++)
            {
                InsertIntoLargeTable(index);
            }

        }

        [TestMethod]
        public void LargeTableInsertBatch()
        {
            int index = 0;

            using (TransactionScope scope = new TransactionScope())
            {
                for (int i = 0; i < 4000; i++)
                {
                    InsertIntoLargeTable(index);
                }

            }
        }

        private static void InsertIntoSmallTable(int index)
        {
            var con = new SqlConnection(ConnectionString);

            var cmd = new SqlCommand("insert into smalltable values (@p1)", con);
            cmd.Parameters.Add("@p1", SqlDbType.Int);
            cmd.Parameters["@p1"].Value = index;
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }
        private static void InsertIntoLargeTable(int index)
        {
            var con = new SqlConnection(ConnectionString);

            var cmd = new SqlCommand("insert into largetable values (@p1)", con);
            cmd.Parameters.Add("@p1", SqlDbType.Int);
            cmd.Parameters["@p1"].Value = index;
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }
    }
}
