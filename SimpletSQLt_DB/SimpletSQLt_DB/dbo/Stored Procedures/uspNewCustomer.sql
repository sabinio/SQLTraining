CREATE PROCEDURE [uspNewCustomer]
@CustomerName NVARCHAR (40)
AS
BEGIN
INSERT INTO [Customer] (CustomerName) VALUES (@CustomerName);
SELECT SCOPE_IDENTITY()
END