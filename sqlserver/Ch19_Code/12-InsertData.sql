USE TestMirroring
GO

 
IF OBJECT_ID('address') IS NULL
CREATE TABLE dbo.Address
(
 AddressID int  NOT NULL
,AddressLine1 nvarchar(60) NOT NULL
,AddressLine2 nvarchar(60) NULL
,City nvarchar(30) NOT NULL
,StateProvinceID int NOT NULL
,PostalCode nvarchar(15) NOT NULL
,rowguid uniqueidentifier ROWGUIDCOL  NOT NULL CONSTRAINT DF_Address_rowguid  DEFAULT (newid())
,ModifiedDate datetime NOT NULL CONSTRAINT DF_Address_ModifiedDate  DEFAULT (getdate())
)

INSERT INTO dbo.address
(
 AddressID 
,AddressLine1 
,AddressLine2
,City 
,StateProvinceID  
,PostalCode  
,rowguid  
,ModifiedDate
)
SELECT 
 AddressID 
,AddressLine1 
,AddressLine2
,City 
,StateProvinceID  
,PostalCode  
,rowguid  
,ModifiedDate
FROM AdventureWorks.person.address
 