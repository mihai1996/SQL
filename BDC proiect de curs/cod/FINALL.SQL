--Crearea Bazei de date MagTehGSM
USE master
GO
IF DB_ID('MagTehGSM') IS NOT NULL 
DROP DATABASE MagTehGSM
GO
CREATE DATABASE MagTehGSM
ON(
NAME = MagTehGSM,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\MagTehGSM.mdf',
SIZE = 5MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 1MB)
LOG ON(
NAME = MagTehGSM_log,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\MagTehGSM_log.ldf',
SIZE = 1MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 5MB)
GO

--Creaza tabele

use MagTehGSM
--relatia produse
IF OBJECT_ID('Produse', 'U') IS NOT NULL
DROP TABLE Produse
CREATE TABLE Produse(
	ID_produs int NOT NULL,
	Nume_produs nvarchar(50) NOT NULL,
	Descriere varchar(50) NOT NULL,
	ID_comanda int NOT NULL,
	PRIMARY KEY (ID_produs)
	)
--relatie comenzi
IF OBJECT_ID('Comenzi', 'U') IS NOT NULL
DROP TABLE Comenzi
CREATE TABLE Comenzi(
	ID_comanda int NOT NULL,
	Pret int NOT NULL,
	ClientID int NOT NULL,
	Data_efectuarii date NULL,
	PRIMARY KEY (ID_comanda)
	)
--relatie clienti
IF OBJECT_ID('Clienti', 'U') IS NOT NULL
DROP TABLE Clienti
CREATE TABLE Clienti(
	ClientID int NOT NULL,
	IDNP varchar(13) NULL,
	NUME nvarchar(50) NULL,
	Prenume nvarchar(50) NULL,
	PRIMARY KEY (ClientID)
	)
--relatie buletin
IF OBJECT_ID('Buletin', 'U') IS NOT NULL
DROP TABLE Buletin
CREATE TABLE Buletin(
	IDNP varchar(13) NOT NULL,
	Sex char(1) NULL,
	Tara nvarchar(20) NULL,
	Virsta int NULL,
	PRIMARY KEY (IDNP)
	)

--Chei externe
USE MagTehGSM
--Produse
ALTER TABLE Produse ADD CONSTRAINT[FK_ComenziProduse]
FOREIGN KEY(ID_comanda) REFERENCES Comenzi (ID_comanda)
ON UPDATE CASCADE;

--Comenzi
ALTER TABLE Comenzi ADD CONSTRAINT[FK_ClientiComenzi]
FOREIGN KEY(ClientID) REFERENCES Clienti(ClientID)
ON UPDATE CASCADE;
--Clienti
ALTER TABLE Clienti ADD CONSTRAINT [FK_clienti_buletin] FOREIGN KEY(IDNP)
REFERENCES Buletin (IDNP)
ON UPDATE CASCADE;
--CHEIE UNICA
ALTER TABLE Clienti
ADD CONSTRAINT UC_Clienti UNIQUE(IDNP)

