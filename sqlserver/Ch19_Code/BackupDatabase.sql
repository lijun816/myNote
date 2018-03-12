USE Master
GO
--Take a full database backup.
BACKUP DATABASE [AdventureWorks] TO  DISK = N'C:\AdventureWorks.bak' 
WITH FORMAT, INIT, NAME = N'AdventureWorks-Full Database Backup',STATS = 10
GO
