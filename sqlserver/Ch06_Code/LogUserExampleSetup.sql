--This script sets up the sending database for the remote login logging example.  It uses the send logic 
--from this chapter.

CREATE DATABASE LogSendExample
GO
USE LogSendExample
GO
-- Service Broker databases always need a database master key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'YourSecurePassword1!'
GO
-- We're going to go between databases and for simplicity we're not going to set up Service Broker
-- security with certificates so the databases have to be trusted
ALTER DATABASE LogSendExample SET TRUSTWORTHY ON
GO
-- You may not need this but it is required if you're not connected to your domain.  I used SA but and 
-- SQL Server authenticated user will work.
ALTER AUTHORIZATION ON DATABASE::LogSendExample TO SA
GO

-- Create the objects required to establish a conversation with the server

CREATE MESSAGE TYPE LoginMessage
AUTHORIZATION dbo
VALIDATION = NONE
GO

CREATE CONTRACT LoginContract
AUTHORIZATION dbo
(LoginMessage SENT BY ANY)
GO

-- This is the procedure to handle the initiator queue.  In this case the server doesn't send 
-- responses so the only message types we need to handle are error and end conversation.
CREATE PROCEDURE dbo.SendQueueHandler
AS
BEGIN -- SendQueueHandler
	DECLARE  @dialog_handle UNIQUEIDENTIFIER, @messagetype nvarchar(128);
	WHILE (1 = 1)
		BEGIN	
		BEGIN TRY
		BEGIN TRANSACTION;

			RECEIVE TOP (1) @dialog_handle = [conversation_handle], 
				 @messagetype = [message_type_name]
			FROM LoginSendQueue
			IF @@ROWCOUNT = 0 
				BEGIN
					COMMIT TRANSACTION;
					BREAK;
				END
			ELSE IF @messagetype = N'http://schemas.microsoft.com/SQL/ServiceBroker/Error'
				BEGIN
					-- log the error in you application's log
					END CONVERSATION @dialog_handle;
					COMMIT TRANSACTION;
					BREAK;
				END
			ELSE IF @messagetype = N'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog'
				BEGIN
					END CONVERSATION @dialog_handle;
					COMMIT TRANSACTION;
					BREAK;
				END
		END TRY 
		Begin Catch
			Rollback Transaction;
			DECLARE @ErrorMessage NVARCHAR(4000);
			DECLARE @ErrorSeverity INT;
			DECLARE @ErrorState INT;
			DECLARE @ErrorNumber INT;
			DECLARE @ErrorLine INT;
			DECLARE @ErrorProcedure NVARCHAR(128);
			SET		@ErrorLine = ERROR_LINE();
			SET		@ErrorSeverity = ERROR_SEVERITY();
			SET		@ErrorState = ERROR_STATE();
			SET		@ErrorNumber = ERROR_NUMBER();
			SET		@ErrorMessage = ERROR_MESSAGE();
			SET		@ErrorProcedure = ISNULL(ERROR_PROCEDURE(), 'None');
			RAISERROR (99123, @ErrorSeverity, 1 , @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage);
		End Catch;
	END -- WHILE
END -- SendQueueHandler
GO


-- The initiator queue will only receive system messages
CREATE QUEUE LoginSendQueue
WITH STATUS=ON,
     RETENTION=OFF,
     ACTIVATION
         (STATUS=ON,
          PROCEDURE_NAME=dbo.SendQueueHandler,
          MAX_QUEUE_READERS=2,
          EXECUTE AS OWNER),
     POISON_MESSAGE_HANDLING (STATUS = ON);
GO

CREATE SERVICE LoginSendSvc
AUTHORIZATION dbo
ON QUEUE dbo.LoginSendQueue
(LoginContract)
GO

-- This is the table that holds the conversation handle for the conversation that 
-- connects to the server.  Saving it here allows us to reuse it.
CREATE TABLE dbo.SSB_Settings
([Source] sysname NOT NULL,
[Destination] sysname NOT NULL,
[Contract] sysname NOT NULL,
[dialog_handle] uniqueidentifier 
CONSTRAINT PK_SSB_Setting PRIMARY KEY ([Source], [Destination], [Contract]))
GO

-- This is the procedure that sends the login records to the server
CREATE PROCEDURE dbo.SendUserLog
     @Destination sysname,
     @Source sysname,
     @Contract sysname,
     @MessageType sysname,
     @MessageBody varchar(MAX)
AS
DECLARE      @dialog_handle uniqueidentifier

BEGIN TRANSACTION

/*Get the conversation id.*/
SELECT @dialog_handle = dialog_handle
FROM dbo.SSB_Settings 
WHERE [Source] = @Source 
     AND [Destination] = @Destination 
     AND [Contract] = @Contract;
/*If there is no current handle create a new conversation.*/
IF @dialog_handle IS NULL 
BEGIN
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
     /*Save the new conversation ID*/
     UPDATE dbo.SSB_Settings 
          SET dialog_handle = @dialog_handle 
     WHERE [Source] = @Source
          AND [Destination] = @Destination 
          AND [Contract] = @Contract;
	 -- If the update didn't find the record we need, insert it.
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

COMMIT TRANSACTION
GO
