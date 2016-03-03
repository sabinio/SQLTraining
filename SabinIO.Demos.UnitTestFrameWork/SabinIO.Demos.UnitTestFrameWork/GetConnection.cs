using System;

namespace SabinIO.Demos.UnitTestFrameWork
{
    public class GetConnection
    {
        public string GetConnectionString(string database)
        {
            string connection = String.Format("Integrated Security=SSPI;Persist Security Info=False;Initial Catalog={0};Data Source=.", database);
            return connection;
        }
    }
}
