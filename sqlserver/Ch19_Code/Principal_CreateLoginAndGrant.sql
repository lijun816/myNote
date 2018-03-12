USE MASTER
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