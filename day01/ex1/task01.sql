USE internship
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Report_VehiclesServicedVisits]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Report_VehiclesServicedVisits] AS' 
END
GO
ALTER PROCEDURE dbo.Report_VehiclesServicedVisits
@DealerID INT
AS
BEGIN

	;WITH 
		ConstantVisit AS(
			SELECT * FROM (VALUES
				(1, '1-2 visited service'),
				(2, '1-2 visited service'),
				(3, '3-4 visited service'),     
				(4, '3-4 visited service'),
				(5, '5+ visited service')
				) AS Visit (Nr,ServiceVisit)
				),
		CountVehicle AS(	
			SELECT VehicleID, CN = COUNT(1)
			        
			FROM ServicedTimes
			WHERE DealerID = CASE WHEN @DealerID IS NULL THEN DealerID ELSE @DealerID END
			GROUP BY VehicleID
			),
		VehicleDetailes AS(
			SELECT Visit = CN, Vehicles = COUNT(1)
			FROM CountVehicle 
			GROUP BY CN
			),
		DISTINCTTABLE AS(
			SELECT ServiceVisit, Vehicles = ISNULL(Vehicles, 0) FROM ConstantVisit A
			LEFT JOIN VehicleDetailes B ON A.Nr = B.Visit 
			)
			SELECT ServiceVisit, SUM(Vehicles) AS Vehicles FROM DISTINCTTABLE
			GROUP BY ServiceVisit
END
			-- DEBUG
			--SELECT * FROM ConstantVisit
			--SELECT * FROM CountVehicle
			--SELECT * FROM VehicleDetailes 
			--SELECT * FROM DISTINCTTABLE


			EXEC dbo.Report_VehiclesServicedVisits @DealerID = NULL