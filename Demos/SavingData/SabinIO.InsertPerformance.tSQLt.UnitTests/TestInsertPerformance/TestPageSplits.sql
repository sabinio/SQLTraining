CREATE PROCEDURE TestInsertPerformance.TestPageSplits
AS
BEGIN
	TRUNCATE TABLE PageSplits

	BEGIN TRANSACTION

	DECLARE @page_Count INT
	DECLARE @first_run_database_transaction_log_bytes_used BIGINT
	DECLARE @first_run_database_transaction_log_bytes_reserved BIGINT
	DECLARE @second_run_database_transaction_log_bytes_used BIGINT
	DECLARE @second_run_database_transaction_log_bytes_reserved BIGINT
	DECLARE @a INT = 1

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

	--select page_count from sys.dm_db_index_physical_stats(db_id(),object_id('PageSplits'),1,Null,null)
	EXEC tSQLt.AssertEquals 20000
		,@page_Count

		COMMIT TRANSACTION

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

	--debugging
	--	select @first_run_database_transaction_log_bytes_used as '1stbytesused', @second_run_database_transaction_log_bytes_used as '2ndbytesused', @first_run_database_transaction_log_bytes_reserved as '1stbytesreserved', @second_run_database_transaction_log_bytes_reserved as '2ndbytesreserved'
	EXEC tSQLt.AssertEquals 40000
		,@page_Count

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


