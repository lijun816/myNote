CREATE TABLE dbo.Employee
(EmployeeId INT IDENTITY(1,1) PRIMARY KEY,
LastName varchar(100),
FirstName varchar(100),
Emailaddress varchar(255),
ManagerId INT,
Username varchar(100))
GO
INSERT INTO dbo.Employee
(LastName, FirstName, EmailAddress, ManagerId, UserName)
VALUES
('Smith', 'John', 'jsmith@contonso.com', 0, 'CONTOSO\jsmith'), 
     ('Gates', 'Fred', 'fgates@contonso.com', 1, 'CONTOSO\fgates'), 
     ('Jones', 'Bob', 'bjones@contonso.com', 1, 'CONTOSO\bjones'), 
     ('Erickson', 'Paula', 'perickson@contonso.com', 1, 'CONTOSO\perickson')
GO
CREATE VIEW dbo.EmployeeView
AS
SELECT *
FROM dbo.Employee
WHERE ManagerId = (SELECT EmployeeId FROM Employee WHERE UserName = suser_sname())
GO
