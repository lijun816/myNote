SELECT  bucketid, (SELECT Text FROM sys.dm_exec_sql_text(plan_handle)) AS SQLStatement, usecounts
,size_in_bytes, refcounts
FROM sys.dm_exec_cached_plans 
WHERE cacheobjtype = 'Compiled Plan'
  AND objtype = 'proc'
