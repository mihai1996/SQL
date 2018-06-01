USE AdventureWorksLT
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TranProd]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[TranProd] AS' 
END
GO
ALTER PROCEDURE dbo.TranProd
@CountryRegion varchar(50),
@StateProvince varchar(50)
AS
BEGIN

;WITH
	ORDERS AS(
		SELECT SalesOrderDetailID, CustomerID, ProductID
		FROM SalesLT.SalesOrderHeader A LEFT JOIN 
		SalesLT.SalesOrderDetail B ON A.SalesOrderID = B.SalesOrderID
		),
	ProdID AS(
		SELECT Name, ProductNumber, Color, StandardCost, CustomerID
		FROM ORDERS O LEFT JOIN SalesLT.Product P ON O.ProductID = P.ProductID
		),
	Location AS(
		SELECT Name, ProductNumber, Color, StandardCost, AddressID
		FROM ProdID P LEFT JOIN SalesLT.CustomerAddress C ON P.CustomerID = C.CustomerID
		),
	AllProdTrans AS(
		SELECT Name, ProductNumber, CountryRegion, StateProvince  
		FROM Location L LEFT JOIN SalesLT.Address A ON L.AddressID = A.AddressID
		),
	Difernece AS(
		SELECT Name FROM SalesLT.Product
		WHERE Name NOT IN (SELECT Name FROM AllProdTrans 
		WHERE CountryRegion = @CountryRegion OR StateProvince = @StateProvince)
		)
		SELECT DISTINCT *FROM Difernece
		--SELECT DISTINCT  *FROM GetState
		--SELECT *FROM AllProdTrans
		--SELECT *FROM Location
		--SELECT *FROM ProdID
		--SELECT * FROM ORDERS
END 

EXEC dbo.TranProd @CountryRegion = 'United Kingdom', @StateProvince = 'England'
EXEC dbo.TranProd @CountryRegion = 'United States', @StateProvince = 'California'
EXEC dbo.TranProd @CountryRegion = 'United States', @StateProvince = 'Utah'
EXEC dbo.TranProd @CountryRegion = 'United States', @StateProvince = 'New Mexico'