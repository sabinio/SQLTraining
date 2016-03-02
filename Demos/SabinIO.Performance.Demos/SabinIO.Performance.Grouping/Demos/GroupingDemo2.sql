USE [SabinIO.Performance.Grouping]
GO

--group by example
--enable actual execution plans
--note the 2 sorts and the cost
SELECT Product.ProductID
	,Product.Name
	,Product.SafetyStockLevel
	,Product.ReorderPoint
	,ProductInventory.Quantity
	,SUM(SalesDetail.OrderQty) LifeTimeSales
FROM Sales.SalesOrderDetail SalesDetail
JOIN Production.ProductInventory ProductInventory ON ProductInventory.ProductID = SalesDetail.ProductID
JOIN Production.Product Product ON Product.ProductID = ProductInventory.ProductID
JOIN Production.Location Location on Location.LocationID = ProductInventory.LocationID
WHERE ProductInventory.Quantity < Product.SafetyStockLevel
GROUP BY Product.ProductID
	,Product.NAME
	,Product.SafetyStockLevel
	,Product.ReorderPoint
	,ProductInventory.Quantity

--same query, rewritten to use derived table
--only grouping by a single column
--same results, now only one sort
--note the cost is less than previous two combined
SELECT Product.ProductID
	,Product.Name
	,Product.SafetyStockLevel
	,Product.ReorderPoint
	,ProductInventory.Quantity
	,LifeTimeSales
FROM (
	SELECT SalesDetail.ProductID
		,SUM(SalesDetail.OrderQty) LifeTimeSales
	FROM Sales.SalesOrderDetail SalesDetail
	GROUP BY SalesDetail.ProductID
	) SalesDetail
JOIN Production.ProductInventory ProductInventory ON ProductInventory.ProductID = SalesDetail.ProductID
JOIN Production.Product Product ON Product.ProductID = ProductInventory.ProductID
WHERE ProductInventory.Quantity < Product.SafetyStockLevel







select Product.ProductID, Product.Name, Product.ProductNumber, Product.SafetyStockLevel, Product.ReorderPoint, ProductInventory.Quantity, SUM(SalesDetail.OrderQty) LifeTimeSales 
from(
select 
Product.ProductID, Product.Name, Product.ProductNumber, Product.SafetyStockLevel, Product.ReorderPoint
from Production.Product Product
GROUP BY Product.Name, Product.ProductNumber, Product.SafetyStockLevel, Product.ReorderPoint
) Product
join Production.ProductInventory ProductInventory on ProductInventory.ProductID = Product.ProductID
join Sales.SalesOrderDetail SalesDetail on SalesDetail.ProductID = ProductInventory.ProductID
WHERE ProductInventory.Quantity < Product.SafetyStockLevel

