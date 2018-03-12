
CREATE EVENT SESSION [long_running_queries] ON SERVER 
ADD EVENT sqlserver.sql_statement_completed(
	SET collect_statement=(1)
    ACTION(sqlserver.sql_text
		,sqlserver.tsql_stack)
    WHERE ([duration]>(30))) 
ADD TARGET package0.event_file(SET filename=N'C:\ch12_samples\XEvents\long_running_queries.xel')
WITH (MAX_MEMORY=4096 KB
	,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS
	,MAX_DISPATCH_LATENCY=5 SECONDS
	,MAX_EVENT_SIZE=0 KB
	,MEMORY_PARTITION_MODE=NONE
	,TRACK_CAUSALITY=OFF
	,STARTUP_STATE=OFF)
GO
