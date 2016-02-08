CREATE PROCEDURE TestInsertPerformance.TestSplitPagesFillFactorSeventyPc
AS
BEGIN
	DECLARE @page_Count INT
	DECLARE @70_pc_PageCount INT
	DECLARE @first_run_database_transaction_log_bytes_used BIGINT
	DECLARE @first_run_database_transaction_log_bytes_reserved BIGINT
	DECLARE @second_run_database_transaction_log_bytes_used BIGINT
	DECLARE @second_run_database_transaction_log_bytes_reserved BIGINT

	TRUNCATE TABLE PageSplits

	BEGIN TRANSACTION

	DECLARE @a INT

	SET @a = 1

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

	SELECT @first_run_database_transaction_log_bytes_used = dt.database_transaction_log_bytes_used
		,@first_run_database_transaction_log_bytes_reserved = dt.database_transaction_log_bytes_reserved
	FROM sys.dm_exec_requests er
	INNER JOIN sys.dm_tran_database_transactions dt ON er.transaction_id = dt.transaction_id
	WHERE er.session_id = @@spid

	SELECT @page_count = page_count
	FROM sys.dm_db_index_physical_stats(db_id(), object_id('PageSplits'), 1, NULL, NULL)

	COMMIT TRANSACTION

	ALTER INDEX idx_PageSplits ON PageSplits rebuild
		WITH (FILLFACTOR = 70)

	SELECT @70_pc_PageCount = page_count
	FROM sys.dm_db_index_physical_stats(db_id(), object_id('PageSplits'), 1, NULL, NULL)

	IF @70_pc_PageCount !> @page_Count
	BEGIN
		EXEC tSQLt.Fail 'rebuild of index with 70% fill factor has resulted in less pages than FF at 100%.'
	END

	BEGIN TRANSACTION

	SET @a = 1

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

	SELECT @second_run_database_transaction_log_bytes_used = dt.database_transaction_log_bytes_used - @first_run_database_transaction_log_bytes_used
		,@second_run_database_transaction_log_bytes_reserved = dt.database_transaction_log_bytes_reserved - @first_run_database_transaction_log_bytes_reserved
	FROM sys.dm_exec_requests er
	INNER JOIN sys.dm_tran_database_transactions dt ON er.transaction_id = dt.transaction_id
	WHERE er.session_id = @@spid

	SELECT @page_count = page_count
	FROM sys.dm_db_index_physical_stats(db_id(), object_id('PageSplits'), 1, NULL, NULL)
	COMMIT TRANSACTION
	--below row is output for debugging
	--select @first_run_database_transaction_log_bytes_used as '1stbytesused', @second_run_database_transaction_log_bytes_used as '2ndbytesused'
	EXEC tSQLt.AssertEquals @70_pc_PageCount
		,@page_Count

	IF @first_run_database_transaction_log_bytes_used < @second_run_database_transaction_log_bytes_used
	BEGIN
		EXEC tSQLt.Fail 'database_transaction_log_bytes_used is larger than second run'
	END
END
GO


