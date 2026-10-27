-- ============================================================
-- Smart Retail Analytics — SQL Business Queries
-- Database: retail.db (SQLite) with tables: sales, customers, products
-- ============================================================

-- Q1: Product & Category Revenue / Profit
SELECT Product_Name, Category,
       COUNT(DISTINCT Order_ID) AS Orders,
       SUM(Quantity) AS Units_Sold,
       ROUND(SUM(Revenue_INR), 2) AS Total_Revenue,
       ROUND(SUM(Profit_INR), 2)  AS Total_Profit
FROM sales
GROUP BY Product_Name, Category
ORDER BY Total_Revenue DESC;

-- Q1b: Category summary
SELECT Category,
       ROUND(SUM(Revenue_INR), 2) AS Revenue,
       ROUND(SUM(Profit_INR), 2)  AS Profit
FROM sales
GROUP BY Category
ORDER BY Revenue DESC;

-- Q2a: Monthly trend
SELECT YearMonth,
       COUNT(DISTINCT Order_ID) AS Orders,
       ROUND(SUM(Revenue_INR), 2) AS Revenue
FROM sales
GROUP BY YearMonth
ORDER BY YearMonth;

-- Q2b: Region performance
SELECT Region,
       COUNT(DISTINCT Order_ID) AS Orders,
       ROUND(SUM(Revenue_INR), 2) AS Revenue
FROM sales
GROUP BY Region
ORDER BY Revenue DESC;

-- Q2c: Channel performance
SELECT Sales_Channel,
       COUNT(DISTINCT Order_ID) AS Orders,
       ROUND(SUM(Revenue_INR), 2) AS Revenue,
       ROUND(AVG(Revenue_INR), 2) AS AOV
FROM sales
GROUP BY Sales_Channel
ORDER BY Revenue DESC;

-- Q3: Top 10 customers by lifetime value
SELECT Customer_ID, Customer_Name,
       COUNT(DISTINCT Order_ID) AS Orders,
       ROUND(SUM(Revenue_INR), 2) AS Lifetime_Value
FROM sales
GROUP BY Customer_ID, Customer_Name
ORDER BY Lifetime_Value DESC
LIMIT 10;

-- Q4: Stock alerts
WITH latest AS (
  SELECT Product_Name, Stock_On_Hand, Reorder_Level,
         ROW_NUMBER() OVER (PARTITION BY Product_Name ORDER BY Order_Date DESC) AS rn
  FROM sales
)
SELECT Product_Name, Stock_On_Hand, Reorder_Level,
       ROUND(Stock_On_Hand * 1.0 / Reorder_Level, 2) AS Stock_Ratio,
       CASE WHEN Stock_On_Hand < Reorder_Level THEN 'CRITICAL'
            WHEN Stock_On_Hand < Reorder_Level * 1.5 THEN 'LOW'
            ELSE 'OK' END AS Status
FROM latest
WHERE rn = 1
ORDER BY Stock_Ratio ASC;

-- Q5: Monthly series for forecasting
SELECT YearMonth,
       ROUND(SUM(Revenue_INR), 2) AS Revenue
FROM sales
GROUP BY YearMonth
ORDER BY YearMonth;
