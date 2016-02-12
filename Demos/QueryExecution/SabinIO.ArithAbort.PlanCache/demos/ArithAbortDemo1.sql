USE [SabinIO.ArithAbort.PlanCache]

--check if arithabort is set to off and if it is not then switch off
DECLARE @ARITHABORT CHAR(3) = 'OFF';

IF ((64 & @@OPTIONS) = 64)
	SET ARITHABORT OFF;

SELECT CASE 
		WHEN ((64 & @@OPTIONS) = 64)
			THEN 'ARITHABORT IS ON'
		ELSE 'ARITHABORT IS OFF'
		END AS ARITHABORT;

--free the cache so we get accurate counts
DBCC FREEPROCCACHE

--run stored proc; this inserts 1000 rows into table
EXEC LoadData 1000

--what does plan cache show?
SELECT p.plan_handle
	,stat.execution_count
	,stat.query_hash
	,stat.query_plan_hash
	,stat.statement_start_offset
	,stat.statement_end_offset
	,plan_generation_num
	,p.usecounts
	,p.refcounts
	,p.cacheobjtype
	,s.TEXT
	,stat.*
FROM sys.dm_exec_cached_plans p
CROSS APPLY sys.dm_exec_sql_text(p.plan_handle) s
LEFT JOIN sys.dm_exec_query_stats stat ON stat.plan_handle = p.plan_handle
WHERE s.TEXT LIKE '%Table1%'
ORDER BY stat.execution_count DESC
GO

--same plan was used for each run
--now what happens if we switch on arithabort (the default)?
DECLARE @ARITHABORT CHAR(2) = 'ON';

IF ((64 & @@OPTIONS) != 64)
	SET ARITHABORT ON;

SELECT CASE 
		WHEN ((64 & @@OPTIONS) = 64)
			THEN 'ARITHABORT IS ON'
		ELSE 'ARITHABORT IS OFF'
		END AS ARITHABORT;

--run same sproc same number of times
EXEC LoadData 1000

SELECT p.plan_handle
	,stat.execution_count
	,stat.query_hash
	,stat.query_plan_hash
	,stat.statement_start_offset
	,stat.statement_end_offset
	,plan_generation_num
	,p.usecounts
	,p.refcounts
	,p.cacheobjtype
	,s.TEXT
	,stat.*
FROM sys.dm_exec_cached_plans p
CROSS APPLY sys.dm_exec_sql_text(p.plan_handle) s
LEFT JOIN sys.dm_exec_query_stats stat ON stat.plan_handle = p.plan_handle
WHERE s.TEXT LIKE '%Table1%'
ORDER BY stat.execution_count DESC
GO

--run sproc again, what happens to plan cache numbers?
