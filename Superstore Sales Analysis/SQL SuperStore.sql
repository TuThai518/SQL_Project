USE PortfolioProject
GO

SELECT TOP 10 *
FROM superstore;

----------------------------------------
-- 1.Remove the time from Ship Date and Order Date

ALTER TABLE superstore 
Add OrderDateOnly Date, ShipDateOnly Date; 

UPDATE superstore  
SET OrderDateOnly = CONVERT(Date, orderdate),
	ShipDateOnly = CONVERT(Date, shipdate);

SELECT TOP 10 *
FROM superstore; 

-- 2. What are the Total Sale and Profit of each year

--The year are grouped by order date so we can see the profit by using GROUP BY. After that we see that there's a steady 
--increase in profit over the years, despite a fall in sales in 2015
SELECT
	YEAR(OrderDateOnly) as Year,
	SUM (Sales) as TotalSales,
	SUM (Profit) as TotalProfit
FROM superstore
GROUP BY YEAR(Orderdateonly)
ORDER BY year

-- 3. What are the Total Sale and Profit per quarter

-- Sales and profit of each quarter per year
SELECT 
  YEAR(OrderDateOnly) AS year, 
  CASE 
    WHEN MONTH(OrderDateOnly) IN (1,2,3) THEN 'Q1'
    WHEN MONTH(OrderDateOnly) IN (4,5,6) THEN 'Q2'
    WHEN MONTH(OrderDateOnly) IN (7,8,9) THEN 'Q3'
    ELSE 'Q4'
  END AS quarter,
  SUM(sales) AS total_sales,
  SUM(profit) AS total_profit
FROM superstore
GROUP BY  
YEAR(OrderDateOnly), 
  CASE 
    WHEN MONTH(OrderDateOnly) IN (1,2,3) THEN 'Q1'
    WHEN MONTH(OrderDateOnly) IN (4,5,6) THEN 'Q2'
    WHEN MONTH(OrderDateOnly) IN (7,8,9) THEN 'Q3'
    ELSE 'Q4'
  END
ORDER BY year, quarter;

/* -- Total sales and profit of each quarter across the year
SELECT 
  SUM(CASE WHEN MONTH(OrderDateOnly) IN (1,2,3) THEN sales ELSE 0 END) AS total_sales_Q1,
  SUM(CASE WHEN MONTH(OrderDateOnly) IN (1,2,3) THEN profit ELSE 0 END) AS total_profit_Q1,
  SUM(CASE WHEN MONTH(OrderDateOnly) IN (4,5,6) THEN sales ELSE 0 END) AS total_sales_Q2,
  SUM(CASE WHEN MONTH(OrderDateOnly) IN (4,5,6) THEN profit ELSE 0 END) AS total_profit_Q2,
  SUM(CASE WHEN MONTH(OrderDateOnly) IN (7,8,9) THEN sales ELSE 0 END) AS total_sales_Q3,
  SUM(CASE WHEN MONTH(OrderDateOnly) IN (7,8,9) THEN profit ELSE 0 END) AS total_profit_Q3,
  SUM(CASE WHEN MONTH(OrderDateOnly) IN (10,11,12) THEN sales ELSE 0 END) AS total_sales_Q4,
  SUM(CASE WHEN MONTH(OrderDateOnly) IN (10,11,12) THEN profit ELSE 0 END) AS total_profit_Q4
FROM superstore;

-- order in a table (using UNION ALL)
SELECT 'Q1' AS quarter,
       SUM(CASE WHEN MONTH(OrderDateOnly) IN (1,2,3) THEN sales ELSE 0 END) AS total_sales,
       SUM(CASE WHEN MONTH(OrderDateOnly) IN (1,2,3) THEN profit ELSE 0 END) AS total_profit
FROM superstore
UNION ALL
SELECT 'Q2' AS quarter,
       SUM(CASE WHEN MONTH(OrderDateOnly) IN (4,5,6) THEN sales ELSE 0 END),
       SUM(CASE WHEN MONTH(OrderDateOnly) IN (4,5,6) THEN profit ELSE 0 END)
FROM superstore
UNION ALL
SELECT 'Q3' AS quarter,
       SUM(CASE WHEN MONTH(OrderDateOnly) IN (7,8,9) THEN sales ELSE 0 END),
       SUM(CASE WHEN MONTH(OrderDateOnly) IN (7,8,9) THEN profit ELSE 0 END)
FROM superstore
UNION ALL
SELECT 'Q4' AS quarter,
       SUM(CASE WHEN MONTH(OrderDateOnly) IN (10,11,12) THEN sales ELSE 0 END),
       SUM(CASE WHEN MONTH(OrderDateOnly) IN (10,11,12) THEN profit ELSE 0 END)
FROM superstore
ORDER BY quarter; */

