using System;
using System.Xml;
using System.Xml.XPath;
using System.IO;

namespace SabinIO.Demos.UnitTestFrameWork
{
    public class GetQueryPlanValues
    {

        public XPathNodeIterator GetXpathIterator(string QueryPlan, string SqlNamespace, string xpath)
        {
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
            XPathNodeIterator iterator =  navigator.Select(xpression);
            //get total value of each of the expressions we are looking for in the node
            return iterator;
        }


        public string GetSumOfValues(string QueryPlan, string SqlNamespace, string xpath)
        {
            try
            {

                string _QueryPlan = QueryPlan;
                string _SqlNameSpace = SqlNamespace;
                string _xpath = xpath;

                XPathNodeIterator i = GetXpathIterator(_QueryPlan, _SqlNameSpace, _xpath);

                //get total value of each of the expressions we are looking for in the node
                Single TotalValue = 0;
                while (i.MoveNext()) TotalValue += Single.Parse(i.Current.Value);
                string ret = String.Empty;
                ret = Convert.ToString(TotalValue);
                return ret;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return "-1";
            }
        }

             public string GetSingleValue(string QueryPlan, string SqlNamespace, string xpath)
        {
            try
            {
                string _QueryPlan = QueryPlan;
                string _SqlNameSpace = SqlNamespace;
                string _xpath = xpath;

                XPathNodeIterator i = GetXpathIterator(_QueryPlan, _SqlNameSpace, _xpath);

                string ret = String.Empty;
                while (i.MoveNext()) ret = i.Current.Value;
                return ret;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return "-1";
            }
        }
    }
}
