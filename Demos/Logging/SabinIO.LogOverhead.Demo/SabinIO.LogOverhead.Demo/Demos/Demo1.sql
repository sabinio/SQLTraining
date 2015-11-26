USE [SabinIO.LogOverhead.Demo]
GO

--INSERT Small number of records

--insert 1 record into the table
BEGIN TRANSACTION
insert into LogOverhead
values (331175850)

select er.session_id,dt.database_transaction_log_record_count,dt.database_transaction_log_bytes_used,dt.database_transaction_log_bytes_reserved 
from sys.dm_exec_requests er
inner join sys.dm_tran_database_transactions dt
on er.transaction_id = dt.transaction_id
where er.session_id = @@spid

COMMIT TRANSACTION
--how much log is used?
--how much log is reserved for a transaction to rollback?


--insert multiple records into the table
BEGIN TRANSACTION
insert into LogOverhead
values (331175870),(126187),(3117657),(1)

select er.session_id,dt.database_transaction_log_record_count,dt.database_transaction_log_bytes_used,dt.database_transaction_log_bytes_reserved 
from sys.dm_exec_requests er
inner join sys.dm_tran_database_transactions dt
on er.transaction_id = dt.transaction_id
where er.session_id = @@spid

COMMIT TRANSACTION
--how much log is used?
--how much log is reserved for a transaction to rollback?