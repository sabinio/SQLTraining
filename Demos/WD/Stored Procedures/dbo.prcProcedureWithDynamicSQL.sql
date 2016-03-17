SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* This is a procedure that simply contains dynamic SQL just to demonstrate that dependencies aren't picked up. 
Use SQL Search to find these. */
CREATE PROCEDURE [dbo].[prcProcedureWithDynamicSQL]
AS 
    BEGIN

        EXECUTE  ('SELECT count(*) FROM Contacts WHERE ContactFullName LIKE ''D%''')
    END

GO
