--------------------------------------------------------------------------------------------------------

-- To Manual failover
-- Manual Failover requires SAFETY FULL but presence of Witness is optional.
-- The mirroring_state (sys.database_mirroring) must be in Synchronized state for successful failover.
ALTER DATABASE AdventureWorks SET PARTNER FAILOVER
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

-- To Force Service failover
-- Manual Failover requires SAFETY OFF (although you can run when SAFETY full if the mirror can not form a quorum)
---and if mirror can not connect to principal.
-- The mirroring_state (sys.database_mirroring) does not matter in this case because it if forced failover and
---that is why you may loose data.
ALTER DATABASE AdventureWorks SET PARTNER FORCE_SERVICE_ALLOW_DATA_LOSS
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

---To stop mirroring run following command either on principal or mirror
ALTER DATABASE AdventureWorks SET PARTNER OFF
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

--To remove WITNESS, you can run below command on either principal or mirror.
ALTER DATABASE AdventureWorks SET WITNESS OFF
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

--To set the database mirroring session in High Performance mode run this On Principal.
ALTER DATABASE AdventureWorks SET SAFETY OFF
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

--To set the database mirroring session in High SAFETY mode run this On Principal.
ALTER DATABASE AdventureWorks SET SAFETY FULL
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

--To suspend the database mirroring session run this on either partner.
--this command will stop transferring logs over to the mirror.
ALTER DATABASE AdventureWorks SET PARTNER SUSPEND
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

--To resume the database mirroring session.
ALTER DATABASE AdventureWorks SET PARTNER RESUME
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
