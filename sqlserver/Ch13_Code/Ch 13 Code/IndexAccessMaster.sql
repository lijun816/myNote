-- drop table dbo.New_SalesOrderHeader

--Make a copy of the table Sales.SalesOrderHeader so that we
--can peform all the following operation on the new table
--called New_SalesOrderHeader.

SELECT * INTO dbo.New_SalesOrderHeader
FROM Sales.SalesOrderHeader

-----------------------------------------------------
--- Table Scan.
SET STATISTICS PROFILE ON
GO
SELECT SalesOrderID, OrderDate, CustomerID
FROM dbo.New_SalesOrderHeader
GO
SET STATISTICS PROFILE OFF
GO

DBCC DROPCLEANBUFFERS
GO
SET STATISTICS IO ON
GO
SELECT SalesOrderID, OrderDate, CustomerID
FROM dbo.New_SalesOrderHeader
GO
SET STATISTICS IO OFF

SELECT dpages, *
FROM sys.sysindexes
WHERE ID = OBJECT_ID('New_SalesOrderHeader')
-----------------------------------------------------
--Clustered Index Scan (Unordered)
CREATE CLUSTERED INDEX IXCU_SalesOrderID ON New_SalesOrderHeader(SalesOrderID)

DBCC DROPCLEANBUFFERS
GO
SET STATISTICS IO ON
GO
SELECT SalesOrderID,RevisionNumber, OrderDate, DueDate  
FROM New_SalesOrderHeader
GO
SET STATISTICS IO OFF

-----------------------------------------------------
--NON-Clustered Index Scan (Unordered)
CREATE NONCLUSTERED INDEX IXNC_SalesOrderID ON New_SalesOrderHeader(OrderDate) 
INCLUDE(RevisionNumber, DueDate)
GO
DBCC DROPCLEANBUFFERS
GO
SET STATISTICS IO ON
GO
SELECT SalesOrderID,RevisionNumber, OrderDate, DueDate  
FROM New_SalesOrderHeader
GO
SET STATISTICS IO OFF

-----------------------------------------------------
--Clustered Index Scan (Ordered)
DBCC DROPCLEANBUFFERS
GO
SET STATISTICS IO ON
GO
SELECT SalesOrderID,RevisionNumber, OrderDate, DueDate  
FROM New_SalesOrderHeader
ORDER BY SalesOrderID
GO
SET STATISTICS IO OFF

-----------------------------------------------------
--NON-Clustered Index Scan (Ordered)
DBCC DROPCLEANBUFFERS
GO
SET STATISTICS IO ON
GO
SELECT SalesOrderID,RevisionNumber, OrderDate, DueDate  
FROM New_SalesOrderHeader
ORDER BY OrderDate
GO
SET STATISTICS IO OFF

-----------------------------------------------------
--Non-Clustered Index Seek with Ordered Partial Scan and Lookups

DROP INDEX New_SalesOrderHeader.IXCU_SalesOrderID
GO
DBCC DROPCLEANBUFFERS
GO
SET STATISTICS IO ON
GO
SELECT SalesOrderID,RevisionNumber, OrderDate, DueDate, SalesOrderNumber
FROM New_SalesOrderHeader
WHERE OrderDate BETWEEN '2007-10-08 00:00:00.000' AND '2007-10-10 00:00:00.000'
GO
SET STATISTICS IO OFF

----------
CREATE CLUSTERED INDEX IXCU_SalesOrderID ON New_SalesOrderHeader(SalesOrderID)
GO
DBCC DROPCLEANBUFFERS
GO
SET STATISTICS IO ON
GO
SELECT SalesOrderID,RevisionNumber, OrderDate, DueDate, SalesOrderNumber
FROM New_SalesOrderHeader
WHERE OrderDate BETWEEN '2007-10-08 00:00:00.000' AND '2007-10-10 00:00:00.000'
GO
SET STATISTICS IO OFF

-----------------------------------------------------
--Clustered Index Seek with Ordered Partial Scan

DBCC DROPCLEANBUFFERS
GO
SET STATISTICS IO ON
GO
SELECT SalesOrderID,RevisionNumber, OrderDate, DueDate, SalesOrderNumber
FROM New_SalesOrderHeader
WHERE SalesOrderID BETWEEN 43696 AND 45734
GO
SET STATISTICS IO OFF

--Finding the depth of an index.
SELECT INDEXPROPERTY (OBJECT_ID('New_SalesOrderHeader'), 'IXCU_SalesOrderID', 'IndexDepth') 

--add below index to change the plan and see the statistics IO information.

CREATE NONCLUSTERED INDEX IXNC_SalesOrderID_2 ON New_SalesOrderHeader(SalesOrderID, OrderDate) 
INCLUDE(RevisionNumber, DueDate, SalesOrderNumber)

--drop above index after you done the exercise.
DROP INDEX New_SalesOrderHeader.IXNC_SalesOrderID_2
-----------------------------------------------------
--find out index fragmentation for table New_SalesOrderHeader

SELECT *
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID('dbo.New_SalesOrderHeader'), NULL, NULL, NULL)

-------------------------------------------------------
--Rebuilding the index online
ALTER INDEX IXNC_SalesOrderID ON dbo.New_SalesOrderHeader REBUILD WITH (ONLINE = ON)
--------------------------------------------------------

--DELETE PLAN (per-row plan)
DELETE FROM New_SalesOrderHeader
WHERE OrderDate = '2007-07-01 00:00:00.000'

---DELETE PLAN (per-index plan)
DELETE FROM Sales.SalesOrderHeader
WHERE OrderDate < '2006-07-01 00:00:00.000'
--------------------------------------------------------
