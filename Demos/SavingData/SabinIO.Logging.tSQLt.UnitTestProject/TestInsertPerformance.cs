using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using tSQLt.Client.Net;

namespace SabinIO.Logging.tSQLt.UnitTestProject
{
    [TestClass]
    public class MSTest_InsertPerformance

    {

        private readonly tSQLtTestRunner _runner = new tSQLtTestRunner("server=(localdb)\\ProjectsV12;Integrated Security=True;initial catalog=SabinIO.InsertPerformance.tSQLt.UnitTests;", 60 * 1000/*optional timeout, default is 2 minutes*/);
        //new tSQLtTestRunner("server=.;Integrated Security=True;initial catalog=SabinIO.Locking.tSQLt.UnitTests;", 60 * 1000/*optional timeout, default is 2 minutes*/);

        [TestMethod]
        public void TestPageSplits()
        {
            var result = _runner.Run("TestInsertPerformance", "TestPageSplits");
            Assert.IsTrue(result.Passed(), result.FailureMessages());
        }
        [TestMethod]
        public void TestSplitPagesFillFactorSeventyPc()
        {
            var result = _runner.Run("TestInsertPerformance", "TestSplitPagesFillFactorSeventyPc");
            Assert.IsTrue(result.Passed(), result.FailureMessages());
        }

        [TestMethod]
        public void TestWideTableNCI()
        {
            var result = _runner.Run("TestInsertPerformance", "TestWideTableNCI");
            Assert.IsTrue(result.Passed(), result.FailureMessages());
        }
    }
}
