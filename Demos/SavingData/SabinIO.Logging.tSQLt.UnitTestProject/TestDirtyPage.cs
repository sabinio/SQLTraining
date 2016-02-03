using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using tSQLt.Client.Net;

namespace SabinIO.Logging.tSQLt.UnitTestProject
{
    [TestClass]
    public class MSTest_DirtyPage

    {

        private readonly tSQLtTestRunner _runner = new tSQLtTestRunner("server=(localdb)\\ProjectsV12;Integrated Security=True;initial catalog=SabinIO.DirtyPage.tSQLt.UnitTests;", 60 * 1000/*optional timeout, default is 2 minutes*/);
        //new tSQLtTestRunner("server=.;Integrated Security=True;initial catalog=SabinIO.Locking.tSQLt.UnitTests;", 60 * 1000/*optional timeout, default is 2 minutes*/);

        [TestMethod]
        public void TestDirtyPage_DefaultValues()
        {
            var result = _runner.Run("TestDirtyPage","TestDirtyPage_DefaultValues");
            Assert.IsTrue(result.Passed(), result.FailureMessages());
        }
    }
}
