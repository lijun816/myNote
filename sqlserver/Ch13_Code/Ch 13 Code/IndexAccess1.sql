DBCC DROPCLEANBUFFERS
GO
SET STATISTICS IO ON
GO
SET STATISTICS PROFILE ON
GO
SELECT SalesOrderID, OrderDate, CustomerID
FROM dbo.New_SalesOrderHeader
GO
SET STATISTICS IO OFF
GO
SET STATISTICS PROFILE OFF
GO
