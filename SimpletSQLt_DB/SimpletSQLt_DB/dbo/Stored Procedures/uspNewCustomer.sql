CREATE PROCEDURE [dbo].[uspNewCustomer]
@CustomerName NVARCHAR (40)
AS
BEGIN
INSERT INTO [Customer] (CustomerName) VALUES (@CustomerName);
END