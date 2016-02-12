/*
	Create a procedure to populate the tables
	
	This procedure distributes the number of rows over the data range selected
*/
create procedure up_OrdersGenerate 
   @StartDate datetime
  ,@EndDate datetime
  ,@Rows int
as
    set nocount on
    set statistics io off
    set statistics xml off
    
    declare @i int = 0
    declare @interval numeric(10,4)
    declare @s_interval int
    declare @ms_interval int

    --find the difference in seconds and then divide by the number of rows wanted
    set @interval = datediff(s,@startdate,@enddate)*1.0/@rows
    set @s_interval = @interval
    set @ms_interval = (1000 * @interval ) % 1000

    while @i < @rows
      begin
      --Use transactions as it can be a bit quicker
      if @@TRANCOUNT =0
        begin transaction
        
      insert into orders 
      select dateadd(ms, @ms_interval * @i ,dateadd(s, @s_interval * @i,@StartDate) ), RAND() * 10000
      --dateadd doesn't handle decimals so you need to add seconds and milliseconds
      
      insert into orderDetails(orderId, col1) 
      select SCOPE_IDENTITY (),''
      --add an order detail record
      
      --Batch commit the transaction
      if @i%20 = 0
        commit transaction
      
      set @i = @i + 1
      end
    --finally commit the transaction
    while @@TRANCOUNT >0
      commit transaction

    --output the final date inserted
    select @s_interval Interval_Seconds, @ms_interval Interval_Milliseconds, 
           dateadd(ms, @ms_interval * @i ,dateadd(s, @s_interval * @i,@StartDate)) Last_Date_Added

    
    set statistics xml on