USE MagTehGSM
--POPULAREA TUPLURILOR
GO
INSERT INTO Buletin VALUES('1234567891001', 'm', 'Romania', 75)
INSERT INTO Buletin VALUES('1234567891002', 'm', 'Moldova', 42)
INSERT INTO Buletin VALUES('1234567891003', 'm', 'Romania', 44)
INSERT INTO Buletin VALUES('1234567891004', 'm', 'Moldova', 34)
INSERT INTO Buletin VALUES('1234567891005', 'f', 'Itala', 22)
INSERT INTO Buletin VALUES('1234567891006', 'f', 'Moldova', 25)
INSERT INTO Buletin VALUES('1234567891007', 'm', 'Moldova', 22)
INSERT INTO Buletin VALUES('1234567891008', 'm', 'Romania', 25)
INSERT INTO Buletin VALUES('1234567891009', 'm', 'Anglia', 39)
INSERT INTO Buletin VALUES('1234567891010', 'm', 'Franta', 60)
GO
INSERT INTO Clienti VALUES(1001, '1234567891001', 'Creanga', 'Vasile')
INSERT INTO Clienti VALUES(1002, '1234567891002', 'Zagareanu', 'Denis')
INSERT INTO Clienti VALUES(1003, '1234567891003', 'Sisea', 'Alexandru')
INSERT INTO Clienti VALUES(1004, '1234567891004', 'Ziozic', 'Andrei')
INSERT INTO Clienti VALUES(1005, '1234567891005', 'Cobra', 'Ana')
INSERT INTO Clienti VALUES(1006, '1234567891006', 'Vulpe', 'Lidia')
INSERT INTO Clienti VALUES(1007, '1234567891007', 'Sendrila', 'Ion')
INSERT INTO Clienti VALUES(1008, '1234567891008', 'Covrig', 'Adrean')
INSERT INTO Clienti VALUES(1009, '1234567891009', 'Ciudic', 'Mihail')
INSERT INTO Clienti VALUES(1010, '1234567891010', 'Magari', 'Igor')
GO
INSERT INTO Comenzi VALUES(1, 4000, 1001, '2017-10-10')
INSERT INTO Comenzi VALUES(2, 6000, 1002, '2017-10-11')
INSERT INTO Comenzi VALUES(3, 9000, 1002, '2017-10-12')
INSERT INTO Comenzi VALUES(4, 5000, 1003, '2017-10-13')
INSERT INTO Comenzi VALUES(5, 3000, 1004, '2017-10-14')
INSERT INTO Comenzi VALUES(6, 799, 1005, '2017-10-15')
INSERT INTO Comenzi VALUES(7, 2500, 1006, '2017-10-16')
INSERT INTO Comenzi VALUES(8, 16000, 1007, '2017-10-17')
INSERT INTO Comenzi VALUES(9, 20000, 1008, '2017-10-18')
INSERT INTO Comenzi VALUES(10, 25000, 1009, '2017-10-19')
INSERT INTO Comenzi VALUES(11, 14000, 1010, '2017-10-20')
GO
INSERT INTO Produse VALUES(1, 'Samsung', 'Galaxy S8', 1)
INSERT INTO Produse VALUES(2, 'Nokia', 'Lumia N9', 2 )
INSERT INTO Produse VALUES(3, 'Lenovo', 'Vibe X', 3 )
INSERT INTO Produse VALUES(4, 'Samsung', 'Galaxy Edge 7', 3 )
INSERT INTO Produse VALUES(5, 'Huawei', 'Y200', 4 )
INSERT INTO Produse VALUES(6, 'Sony', 'Z2', 5 )
INSERT INTO Produse VALUES(7, 'Samsung', 'NOTE 2', 6 )
INSERT INTO Produse VALUES(8, 'Alcatel', 'N300', 7 )
INSERT INTO Produse VALUES(9, 'Cubot', 'C100', 8 )
INSERT INTO Produse VALUES(10, 'Apple', 'Iphone X', 9 )
INSERT INTO Produse VALUES(11, 'Apple', 'Iphone 8', 10 )
GO

--scheme
IF EXISTS(SELECT sys.schemas.name FROM sys.schemas WHERE sys.schemas.name = 'Clienti')
DROP SCHEMA Clienti
GO
CREATE SCHEMA Clienti
GO
ALTER SCHEMA Clienti TRANSFER dbo.Clienti
GO
IF EXISTS(SELECT sys.schemas.name FROM sys.schemas WHERE sys.schemas.name = 'Buletin')
DROP SCHEMA Buletin
GO
CREATE SCHEMA Buletin
GO
ALTER SCHEMA Buletin TRANSFER dbo.Buletin
GO
--crearea userilor
--user2
USE MagTehGSM
GO
IF EXISTS(SELECT * FROM master.dbo.syslogins WHERE name = 'user2' AND dbname = 'MagTehGSM')
DROP LOGIN user2
CREATE LOGIN user2
WITH PASSWORD = '12345', DEFAULT_DATABASE = MagTehGSM
IF EXISTS(SELECT * FROM master.dbo.sysusers WHERE name = 'user2')
DROP USER user2
CREATE USER user2 FOR LOGIN user2
WITH DEFAULT_SCHEMA = Produse
EXEC SP_ADDSRVROLEMEMBER 'user2', 'dbcreator'
EXEC SP_ADDROLEMEMBER 'db_datawriter', 'user2'
GO
--user3
USE MagTehGSM
IF EXISTS(SELECT * FROM master.dbo.syslogins WHERE name = 'user3' AND dbname = 'MagTehGSM')
DROP LOGIN user3
CREATE LOGIN user3
WITH PASSWORD = '54321', DEFAULT_DATABASE = MagTehGSM
IF EXISTS(SELECT * FROM master.dbo.sysusers WHERE name = 'user3')
DROP USER user3
CREATE USER user3 FOR LOGIN user3
WITH DEFAULT_SCHEMA = Bul
EXEC SP_ADDSRVROLEMEMBER 'user3', 'sysadmin'
EXEC SP_ADDROLEMEMBER 'db_datareader', 'user3'
GO


