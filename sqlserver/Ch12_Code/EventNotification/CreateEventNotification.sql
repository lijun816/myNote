USE StoreEvent
GO
CREATE EVENT NOTIFICATION CreateTableNotification
ON DATABASE
FOR CREATE_TABLE
TO SERVICE 'EventNotificationService', 'current database' ;