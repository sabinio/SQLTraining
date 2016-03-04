using System.Text.RegularExpressions;
using System.IO;

namespace SabinIO.Demos.UnitTestFrameWork
{
    public class GetBatches
    {
        public string[] GetFileContent(string _DemoFile)
        {
            string DemoFile = File.ReadAllText(_DemoFile);
            string[] batches = Regex.Split(DemoFile, "GO", RegexOptions.IgnoreCase);
            return batches;
        }
    }
}
