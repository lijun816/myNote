USE AdventureWorks2012
GO
IF OBJECT_ID('dbo.TestCacheReUse') IS NOT NULL
   DROP PROC dbo.TestCacheReUse
GO
CREATE PROC dbo.TestCacheReUse
AS

SELECT BusinessEntityID, LoginID, JobTitle
FROM HumanResources.Employee
WHERE BusinessEntityID = 109
GO

USE AdventureWorks2012
GO
EXEC dbo.TestCacheReUse
