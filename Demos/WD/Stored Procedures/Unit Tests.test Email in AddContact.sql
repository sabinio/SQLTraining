SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [Unit Tests].[test Email in AddContact]
AS
BEGIN
-- Create a fake table
EXEC tSQLt.FakeTable 'dbo.Contacts';

-- Populate a record using the procedure I'm testing
EXEC [prcAddContact]
@ContactFullName = 'David Atkinson',
@Email = 'sql.in.the.city@red-gate.com';

-- Specify the actual results
DECLARE @ActualEmail CHAR(30);
SET @ActualEmail = (SELECT Email FROM dbo.Contacts);

-- Verify that the actual results corresponds to the expected results
EXEC tSQLt.AssertEquals @Expected = 'sql.in.the.city@red-gate.com', @Actual = @ActualEmail;
END;

GO
