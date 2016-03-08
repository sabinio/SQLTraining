using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Data.SqlClient;

namespace SabinIO.Demos.UnitTestFrameWork
{
    public class GetSqlInfo
    {

        public List<string> SqlInfoMessages = new List<string>();

        public void Message(object sender, SqlInfoMessageEventArgs e)
        {

            int i;
            for (i = 0; i < e.Errors.Count; i++)
            {
                SqlInfoMessages.Add(e.Errors[i].Message);
            }
        }
    }
}
