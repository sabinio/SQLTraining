USE [SabinIO.Statistics.OutOfDate]

/*
    How are statistics updated and when

    This set of scripts highlight the issue of out of date statistics
    This is simulated with an orders and orderdetails table

*/
/* 
	Add a primary key and an index, this will create a set of statistics
*/
ALTER TABLE Orders ADD CONSTRAINT pk_Orders PRIMARY KEY (OrderId)
GO

CREATE INDEX IX_Orders_OrderDate ON Orders (OrderDate)
GO

CREATE CLUSTERED INDEX IX_OrderDetails ON OrderDetails (OrderId)
GO

--This should show an even distribution of data over 10 days
DBCC SHOW_STATISTICS (
		Orders
		,IX_Orders_OrderDate
		)

--Free the cache to make sure we haven't got any existing plans
DBCC FREEPROCCACHE
GO

--Now look at a simple query for a date range greater than the maximum we know we have
--we get 0 rows, the estimate and actual are both 1
SELECT *
FROM orders
WHERE OrderDate > '11 jan 2016'
GO

EXEC up_GetOrdersBYDate '11 jan 2016'
	,'12 jan 2016'
	--Now lets add a days worth of data
GO

EXEC up_OrdersGenerate '11 jan 2016'
	,'12 jan 2016'
	,100

SET STATISTICS IO ON
GO

--Lets run the stored procedure again this will use a cached plan and so the estimate should be 1
EXEC up_GetOrdersBYDate '11 jan 2016'
	,'12 jan 2016'
GO

--lets free the cache and see what new plan we get
DBCC FREEPROCCACHE

EXEC up_GetOrdersBYDate '11 jan 2016'
	,'12 jan 2016'

--We still get an estimate 1 but the actual number is 10,000
--Lets look at the statistics and see if we can explain it
DBCC SHOW_STATISTICS (
		'orders'
		,'IX_Orders_OrderDate'
		)

--We can see from the stats that the last date is apparently on 10 jan 2016
--If we update the statistics what do we get
UPDATE STATISTICS orders

UPDATE STATISTICS orderDetails

DBCC SHOW_STATISTICS (
		'orders'
		,'IX_Orders_OrderDate'
		)

--The statistics are now up to date
--If we re run the stored proc, even though we haven't cleared the cache, the query plan is now correct
--This is because the updating of the stats causes the query plan to be invalidated.
EXEC up_GetOrdersBYDate '11 jan 2016'
	,'12 jan 2016'
GO


