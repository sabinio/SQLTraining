
using System;

using System.Collections.Generic;

using System.Text;

using Microsoft.VisualStudio.TestTools.LoadTesting;

namespace SQL
{
    public class SequentialPlugin: ILoadTestPlugin
    {
    
            //store the load test object.  

            LoadTest mLoadTest;
        
            public void Initialize(LoadTest loadTest)
{
                mLoadTest = loadTest;
            //connect to the TestStarting event.
            mLoadTest.TestSelected += MLoadTest_TestSelected;
            mLoadTest.LoadTestStarting += MLoadTest_LoadTestStarting;
                mLoadTest.TestStarting += new EventHandler<TestStartingEventArgs>(mLoadTest_TestStarting);
            }

        private void MLoadTest_LoadTestStarting(object sender, EventArgs e)
        {
        
        }

        private void MLoadTest_TestSelected(object sender, TestSelectedEventArgs e)
        {
            
        }

        void mLoadTest_TestStarting(object sender, TestStartingEventArgs e)
            {
             
                
                //When the test starts, copy the load test context parameters to 

                //the test context parameters

                foreach (string key in mLoadTest.Context.Keys)
                {
                    e.TestContextProperties.Add(key, mLoadTest.Context[key]);
                }
            }
        }
}
