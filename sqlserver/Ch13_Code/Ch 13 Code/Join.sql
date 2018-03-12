--Nested Loop Join
 
DBCC DROPCLEANBUFFERS
GO
SET STATISTICS IO ON
GO
 SELECT C.CustomerID, c.TerritoryID
 FROM Sales.SalesOrderHeader oh
 JOIN Sales.Customer c
   ON c.CustomerID = oh.CustomerID
 WHERE c.CustomerID IN (11000,11002)
 GROUP BY C.CustomerID, c.TerritoryID
GO
SET STATISTICS IO OFF
GO
