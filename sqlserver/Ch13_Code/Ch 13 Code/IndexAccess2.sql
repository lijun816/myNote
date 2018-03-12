CREATE CLUSTERED INDEX IXCU_SalesOrderID ON New_SalesOrderHeader(SalesOrderID)
GO
DBCC DROPCLEANBUFFERS
GO
SET STATISTICS IO ON
GO
SELECT SalesOrderID, RevisionNumber, OrderDate, DueDate 
FROM New_SalesOrderHeader
GO
SET STATISTICS IO OFF
GO
