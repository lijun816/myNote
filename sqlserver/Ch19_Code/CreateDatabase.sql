IF NOT EXISTS(SELECT 1 FROM sys.sysdatabases WHERE name = 'AdventureWorks')
CREATE DATABASE AdventureWorks

--Although when you create the database it is in full recovery mode
--i am doing it here as a reminder that you will need to set the
--recovery model to FULL recovery in order to establish mirror the database.
ALTER DATABASE AdventureWorks SET RECOVERY FULL
