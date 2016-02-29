--demo2

SELECT COUNT (*) FROM [AdventureWorks2014].[Sales].[Customer]
--19820 rows

CREATE FUNCTION Sales.TripleTerritoryId(@Input int)
       RETURNS int
AS
BEGIN;
  DECLARE @Result int;
  SET @Result = @Input * 3;
  RETURN @Result;
END
GO

--leave execution plan off, just run time on
SET STATISTICS TIME ON
GO
SELECT MAX(3 * TerritoryId) AS MaxTriple
FROM   [AdventureWorks2014].[Sales].[Customer]
GO
SELECT MAX(Sales.TripleTerritoryId([TerritoryID])) AS MaxTriple
FROM   [AdventureWorks2014].[Sales].[Customer]
GO
SET STATISTICS TIME OFF
--the cpu and elapsed time when executing on sql server is greater 
--using the udf than the first time round because the udf is called each time

--run queries again with actual plan on
--the scalar operation in the first plan is wher the compute ofthe 3* is happening
--the stream aggregate in the 2nd plan is where the call to the udf is happening each time (~19000 rows)

--now highlight queries and get estimated plans
--2nd plan will now include a call to the udf!
--there is no estimated costing to call udf, so there are no query optimisations that occur inside the udf

--zero costing is bad; query below calls udf twice, whilst 2nd query just performs calculation

SET STATISTICS TIME ON
GO
SELECT 1 - Sales.TripleTerritoryId(TerritoryID)
FROM   [AdventureWorks2014].[Sales].[Customer]
WHERE  Sales.TripleTerritoryId(TerritoryID) > 20;


SELECT 1 - (3 * TerritoryId)
FROM   [AdventureWorks2014].[Sales].[Customer]
WHERE  (3 * TerritoryId) > 20;
GO
SET STATISTICS TIME OFF

SELECT DISTINCT TerritoryId from [AdventureWorks2014].[Sales].[Customer]
--there are only 10 distinct territory id's, so does the udf ned to be called 19820 times?

SET STATISTICS TIME ON
GO
SELECT MAX(3 * TerritoryId) AS MaxTriple
FROM   (SELECT DISTINCT TerritoryId from [AdventureWorks2014].[Sales].[Customer]) as T
GO
SELECT MAX(Sales.TripleTerritoryId([TerritoryID])) AS MaxTriple
FROM   (SELECT DISTINCT TerritoryId from [AdventureWorks2014].[Sales].[Customer]) as T
GO
SET STATISTICS TIME OFF

--execution time for the udf will be much improved; if not as good then nearly as good


