USE MASTER
GO

--For Principal server to connect
IF NOT EXISTS(SELECT 1 FROM sys.syslogins WHERE name = 'PrincipalServerUser')
CREATE LOGIN PrincipalServerUser WITH PASSWORD = '32sdgsgy^%$!'

IF NOT EXISTS(SELECT 1 FROM sys.sysusers WHERE name = 'PrincipalServerUser')
CREATE USER PrincipalServerUser;

IF NOT EXISTS(SELECT 1 FROM sys.certificates WHERE name = 'PrincipalDBCertPub')
CREATE CERTIFICATE PrincipalDBCertPub  AUTHORIZATION PrincipalServerUser
FROM FILE = 'C:\PrincipalServerCert.cer'

GRANT CONNECT ON ENDPOINT::DBMirrorEndPoint TO PrincipalServerUser
GO

--For Witness server to connect
IF NOT EXISTS(SELECT 1 FROM sys.syslogins WHERE name = 'WitnessServerUser')
CREATE LOGIN WitnessServerUser WITH PASSWORD = '32sdgsgy^%$!'

IF NOT EXISTS(SELECT 1 FROM sys.sysusers WHERE name = 'WitnessServerUser')
CREATE USER WitnessServerUser;

IF NOT EXISTS(SELECT 1 FROM sys.certificates WHERE name = 'WitnessDBCertPub')
CREATE CERTIFICATE WitnessDBCertPub  AUTHORIZATION WitnessServerUser
FROM FILE = 'C:\WitnessServerCert.cer'

GRANT CONNECT ON ENDPOINT::DBMirrorEndPoint TO WitnessServerUser
GO