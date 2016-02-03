CREATE PROCEDURE TestDirtyPage.TestDirtyPage_DefaultValues
AS

BEGIN

declare @Actual NVARCHAR (10)
insert into WriteLogTest
Select 'CleanPage'

--Ensure written to disk
Checkpoint

select @Actual = StringColumn FROM WriteLogTest

--Check value 
EXEC tSQLt.AssertEquals 'CleanPage'
		,@Actual

END