USE StoreEvent
GO

--CREATE QUEUE to receive the event details.
IF OBJECT_ID('dbo.NotifyQueue') IS NULL
CREATE QUEUE dbo.NotifyQueue
WITH STATUS = ON
    ,RETENTION = OFF
GO

--create the service so that when event happens
--server can send the message to this service.
--we are using the pre-defined contract here.
IF NOT EXISTS(SELECT * FROM sys.services WHERE name = 'EventNotificationService')
CREATE SERVICE EventNotificationService
ON QUEUE NotifyQueue
([http://schemas.microsoft.com/SQL/Notifications/PostEventNotification])

IF NOT EXISTS(SELECT * FROM sys.routes WHERE name = 'NotifyRoute')

CREATE ROUTE NotifyRoute
WITH SERVICE_NAME = 'EventNotificationService',
ADDRESS = 'LOCAL';
GO

