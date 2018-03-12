SELECT
  name
 ,type
 ,pages_kb/1024/1024 AS MemoryUsedInKB
 FROM sys.dm_os_memory_clerks
 ORDER BY pages_kb DESC

