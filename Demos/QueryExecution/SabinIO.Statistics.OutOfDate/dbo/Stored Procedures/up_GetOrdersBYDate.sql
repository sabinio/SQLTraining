/*
    Create a procedure to return orders for a date window

*/

create procedure up_GetOrdersBYDate
	@FromDate Datetime
   ,@ToDate   Datetime
as
set statistics io on
--select orders with the orderdate between the two dates passed in
    select o.OrderId, o.OrderDate, od.OrderDetailId, od.col1
    into #dump
    from orders  o
    join orderdetails od on o.OrderId = od.OrderId
    where OrderDate between @FromDate and @ToDate
    
    select @@rowcount RowsAffected