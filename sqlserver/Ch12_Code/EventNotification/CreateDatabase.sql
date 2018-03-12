IF NOT EXISTS(SELECT 1 FROM sys.databases WHERE name = 'StoreEvent')
CREATE DATABASE StoreEvent
GO

USE StoreEvent
GO

IF OBJECT_ID('EventTable') IS NULL
CREATE TABLE EventTable
(
 RID int IDENTITY (1,1) NOT NULL
,EventDetails xml NULL
,EventDateTime datetime NULL
)