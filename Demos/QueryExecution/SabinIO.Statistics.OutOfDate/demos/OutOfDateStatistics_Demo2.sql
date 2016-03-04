USE [SabinIO.Statistics.OutOfDate]
GO
/*
    This script highlights how statistics are updated as data changes
    
    The part 1-2 scripts in this series should have been run in full 
    first for this to have the expected results

*/
--So How many rows have to be changed to get statistics updated 
--General rule is 20% + 500 - thats a lot, imagine a table with a year of data, 20 days will pass before stats are updated
--http://sqlserverpedia.com/wiki/Updating_Statistics#How_and_when_are_statistics_updated_automatically
--In the following script we add data until the stats get updated
--We can use the stats_date() function to see when indexes have been updated

SELECT p.rows
	,stats_date(i.object_id, p.index_id)
FROM sys.indexes i
JOIN sys.partitions p ON p.object_id = i.object_id
	AND i.index_id = p.index_id
WHERE NAME = 'IX_Orders_OrderDate'
GO
EXEC up_OrdersGenerate '12 jan 2016'
	,'13 jan 2016'
	,100
GO
EXEC up_GetOrdersBYDate '11 jan 2016'
	,'12 jan 2016' --We have to perform a query to update the stats
GO
SELECT p.rows
	,stats_date(i.object_id, p.index_id)
FROM sys.indexes i
JOIN sys.partitions p ON p.object_id = i.object_id
	AND i.index_id = p.index_id
WHERE NAME = 'IX_Orders_OrderDate'
GO
EXEC up_OrdersGenerate '13 jan 2016'
	,'14 jan 2016'
	,100
GO
EXEC up_GetOrdersBYDate '11 jan 2016'
	,'12 jan 2016'
GO
SELECT p.rows
	,stats_date(i.object_id, p.index_id)
FROM sys.indexes i
JOIN sys.partitions p ON p.object_id = i.object_id
	AND i.index_id = p.index_id
WHERE NAME = 'IX_Orders_OrderDate'
GO
EXEC up_OrdersGenerate '14 jan 2016'
	,'15 jan 2016'
	,100
GO
EXEC up_GetOrdersBYDate '11 jan 2016'
	,'12 jan 2016'
GO
SELECT p.rows
	,stats_date(i.object_id, p.index_id)
FROM sys.indexes i
JOIN sys.partitions p ON p.object_id = i.object_id
	AND i.index_id = p.index_id
WHERE NAME = 'IX_Orders_OrderDate'
GO
	--Stats will have been now have been updated with the last set of data having been added
--Lets add 5 days worth and have a look at what happens to the stored proc call
EXEC up_OrdersGenerate '15 jan 2016'
	,'19 jan 2016'
	,600
GO

--import trace template from demos\trace template into profiler and exec stored proc
EXEC up_GetOrdersBYDate '11 jan 2016'
	,'12 jan 2016'
	/* 
You will find that there are 3 odd statements like the ones below. These are used by the optimiser to update the statistics. Each is an index scan, or a tablesample. This isn't ideal

SELECT StatMan([SC0]) FROM (SELECT TOP 100 PERCENT [OrderId] AS [SC0] FROM [dbo].[orders] WITH (READUNCOMMITTED)  ORDER BY [SC0] ) AS _MS_UPDSTATS_TBL 

SELECT StatMan([SC0], [SC1]) FROM (SELECT TOP 100 PERCENT [OrderDate] AS [SC0], [OrderId] AS [SC1] FROM [dbo].[orders] WITH (READUNCOMMITTED)  ORDER BY [SC0], [SC1] ) AS _MS_UPDSTATS_TBL 

SELECT StatMan([SC0], [SB0000]) FROM (SELECT TOP 100 PERCENT [SC0], step_direction([SC0]) over (order by NULL) AS [SB0000]  FROM (SELECT [OrderId] AS [SC0] FROM [dbo].[orderdetails] TABLESAMPLE SYSTEM (8.977087e+001 PERCENT) WITH (READUNCOMMITTED) ) AS _MS_UPDSTATS_TBL_HELPER ORDER BY [SC0], [SB0000] ) AS _MS_UPDSTATS_TBL  OPTION (MAXDOP 1)


*/
GO
SELECT p.rows
	,stats_date(i.object_id, p.index_id)
FROM sys.indexes i
JOIN sys.partitions p ON p.object_id = i.object_id
	AND i.index_id = p.index_id
WHERE NAME = 'IX_Orders_OrderDate'
GO
