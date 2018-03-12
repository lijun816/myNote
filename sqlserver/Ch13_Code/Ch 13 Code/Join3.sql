--Merge Join
SELECT * INTO New_SalesOrderDetail FROM Sales.SalesOrderDetail
GO
CREATE UNIQUE CLUSTERED INDEX PK_SalesOrderDetail 
ON New_SalesOrderDetail (SalesOrderID, SalesOrderDetailID)
GO
DBCC DROPCLEANBUFFERS
GO
SET STATISTICS IO ON
GO
SELECT oh.SalesOrderID, oh.OrderDate,od.ProductID
FROM New_SalesOrderDetail od
JOIN New_SalesOrderHeader oh
ON oh.SalesOrderID = od.SalesOrderID
SET STATISTICS IO OFF
GO

