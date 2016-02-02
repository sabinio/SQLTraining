CREATE PROCEDURE TestOrder.TestuspFillOrderTest
AS
BEGIN
	DECLARE 
		 @ret AS INT
		,@CustomerID AS INT
		,@Amount AS INT
		,@OrderDate AS DATETIME
		,@Status AS CHAR(1)
		,@CustomerName NVARCHAR(12);

	SELECT @ret = 0
		,@CustomerID = 0
		,@Amount = 100
		,@OrderDate = GETDATE()
		,@Status = 'O'
		,@CustomerName = 'Mr X';

	EXECUTE @ret = [uspNewCustomer] @CustomerName;

	SELECT @CustomerID = MAX(CustomerID)
	FROM dbo.Customer
	WHERE CustomerName = @CustomerName

	EXECUTE @ret = [uspPlaceNewOrder] @CustomerId
		,@Amount
		,@OrderDate
		,@Status;

	EXECUTE @ret = [uspFillOrder] @CustomerID,
		@OrderDate;

	DECLARE @CustomerSales INT, @CustomerOrders INT,@NewCustomerName NVARCHAR (12)

SELECT @NewCustomerName = CustomerName from dbo.Customer WHERE CustomerName = @CustomerName;

EXEC tSQLt.AssertEquals @CustomerName, @NewCustomerName;

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
