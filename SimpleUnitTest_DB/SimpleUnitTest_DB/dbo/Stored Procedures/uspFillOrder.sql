CREATE PROCEDURE [uspFillOrder]
@OrderID INT, @FilledDate DATETIME
AS
BEGIN
DECLARE @Value INT, @CustomerID INT
BEGIN TRANSACTION
    SELECT @Value = [Amount], @CustomerID = [CustomerID]
     FROM [CustomerOrders] WHERE [OrderID] = @OrderID;
 
UPDATE [CustomerOrders]
   SET [Status] = 'F',
       [FilledDate] = @FilledDate
WHERE [OrderID] = @OrderID;

UPDATE [Customer]
   SET
   CustomerSales = CustomerSales + @Value
    WHERE [CustomerID] = @CustomerID
COMMIT TRANSACTION
END
