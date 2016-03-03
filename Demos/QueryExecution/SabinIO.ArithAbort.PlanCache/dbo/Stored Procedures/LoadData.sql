CREATE PROCEDURE LoadData @i INT
AS
BEGIN
SET NOCOUNT ON
DECLARE @t INT = 0
WHILE @t < @i
BEGIN
      if @@TRANCOUNT =0
        begin transaction
INSERT INTO dbo.Table1 (MonthEndDate, memberId)
VALUES
(GETDATE(), RAND ()*12)
      if @i%20 = 0
        commit transaction
SET @t = @t + 1
END
    while @@TRANCOUNT >0
      commit transaction
SET NOCOUNT OFF
END