--------------------------------------------------------------------------
 --This will store the indexes which are not used.
 IF OBJECT_ID('dbo.NotUsedIndexes') IS NULL
 CREATE TABLE dbo.NotUsedIndexes
 (
  IndexName sysname NULL
 ,ObjectName sysname NOT NULL
 ,StatusDate datetime NOT NULL
 ,DatabaseName sysname NOT NULL
 )
 
 ----Below query will give you index which are NOT used per table in a database.
 INSERT dbo.NotUsedIndexes
 (
  IndexName
 ,ObjectName
 ,StatusDate
 ,DatabaseName
 )
 SELECT
  si.name AS IndexName
 ,so.name AS ObjectName
 ,GETDATE() AS  StatusDate
 ,DB_NAME()
 FROM sys.indexes si
 JOIN sys.all_objects so
   ON so.object_id = si.object_id
 WHERE si.index_id NOT IN (SELECT index_id
                           FROM sys.dm_db_index_usage_stats diu
                           WHERE si.object_id = diu.object_id
                             AND si.index_id = diu.index_id
                           )
   AND so.is_ms_shipped <> 1

   select * from NotUsedIndexes
