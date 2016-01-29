CREATE PROCEDURE [uspCancelOrder]
@OrderID INT
AS
BEGIN
DECLARE @Value INT, @CustomerID INT
BEGIN TRANSACTION
    SELECT @Value = [Amount], @CustomerID = [CustomerID]
     FROM [CustomerOrders] WHERE [OrderID] = @OrderID;
 
UPDATE [CustomerOrders]
   SET [Status] = 'X'
WHERE [OrderID] = @OrderID;

UPDATE [Customer]
   SET
   CustomerOrders = CustomerOrders - @Value
    WHERE [CustomerID] = @CustomerID
COMMIT TRANSACTION
END