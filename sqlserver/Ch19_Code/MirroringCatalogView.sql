 
SELECT 
 DB_NAME(database_id) AS DatabaseName
,mirroring_role_desc 
,mirroring_safety_level_desc
,mirroring_state_desc
,mirroring_safety_sequence
,mirroring_role_sequence
,mirroring_partner_instance
,mirroring_witness_name
,mirroring_witness_state_desc
,mirroring_failover_lsn
,mirroring_connection_timeout
,mirroring_redo_queue
FROM sys.database_mirroring
WHERE mirroring_guid IS NOT NULL
GO

SELECT * FROM sys.database_mirroring_witnesses
GO

SELECT 
 dme.name AS EndPointName
,dme.protocol_desc
,dme.type_desc AS EndPointType
,dme.role_desc AS MirroringRole
,dme.state_desc AS EndPointStatus
,te.port AS PortUsed
,CASE WHEN dme.is_encryption_enabled = 1 
      THEN 'Yes'
      ELSE 'No'
 END AS Is_Encryption_Enabled
,dme.encryption_algorithm_desc 
,dme.connection_auth_desc 
FROM sys.database_mirroring_endpoints dme 
JOIN sys.tcp_endpoints te
  ON dme.endpoint_id = te.endpoint_id 

GO 
