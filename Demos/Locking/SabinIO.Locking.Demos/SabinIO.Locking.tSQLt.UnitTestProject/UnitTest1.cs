using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using tSQLt.Client.Net;

namespace tSQLtTestProjects
{
    [TestClass]
    public class MSTest_ExampleTests
    {

        private readonly tSQLtTestRunner _runner =
            new tSQLtTestRunner("server=(localdb)\\ProjectsV12;Integrated Security=True;initial catalog=SabinIO.Locking.tSQLt.UnitTests;", 60 * 1000/*optional timeout, default is 2 minutes*/);
        //new tSQLtTestRunner("server=giratina;Integrated Security=True;initial catalog=SimpleUnitTest_DB;", 60 * 1000/*optional timeout, default is 2 minutes*/); 

        [TestMethod]
        public void TestHeapLockHierarchy()
        {
            var result = _runner.Run("TestLockingHierarchy", "TestHeapLockHierarchy");
            Assert.IsTrue(result.Passed());
        }

       
    }
}
