CREATE DATABASE [ch17_samples] ON 
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\ch17_samples.mdf' ),
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\ch17_samples_log.ldf' )

EXEC master.dbo.sp_detach_db @dbname = N'ch17_samples'

ALTER DATABASE ch17_samples SET OFFLINE

CREATE DATABASE [ch17_samples] ON 
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\ch17_samples.mdf' ),
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\ch17_samples_log.ldf' )
 FOR ATTACH

ALTER DATABASE ch17_samples SET ONLINE

ALTER DATABASE ch17_samples SET RECOVERY BULK_LOGGED

ALTER DATABASE ch17_samples SET RECOVERY SIMPLE
go

ALTER DATABASE ch17_samples SET RECOVERY FULL
go

RESTORE FILELISTONLY FROM ch17_samples_Backup

RESTORE HEADERONLY FROM ch17_samples_Backup

RESTORE LABELONLY FROM ch17_samples_Backup

BACKUP DATABASE ch17_samples
TO DISK = 'c:\ch17_samples\backup\ch17_samples.bak'
MIRROR TO DISK = 'c:\ch17_samples\backup_mirror\ch17_samples.bak'
WITH FORMAT, MEDIANAME='ch17_sample_mirror'

