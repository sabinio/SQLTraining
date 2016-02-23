declare @i as int;
set @i = 1;
begin tran
while @i <= 4000
begin
 insert into dbo.Table1
 ( [Id], [OrderDate], [BigId],[FFOS],[value] )
 values
 ( @i, GETDATE(), RAND ()*12, 'FFOS', RAND ()*13)
 
 set @i = @i + 1;
end;
commit;