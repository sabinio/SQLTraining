CREATE PROCEDURE [uspPlaceNewOrder]
@CustomerID INT, @Amount INT, @OrderDate DATETIME, @Status CHAR (1)='O'
AS
BEGIN
DECLARE @RC INT
BEGIN TRANSACTION
INSERT INTO [CustomerOrders] (CustomerID, OrderDate, FilledDate, Status, Amount) 
     VALUES (@CustomerID, @OrderDate, NULL, @Status, @Amount)
SELECT @RC = SCOPE_IDENTITY();
UPDATE [Customer]
   SET
   CustomerOrders = CustomerOrders + @Amount
    WHERE [CustomerID] = @CustomerID
COMMIT TRANSACTION
RETURN @RC
END