USE AdventureWorks2014
GO
--logical read: how many 8kb pages read
--physical reads: how many 8kb pages were read from disk
--read-ahead reads: pre-fetched disksfor the query

SET STATISTICS IO ON;
SELECT *
FROM [Sales].[SalesOrderDetail]
GO
SET STATISTICS IO OFF;
GO

--parse and compile time: parse for errors and create query plan 
--execution time: complete the execution of the query plan

SET STATISTICS TIME ON;
SELECT *
FROM [Sales].[SalesOrderDetail]
GO
SET STATISTICS TIME OFF;