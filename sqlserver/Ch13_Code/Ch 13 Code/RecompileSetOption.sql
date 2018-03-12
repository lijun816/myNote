USE AdventureWorks2012
GO

IF OBJECT_ID('dbo.RecompileSetOption') IS NOT NULL
   DROP PROC dbo.RecompileSetOption
GO

CREATE PROC dbo.RecompileSetOption
AS
SET ANSI_NULLS OFF

SELECT s.CustomerID, COUNT(s.SalesOrderID)
FROM Sales.SalesOrderHeader s
GROUP BY s.CustomerID
HAVING COUNT(s.SalesOrderID) > 8
GO


EXEC dbo.RecompileSetOption
