
USE LogSendExample
GO

--Execute this script to test the login record process.  In practice the procedure would be called from the
--security server

DECLARE @msg varchar(MAX)
SET @msg = 'Sam Smith - ' + CONVERT (varchar(100), GetDate(),109)


EXEC dbo.SendUserLog
     @Destination = 'LoginReceiveSvc',
     @Source = 'LoginSendSvc',
     @Contract = 'LoginContract',
     @MessageType = 'LoginMessage',
     @MessageBody = @msg
     
-- See if it worked    
-- SELECT * FROM LogReceiveExample.dbo.LoginRecords     


 
     
