
use AdventureWorks2014
GO

SELECT TOP 100 Name, ProductNumber INTO table1 FROM Production.Product
ORDER BY 1 ASC

SELECT TOP 100 Name, ProductNumber INTO table2 FROM Production.Product
ORDER BY 1 DESC
GO
SET STATISTICS TIME ON
GO
--run both with actual execution plan on

SELECT * FROM table1
UNION ALL
SELECT * FROM table2
GO
SELECT * FROM table1
UNION
SELECT * FROM table2
GO
--union runs a distinct sort to eliminate the duplicate rows even if there are none
SET STATISTICS TIME OFF
GO
DROP TABLE table1
DROP TABLE table2
GO
SELECT TOP 100 Name, ProductNumber INTO table1 FROM Production.Product
ORDER BY 1 ASC

SELECT TOP 100 Name, ProductNumber INTO table2 FROM Production.Product
ORDER BY 1 ASC
GO
SET STATISTICS TIME ON
GO
SELECT * FROM table1
UNION ALL
SELECT * FROM table2
GO
SELECT * FROM table1
UNION
SELECT * FROM table2
GO
SET STATISTICS TIME OFF

--in both cases union all is faster than union
