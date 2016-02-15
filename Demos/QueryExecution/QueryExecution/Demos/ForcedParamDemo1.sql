USE [SabinIO.ForcedParameterisation.Demo]
GO

/*
    How are does parametrization effect query plan reuse

    This set of scripts shows the impact of parameterization on
    query plan reuse. It shows how the query text is reduced to 
    removing comments before the query plan is produced.    
    
*/
--set simple to see what happens
ALTER DATABASE [SabinIO.ForcedParameterisation.Demo] SET PARAMETERIZATION SIMPLE

SELECT NAME
	,is_parameterization_forced
FROM sys.databases
WHERE database_id = DB_ID('SabinIO.ForcedParameterisation.Demo')
GO

DBCC FREEPROCCACHE
GO

--Try and repeat the query in profiler
DECLARE @i TINYINT = 1;

WHILE @i <= 10
BEGIN
	SELECT *
	FROM [SabinIO.ForcedParameterisation.Demo].dbo.fp_sales
	WHERE DueDate BETWEEN '2012/01/01'
			AND '2012/01/02'

	SET @i = @i + 1;
END;
GO

--Lets see what is in the cache.
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
WHERE s.TEXT LIKE '%fp_sales%'
ORDER BY stat.execution_count desc
GO

--Some other comment
DECLARE @i TINYINT = 1;

WHILE @i <= 10
BEGIN
	SELECT *
	FROM [SabinIO.ForcedParameterisation.Demo].dbo.fp_sales
	WHERE DueDate BETWEEN '2012/01/01'
			AND '2012/01/02'

	SET @i = @i + 1;
END;
GO

--Same query just using >= and <= instead of between
DECLARE @i TINYINT = 1;

WHILE @i <= 10
BEGIN
	SELECT *
	FROM [SabinIO.ForcedParameterisation.Demo].dbo.fp_sales
	WHERE DueDate >= '2012/01/01'
		AND DueDate <= '2012/01/02'

	SET @i = @i + 1;
END;
GO

--What about after a few other similar queries are executed.
--Lets see what is in the cache.
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
WHERE s.TEXT LIKE '%fp_sales%'
ORDER BY stat.execution_count desc

/*
now run in forced
*/
ALTER DATABASE [SabinIO.ForcedParameterisation.Demo] SET PARAMETERIZATION FORCED
GO

SELECT NAME
	,is_parameterization_forced
FROM sys.databases
WHERE database_id = DB_ID('SabinIO.ForcedParameterisation.Demo')
GO

DBCC FREEPROCCACHE
GO

--Try and repeat the query in profiler
DECLARE @i TINYINT = 1;

WHILE @i <= 10
BEGIN
	SELECT *
	FROM [SabinIO.ForcedParameterisation.Demo].dbo.fp_sales
	WHERE DueDate BETWEEN '2012/01/01'
			AND '2012/01/02'

	SET @i = @i + 1;
END;
GO

--Lets see what is in the cache.
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
WHERE s.TEXT LIKE '%fp_sales%'
ORDER BY stat.execution_count desc
GO

--Some other comment
DECLARE @i TINYINT = 1;

WHILE @i <= 10
BEGIN
	SELECT *
	FROM [SabinIO.ForcedParameterisation.Demo].dbo.fp_sales
	WHERE DueDate BETWEEN '2012/01/01'
			AND '2012/01/02'

	SET @i = @i + 1;
END;
GO

--Same query just using >= and <= instead of between
DECLARE @i TINYINT = 1;

WHILE @i <= 10
BEGIN
	SELECT *
	FROM [SabinIO.ForcedParameterisation.Demo].dbo.fp_sales
	WHERE DueDate >= '2012/01/01'
		AND DueDate <= '2012/01/02'

	SET @i = @i + 1;
END;
GO

--What about after a few other similar queries are executed.
--Lets see what is in the cache.
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
WHERE s.TEXT LIKE '%fp_sales%'
ORDER BY stat.execution_count desc
