DROP INDEX New_SalesOrderHeader.IXCU_SalesOrderID
GO
DBCC DROPCLEANBUFFERS
GO
SET STATISTICS IO ON
GO
SELECT SalesOrderID,RevisionNumber, OrderDate, DueDate
FROM New_SalesOrderHeader
WHERE OrderDate BETWEEN �2007-10-08 00:00:00.000� AND �2007-10-10 00:00:00.000�
GO
SET STATISTICS IO OFF
