--Hash Match
 
DBCC DROPCLEANBUFFERS
GO
SET STATISTICS IO ON
GO

 SELECT p.Name As ProductName, ps.Name As ProductSubcategoryName
 FROM Production.Product p
 JOIN Production.ProductSubcategory ps
   ON p.ProductSubcategoryID = ps.ProductSubcategoryID
 ORDER BY p.Name,  ps.Name

SET STATISTICS IO OFF
GO
