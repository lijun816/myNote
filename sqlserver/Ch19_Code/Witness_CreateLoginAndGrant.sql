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

--For Mirror server to connect
IF NOT EXISTS(SELECT 1 FROM sys.syslogins WHERE name = 'MirrorServerUser')
CREATE LOGIN MirrorServerUser WITH PASSWORD = '32sdgsgy^%$!'

IF NOT EXISTS(SELECT 1 FROM sys.sysusers WHERE name = 'MirrorServerUser')
CREATE USER MirrorServerUser;

IF NOT EXISTS(SELECT 1 FROM sys.certificates WHERE name = 'MirrorDBCertPub')
CREATE CERTIFICATE MirrorDBCertPub  AUTHORIZATION MirrorServerUser
FROM FILE = 'C:\MirrorServerCert.cer'

GRANT CONNECT ON ENDPOINT::DBMirrorEndPoint TO MirrorServerUser
GO