using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Text;
using Microsoft.Data.Tools.Schema.Sql.UnitTesting;
using Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SSDT.DatabaseUnitTesting
{
    [TestClass()]
    public class ufnGetProductDealerPrice : SqlDatabaseTestClass
    {

        public ufnGetProductDealerPrice()
        {
            InitializeComponent();
        }

        [TestInitialize()]
        public void TestInitialize()
        {
            base.InitializeTest();
        }
        [TestCleanup()]
        public void TestCleanup()
        {
            base.CleanupTest();
        }

        #region Designer support code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dbo_ufnGetProductDealerPriceTest_TestAction;
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(ufnGetProductDealerPrice));
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition1;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition scalarValueCondition1;
            this.dbo_ufnGetProductDealerPriceTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            dbo_ufnGetProductDealerPriceTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition1 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            scalarValueCondition1 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition();
            // 
            // dbo_ufnGetProductDealerPriceTest_TestAction
            // 
            dbo_ufnGetProductDealerPriceTest_TestAction.Conditions.Add(notEmptyResultSetCondition1);
            dbo_ufnGetProductDealerPriceTest_TestAction.Conditions.Add(scalarValueCondition1);
            resources.ApplyResources(dbo_ufnGetProductDealerPriceTest_TestAction, "dbo_ufnGetProductDealerPriceTest_TestAction");
            // 
            // notEmptyResultSetCondition1
            // 
            notEmptyResultSetCondition1.Enabled = true;
            notEmptyResultSetCondition1.Name = "notEmptyResultSetCondition1";
            notEmptyResultSetCondition1.ResultSet = 1;
            // 
            // dbo_ufnGetProductDealerPriceTestData
            // 
            this.dbo_ufnGetProductDealerPriceTestData.PosttestAction = null;
            this.dbo_ufnGetProductDealerPriceTestData.PretestAction = null;
            this.dbo_ufnGetProductDealerPriceTestData.TestAction = dbo_ufnGetProductDealerPriceTest_TestAction;
            // 
            // scalarValueCondition1
            // 
            scalarValueCondition1.ColumnNumber = 1;
            scalarValueCondition1.Enabled = true;
            scalarValueCondition1.ExpectedValue = "20.1865";
            scalarValueCondition1.Name = "scalarValueCondition1";
            scalarValueCondition1.NullExpected = false;
            scalarValueCondition1.ResultSet = 1;
            scalarValueCondition1.RowNumber = 1;
        }

        #endregion


        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        #endregion

        [TestMethod()]
        public void dbo_ufnGetProductDealerPriceTest()
        {
            SqlDatabaseTestActions testActions = this.dbo_ufnGetProductDealerPriceTestData;
            // Execute the pre-test script
            // 
            System.Diagnostics.Trace.WriteLineIf((testActions.PretestAction != null), "Executing pre-test script...");
            SqlExecutionResult[] pretestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PretestAction);
            try
            {
                // Execute the test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.TestAction != null), "Executing test script...");
                SqlExecutionResult[] testResults = TestService.Execute(this.ExecutionContext, this.PrivilegedContext, testActions.TestAction);
            }
            finally
            {
                // Execute the post-test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.PosttestAction != null), "Executing post-test script...");
                SqlExecutionResult[] posttestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PosttestAction);
            }
        }
        private SqlDatabaseTestActions dbo_ufnGetProductDealerPriceTestData;
    }
}
