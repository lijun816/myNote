-- Make sure we are in the Publisher database
Use Publisher
Go
-- Create the new Sales schema
Create Schema Sales
Go
-- Create the Cars table
CREATE TABLE Sales.Cars
(ProdID INT PRIMARY KEY,
ProdDesc varchar(35),
Country varchar(7),
LastUpdate smalldatetime
)
Go
-- Insert rows into the Cars table
insert Sales.Cars (prodid, proddesc, country, lastupdate)
values (1, 'ProEfficient Sedan', 'US', getdate())
insert Sales.Cars (prodid, proddesc, country, lastupdate)
values (2, 'ProEfficient Van', 'US', getdate())
insert Sales.Cars (prodid, proddesc, country, lastupdate)
values (3, 'JieNeng Crossover', 'China', getdate())
insert Sales.Cars (prodid, proddesc, country, lastupdate)
values (4, 'Jieneng Utility', 'China', getdate())
insert Sales.Cars (prodid, proddesc, country, lastupdate)
values (5, 'EuroEfficient Wagon', 'Sweden', getdate())
insert Sales.Cars (prodid, proddesc, country, lastupdate)
values (6, 'EuroEfficient Pickup', 'Sweden', getdate())