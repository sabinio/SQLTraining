using System;
using System.Xml;
using System.Xml.XPath;
using System.IO;

namespace SabinIO.Demos.UnitTestFrameWork
{
    public class GetQueryPlanValues
    {
        public Single GetSumOfValues(string QueryPlan, string SqlNamespace, string xpath)
        {
            try {
                //read query plan to tring, then xml reader
                StringReader strReader = new StringReader(QueryPlan);
                XmlTextReader xreader = new XmlTextReader(strReader);

                //xpath document from the xreader, preserving whitespace, 
                //then a nvaigator so that we can search using xpath
                XPathDocument doc = new XPathDocument(xreader, XmlSpace.Preserve);
                XPathNavigator navigator = doc.CreateNavigator();

                //define namespace
                XmlNamespaceManager nsmgr = new XmlNamespaceManager(navigator.NameTable);
                nsmgr.AddNamespace("sql", SqlNamespace);

                //create xpath expression to search
                XPathExpression xpression;
                xpression = navigator.Compile(xpath);
                //set namespace in the expression
                xpression.SetContext(nsmgr);
                //iterate over the nodes
                XPathNodeIterator iterator = navigator.Select(xpression);
                //get total value of each of the expressions we are looking for in the node
                Single TotalValue = 0;
                while (iterator.MoveNext()) TotalValue += Single.Parse(iterator.Current.Value);
                return TotalValue;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return -1;
            }
        }
    }
}