--viziuni
USE MagTehGSM
GO
--pirma viziune
IF OBJECT_ID('View1', 'V') IS NOT NULL
DROP VIEW View1
GO
CREATE VIEW View1 WITH SCHEMABINDING AS
SELECT ClientID, NUME, Prenume 
FROM Clienti.Clienti
WHERE IDNP = '1234567891005'
GO
SELECT * FROM View1
GO
--a doua viziune
IF OBJECT_ID('View2', 'V') IS NOT NULL
DROP VIEW View2
GO
CREATE VIEW View2 AS
SELECT ID_produs, Nume_produs, Descriere FROM Produse
WITH CHECK OPTION
GO
UPDATE View2
SET View2.Descriere = 'Iphone SE' WHERE ID_produs = 11
SELECT * FROM View2

--sinonime
--Sinonim pt buletin
GO 
CREATE SYNONYM Bul for Buletin.Buletin
 GO
 --sinonim pt clienti
 CREATE SYNONYM Cli for Clienti.Clienti
 GO
 --SINONIM PENTRU COMENZI
 CREATE SYNONYM Com for dbo.Comenzi
 GO
 --SINONIM PT PRODUSE
 CREATE SYNONYM Prod for dbo.Produse
 GO
 USE MagTehGSM
GO
SELECT COUNT(ID_produs) AS COUNTS FROM Produse
WHERE Nume_produs = 'Samsung'
UNION
SELECT Count(ID_comanda) FROM Comenzi
WHERE Pret > 5000
GO
--------------------------------------------
-- INTERSECT
SELECT ClientID AS ClientiFideli FROM Cli  
INTERSECT  
SELECT ClientID FROM Com  
GO 
-------------------------------------------
--EXCEPT
SELECT Pret AS [Diferenta] FROM  Comenzi  
WHERE ID_comanda = 1  
EXCEPT  
SELECT Pret FROM Comenzi  
WHERE ID_comanda = 5 
GO 
-------------------------------------------
-- Produsul cartezian
;WITH 
	Produs AS(
		SELECT ID_produs, Nume_produs, Descriere
		FROM Prod
		),
	Comanda AS(
		SELECT Pret
		FROM Com
		)
		SELECT * FROM Produs CROSS JOIN Comanda
