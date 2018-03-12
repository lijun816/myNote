USE AdventureWorks2012
GO

SET STATISTICS PROFILE ON
GO
SELECT p.Name AS ProdName, c.TerritoryID, SUM(od.OrderQty)
FROM Sales.SalesOrderDetail od
JOIN Production.Product p
  ON p.ProductID = od.ProductID
JOIN Sales.SalesOrderHeader oh
  ON oh.SalesOrderID = od.SalesOrderID
JOIN Sales.Customer c
  ON c.CustomerID = oh.CustomerID
WHERE oh.OrderDate >= '2004-06-09'
 AND oh.OrderDate <= '2004-06-11'
GROUP BY p.Name, c.TerritoryID
GO

SET STATISTICS PROFILE OFF
GO
