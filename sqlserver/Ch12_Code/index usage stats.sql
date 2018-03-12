-------------------------------------------------------------------------
 IF OBJECT_ID('dbo.IndexUsageStats') IS NULL
 CREATE TABLE dbo.IndexUsageStats
 (
  IndexName sysname NULL
 ,ObjectName sysname NOT NULL
 ,user_seeks bigint NOT NULL
 ,user_scans bigint NOT NULL
 ,user_lookups bigint NOT NULL
 ,user_updates bigint NOT NULL
 ,last_user_seek datetime NULL
 ,last_user_scan datetime NULL
 ,last_user_lookup datetime NULL
 ,last_user_update datetime NULL
 ,StatusDate datetime NOT NULL
 ,DatabaseName sysname NOT NULL
 )
 
 GO
 ----Below query will give you index USED per table in a database.
 INSERT INTO dbo.IndexUsageStats
 (
  IndexName
 ,ObjectName
 ,user_seeks
 ,user_scans
 ,user_lookups
 ,user_updates
 ,last_user_seek
 ,last_user_scan
 ,last_user_lookup
 ,last_user_update
 ,StatusDate
 ,DatabaseName
 )
 SELECT
  si.name AS IndexName
 ,so.name AS ObjectName
 ,diu.user_seeks
 ,diu.user_scans
 ,diu.user_lookups
 ,diu.user_updates
 ,diu.last_user_seek
 ,diu.last_user_scan
 ,diu.last_user_lookup
 ,diu.last_user_update
 ,GETDATE() AS StatusDate
 ,sd.name AS DatabaseName
 FROM sys.dm_db_index_usage_stats  diu
 JOIN sys.indexes si
   ON diu.object_id = si.object_id
  AND diu.index_id = si.index_id
 JOIN sys.all_objects so
   ON so.object_id = si.object_id
 JOIN sys.databases sd
   ON sd.database_id = diu.database_id
 WHERE is_ms_shipped <> 1
   AND diu.database_id = DB_ID()
 
 select * from IndexUsageStats
