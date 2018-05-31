--SELECT * FROM SalesLT.ProductCategory
USE AdventureWorksLT
	;WITH
		ProductUnion AS(
			SELECT ProductCategoryID, ParentProductCategoryID, Name, rowguid, ModifiedDate 
			FROM SalesLT.ProductCategory
			UNION ALL
			SELECT ProductCategoryID, ParentProductCategoryID, Name, rowguid, ModifiedDate
			FROM SalesLT.ProductCategory
		),
		ProductAll AS(
			SELECT B.ProductCategoryID, B.ParentProductCategoryID, B.Name, B.rowguid, B.ModifiedDate
			FROM ProductUnion A INNER JOIN SalesLT.ProductCategory B ON A.ProductCategoryID = B.ParentProductCategoryID
			),
		SearchProduct AS(
			SELECT Name,ProductNumber, Color 
			FROM SalesLT.Product
			WHERE Name LIKE '%@KeyWord%' OR ProductNumber LIKE '%@KeyWord%' OR Color LIKE '%@KeyWord%'
			),
		SearchDescription AS(
			SELECT Description
			FROM SalesLT.ProductDescription
			WHERE Description LIKE '%@KeyWord%'
			),
		ORDERS AS(
			SELECT SalesOrderDetailID, CustomerID, ProductID
			FROM SalesLT.SalesOrderHeader A LEFT JOIN SalesLT.SalesOrderDetail B ON A.SalesOrderID = B.SalesOrderID
			),
		Clients AS(
			SELECT SalesOrderDetailID, AddressID, AddressType 
			FROM ORDERS O LEFT JOIN SalesLT.CustomerAddress C ON O.CustomerID = C.CustomerID
			),
		Regions AS(
			SELECT SalesOrderDetailID, CountryRegion, StateProvince 
			FROM Clients C JOIN SalesLT.Address A ON C.AddressID = A.AddressID
			),
		GrupCountry AS(
			SELECT CountryRegion, StateProvince, Comenzi = COUNT(1) 
			FROM Regions
			GROUP BY CountryRegion, StateProvince
			),
		ProdID AS(
			SELECT Name, ProductNumber, Color, StandardCost, CustomerID
			FROM ORDERS O LEFT JOIN SalesLT.Product P ON O.ProductID = P.ProductID
			),
		Location AS(
			SELECT Name, ProductNumber, Color, StandardCost, AddressID
			FROM ProdID P LEFT JOIN SalesLT.CustomerAddress C ON P.CustomerID = C.CustomerID
			),
		SetLocation AS(
			SELECT DISTINCT Name, ProductNumber, CountryRegion, StateProvince  
			FROM Location L LEFT JOIN SalesLT.Address A ON L.AddressID = A.AddressID
			),
		GroupProd AS(
			SELECT CountryRegion, StateProvince, ProdUnic = COUNT(1)  
			FROM SetLocation
			GROUP BY CountryRegion, StateProvince
			)
			--ex5
			SELECT * FROM GroupProd
			--SELECT *FROM SetLocation
			--SELECT *FROM Location
			--SELECT  * FROM ProdID
			 
			--ex1
			--SELECT DISTINCT * FROM ProductAll
			--ORDER BY ProductCategoryID
			--EX2
			--SELECT * FROM SearchProduct
			--EX3
			--SELECT *FROM SearchDescription
			--ex4
			--SELECT * FROM GrupCountry 
			--SELECT * FROM Regions
			--SELECT * FROM Clients
			--SELECT * FROM ORDERS