CREATE PROCEDURE TestInsertPerformance.TestSplitPagesFillFactorSeventyPc
AS
BEGIN
	DECLARE @startTime DATETIME2(3)
	DECLARE @endTime DATETIME2(3)
	DECLARE @FirstRunDateDiff SMALLINT
	DECLARE @SecondRunDateDiff SMALLINT
	DECLARE @page_Count INT
	DECLARE @70_pc_PageCount INT
	DECLARE @first_run_database_transaction_log_bytes_used BIGINT
	DECLARE @first_run_database_transaction_log_bytes_reserved BIGINT
	DECLARE @second_run_database_transaction_log_bytes_used BIGINT
	DECLARE @second_run_database_transaction_log_bytes_reserved BIGINT

	TRUNCATE TABLE PageSplits

BEGIN TRANSACTION
	declare @a INT
	set @a = 1
SELECT @startTime = GETDATE()

	WHILE @a <= 20000
	BEGIN
		INSERT INTO PageSplits (
			id
			,col1
			)
		VALUES (
			@a
			,'a'
			)
			,(
			@a
			,'b'
			)
			,(
			@a
			,'c'
			)
			,(
			@a
			,'d'
			)
			,(
			@a
			,'e'
			)
			,(
			@a
			,'f'
			)
			,(
			@a
			,'g'
			)
			,(
			@a
			,'h'
			)

		SET @a = @a + 1
	END

	SELECT @endTime = GETDATE()

	SELECT @FirstRunDateDiff = DATEDIFF(SECOND, @startTime, @endTime)


SELECT @first_run_database_transaction_log_bytes_used = dt.database_transaction_log_bytes_used
		,@first_run_database_transaction_log_bytes_reserved = dt.database_transaction_log_bytes_reserved
	FROM sys.dm_exec_requests er
	INNER JOIN sys.dm_tran_database_transactions dt ON er.transaction_id = dt.transaction_id
	WHERE er.session_id = @@spid

	SELECT @page_count = page_count
	FROM sys.dm_db_index_physical_stats(db_id(), object_id('PageSplits'), 1, NULL, NULL)

	--output for debugging
	--select @page_Count,  @first_run_database_transaction_log_bytes_used, @first_run_database_transaction_log_bytes_reserved

	COMMIT TRANSACTION

	alter index idx_PageSplits on PageSplits rebuild with (fillfactor = 70)

select @70_pc_PageCount = page_count from sys.dm_db_index_physical_stats(db_id(),object_id('PageSplits'),1,Null,null)

	IF @70_pc_PageCount !> @page_Count
	BEGIN
		EXEC tSQLt.Fail 'rebuild of index with 70% fill factor has resulted in less pages than FF at 100%.'
	END

	BEGIN TRANSACTION

	SELECT @startTime = GETDATE()

	WHILE @a <= 20000
	BEGIN
		INSERT INTO PageSplits (
			id
			,col1
			)
		VALUES (
			@a
			,'a'
			)

		SET @a = @a + 1
	END

	SELECT @endTime = GETDATE()

	SELECT @SecondRunDateDiff = DATEDIFF(SECOND, @StartTime, @EndTime)

	SELECT @second_run_database_transaction_log_bytes_used = dt.database_transaction_log_bytes_used - @first_run_database_transaction_log_bytes_used
		,@second_run_database_transaction_log_bytes_reserved = dt.database_transaction_log_bytes_reserved - @first_run_database_transaction_log_bytes_reserved
	FROM sys.dm_exec_requests er
	INNER JOIN sys.dm_tran_database_transactions dt ON er.transaction_id = dt.transaction_id
	WHERE er.session_id = @@spid

	SELECT @page_count = page_count
	FROM sys.dm_db_index_physical_stats(db_id(), object_id('PageSplits'), 1, NULL, NULL)

	COMMIT TRANSACTION

	--output for debugging
	--select @page_Count, @second_run_database_transaction_log_bytes_used, @second_run_database_transaction_log_bytes_reserved
	
	EXEC tSQLt.AssertEquals @70_pc_PageCount
		,@page_Count

	IF @FirstRunDateDiff < @SecondRunDateDiff
	BEGIN
		EXEC tSQLt.Fail 'Second run was quicker or as quick as first run. '
	END

		IF @first_run_database_transaction_log_bytes_used < @second_run_database_transaction_log_bytes_used
	BEGIN
		EXEC tSQLt.Fail 'database_transaction_log_bytes_used is larger than second run'
	END
	
	IF @first_run_database_transaction_log_bytes_reserved < @second_run_database_transaction_log_bytes_reserved
	BEGIN
		EXEC tSQLt.Fail 'database_transaction_log_bytes_reserved is larger than second run'
	END
END
GO


