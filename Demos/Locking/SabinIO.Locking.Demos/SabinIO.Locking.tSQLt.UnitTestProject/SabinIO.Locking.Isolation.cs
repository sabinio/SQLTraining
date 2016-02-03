using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using tSQLt.Client.Net;

namespace tSQLtTestProjects
{
    [TestClass]
    public class MSTest_LockingIsolation
    {

        private readonly tSQLtTestRunner _runner =
            new tSQLtTestRunner("server=(localdb)\\ProjectsV12;Integrated Security=True;initial catalog=SabinIO.Locking.tSQLt.UnitTests;", 60 * 1000/*optional timeout, default is 2 minutes*/);
        //new tSQLtTestRunner("server=.;Integrated Security=True;initial catalog=SabinIO.Locking.tSQLt.UnitTests;", 60 * 1000/*optional timeout, default is 2 minutes*/);

        [TestMethod]

        public void TestLockingIsolation()
        {
            var result = _runner.RunClass("TestLockingIsolation");
            Assert.IsTrue(result.Passed(), result.FailureMessages());
        }


    }
}
