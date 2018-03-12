-- Create a new event session
create event session long_running_queries on server
-- Add the sql_statement_complete event
add event sqlserver.sql_statement_completed	
(
	-- for this event get the sql_text, and tsql_stack
	action(sqlserver.sql_text, sqlserver.tsql_stack)	
	-- Predicate on duration > 30 ms ( milli seconds )
	where sqlserver.sql_statement_completed.duration > 30	
)

-- Send the output to the specified XML file
add target package0.asynchronous_file_target			
(
	set filename=N'c:\chapter_12_samples\XEvents\long_running_queries.xel'
	, metadatafile = N'c:\chapter_12_samples\XEvents\long_running_queries.xem'
)
-- Specify session options, 
-- max_dispatch_latency specifies how long we buffer in memory before pushing to the target
with (max_dispatch_latency = 1 seconds)				


-- Which event session do we want to alter
alter event session long_running_queries on server
-- Now make any changes
-- change the state to start
state = start

-- Which event session do we want to alter
alter event session long_running_queries on server
-- Now make any changes
-- add another event, this time the long_io_detected event
add event sqlserver.long_io_detected
(
-- for this event get the sql_text, and tsql_stack
	action(sqlserver.sql_text, sqlserver.tsql_stack)
	-- No predicate, we want all of these to see if there is any correlation
)
