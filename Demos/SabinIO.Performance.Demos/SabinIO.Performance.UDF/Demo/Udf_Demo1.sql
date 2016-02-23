
--populate table with 1000 rows
SET NOCOUNT ON
set statistics IO OFF
declare @i as int;
set @i = 1;
begin tran
while @i <= 1000
begin
 insert into dbo.Numbers
 ( [Number] )
 values
 ( @i)
 set @i = @i + 1;
end;
commit;

--what happens when we run this query?
SELECT Number, GetDate() AS CurDate
FROM dbo.Numbers
WHERE Number <= 1000;
GO
--1000 rows with identical date; getdate is only called once

--create function to getdate
CREATE FUNCTION dbo.GetDateFunction()
RETURNS DateTime
AS
BEGIN
   RETURN GetDate();
END
GO

--whatwill happen now?
SELECT Number, dbo.GetDateFunction() AS CurDate
FROM dbo.Numbers
WHERE Number <= 1000;
--getdate is called 1000 separate times
