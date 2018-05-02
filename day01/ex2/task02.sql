/*1. Creez un tabel in care sunt stocate datele privind vinzari de buniri
	catre anumiti clienti
2. Raportul clientilor care au efectuat cumparaturi:
		1. macar un prdus macar odata
		2. numai un singur produs
		3. 1,5 produse
		4. 6 ori mai multe produse
*/

	;WITH 
		ConstantOrder AS (
			SELECT * FROM (VALUES
				(1,999999, 'least one order'),
				(1,1, 'one order'),
				(1,5, '1-5 orders'),
				(6,99999, '6+ orders')
				) AS Comands(Nrfrom,Nrdo, Orders)
				),
				--Numarul de tranzactii efectuate de clienti
		CustomerDetails AS(
			SELECT CustomerID, CN = COUNT(1) FROM Orders
			GROUP BY CustomerID
			),
		OrderResult AS(
			SELECT Orders, Counts = SUM(CN)  
			FROM ConstantOrder A LEFT JOIN CustomerDetails B ON CN BETWEEN Nrdo AND Nrdo
			GROUP BY Orders
			),
		ShowResult AS(
			SELECT Orders, Counts = ISNULL(Counts, 0) FROM OrderResult
			)
			SELECT * FROM ShowResult
			--SELECT * FROM OrderResult
			--SELECT *FROM ConstantOrder
			--SELECT *FROM CustomerDetails