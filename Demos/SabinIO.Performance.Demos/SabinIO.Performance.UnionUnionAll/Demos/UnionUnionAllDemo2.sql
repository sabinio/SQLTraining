
use AdventureWorks2014
GO

SELECT TOP 100 Name, ProductNumber INTO #table1 FROM Production.Product
ORDER BY 1 ASC

SELECT TOP 100 Name, ProductNumber INTO #table2 FROM Production.Product
ORDER BY 1 DESC

SET STATISTICS TIME ON
--run both with actual execution plan on

SELECT * FROM #table1
UNION ALL
SELECT * FROM #table2

SELECT * FROM #table1
UNION
SELECT * FROM #table2
--union runs a distinct sort to eliminate the duplicate rows even if there are none
SET STATISTICS TIME OFF

DROP TABLE #table1
DROP TABLE #table2

SELECT TOP 100 Name, ProductNumber INTO #table1 FROM Production.Product
ORDER BY 1 ASC

SELECT TOP 100 Name, ProductNumber INTO #table2 FROM Production.Product
ORDER BY 1 ASC

SET STATISTICS TIME ON

SELECT * FROM #table1
UNION ALL
SELECT * FROM #table2

SELECT * FROM #table1
UNION
SELECT * FROM #table2

SET STATISTICS TIME OFF

--in both cases union all is faster than union
