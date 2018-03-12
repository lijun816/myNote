
-------------------------------------------------------------------------------------------------------------
---- Listing 6.1
-------------------------------------------------------------------------------------------------------------
---------------------------Chapter 6 Sample Code ------------------------------------------------------------


-- Enable the Service Broker so the rest of the code will work
--------------------------------------------------------------
USE Master
GO

ALTER DATABASE sample_database
SET ENABLE_BROKER
GO

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------Create Service Broker objects
-------------------------------------------------------------------------------------------------------------
USE Sample_Database
GO



-- Create two sample message type objects
-----------------------------------------
CREATE MESSAGE TYPE YourMessageType
AUTHORIZATION dbo
VALIDATION = WELL_FORMED_XML

CREATE MESSAGE TYPE AnotherMessageType
AUTHORIZATION dbo
VALIDATION = NONE


-- Create contracts to define dialog conversations
--------------------------------------------------
CREATE CONTRACT MyContract1
AUTHORIZATION dbo
(YourMessageType SENT BY ANY)

CREATE CONTRACT MyHighPriority
AUTHORIZATION dbo
(YourMessageType SENT BY ANY)

CREATE CONTRACT MyContract2
AUTHORIZATION dbo
(YourMessageType SENT BY INITIATOR,
AnotherMessageType SENT BY TARGET)
GO

-- Dummy procedure to make the example work
-------------------------------------------
CREATE PROCEDURE dbo.MySourceActivationProcedure AS RETURN 0;
GO
-- Create a queue object to receive messages.  Messages are stored in the queue so make sure there is 
-- space available
------------------------------------------------------------------------------------------------------
CREATE QUEUE YourQueue_Source
WITH STATUS=ON,
     RETENTION=OFF,
     ACTIVATION
         (STATUS=ON,
          PROCEDURE_NAME=dbo.MySourceActivationProcedure,
          MAX_QUEUE_READERS=30,
          EXECUTE AS OWNER),
     POISON_MESSAGE_HANDLING (STATUS = ON);


	 CREATE QUEUE MyDestinationQueue
WITH STATUS=ON,
     RETENTION=OFF,
     ACTIVATION
         (STATUS=ON,
          PROCEDURE_NAME=dbo.MySourceActivationProcedure,
          MAX_QUEUE_READERS=30,
          EXECUTE AS OWNER),
     POISON_MESSAGE_HANDLING (STATUS = ON);


-- Create a Service object to define the Service Broker service.  The service will be addressed by the 
-- service name.
-------------------------------------------------------------------------------------------------------
CREATE SERVICE YourService_Source
AUTHORIZATION dbo
ON QUEUE dbo.YourQueue_Source
(MyContract1)
GO

CREATE SERVICE MyDestinationService
AUTHORIZATION dbo
ON QUEUE dbo.MyDestinationQueue
(MyContract1)
GO

-- Create a route to be used to route messages from a remote database to this service.  The addresses are
-- made up and must be replaced with real addresses
----------------------------------------------------------------------------------------------------------
CREATE ROUTE ExpenseRoute
    WITH SERVICE_NAME = 'MyService',
    BROKER_INSTANCE = '53FA2363-BF93-4EB6-A32D-F672339E08ED',
    ADDRESS = 'TCP://sql2:1234',
    MIRROR_ADDRESS = 'TCP://sql4:4567' ;


-- Create a Priority object.  A seperate priority object must be created for each priority
------------------------------------------------------------------------------------------
CREATE BROKER PRIORITY HighPriority
FOR CONVERSATION
SET ( CONTRACT_NAME = MyHighPriority ,
      LOCAL_SERVICE_NAME = ANY ,
      REMOTE_SERVICE_NAME = N'ANY' ,
      PRIORITY_LEVEL = 8
)

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------


-- Get the next conversation group that has messages available from the queue
-----------------------------------------------------------------------------
DECLARE @conversation_group_id AS UNIQUEIDENTIFIER;
GET CONVERSATION GROUP @conversation_group_id
FROM YourQueue_Source;


