USE [SabinIO.LogOverhead.Demo]
GO

SET NOCOUNT ON;
GO


--UPDATE Small number of records

--Update 1 record in the table
BEGIN TRANSACTION
update LogOverhead
set id = 2
where id = 1

select er.session_id,dt.database_transaction_log_record_count,dt.database_transaction_log_bytes_used,dt.database_transaction_log_bytes_reserved 
from sys.dm_exec_requests er
inner join sys.dm_tran_database_transactions dt
on er.transaction_id = dt.transaction_id
where er.session_id = @@spid

COMMIT TRANSACTION
--how much log is used?
--how much log is reserved for a transaction to rollback?


--Update multiple records in the table
BEGIN TRANSACTION
update LogOverhead
set id = 3

select er.session_id,dt.database_transaction_log_record_count,dt.database_transaction_log_bytes_used,dt.database_transaction_log_bytes_reserved 
from sys.dm_exec_requests er
inner join sys.dm_tran_database_transactions dt
on er.transaction_id = dt.transaction_id
where er.session_id = @@spid

COMMIT TRANSACTION
--how much log is used?
--how much log is reserved for a transaction to rollback?
