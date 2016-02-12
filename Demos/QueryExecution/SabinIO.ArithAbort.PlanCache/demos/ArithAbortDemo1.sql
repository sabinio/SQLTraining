USE [SabinIO.ArithAbort.PlanCache]

-- SET ARITHABORT OFF (default for .net and most other providers)
SET ARITHABORT OFF

--free the cache so we get accurate counts
DBCC FREEPROCCACHE

--run stored proc; this inserts 100 rows into table each time
EXEC LoadData 100
EXEC LoadData 100

--what does plan cache show?
SELECT p.plan_handle
	,stat.execution_count
	,plan_generation_num
	,(SELECT TOP 1 SUBSTRING(s.[text],statement_start_offset / 2+1 , 
      ( (CASE WHEN statement_end_offset = -1 
         THEN (LEN(CONVERT(nvarchar(max),s.[text])) * 2) 
         ELSE statement_end_offset END)  - statement_start_offset) / 2+1))  AS sql_statement
	,stat.creation_time, ats.*
FROM sys.dm_exec_cached_plans p
CROSS APPLY sys.dm_exec_plan_attributes(p.plan_handle) ats
CROSS APPLY sys.dm_exec_sql_text(p.plan_handle) s
LEFT JOIN sys.dm_exec_query_stats stat ON stat.plan_handle = p.plan_handle
WHERE s.TEXT LIKE 'CREATE PROCEDURE%'
	and ats.attribute = 'set_options'
ORDER BY stat.execution_count DESC
GO

--same plan was used for each run
--now what happens if we switch on arithabort?
-- SET ARITHABORT ON (it is by default in SSMS)
SET ARITHABORT ON


--run same sproc again with 50 more records
EXEC LoadData 50

SELECT p.plan_handle
	,stat.execution_count
	,plan_generation_num
	,(SELECT TOP 1 SUBSTRING(s.[text],statement_start_offset / 2+1 , 
      ( (CASE WHEN statement_end_offset = -1 
         THEN (LEN(CONVERT(nvarchar(max),s.[text])) * 2) 
         ELSE statement_end_offset END)  - statement_start_offset) / 2+1))  AS sql_statement
	,stat.creation_time, ats.*
FROM sys.dm_exec_cached_plans p
CROSS APPLY sys.dm_exec_plan_attributes(p.plan_handle) ats
CROSS APPLY sys.dm_exec_sql_text(p.plan_handle) s
LEFT JOIN sys.dm_exec_query_stats stat ON stat.plan_handle = p.plan_handle
WHERE s.TEXT LIKE 'CREATE PROCEDURE%'
	and ats.attribute = 'set_options'
ORDER BY stat.execution_count DESC
GO

--run sproc again, what happens to plan cache numbers?
