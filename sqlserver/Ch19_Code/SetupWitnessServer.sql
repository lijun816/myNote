USE MASTER
GO
ALTER DATABASE TestMirroring
SET WITNESS = 'TCP://OUM.redmond.corp.microsoft.com:4040'
