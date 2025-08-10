-- DATA CLEANING & EXPLORATORY DATA ANALYSIS PROJECT

SELECT * FROM dirty_cafe_sales;

-- CHECKING FOR DUPLICATE ROWS
SELECT * 
FROM 
	(	SELECT 
		Transaction_ID,
		Item,
		Quantity,
		COUNT(*) AS records
	FROM dirty_cafe_sales 
	GROUP BY Transaction_ID, Item, Quantity) a
	WHERE records > 1;
 

SELECT  
	Transaction_ID,
	Item,
	Quantity,
	COUNT(*) AS records
FROM dirty_cafe_sales
GROUP BY Transaction_ID, Item, Quantity
HAVING COUNT(*) > 1;

-- DATA CLEANING -->REPLACING NULL, UNKNOWN AND ERROR (INCONSISTENT VALUES) VALUES IN "ITEM" COLUMN WITH "UNSPECIFIED"
UPDATE dirty_cafe_sales
	SET Item = 'Unspecified'
	WHERE Item IS NULL
	OR Item LIKE '%UNKNOWN%' 
	OR Item LIKE '%ERROR%'

-- CHECK
SELECT *	
	FROM dirty_cafe_sales
	WHERE Item IS NULL 
	OR Item LIKE '%UNKNOWN%' 
	OR Item LIKE '%ERROR%';


-- 2. CLEAN AND FILL MISSING VALUES IN "Quantity, Price_per_unit, and Total_spent" columns

-- TOTAL MISSING VALUES 
SELECT 
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS missing_quantity,
    SUM(CASE WHEN price_per_unit IS NULL THEN 1 ELSE 0 END) AS missing_price_per_unit,
    SUM(CASE WHEN total_spent IS NULL THEN 1 ELSE 0 END) AS missing_total_spent
FROM dirty_cafe_sales;

-- FILLING TOTAL_SPENT COLUMN
UPDATE dirty_cafe_sales
SET total_spent = Quantity * price_per_unit
WHERE total_spent IS NULL 
AND Quantity IS NOT NULL 
AND price_per_unit IS NOT NULL;

-- FILLING QUANTITY COLUMN
UPDATE dirty_cafe_sales
SET Quantity = total_spent / price_per_unit
WHERE Quantity IS NULL 
AND total_spent IS NOT NULL 
AND price_per_unit IS NOT NULL;

-- FILLING PRICE_PER_UNIT COLUMN
UPDATE dirty_cafe_sales
SET Price_Per_Unit = Total_Spent/Quantity
WHERE Price_Per_Unit IS NULL
AND Total_Spent IS NOT NULL
AND Quantity IS NOT NULL;

-- THE NUMBER OF MISSING VALUES HAVE NOW REDUCED, FOR THE SCOPE OF THIS PROJECT WE CHOOSE TO DELETE 
--THE ROWS WITH MISSING DATA IN THE THREE COLUMNS 0.4% OF THE TOTAL DATASET
DELETE FROM dirty_cafe_sales
WHERE 
Quantity IS NULL 
OR Total_Spent IS NULL 
OR Price_Per_Unit IS NULL;


-- REPLACE INCONSISTENT VALUES IN PAYMENT_METHOD WITH 'UNKNOWN'
SELECT 
	Payment_Method,
	COUNT(*)
	FROM dirty_cafe_sales
	GROUP BY Payment_Method;

UPDATE dirty_cafe_sales
	SET Payment_Method = 'Unknown'
	WHERE Payment_Method IS NULL
	OR Payment_Method LIKE '%UNKNOWN%' 
	OR Payment_Method LIKE '%ERROR%';

-- REPLACE INCONSISTENT VALUES IN LOCATION WITH 'UNKNOWN'
SELECT 
	Location,
	COUNT(*)
	FROM dirty_cafe_sales
	GROUP BY Location;

UPDATE dirty_cafe_sales
	SET Location = 'Unknown'
	WHERE Location IS NULL
	OR Location LIKE '%UNKNOWN%' 
	OR Location LIKE '%ERROR%';


--
SELECT 
	Transaction_Date,
	COUNT(*)
	FROM dirty_cafe_sales
	WHERE Transaction_Date IS NULL
	GROUP BY Transaction_Date;


SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Transaction_Date IS NULL THEN 1 ELSE 0 END) AS missing_dates,
    (SUM(CASE WHEN Transaction_Date IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percent_missing
FROM dirty_cafe_sales;

-- Replace Null values in Transaction_date with '1900-01-01' - Default date
UPDATE dirty_cafe_sales
	SET Transaction_Date = '1900-01-01'
	WHERE Transaction_Date IS NULL;

ALTER TABLE dirty_cafe_sales ADD Date_Status VARCHAR(20);

UPDATE dirty_cafe_sales
SET Date_Status = 
    CASE 
        WHEN Transaction_Date = '1900-01-01' THEN 'Unknown' 
        ELSE 'Valid' 
    END;

	SELECT * FROM dirty_cafe_sales;
	
-- EXPLORATORY DATA ANALYSIS
-- LAST CHECK FOR MISSING OR NULL VALUES
SELECT 
    SUM(CASE WHEN Transaction_ID IS NULL THEN 1 ELSE 0 END) AS missing_transaction_id,
    SUM(CASE WHEN Item IS NULL THEN 1 ELSE 0 END) AS missing_item,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS missing_quantity,
    SUM(CASE WHEN Price_Per_Unit IS NULL THEN 1 ELSE 0 END) AS missing_price,
    SUM(CASE WHEN Total_Spent IS NULL THEN 1 ELSE 0 END) AS missing_total_spent,
    SUM(CASE WHEN Payment_Method IS NULL THEN 1 ELSE 0 END) AS missing_payment_method,
    SUM(CASE WHEN Location IS NULL THEN 1 ELSE 0 END) AS missing_location,
    SUM(CASE WHEN Transaction_Date IS NULL THEN 1 ELSE 0 END) AS missing_transaction_date
FROM dirty_cafe_sales;

-- EXPLORATORY DATA ANALYSIS
-- Daily Sale
SELECT Transaction_Date, 
	SUM(Total_Spent) AS daily_sales
FROM dirty_cafe_sales
GROUP BY Transaction_Date
ORDER BY Transaction_Date;

-- Monthly Sales
SELECT 
	FORMAT(Transaction_Date, 'yyyy-MM') AS Month_name, SUM(Total_Spent) AS Monthly_sales
	FROM dirty_cafe_sales
	GROUP BY FORMAT(Transaction_Date, 'yyyy-MM')
	ORDER BY 2  DESC;

SELECT 
    YEAR(Transaction_Date) AS Year,
    MONTH(Transaction_Date) AS Month,
    SUM(Total_Spent) AS Monthly_Sales
FROM dirty_cafe_sales
GROUP BY YEAR(Transaction_Date), MONTH(Transaction_Date)
ORDER BY Year, Month;


-- Best Selling item
SELECT TOP 5
	Item,
	SUM(Quantity) AS total_qty_sold
	FROM dirty_cafe_sales
	GROUP BY Item
	ORDER BY 2 DESC;

-- Highest Revenue Generating Items
SELECT TOP 5
	Item, 
	SUM(Total_Spent) AS Total_Revenue
	FROM dirty_cafe_sales
	GROUP BY Item
	ORDER BY 2 DESC;

-- Most preferred payment method
SELECT 
	Payment_Method,
	COUNT(*) AS usage_count
	FROM dirty_cafe_sales
	GROUP BY Payment_Method
	ORDER BY 2 DESC;

-- SALES BY LOCATION
SELECT 
	Location,
	SUM(Total_Spent) AS Total_sales
	FROM dirty_cafe_sales
	GROUP BY Location
	ORDER BY 2;

-- CUSTOMER BUYING PATTERNS
-- Average spending per transaction
SELECT 
	ROUND(AVG(Total_Spent), 2) AS avg_spending_per_transaction
	FROM dirty_cafe_sales;

-- Average Quantity per order
SELECT 
	AVG(Quantity) AS avg_items_per_order
	FROM dirty_cafe_sales;

-- Anomaly Detection
SELECT 
* 
FROM dirty_cafe_sales
WHERE Total_Spent <> (Quantity * Price_Per_Unit);

SELECT * 
FROM dirty_cafe_sales
WHERE Payment_Method = 'Unknown' 
OR Location = 'Unknown';

SELECT 
COUNT(*) TOTAL_COUNT 
FROM dirty_cafe_sales
WHERE Payment_Method = 'Unknown' 
OR Location = 'Unknown';