/*The data above shows that the period of October, November and December are our best selling months 
and our months where we bring in the most profit. 
Just by seeing this table, we can develop operation strategies pretty nicely as there is a clear buildup like 
a stock market rally from January to December then it dumps around the first 3 months. Let’s get into the regions. */

--4. What region generate the most profit?

SELECT Region, SUM(sales) AS TotalSales, SUM(profit) AS TotalProfit
FROM superstore
GROUP BY Region
ORDER BY TotalProfit DESC

-- Profit margin
SELECT Region, (SUM(Profit)/SUM(Sales)*100) AS ProfitMargin
FROM superstore
GROUP BY Region
ORDER BY ProfitMargin DESC

-- 5. What state and city brings in the highest sales and profits ?

-- state
SELECT TOP 10 
	State, SUM(sales) AS TotalSales, SUM(profit) AS TotalProfit, (SUM(Profit)/SUM(Sales)*100) AS ProfitMargin
FROM superstore
GROUP BY State
ORDER BY TotalProfit DESC

/*The decision was to include profit margins to see this under a different lens. 
The data shows the top 10 most profitable states. Besides we can see the total sales and profit margins. 
Profit margins are important and it allows us to mostly think long-term as an investor to see potential big markets. 
In terms of profits, California, New York and Washington are our most profitable markets and most present ones 
especially in terms of sales. Which, are so high that it would take so much for the profit margins to be higher. 
However the profits are great and the total sales show that we have the best part of our business share at 
those points so we need to boost our resources and customer service in those top states. */

-- city
SELECT TOP 10 
	City, SUM(sales) AS TotalSales, SUM(profit) AS TotalProfit, (SUM(Profit)/SUM(Sales)*100) AS ProfitMargin
FROM superstore
GROUP BY City
ORDER BY TotalProfit DESC

/* The top 3 cities that we should focus on are New York City, Los Angeles and Seattle.*/

-- 6. The relationship between discount and sales and the total discount per category
SELECT Discount, AVG(Sales) AS Avg_Sales
FROM superstore
GROUP BY Discount
ORDER BY Discount;

/* Then graph the table in excel, showing no correlation
They almost have no linear relationship. This noted by the correlation coefficient of -0.3 and the shape of the graph. 
However we can at least observe that at a 50% discount, our average sales are the highest it can be. 
Maybe it is a psychology technique or it’s just the right product category that is discounted.
*/

--Total discount per product category
SELECT Category, SUM(discount) AS total_discount
FROM superstore
GROUP BY CATEGORY
ORDER BY total_discount DESC;

/* So Office supplies are the most discounted items followed by Furniture and Technology. 
We will later dive in into how much profit and sales each generate. 
Before that, let’s zoom in the category section to see exactly what type of products are the most discounted.
*/

SELECT category, subcategory, ROUND(SUM(discount),2) AS total_discount
FROM superstore
GROUP BY category, subcategory
ORDER BY total_discount DESC;

/* Binders, Phones and Furnishings are the most discounted items. 
But the gap between binders and the others are drastic. 
We should check the sales and profits for the binders and other items on the list. 
But first let’s move on to the categories per state.*/