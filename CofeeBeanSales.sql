CREATE TABLE Coffee_Bean_Orders (
    Order_ID VARCHAR(255),
    Order_Date DATE,
    Customer_ID VARCHAR(255),
    Product_ID VARCHAR(255),
    Quantity INT,
    Coffee_Type VARCHAR(255),
    Roast_Type VARCHAR(255),
    Unit_Price money,
    Size VARCHAR(255),
    Profit money,
	Calc_Sales money,
	Calc_Profit money,
    Customer_Name VARCHAR(255),
    Email VARCHAR(255),
    City VARCHAR(255),
    Country VARCHAR(255),
    Loyalty_Card BIT
);


INSERT INTO Coffee_Bean_Orders (Order_ID, Order_Date, Customer_ID, Product_ID, Quantity, Coffee_Type, Roast_Type, 
Unit_Price, Size, Profit, Customer_Name, Email, City, Country, Loyalty_Card)
SELECT
    s.Order_ID,
    s.Order_Date,
    c.Customer_ID,
    p.Product_ID,
    s.Quantity,
    p.Coffee_Type,
    p.Roast_Type,
    p.Unit_Price,
    p.Size,
    p.Profit,
    c.Customer_Name,
    c.Email,
    c.City,
    c.Country,
    c.Loyalty_Card
FROM [CoffeBeanSales].[dbo].[Coffee bean sales] AS s
INNER JOIN [CoffeBeanSales].[dbo].[Coffee bean products] AS p ON s.Product_ID = p.Product_ID
INNER JOIN [CoffeBeanSales].[dbo].[Coffee bean customers] AS c ON s.Customer_ID = c.Customer_ID;

SELECT * FROM Coffee_Bean_Orders;

--TOTAL NO OF ORDERS BY YEAR
SELECT YEAR(Order_Date) AS 'Year', COUNT(Order_ID) 'No of Orders' FROM Coffee_Bean_Orders
Group By YEAR(Order_Date)
Order By YEAR(Order_Date);

--TOTAL NO OF CUSTOMERS BY YEAR
SELECT YEAR(Order_Date) AS 'Year', COUNT(DISTINCT Customer_ID) AS 'No of Customers' FROM Coffee_Bean_Orders
Group By YEAR(Order_Date)
Order By YEAR(Order_Date);

--TOTAL NO OF ORDERS BY COUNTRY BY YEAR
SELECT YEAR(Order_Date) AS 'Year', Country, COUNT(Order_ID) AS 'No of Orders' FROM Coffee_Bean_Orders
Group By YEAR(Order_Date), Country
Order By YEAR(Order_Date), Country;

--TOTAL NO OF CUSTOMERS BY COUNTRY BY YEAR
SELECT YEAR(Order_Date) AS 'Year', Country, COUNT(DISTINCT Customer_ID) AS 'No of Customers' FROM Coffee_Bean_Orders
Group By YEAR(Order_Date), Country
Order By YEAR(Order_Date), Country;

--CALCULATED STORE SALES AND PROFITS
SELECT Order_ID, Order_Date, Customer_ID, Customer_Name, Quantity, Coffee_Type, Roast_Type, Product_ID, 
Unit_Price, Size, Profit, (Unit_Price* Quantity) AS StoreSales, (Profit* Quantity) AS Profits  
FROM Coffee_Bean_Orders;

--2019 SALES AND PROFITS BY PRODUCT ID AND COFFEE AND ROAST TYPE
SELECT Product_ID, SUM(Quantity) AS TotalQuantity, Coffee_Type, Roast_Type, 
SUM(Unit_Price * Quantity) AS StoreSales, SUM(Profit * Quantity) AS Profits
FROM Coffee_Bean_Orders
WHERE YEAR(Order_Date) = 2019
GROUP BY Product_ID, Coffee_Type, Roast_Type;

----QUANTITY SOLD BY COFFEE AND ROAST TYPE IN 2019
SELECT YEAR(Order_Date) AS 'Year', Coffee_Type,  Roast_Type, SUM(Quantity) AS TotalQuantity, 
SUM(Unit_Price * Quantity) AS StoreSales, SUM(Profit * Quantity) AS Profits
FROM Coffee_Bean_Orders
WHERE YEAR(Order_Date) = 2019
GROUP BY YEAR(Order_Date), Coffee_Type, Roast_Type;

--QUANTITY SOLD BY COFFEE TYPE OVER THE YEARS
SELECT YEAR(Order_Date) AS 'Year', Coffee_Type, SUM(Quantity) AS TotalQuantity, 
SUM(Unit_Price * Quantity) AS StoreSales, SUM(Profit * Quantity) AS Profits
FROM Coffee_Bean_Orders
GROUP BY YEAR(Order_Date), Coffee_Type
ORDER BY YEAR(Order_Date), Coffee_Type;

