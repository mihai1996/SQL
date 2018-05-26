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
			SELECT SalesOrderDetailID, CustomerID
			FROM SalesLT.SalesOrderHeader A LEFT JOIN SalesLT.SalesOrderDetail B ON A.SalesOrderID = B.SalesOrderID
			),
		Clients AS(
			SELECT SalesOrderDetailID, AddressID, AddressType 
			FROM ORDERS O LEFT JOIN SalesLT.CustomerAddress C ON O.CustomerID = C.CustomerID
			),
		Regions AS(
			SELECT SalesOrderDetailID, CountryRegion, StateProvince 
			FROM Clients C LEFT JOIN SalesLT.Address A ON C.AddressID = A.AddressID
			),
		GrupCountry AS(
			SELECT CountryRegion, StateProvince, CN = COUNT(1) 
			FROM Regions
			GROUP BY CountryRegion, StateProvince
			)
			--ex4
			SELECT * FROM GrupCountry 
			--SELECT * FROM Regions
			--SELECT * FROM Clients
			--SELECT * FROM ORDERS
			--ex1
			--SELECT DISTINCT * FROM ProductAll
			--ORDER BY ProductCategoryID
			--EX2
			--SELECT * FROM SearchProduct
			--EX3
			--SELECT *FROM SearchDescription