USE Master
GO
--Check If Mirroring endpoint exists
IF NOT EXISTS(SELECT * FROM sys.endpoints WHERE type = 4)
CREATE ENDPOINT DBMirrorEndPoint
STATE=STARTED AS TCP (LISTENER_PORT = 4040)
FOR DATABASE_MIRRORING ( AUTHENTICATION = CERTIFICATE WitnessServerCert, ENCRYPTION = REQUIRED
                        ,ROLE = ALL
                       )
