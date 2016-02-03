CREATE PROCEDURE ShellNoLock
--this is called from main test
as 
BEGIN
SELECT * FROM TableA (NOLOCK)
-- This retruns with a dirty read, session 1 could rollback yet and we have incorrect data

END;
GO