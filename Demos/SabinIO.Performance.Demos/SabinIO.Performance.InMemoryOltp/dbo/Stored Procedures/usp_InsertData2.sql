
-- Create a natively-compiled stored procedure.
--keyword 'with native compilation' determines it is natively compiled
--'begin atomic' is required at least once in a native stored procedure and creates a transaction or save point
--atomic requires that isolation level and language are defined 
CREATE PROCEDURE [dbo].[usp_InsertData2] 
  @rowcount INT,
  @c NCHAR(48)
  WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
  AS 
  BEGIN ATOMIC 
  WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = N'British')
  DECLARE @i INT = 1;
  WHILE @i <= @rowcount
  BEGIN
    INSERT INTO [dbo].[InMemTable2](c1,c2) VALUES (@i, @c);
    SET @i += 1;
  END
END