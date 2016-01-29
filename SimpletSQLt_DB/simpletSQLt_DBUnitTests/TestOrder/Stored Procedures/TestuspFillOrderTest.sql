
CREATE PROCEDURE TestOrder.TestuspFillOrderTest
AS
BEGIN
		
		DECLARE 
		 @ret AS INT
		,@CustomerID AS INT
		,@Amount AS INT
		,@OrderDate AS DATETIME
		,@Status AS CHAR(1)
		,@CustomerName NVARCHAR(12)
		,@OrderId INT;

	SELECT @ret = 0
		,@CustomerID = 0
		,@Amount = 100
		,@OrderDate = GETDATE()
		,@Status = 'O'
		,@CustomerName = 'Mr X';

	IF NOT EXISTS(SELECT * FROM [Customer] WHERE CustomerName = @CustomerName)
	BEGIN
	EXECUTE @CustomerID = [uspNewCustomer] @CustomerName;
	END

	IF EXISTS (SELECT * FROM [Customer] WHERE CustomerName = @CustomerName)
	BEGIN
	SELECT @CustomerID = CustomerId FROM dbo.Customer
	WHERE @CustomerName = @CustomerName
	END

	DELETE from [CustomerOrders] WHERE [CustomerID] = @CustomerID;
	UPDATE [Customer] SET CustomerOrders = 0, CustomerSales = 0 WHERE [CustomerID] = @CustomerID;

	EXECUTE @ret = [uspPlaceNewOrder] @CustomerId
		,@Amount
		,@OrderDate
		,@Status;

	SELECT @OrderId = MAX (OrderId)
	FROM dbo.CustomerOrders
	WHERE CustomerID = @CustomerID

	EXECUTE @ret = [uspFillOrder] @OrderId,
		@OrderDate;

	DECLARE @CustomerSales INT, @CustomerOrders INT,@NewCustomerName NVARCHAR (12)

SELECT @NewCustomerName = CustomerName from dbo.Customer WHERE CustomerName = @CustomerName;

EXEC tSQLt.AssertEquals 'Mr X', @NewCustomerName;

	SELECT @CustomerSales = [CustomerSales]
	FROM [Customer]
	WHERE [CustomerID] = @CustomerID

	EXEC tSQLt.AssertEquals 100
		,@CustomerSales;


	-- verify that the CustomerOrders value is correct.
	SELECT @CustomerOrders = [CustomerOrders]
	FROM [Customer]
	WHERE [CustomerID] = @CustomerID

	EXEC tSQLt.AssertEquals 100
		,@CustomerOrders;

END;
GO