-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-- Sending Messages with Service Broker


-- Send a message
-----------------
DECLARE @message_body AS XML, @dialog_handle as UNIQUEIDENTIFIER
SET @message_body = (SELECT * 
     FROM sys.all_objects as object 
     FOR XML AUTO, root('root'))  --- Create an XML document to use as a message body

BEGIN DIALOG CONVERSATION @dialog_handle
     FROM SERVICE [YourService_Source]
     TO SERVICE 'YourDestinationService' -- TO SERVICE must be a string and is case sensitive
     ON CONTRACT [MyContract2];

SEND ON CONVERSATION @dialog_handle
MESSAGE TYPE YourMessageType
(@message_body)
GO



-- Create a table to hold conversation handles for the example application
--------------------------------------------------------------------------
CREATE TABLE dbo.SSB_Settings
([Source] sysname NOT NULL,
[Destination] sysname NOT NULL,
[Contract] sysname NOT NULL,
[dialog_handle] uniqueidentifier
CONSTRAINT PK_SSB_Setting PRIMARY KEY ([Source], [Destination], [Contract])
)
GO

CREATE PROCEDURE dbo.CreateConversation
     @Destination sysname,
     @Source sysname,
     @Contract sysname,
     @MessageType sysname,
     @MessageBody XML,
     @dialog_handle uniqueidentifier
AS
/*Get the conversation id.*/
SELECT @dialog_handle = dialog_handle
FROM dbo.SSB_Settings 
WHERE [Source] = @Source 
     AND [Destination] = @Destination 
     AND [Contract] = @Contract;

/*If there is no current handle, create a new conversation.*/
IF @dialog_handle IS NULL 
BEGIN
     BEGIN TRANSACTION
     /*If there is a conversation dialog handle signal the destination 
     code that the old conversation is dead.*/
     IF @dialog_handle IS NOT NULL
     BEGIN
          UPDATE dbo.SSB_Settings 
          SET dialog_handle = NULL
          WHERE [Source] = @Source
               AND [Destination] = @Destination 
               AND [Contract] = @Contract;
          SEND ON CONVERSATION @dialog_handle
          MESSAGE TYPE EndOfConversation;
     END

     /*Setup the new conversation*/
     BEGIN DIALOG CONVERSATION @dialog_handle
     FROM SERVICE @Source
     TO SERVICE @Destination
     ON CONTRACT @Contract;

     /*Log the new conversation ID*/
     UPDATE dbo.SSB_Settings 
          SET dialog_handle = @dialog_handle 
     WHERE [Source] = @Source
          AND [Destination] = @Destination 
          AND [Contract] = @Contract;

     IF @@ROWCOUNT = 0
          INSERT INTO dbo.SSB_Settings 
           ([Source], [Destination], [Contract], [dialog_handle])
          VALUES
           (@Source, @Destination, @Contract, @dialog_handle);
END;

/*Send the message*/
SEND ON CONVERSATION @dialog_handle
MESSAGE TYPE @MessageType
(@MessageBody);
/*Verify that the conversation handle is still the one logged in the table. 
  If not then mark this conversation as done.*/
IF (SELECT dialog_handle 
    FROM dbo.SSB_Settings  
    WHERE [Source] = @Source 
        AND [Destination] = @Destination 
        AND [Contract] = @Contract) <> @dialog_handle 
    SEND ON CONVERSATION @dialog_handle
        MESSAGE TYPE EndOfConversation;
GO


-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-- Receiving messages
---------------------
DECLARE @dialog_handle UNIQUEIDENTIFIER, @messagetype nvarchar(128), @message_body XML;

BEGIN TRANSACTION;
RECEIVE TOP (1) @dialog_handle = conversation_handle, @messagetype = [message_type_name],
     @message_body = CAST(message_body as XML)
FROM MyDestinationQueue
IF @@ROWCOUNT = 0 
	BEGIN
		COMMIT TRANSACTION;
	END
