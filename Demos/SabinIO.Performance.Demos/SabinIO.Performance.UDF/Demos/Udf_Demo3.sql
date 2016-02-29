--demo3

--udf returns the max totaldue from sales order header for each territory
CREATE FUNCTION GetMaxTotalDue_Scalar
(
    @TerritoryId INT
)
RETURNS INT
AS
BEGIN
    DECLARE @maxSale INT

    SELECT @maxSale = MAX(soh.[TotalDue])
    FROM [AdventureWorks2014].[Sales].[SalesOrderHeader] soh
    WHERE soh.TerritoryID = @TerritoryId
	AND TerritoryID IS NOT NULL

    RETURN (@maxSale)
END
GO

SET STATISTICS TIME ON
SELECT
    TerritoryID,
    dbo.GetMaxTotalDue_Scalar(TerritoryID)
FROM [Sales].[SalesTerritory] T
GO
--note the sql server execution time


--create tdf for the same logic; this just returns a table
CREATE FUNCTION GetMaxTotalDue_Inline
(
    @TerritoryId INT
)
RETURNS TABLE
AS
    RETURN
    (
        SELECT MAX(soh.[TotalDue]) as TotalDue
    FROM [AdventureWorks2014].[Sales].[SalesOrderHeader] soh
    WHERE soh.TerritoryID = 10
	AND TerritoryID IS NOT NULL
	)
GO

--returns the same value as the query using udf
--notice time has gone down by ~50%
--now we're returning a table it can be optimised
	SELECT
    TerritoryID,
    (
        SELECT TotalDue
        FROM dbo.GetMaxTotalDue_Inline(TerritoryID)
    ) TotalDue
FROM [Sales].[SalesTerritory] T
GO