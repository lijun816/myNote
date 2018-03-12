USE Master
GO
--If the path of the mirror database differs from 
--the path of the principal database (for instance, their drive letters differ), 
--creating the mirror database requires that the restore operation 
--include a MOVE clause. See BOL for details on MOVE option.

RESTORE DATABASE [AdventureWorks]
FROM DISK = 'C:\AdventureWorks.bak'
WITH 
 NORECOVERY
,MOVE N'AdventureWorks' TO N'C:\AdventureWorks.mdf'
,MOVE N'AdventureWorks_log' TO N'C:\BAdventureWorks_log.LDF'
 