ELSE IF @messagetype = N'http://schemas.microsoft.com/SQL/ServiceBroker/Error'
	BEGIN
		-- log the error in you application's log
		END CONVERSATION @dialog_handle;
		COMMIT TRANSACTION;
	END
ELSE IF @messagetype = N'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog'
	BEGIN
		END CONVERSATION @dialog_handle;
		COMMIT TRANSACTION;
	END
ELSE
	BEGIN
/*Do whatever needs to be done with your XML document*/
		COMMIT TRANSACTION;
	END
GO

-- Receiving multiple messages per receive command to improve efficiency
------------------------------------------------------------------------
DECLARE @dialog_handle UNIQUEIDENTIFIER, @message_body XML, @message_type nvarchar(128)
DECLARE @Messages TABLE
(conversation_handle uniqueidentifier,
message_type sysname,
message_body VARBINARY(MAX))
BEGIN TRANSACTION
WAITFOR (
	RECEIVE TOP (1000) conversation_handle, message_type_name, message_body
	FROM MyDestinationQueue
	INTO @Messages), TIMEOUT 5000;
	DECLARE cur CURSOR FOR select conversation_handle, message_type, CAST(message_body AS XML) 
                       FROM @Messages 
                       WHERE message_body IS NOT NULL
OPEN cur
FETCH NEXT FROM cur INTO @dialog_handle, @message_type, @message_body
WHILE @@FETCH_STATUS = 0
BEGIN
IF @message_type = N'http://schemas.microsoft.com/SQL/ServiceBroker/Error'
	BEGIN
		-- log the error in you application's log
		END CONVERSATION @dialog_handle;
	END
ELSE IF @message_type = N'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog'
	BEGIN
		END CONVERSATION @dialog_handle;
	END
ELSE
	BEGIN
/*Do whatever needs to be done with your XML document*/
		SELECT @message_body
	END
    FETCH NEXT FROM cur INTO @dialog_handle, @message_body
END
CLOSE cur
DEALLOCATE cur;
IF EXISTS (SELECT * FROM @Messages WHERE message_type = 'EndOfConversation')
     END CONVERSATION @dialog_handle
COMMIT TRANSACTION
GO


-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
--Configure Service Broker for remote access

USE master
GO
-- Service Broker security requires databases have a master key
---------------------------------------------------------------
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'YourSecurePassword1!'


-- Create a certificate to identify each endpoint
-------------------------------------------------
CREATE CERTIFICATE MyServiceBrokerCertificate
WITH SUBJECT = 'Service Broker Certificate', 
     START_DATE = '1/1/2014',
     EXPIRY_DATE = '12/31/2099'

-- Backup the public kay part of the certificate to transfer it to the other endpoint
BACKUP CERTIFICATE MyServiceBrokerCertificate 
     TO FILE='C:\MyServiceBrokerCertificate.cer'

-- Import the certificate into the remote server
------------------------------------------------
CREATE CERTIFICATE MyServiceBrokerCertificate
FROM FILE='c:\MyServiceBrokerCertificate.cer'


USE master
GO 
-- Create a Service Broker endpoint for the server
--------------------------------------------------
CREATE ENDPOINT ServiceBrokerEndpoint
STATE = STARTED
AS TCP (LISTENER_PORT = 1234, LISTENER_IP=ALL)
FOR SERVICE_BROKER
(AUTHENTICATION = CERTIFICATE MyServiceBrokerCertificate, 
     ENCRYPTION = REQUIRED ALGORITHM AES);
GO



-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-- Create a queue and event for use by external activation
----------------------------------------------------------
USE Sample_Database

CREATE QUEUE dbo.MyDestinationQueueEA
GO

CREATE SERVICE MyDestinationServiceEA
ON QUEUE dbo.MyDestinationQueueEA
(
    [http://schemas.microsoft.com/SQL/Notifications/PostEventNotification]
)
GO

CREATE EVENT NOTIFICATION MyDestinationNotificationEA
ON QUEUE MyDestinationQueue
FOR QUEUE_ACTIVATION
TO SERVICE 'MyDestinationServiceEA', 'current database'
GO










