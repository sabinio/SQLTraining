USE AdventureWorks2014;
GO

ALTER DATABASE AdventureWorks2014
SET PARAMETERIZATION FORCED;
GO

DBCC FREEPROCCACHE
GO
--include actual execution plan
--view estimated and actual row counts for both nested loops (left outer join)
--the first will be accurate and the second will be wildly off 
SELECT p.ProductID
	,p.NAME AS Product
	,th.ActualCost
	,th.Quantity
FROM [Production].[TransactionHistory] th
INNER JOIN [Production].[Product] p ON th.ProductID = p.ProductID
WHERE p.ProductID < 3;
GO

SELECT p.ProductID
	,p.NAME AS Product
	,th.ActualCost
	,th.Quantity
FROM [Production].[TransactionHistory] th
INNER JOIN [Production].[Product] p ON th.ProductID = p.ProductID
WHERE p.ProductID < 420;
GO

--two adhoc plans used as shells that point to parameterised plan
--view query_plan to verify (should only show "select")
SELECT cp.objtype
	,cp.cacheobjtype
	,cp.usecounts
	,st.TEXT
	,qp.query_plan
FROM sys.dm_exec_cached_plans cp
OUTER APPLY sys.dm_exec_sql_text(cp.plan_handle) st
OUTER APPLY sys.dm_exec_query_plan(cp.plan_handle) qp
WHERE st.TEXT LIKE '%TransactionHistory%'
	AND st.TEXT NOT LIKE '%dm_exec_cached_plans%';
GO

ALTER DATABASE AdventureWorks2014

SET PARAMETERIZATION SIMPLE;
GO


DBCC FREEPROCCACHE
GO
--include actual execution plan
--run both queries at the same time 
--view estimated and actual row counts for both nested loops (left outer join)
--estimated row counts now accurate for both
SELECT p.ProductID
	,p.NAME AS Product
	,th.ActualCost
	,th.Quantity
FROM [Production].[TransactionHistory] th
INNER JOIN [Production].[Product] p ON th.ProductID = p.ProductID
WHERE p.ProductID < 3;
GO
SELECT p.ProductID
	,p.NAME AS Product
	,th.ActualCost
	,th.Quantity
FROM [Production].[TransactionHistory] th
INNER JOIN [Production].[Product] p ON th.ProductID = p.ProductID
WHERE p.ProductID < 420;
GO

--two adhoc plans used as shells that point to parameterised plan
--view query_plan to verify (should only show"select")
SELECT cp.objtype
	,cp.cacheobjtype
	,cp.usecounts
	,st.TEXT
	,qp.query_plan
FROM sys.dm_exec_cached_plans cp
OUTER APPLY sys.dm_exec_sql_text(cp.plan_handle) st
OUTER APPLY sys.dm_exec_query_plan(cp.plan_handle) qp
WHERE st.TEXT LIKE '%TransactionHistory%'
	AND st.TEXT NOT LIKE '%dm_exec_cached_plans%';