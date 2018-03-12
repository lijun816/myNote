CREATE ASSEMBLY myfirstsqlclr
FROM 'c:\temp\myfirstsqlclr.dll'
WITH PERMISSION_SET = SAFE
go

CREATE PROCEDURE DoIt
@i nchar(50) OUTPUT
AS
EXTERNAL NAME myfirstsqlclr.FirstSQLCLRProc.FirstSQLCLR
go


DECLARE @var nchar(50)
EXEC DoIt @var out
PRINT @var
go