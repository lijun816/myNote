SELECT TOP 10 execution_count as [Number of Executions], 
  total_worker_time/execution_count as [Average CPU Time],
   Total_Elapsed_Time/execution_count as [Average Elapsed Time],
   ( 
     SELECT SUBSTRING(text,statement_start_offset/2,
       (CASE WHEN statement_end_offset = -1 
              THEN LEN(CONVERT(nvarchar(max), [text])) * 2
	      ELSE statement_end_offset END - statement_start_offset) /2)
     FROM sys.dm_exec_sql_text(sql_handle)
   ) as query_text
FROM sys.dm_exec_query_stats 
ORDER BY [Average CPU Time] DESC;
