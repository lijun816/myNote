-- Make sure we are in the Publisher database
Use NorthAmerica;
Go
-- Create the new Sales schema
Create Schema Sales;
Go
-- Create the Cars table
CREATE TABLE Sales.Cars
(ProdID INT PRIMARY KEY,
ProdDesc varchar(35),
Country varchar(7),
Region varchar(24),
LastUpdate smalldatetime
);
Go
-- Insert rows into the Cars table
insert Sales.Cars (prodid, proddesc, country, region, lastupdate)
values (1, 'ProEfficient Sedan', 'US', 'NorthAmerica', getdate());
insert Sales.Cars (prodid, proddesc, country, region, lastupdate)
values (2, 'ProEfficient Van', 'US', 'NorthAmerica', getdate());
insert Sales.Cars (prodid, proddesc, country, region, lastupdate)
values (3, 'JieNeng Crossover', 'China', 'Asia', getdate());
insert Sales.Cars (prodid, proddesc, country, region, lastupdate)
values (4, 'Jieneng Utility', 'China', 'Asia', getdate());
insert Sales.Cars (prodid, proddesc, country, region, lastupdate)
values (5, 'EuroEfficient Wagon', 'Sweden', 'Europe', getdate());
insert Sales.Cars (prodid, proddesc, country, region, lastupdate)
values (6, 'EuroEfficient Pickup', 'Sweden', 'Europe', getdate());
go
