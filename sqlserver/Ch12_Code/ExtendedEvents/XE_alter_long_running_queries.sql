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