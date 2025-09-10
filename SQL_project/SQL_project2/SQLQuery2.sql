USE PortofolioProject;

SELECT top 5
	*
FROM SalesRecords
ORDER BY Country;

EXEC sp_rename 'SalesRecords.[Sales Channel]', 'SalesChannel', 'COLUMN';
GO
EXEC sp_rename 'SalesRecords.[Order Priority]', 'OrderPriority', 'COLUMN';
GO
EXEC sp_rename 'SalesRecords.[Order Date]', 'OrderDate', 'COLUMN';
GO
EXEC sp_rename 'SalesRecords.[Order ID]', 'OrderID', 'COLUMN';
GO
EXEC sp_rename 'SalesRecords.[Ship Date]', 'ShipDate', 'COLUMN';
GO
EXEC sp_rename 'SalesRecords.[Units Sold]', 'UnitsSold', 'COLUMN';
GO
EXEC sp_rename 'SalesRecords.[Unit Price]', 'UnitPrice', 'COLUMN';
GO
EXEC sp_rename 'SalesRecords.[Unit Cost]', 'UnitCost', 'COLUMN';
GO
EXEC sp_rename 'SalesRecords.[Total Revenue]', 'TotalRevenue', 'COLUMN';
GO
EXEC sp_rename 'SalesRecords.[Total Cost]', 'TotalCost', 'COLUMN';
GO
EXEC sp_rename 'SalesRecords.[Total Profit]', 'TotalProfit', 'COLUMN';
GO

ALTER TABLE SalesRecords
ALTER COLUMN OrderDate DATE;

ALTER TABLE SalesRecords
ALTER COLUMN ShipDate DATE;

ALTER TABLE SalesRecords
ALTER COLUMN UnitsSold DECIMAL(12, 2);

ALTER TABLE SalesRecords
ALTER COLUMN UnitPrice DECIMAL(12, 2);

ALTER TABLE SalesRecords
ALTER COLUMN UnitCost DECIMAL(12, 2);

ALTER TABLE SalesRecords
ALTER COLUMN TotalRevenue DECIMAL(12, 2);

ALTER TABLE SalesRecords
ALTER COLUMN TotalCost DECIMAL(12, 2);

ALTER TABLE SalesRecords
ALTER COLUMN TotalProfit DECIMAL(12, 2);

SELECT top 5
	*
FROM SalesRecords
ORDER BY Country;


SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME = 'SalesRecords';

SELECT 
	*
FROM SalesRecords;

SELECT 
	Country,
	OrderPriority AS [Order Priority],
	ROUND(SUM(TotalRevenue), -4) AS  [Total Revenue],
	ROUND(SUM(TotalCost), -4) AS [Total Cost],
	ROUND(SUM(TotalProfit), -4) AS [Total Profit]
FROM PortofolioProject..SalesRecords
GROUP BY Country,OrderPriority
ORDER BY Country,OrderPriority DESC;

SELECT 
	Region,
	OrderPriority AS [Order Priority],
	ROUND(SUM(TotalRevenue), -4) AS  [Total Revenue],
	ROUND(SUM(TotalCost), -4) AS [Total Cost],
	ROUND(SUM(TotalProfit), -4) AS [Total Profit]
FROM PortofolioProject..SalesRecords
GROUP BY Region,OrderPriority
ORDER BY Region,OrderPriority DESC;

SELECT
	ItemType,
	COUNT(ItemType),
	SUM(TotalCost),
	SUM(TotalProfit)
FROM PortofolioProject..SalesRecords
WHERE Country = 'Laos'
GROUP BY ItemType;

SELECT 
	Country,
	ItemType,
	COUNT(ItemType) AS EachItemTypeSold,
	SUM(TotalProfit) AS TotalProfit
FROM PortofolioProject..SalesRecords
GROUP BY 
	Country,
	ItemType
HAVING 
	COUNT(ItemType) >= 5
	AND
	SUM(TotalProfit) >= 2000000
ORDER BY 
	Country,
	EachItemTypeSold DESC

SELECT 
	Country,
	ItemType,
	AVG(UnitCost) AS Cost,
	AVG(UnitPrice) AS Price,
	(AVG(UnitPrice) - AVG(UnitCost)) AS Devian
FROM PortofolioProject..SalesRecords
GROUP BY Country, ItemType
ORDER BY Country, ItemType, Devian DESC;

SELECT 
	Country,
	ItemType,
	AVG(TotalProfit) AS Profit,
	AVG(TotalCost) AS Cost,
	CASE
		WHEN AVG(TotalProfit) > AVG(TotalCost) THEN 'Profit Bigger'
		WHEN AVG(TotalProfit) < AVG(TotalCost) THEN 'Cost Bigger'
		ELSE 'Equivalen'
	END AS Different
FROM PortofolioProject..SalesRecords
GROUP BY Country, ItemType
ORDER BY Country, ItemType DESC;

SELECT
	COUNT(
		CASE WHEN Different = 'Profit Bigger' THEN 1 END
	) AS CountProfitBigger,
	COUNT(
		CASE WHEN Different = 'Cost Bigger' THEN 1 END
	) AS CountCostBigger
FROM (
SELECT 
	Country,
	ItemType,
	AVG(TotalProfit) AS Profit,
	AVG(TotalCost) AS Cost,
	CASE
		WHEN AVG(TotalProfit) > AVG(TotalCost) THEN 'Profit Bigger'
		WHEN AVG(TotalProfit) < AVG(TotalCost) THEN 'Cost Bigger'
		ELSE 'Equivalen'
	END AS Different
FROM PortofolioProject..SalesRecords
GROUP BY Country, ItemType) AS a;

SELECT 
	Country,
	ItemType,
	COUNT( CASE WHEN AVG(TotalProfit) > AVG(TotalCost) THEN AVG(TotalProfit) END) AS 'Order Bigger',
	COUNT( CASE WHEN AVG(TotalProfit) < AVG(TotalCost) THEN AVG(TotalCost) END) AS 'Cost Bigger'
FROM PortofolioProject..SalesRecords
GROUP BY Country, ItemType
ORDER BY Country, ItemType DESC;

SELECT
	Region,
	Country,
	ItemType,
	TotalProfit,
	RANK() OVER (PARTITION BY ItemType, Region ORDER BY TotalProfit	DESC) AS profit_rank
FROM PortofolioProject..SalesRecords;

SELECT
	Region,
	Country,
	ItemType,
	TotalCost,
	AVG(TotalCost) OVER (PARTITION BY ItemType, Region) AS average_cost_rank
FROM PortofolioProject..SalesRecords;

WITH SpesificOrder AS (
SELECT 
	*
FROM PortofolioProject..SalesRecords
WHERE Country = 'Afghanistan'
AND
ItemType = 'Vegetables'
)

SELECT
	OrderPriority,
	OrderID,
	OrderDate,
	TotalProfit,
	LAG(TotalProfit, 1) OVER (ORDER BY OrderDate ASC) AS LastProfit
FROM SpesificOrder;


SELECT top 5
	*
FROM PortofolioProject..SalesRecords
ORDER BY Country;