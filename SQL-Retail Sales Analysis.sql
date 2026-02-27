-- CREATE DATABASE
CREATE DATABASE retail_sales_analysis;

USE retail_sales_analysis;

-- DATA PREVIEW
SELECT * FROM retail_sales;

SELECT * FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantity IS NULL
OR cogs IS NULL
OR price_per_unit IS NULL
OR total_sale IS NULL;

-- DATA EXPLORATION

-- How many sales do we have?
SELECT COUNT(*) AS total_sales from retail_sales;

-- How many unique customers do we have?
SELECT COUNT(DISTINCT(customer_id)) AS total_customers FROM retail_sales;

-- How many different categories do we have?
SELECT DISTINCT(category) AS all_categories FROM retail_sales;

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS AND ANSWERS

-- Retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND quantity >= 4
AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';

-- Calculate the total sales for each category
SELECT category, SUM(total_sale) AS total_sales_per_category
FROM retail_sales
GROUP BY category;

-- Find the average age of customers who purchased items from the 'Beauty' category
SELECT category, ROUND(AVG(age),2) AS average_age
FROM retail_sales
WHERE category = 'Beauty';

-- Find all the transactions where the total sale is greater than 1000
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Find the total number of transactions made by each gender in each category
SELECT category, gender, COUNT(*)
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- 	Calculate the average sale for each month. Find out the best selling month in each year
SELECT * FROM (
SELECT YEAR(sale_date) AS `year`, MONTH(sale_date) AS `month`, ROUND(AVG(total_sale),2) AS total_sale,
RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS Ranking
FROM retail_sales
GROUP BY `year`, `month`
) AS t1
WHERE ranking = 1;

-- Find the top 5 customers based on highest total sales
SELECT customer_id, SUM(total_sale) AS total_sales_per_customer
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales_per_customer DESC;

-- Find the unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT(customer_id)) AS unique_customers FROM retail_sales
GROUP BY category;

-- Create each shift and number of orders (Example :- Morning <= 12, Afternoon Between 12 & 17, Evening > 17)
WITH hourly_sales
AS 
(
SELECT *,
CASE 
	WHEN HOUR (sale_time) < 12 THEN 'Morning'
    WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
END AS shift
FROM retail_sales
) 
SELECT shift, COUNT(*) AS total_orders FROM hourly_sales
GROUP BY shift;



















