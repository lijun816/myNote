 -- Turn ON advanced options
 exec sp_configure 'show advanced options', '1'
 reconfigure with override
 go
 -- Turn OFF default trace
 exec sp_configure 'default trace enabled', '0'
 reconfigure with override
 go
 -- Turn OFF advanced options
 exec sp_configure 'show advanced options', '0'
 reconfigure with override
 go