--QUANTITY SOLD BY ROAST TYPE OVER THE YEARS
SELECT YEAR(Order_Date) AS 'Year', Roast_Type, SUM(Quantity) AS TotalQuantity, 
SUM(Unit_Price * Quantity) AS StoreSales, SUM(Profit * Quantity) AS Profits
FROM Coffee_Bean_Orders
GROUP BY YEAR(Order_Date), Roast_Type
ORDER BY YEAR(Order_Date), Roast_Type;

--QUANTITY SOLD BY SIZE OVER THE YEARS
SELECT YEAR(Order_Date) AS 'Year', Size, SUM(Quantity) AS TotalQuantity, 
SUM(Unit_Price * Quantity) AS StoreSales, SUM(Profit * Quantity) AS Profits
FROM Coffee_Bean_Orders
GROUP BY YEAR(Order_Date), Size
ORDER BY YEAR(Order_Date), Size;

--COST OF COFFEE BEANS BY YEAR BASED ON SALES
SELECT YEAR(Order_Date) AS 'Year',Coffee_Type, SUM(Quantity) AS TotalQuantity, 
SUM(Unit_Price * Quantity) AS StoreSales, SUM(Profit * Quantity) AS Profits, (SUM(Unit_Price) - SUM(Profit)) AS COGs
FROM Coffee_Bean_Orders
GROUP BY Coffee_Type, YEAR(Order_Date)
ORDER BY YEAR(Order_Date), Coffee_Type;

--AOV OVER THE YEARS
SELECT YEAR(Order_Date) AS 'Year', SUM(Quantity) AS TotalQuantity, COUNT(DISTINCT Order_ID) AS TotalOrders,  
SUM(Unit_Price * Quantity) AS StoreSales, (SUM(Unit_Price * Quantity)/COUNT(DISTINCT Order_ID)) AS AOV
FROM Coffee_Bean_Orders
GROUP BY YEAR(Order_Date)
ORDER BY YEAR(Order_Date);

--AOV OF COFFEE TYPES OVER THE YEARS
SELECT YEAR(Order_Date) AS 'Year',Coffee_Type, SUM(Quantity) AS TotalQuantity, COUNT(DISTINCT Order_ID) AS TotalOrders,  
SUM(Unit_Price * Quantity) AS StoreSales, (SUM(Unit_Price * Quantity)/COUNT(DISTINCT Order_ID)) AS AOV
FROM Coffee_Bean_Orders
GROUP BY Coffee_Type, YEAR(Order_Date)
ORDER BY YEAR(Order_Date), Coffee_Type;

--NO OF CUSTOMERS WITH LOYALTY CARDS
SELECT  YEAR(Order_Date) AS 'Year', COUNT(DISTINCT Customer_ID) AS 'CustomersWithLoyaltyCard' 
FROM Coffee_Bean_Orders
WHERE Loyalty_Card = 1
GROUP BY YEAR(Order_Date)
ORDER BY YEAR(Order_Date);

--NO OF CUSTOMERS WITHOUT LOYALTY CARDS
SELECT  YEAR(Order_Date) AS 'Year', COUNT(DISTINCT Customer_ID) AS 'CustomersWithoutLoyaltyCard' 
FROM Coffee_Bean_Orders
WHERE Loyalty_Card = 0
GROUP BY YEAR(Order_Date)
ORDER BY YEAR(Order_Date);

--NO OF CUSTOMERS WITH LOYALTY CARDS BY COUNTRY
SELECT  YEAR(Order_Date) AS 'Year', Country, COUNT(DISTINCT Customer_ID) AS 'CustomersWithLoyaltyCard' 
FROM Coffee_Bean_Orders
WHERE Loyalty_Card = 1
GROUP BY YEAR(Order_Date), Country
ORDER BY YEAR(Order_Date), Country;

--BEST SELLING PRODUCT AS OF 2021
SELECT Product_ID, SUM(Unit_Price * Quantity) AS Sales, SUM(Profit * Quantity) AS Profits
FROM Coffee_Bean_Orders
WHERE YEAR(Order_Date)= 2021
GROUP BY Product_ID
ORDER BY SUM(Unit_Price * Quantity) DESC, SUM(Profit * Quantity) DESC;

--SALES AND PROFITS PERFORMANCE FOR EACH COFFEE TYPE BY QUARTER IN 2021
SELECT Coffee_Type, DATEPART(QUARTER, Order_Date) AS 'QUARTER', SUM(Quantity) AS 'Total Quantity', SUM(Unit_Price * Quantity) AS Sales, 
SUM(Profit * Quantity) AS Profits
FROM Coffee_Bean_Orders
WHERE YEAR(Order_Date)= 2021
GROUP BY Coffee_Type, DATEPART(QUARTER, Order_Date)
ORDER BY Coffee_Type, QUARTER;
