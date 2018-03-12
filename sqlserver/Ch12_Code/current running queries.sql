 select r.session_id
   ,r.status
   ,substring(qt.text,r.statement_start_offset/2,
   (case when r.statement_end_offset = -1
   then len(convert(nvarchar(max), qt.text)) * 2
   else r.statement_end_offset end - r.statement_start_offset)/2)
   as query_text
   ,qt.dbid
   ,qt.objectid
   ,r.cpu_time
   ,r.total_elapsed_time
   ,r.reads
   ,r.writes
   ,r.logical_reads
   ,r.scheduler_id
 from sys.dm_exec_requests as r
 cross apply sys.dm_exec_sql_text(sql_handle) as qt
 inner join sys.dm_exec_sessions as es on r.session_id = es.session_id 
 where es.is_user_process = 1
 order by r.cpu_time desc


