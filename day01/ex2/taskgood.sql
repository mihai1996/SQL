;WITH
	JoinTables AS(
		SELECT O.OrderID,  ProductID, CustomerID
		FROM [Order Details] OD JOIN Orders O ON OD.OrderID = O.OrderID
		),

		--SELECT * FROM JoinTables

	ConstantOrders AS(
		SELECT * FROM (VALUES
				(1,999999, 'least one products'),
				(1,1, 'one products'),
				(1,5, '1-5 products'),
				(6,99999, '6+ products')
				) AS Comands(Nrfrom,Nrdo, Produse)
				),
	CustumerDetails AS(
		SELECT CustomerID, CN = COUNT(1)
		FROM JoinTables
		GROUP BY CustomerID 
		),
	ProductsResult AS(
		SELECT Produse,CNproduse = COUNT(CN)
		FROM ConstantOrders A LEFT JOIN CustumerDetails B ON CN BETWEEN Nrfrom and Nrdo
		GROUP BY Produse
		)
		SELECT * FROM ProductsResult

		--SELECT  * FROM CustumerDetails

