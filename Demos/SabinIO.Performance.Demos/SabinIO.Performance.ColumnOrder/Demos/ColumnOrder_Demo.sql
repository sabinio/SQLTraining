use [SabinIO.Performance.ColumnOrder]
GO

--include actual execution plan
SELECT [CustomerID], [SalesOrderID], [OrderDate], [SubTotal]
FROM [dbo].[SalesOrderHeader]
WHERE CustomerID = 29825
GO

--create non clustered index 
CREATE NONCLUSTERED INDEX [IX_SalesOrderHeader_CustomerID_OrderDate_SubTotal]
ON [dbo].[SalesOrderHeader](
[CustomerID] ASC
,[SalesOrderID] ASC
,[OrderDate] ASC 
,[SubTotal] ASC
)
GO

--query now uses seek on the non clustered index
SELECT [CustomerID], [SalesOrderID], [OrderDate], [SubTotal]
FROM [dbo].[SalesOrderHeader]
WHERE CustomerID = 29825
GO

--run this query
--index will scan as the column we're querying on is last in the sort order 
--of the index
SELECT [CustomerID], [SalesOrderID], [OrderDate], [SubTotal]
FROM [dbo].[SalesOrderHeader]
WHERE OrderDate = '2011-05-31 00:00:00.000';
GO

--if we run again including customer id and orderdate, even in non index order, the
--optimiser will sort the order and seek on the non clustered index
SELECT [CustomerID], [SalesOrderID], [OrderDate], [SubTotal]
FROM [dbo].[SalesOrderHeader]
WHERE OrderDate = '2011-05-31 00:00:00.000'
AND CustomerID = 29825;
GO