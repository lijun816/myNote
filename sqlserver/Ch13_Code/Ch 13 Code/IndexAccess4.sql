CREATE NONCLUSTERED INDEX IXNC_SalesOrderID ON New_SalesOrderHeader(OrderDate)
INCLUDE(RevisionNumber, DueDate)
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
