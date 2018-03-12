-------------------------
IF OBJECT_ID('Stocks') IS NOT NULL
DROP TABLE Stocks
GO

CREATE TABLE Stocks
(
 Symbol varchar(10) NOT NULL 
,Quantity int NOT NULL CHECK(Quantity > 0) 
)

CREATE UNIQUE CLUSTERED INDEX IXU_Stocks ON Stocks(Symbol)
-------------------------
IF OBJECT_ID('Trades') IS NOT NULL
DROP TABLE Trades
GO

CREATE TABLE Trades
(
 Symbol varchar(10) NOT NULL 
,DeltaQuantity int NOT NULL
)

CREATE UNIQUE CLUSTERED INDEX IXU_Trades ON Trades(Symbol)
-------------------------
INSERT Stocks VALUES('MSFT', 20), ('GOOG', 5);
INSERT Trades VALUES('MSFT', 10), ('GOOG', -5), ('INTEL', 8);
-------------------------
MERGE Stocks s
USING Trades t
  ON s.Symbol = t.Symbol
WHEN MATCHED AND (s.Quantity + t.DeltaQuantity = 0) THEN
   DELETE -- delete stock if entirely sold
WHEN MATCHED THEN
-- delete takes precedence on update
   UPDATE SET s.Quantity = s.Quantity + t.DeltaQuantity
WHEN NOT MATCHED THEN
   INSERT VALUES (t.Symbol, t.DeltaQuantity)
OUTPUT $action,  inserted.Symbol AS NewSymbol, deleted.Symbol AS DeletedSymbol;

-------------------------
SELECT * FROM Stocks
SELECT * FROM Trades
-------------------------