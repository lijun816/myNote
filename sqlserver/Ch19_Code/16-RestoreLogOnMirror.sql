USE MASTER
GO
RESTORE LOG AdventureWorks 
FROM DISK = 'C:\DM\AdventureWorks.trn'
WITH NORECOVERY