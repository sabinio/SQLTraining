--select top 100 * from Sales.SalesOrderDetail

USE AdventureWorks2014
GO

-- Clear Any existing cache
DBCC FREEPROCCACHE()
GO

-- Run both queries (turn on actual plan first)
-- Neither are paramertised (plans are different because product 870 has lots of results, -1 has none - taken from statistics)
-- Query is not paramertised because the group by is too complex for simple paramertisation


SELECT OrderQty, COUNT(*)
FROM Sales.SalesOrderDetail
WHERE ProductID = 870
GROUP BY OrderQty
ORDER BY 2 DESC;
GO
SELECT OrderQty, COUNT(*)
FROM Sales.SalesOrderDetail
WHERE ProductID = -1
GROUP BY OrderQty
ORDER BY 2 DESC;
GO

-- If we look in the plan cache there are two entries (one for each query above)
WITH XMLNAMESPACES
(
DEFAULT 
'http://schemas.microsoft.com/sqlserver/2004/07/showplan'
)
SELECT deqp.query_plan.value(
       '(//StmtSimple)[1]/@ParameterizedPlanHandle', 'nvarchar(64)') 
         AS ParameterizedPlanHandle, 
       deqp.query_plan.value(
       '(//StmtSimple)[1]/@ParameterizedText', 'nvarchar(max)') 
         AS ParameterizedText,
       deqp.query_plan,
       decp.cacheobjtype,
       decp.objtype,
       decp.plan_handle,
       dest.[text],
       decp.refcounts,
       decp.usecounts
FROM sys.dm_exec_cached_plans AS decp 
CROSS APPLY sys.dm_exec_sql_text(decp.plan_handle) AS dest
CROSS APPLY sys.dm_exec_query_plan(decp.plan_handle) AS deqp
WHERE dest.[text] LIKE N'%Product%'
AND dest.[text] NOT LIKE N'%sys.dm_exec_cached_plans%';
GO


-- Now execute the same query twice for each product using a prepared statement - like nHibernate/Linq would
-- The query plans are identical (the plan for the 870 product was chosen)
DECLARE @Cmd NVARCHAR(4000)

SET @cmd = 'SELECT OrderQty, COUNT(*)
FROM Sales.SalesOrderDetail
WHERE ProductID =@p1
GROUP BY OrderQty
ORDER BY 2 DESC;'

EXEC sp_executesql @Cmd, N'@p1 INT', 870
EXEC sp_executesql @Cmd, N'@p1 INT', -1
GO

-- Recheck the plan cache, we now have 3
-- the prepared row has been used twice
WITH XMLNAMESPACES
(
DEFAULT 
'http://schemas.microsoft.com/sqlserver/2004/07/showplan'
)
SELECT deqp.query_plan.value(
       '(//StmtSimple)[1]/@ParameterizedPlanHandle', 'nvarchar(64)') 
         AS ParameterizedPlanHandle, 
       deqp.query_plan.value(
       '(//StmtSimple)[1]/@ParameterizedText', 'nvarchar(max)') 
         AS ParameterizedText,
       deqp.query_plan,
       decp.cacheobjtype,
       decp.objtype,
       decp.plan_handle,
       dest.[text],
       decp.refcounts,
       decp.usecounts
FROM sys.dm_exec_cached_plans AS decp 
CROSS APPLY sys.dm_exec_sql_text(decp.plan_handle) AS dest
CROSS APPLY sys.dm_exec_query_plan(decp.plan_handle) AS deqp
WHERE dest.[text] LIKE N'%Product%'
AND dest.[text] NOT LIKE N'%sys.dm_exec_cached_plans%';
GO



-- clean the cache
DBCC FREEPROCCACHE()
GO


-- Rerun the same two queries but in a different order (-1 first)
-- Notice a different plan is now chosen
DECLARE @Cmd NVARCHAR(4000)

SET @cmd = 'SELECT OrderQty, COUNT(*)
FROM Sales.SalesOrderDetail
WHERE ProductID =@p1
GROUP BY OrderQty
ORDER BY 2 DESC;'

EXEC sp_executesql @Cmd, N'@p1 INT', -1
EXEC sp_executesql @Cmd, N'@p1 INT', 870
GO