GO
-----------------------------------------------------------------------
-- TETA Jonctiune
SELECT ID_comanda, Pret, Nume,Prenume 
FROM Com A,Cli B 
WHERE A.ClientID = B.ClientID 
GO
----------------------------------------------------------------------
--Jonctiune naturala
SELECT ClientID, Nume, Prenume, Cli.IDNP, Sex, Tara, Virsta
FROM Cli INNER JOIN Bul ON Cli.IDNP = Bul.IDNP
GO
-------------------------------------------------------------------
--Jonctiunea la stinga
SELECT ClientID, Nume, Prenume, Cli.IDNP, Sex, Tara, Virsta
FROM Cli LEFT JOIN Bul ON Cli.IDNP = Bul.IDNP
GO
-------------------------------------------------------------------
-- Jonctiune la dreapta
SELECT DISTINCT ID_comanda, Pret, Nume,Prenume 
FROM Com A RIGHT join Cli B ON A.ClientID = B.ClientID 
GO
------------------------------------------------------------------
--Diviziuni
SELECT Diviziunea1.ClientID, IDNP, NUME, Prenume, ID_comanda, Pret, Data_efectuarii 
FROM 
(SELECT * FROM Cli) AS [Diviziunea1]
JOIN
(SELECT * FROM Com WHERE Pret > 4000) AS Diviziunea2
ON [Diviziunea1].ClientID = [Diviziunea2].ClientID
GO
---------------------------------------------------------------------------
-- Comenzi de agregare
SELECT MAX(PRET) AS Maxim, MIN(Pret) AS Minim, 
SUM(Pret) AS Suma, AVG(Pret) AS Venit, 
count(*) AS Comenzi
FROM Com
GO
--------------------------------------------------------------------------
SELECT MAX(Virsta) AS Maxim, MIN(Virsta) AS Minim, 
SUM(Virsta) AS Suma, AVG(Virsta) AS Venit, 
count(*) AS clients
FROM Bul
GO
---------------------------------------------------------------------
SELECT COUNT(1) FROM Prod
GO
-------------------------------------------------------------------
SELECT ClientID FROM Com
WHERE Pret > 1000
GROUP BY ClientID 
Having Count(Pret) >= 2
GO
--------------------------------------------------------------------
SELECT AVG(Pret) as PretMediu, Com.ClientID FROM Com
join Cli ON Cli.ClientID = Com.ClientID
GROUP BY Com.ClientID
GO
-------------------------------------------------------------------
SELECT ID_comanda, Data_efectuarii, Pret
FROM Com
WHERE ClientID IN (SELECT ClientID FROM Cli WHERE NUME LIKE 'C%')
ORDER BY Pret 
GO
--------------------------------------------------------------------
SELECT Nume, Prenume, IDNP
FROM Cli
WHERE EXISTS (SELECT ClientID FROM Com WHERE ClientID = Cli.ClientID);
GO
-------------------------------------------------------------------------
SELECT Nume, Prenume, IDNP
FROM Cli
WHERE ClientID = ANY (SELECT ClientID FROM Com WHERE Pret > 4000);
GO
------------------------------------------------------------------------
SELECT Nume, Prenume,
ClientID = (SELECT Count(*) FROM Com WHERE Com.ClientID = C.ClientID) 
FROM Cli C
GO

-- declansator delete
---------------------------------------------------------------------------------
USE MagTehGSM
GO
IF OBJECT_ID('stergere_client', 'TR') IS NOT NULL 
DROP TRIGGER stergere_client
GO
CREATE TRIGGER stergere_client ON Buletin.Buletin
AFTER DELETE
AS
BEGIN
DELETE FROM Buletin.Buletin
WHERE IDNP = (SELECT MAX(Virsta) FROM Buletin.Buletin )
END
GO
--declansator update
------------------------------------------------------------------------------------
USE MagTehGSM
GO
IF OBJECT_ID('inregstrare_noua', 'TR') IS NOT NULL
DROP TRIGGER inregistrare_noua
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID('inregstrare_noua'))
DROP TRIGGER inregstrare_noua
GO
CREATE TRIGGER inregistrare_noua ON Produse
AFTER UPDATE
AS SET NOCOUNT ON;
IF UPDATE(Descriere)
SELECT 'Produsul cu ID-ul ' + RTRIM(CAST(inserted.ID_produs AS tinyint)) +
'are o descriere noua '+CAST(inserted.Descriere AS varchar(50))
FROM inserted
SELECT 'Descrierea veche era ' +RTRIM(CAST(deleted.Descriere AS varchar(50)))
FROM deleted
GO
UPDATE produse SET Descriere = 'Galaxy S9' WHERE ID_produs = 1;
GO

-------------------------------------------------------------------------------------
--PROCCEDURA STOCATA 1
USE MagTehGSM
GO
IF OBJECT_ID ('sondaj', 'P') IS NOT NULL DROP PROCEDURE sondaj
GO
CREATE PROCEDURE sondaj 
@Virsta INT
AS
SELECT c.IDNP, c.Nume, c.Prenume, b.Tara, b.Virsta
FROM Clienti.Clienti AS c JOIN Buletin.Buletin  AS b ON c.IDNP = b.IDNP
WHERE Virsta < @Virsta
GO
EXEC sondaj 40
GO
------------------------------------------------------------------------------------
--PROCCEDURA STOCATA 1
USE MagTehGSM
GO
IF OBJECT_ID ('GetSuperComands', 'P') IS NOT NULL DROP PROCEDURE GetSuperComands
GO
CREATE PROCEDURE GetSuperComands
@pret INT
AS
SELECT c.IDNP, c.Nume, c.Prenume, com.ID_comanda, com.Pret
FROM Comenzi com join Clienti.Clienti c ON com.ClientID = c.ClientID
WHERE Pret >= @pret
GO
EXEC GetSuperComands 15000
GO