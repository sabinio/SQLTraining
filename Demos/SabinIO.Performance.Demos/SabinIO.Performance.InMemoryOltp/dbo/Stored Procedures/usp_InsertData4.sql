
--create 2nd stored proc to insert into 4th table
CREATE PROCEDURE [dbo].[usp_InsertData4] 
  @rowcount INT,
  @c NCHAR(48)
  WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
  AS 
  BEGIN ATOMIC 
  WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = N'British')
  DECLARE @i INT = 1;
  WHILE @i <= @rowcount
  BEGIN
    INSERT INTO [dbo].[inMemTable4](c1,c2) VALUES (@i, @c);
    SET @i += 1;
  END
END