-- Again check the cache - we now have one plan for above
WITH XMLNAMESPACES
(
DEFAULT 
'http://schemas.microsoft.com/sqlserver/2004/07/showplan'
)
SELECT deqp.query_plan.value(
       '(//StmtSimple)[1]/@ParameterizedPlanHandle', 'nvarchar(64)') 
         AS ParameterizedPlanHandle, 
       deqp.query_plan.value(
       '(//StmtSimple)[1]/@ParameterizedText', 'nvarchar(max)') 
         AS ParameterizedText,
       deqp.query_plan,
       decp.cacheobjtype,
       decp.objtype,
       decp.plan_handle,
       dest.[text],
       decp.refcounts,
       decp.usecounts
FROM sys.dm_exec_cached_plans AS decp 
CROSS APPLY sys.dm_exec_sql_text(decp.plan_handle) AS dest
CROSS APPLY sys.dm_exec_query_plan(decp.plan_handle) AS deqp
WHERE dest.[text] LIKE N'%Product%'
AND dest.[text] NOT LIKE N'%sys.dm_exec_cached_plans%';
GO



-- clean the cache
DBCC FREEPROCCACHE()
GO



-- In production how do we know we will get the right plan being cached?
-- You can use the Optimise keyword hint
DECLARE @Cmd NVARCHAR(4000)

SET @cmd = 'SELECT OrderQty, COUNT(*)
FROM Sales.SalesOrderDetail
WHERE ProductID =@p1
GROUP BY OrderQty
ORDER BY 2 DESC
OPTION (OPTIMIZE FOR(@p1=870));'

EXEC sp_executesql @Cmd, N'@p1 INT', -1
EXEC sp_executesql @Cmd, N'@p1 INT', 870
GO

-- Again check the cache - we now have one plan for above using the 870 version despite -1 being called first
WITH XMLNAMESPACES
(
DEFAULT 
'http://schemas.microsoft.com/sqlserver/2004/07/showplan'
)
SELECT deqp.query_plan.value(
       '(//StmtSimple)[1]/@ParameterizedPlanHandle', 'nvarchar(64)') 
         AS ParameterizedPlanHandle, 
       deqp.query_plan.value(
       '(//StmtSimple)[1]/@ParameterizedText', 'nvarchar(max)') 
         AS ParameterizedText,
       deqp.query_plan,
       decp.cacheobjtype,
       decp.objtype,
       decp.plan_handle,
       dest.[text],
       decp.refcounts,
       decp.usecounts
FROM sys.dm_exec_cached_plans AS decp 
CROSS APPLY sys.dm_exec_sql_text(decp.plan_handle) AS dest
CROSS APPLY sys.dm_exec_query_plan(decp.plan_handle) AS deqp
WHERE dest.[text] LIKE N'%Product%'
AND dest.[text] NOT LIKE N'%sys.dm_exec_cached_plans%';
GO

-- clean the cache
DBCC FREEPROCCACHE()
GO




-- What if you can't be sure 870 will always be a correct choice of ID (data changes over time)
-- Use UNKNOWN - this will take an average of the expected results based on input
DECLARE @Cmd NVARCHAR(4000)

SET @cmd = 'SELECT OrderQty, COUNT(*)
FROM Sales.SalesOrderDetail
WHERE ProductID =@p1
GROUP BY OrderQty
ORDER BY 2 DESC
OPTION (OPTIMIZE FOR(@p1 UNKNOWN));'

EXEC sp_executesql @Cmd, N'@p1 INT', -1
EXEC sp_executesql @Cmd, N'@p1 INT', 870
GO

-- Again check the cache - we now have one plan for above using the 870 version despite -1 being called first
WITH XMLNAMESPACES
(
DEFAULT 
'http://schemas.microsoft.com/sqlserver/2004/07/showplan'
)
SELECT deqp.query_plan.value(
       '(//StmtSimple)[1]/@ParameterizedPlanHandle', 'nvarchar(64)') 
         AS ParameterizedPlanHandle, 
       deqp.query_plan.value(
       '(//StmtSimple)[1]/@ParameterizedText', 'nvarchar(max)') 
         AS ParameterizedText,
       deqp.query_plan,
       decp.cacheobjtype,
       decp.objtype,
       decp.plan_handle,
       dest.[text],
       decp.refcounts,
       decp.usecounts
FROM sys.dm_exec_cached_plans AS decp 
CROSS APPLY sys.dm_exec_sql_text(decp.plan_handle) AS dest
CROSS APPLY sys.dm_exec_query_plan(decp.plan_handle) AS deqp
WHERE dest.[text] LIKE N'%Product%'
AND dest.[text] NOT LIKE N'%sys.dm_exec_cached_plans%';