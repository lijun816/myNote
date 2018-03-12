USE AdventureWorks2012
GO
SET SHOWPLAN_XML ON
GO
SELECT sh.CustomerID, st.Name, SUM(sh.SubTotal) AS SubTotal
FROM Sales.SalesOrderHeader sh
JOIN Sales.Customer c
  ON c.CustomerID = sh.CustomerID
JOIN Sales.SalesTerritory st
  ON st.TerritoryID = c.TerritoryID
GROUP BY sh.CustomerID, st.Name
HAVING SUM(sh.SubTotal) > 2000.00
GO
SET SHOWPLAN_XML OFF
GO
