-- This script creates the Service Broker objects and stored procedure required to 
-- 

CREATE DATABASE LogReceiveExample
GO
USE LogReceiveExample
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'YourSecurePassword1!'
GO
ALTER DATABASE LogReceiveExample SET TRUSTWORTHY ON
GO
-- You may not need to do this.  I do it so I can run the example on a laptop that's
-- not connected to a doamin.  The other alternative would be to create the databases
-- as a SQL Server authenticated user instead of as a Windows authenticated user.
-- If you are running this on a server connected to a domain, then this isn't required.
ALTER AUTHORIZATION ON DATABASE::LogReceiveExample TO SA
GO

-- Create the Service Broker obects that define the conversation
CREATE MESSAGE TYPE LoginMessage
AUTHORIZATION dbo
VALIDATION = NONE
GO

CREATE CONTRACT LoginContract
AUTHORIZATION dbo
(LoginMessage SENT BY ANY)
GO

-- This is the table that stores the records sent from the client
CREATE TABLE dbo.LoginRecords
(LoginEntry varchar(MAX))
GO

CREATE PROCEDURE dbo.ReceiveQueueHandler
AS 
RETURN;
GO

ALTER PROCEDURE dbo.ReceiveQueueHandler
AS
BEGIN -- ReceiveQueueHandler
	DECLARE  @dialog_handle UNIQUEIDENTIFIER, @messagetype nvarchar(128);
	-- Create a table variable to hold received messages
	DECLARE @LoginMessage TABLE (
	[conversation_handle] uniqueidentifier,
	message_type_name nvarchar(128),
	[message_body] varchar(MAX)
	)
	-- Main receive loop
	WHILE (1 = 1)
		BEGIN	
		BEGIN TRY
			BEGIN TRANSACTION;

			WAITFOR (
				RECEIVE TOP (1000) -- Receiving many messages at a time is more efficient
					[conversation_handle], 
					[message_type_name],
					CAST(message_body AS varchar(MAX)) AS LoginEntry
				FROM LoginReceiveQueue
				INTO @LoginMessage
			), TIMEOUT 100;
			-- If no messages received, bail out
			IF @@ROWCOUNT = 0 
				BEGIN
					COMMIT TRANSACTION;
					BREAK;
				END
			ELSE 
				BEGIN
					-- Check to see if system messages were received
					SELECT TOP (1) @dialog_handle = [conversation_handle], 
						 @messagetype = [message_type_name]
					FROM @LoginMessage
					WHERE [message_type_name] IN 
					(N'http://schemas.microsoft.com/SQL/ServiceBroker/Error', 
					N'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog')
					-- Handle system messages
					IF @@ROWCOUNT > 0
					BEGIN 
						IF @messagetype = N'http://schemas.microsoft.com/SQL/ServiceBroker/Error'
							BEGIN
								-- log the error in you application's log
								END CONVERSATION @dialog_handle;
							END
						ELSE IF @messagetype = N'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog'
							BEGIN
								END CONVERSATION @dialog_handle;
							END
						END
					END
					-- Insert the received records into the log table
					INSERT INTO dbo.LoginRecords
					SELECT [message_body] AS LoginEntry FROM @LoginMessage
						
					COMMIT TRANSACTION
				
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
			RAISERROR (99124, @ErrorSeverity, 1 , @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage);
		End Catch;
	END -- WHILE
END -- ReceiveQueueHandler
GO


CREATE QUEUE LoginReceiveQueue
WITH STATUS=ON,
     RETENTION=OFF,
     ACTIVATION
         (STATUS=ON,
          PROCEDURE_NAME=dbo.ReceiveQueueHandler,
          MAX_QUEUE_READERS=10,
          EXECUTE AS OWNER),
     POISON_MESSAGE_HANDLING (STATUS = ON);
GO

CREATE SERVICE LoginReceiveSvc
AUTHORIZATION dbo
ON QUEUE dbo.LoginReceiveQueue
(LoginContract)
GO

-- SELECT * FROM LoginReceiveQueue



