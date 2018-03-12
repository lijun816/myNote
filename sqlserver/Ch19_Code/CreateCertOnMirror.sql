USE MASTER
GO
IF NOT EXISTS(SELECT 1 FROM sys.symmetric_keys where name = '##MS_DatabaseMasterKey##')
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '23%&weq^yzYu2005!'
GO

IF NOT EXISTS (select 1 from sys.databases where [is_master_key_encrypted_by_server] = 1)
ALTER MASTER KEY ADD ENCRYPTION BY SERVICE MASTER KEY 
GO

IF NOT EXISTS (SELECT 1 FROM sys.certificates WHERE name = 'MirrorServerCert')
CREATE  CERTIFICATE MirrorServerCert
WITH SUBJECT = 'Mirror Server Certificate'
GO

BACKUP CERTIFICATE MirrorServerCert TO FILE = 'C:\MirrorServerCert.cer'