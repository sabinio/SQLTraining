using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using tSQLt.Client.Net;

namespace tSQLtTestProjects
{
    [TestClass]
    public class MSTest_ExampleTests
    {

        private readonly tSQLtTestRunner _runner =
            new tSQLtTestRunner("server=(localdb)\\ProjectsV12;Integrated Security=True;initial catalog=simpletSQLt_DB.UnitTests;", 60 * 1000/*optional timeout, default is 2 minutes*/);
            //new tSQLtTestRunner("server=giratina;Integrated Security=True;initial catalog=SimpleUnitTest_DB;", 60 * 1000/*optional timeout, default is 2 minutes*/); 

        //[TestMethod]
        //public void sqlcop_test_user_aliases()
        //{
        //    var result = _runner.Run("SQLCop", "test User Aliases");
        //    Assert.IsTrue(result.Passed());
        //}

        [TestMethod]
        public void TestNewCustomerTest()
        {
            var result = _runner.Run("TestCustomer", "TestNewCustomerTest");
            Assert.IsTrue(result.Passed());
        }

        [TestMethod]
        public void TestuspFillOrderTest()
        {
            var result = _runner.Run("TestOrder", "TestuspFillOrderTest");
            Assert.IsTrue(result.Passed(), result.FailureMessages());
        }
    }
}
