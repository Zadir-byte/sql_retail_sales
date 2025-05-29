	DROP TABLE IF EXISTS retail_sales;
   -- Inserting table --
   
   CREATE TABLE retail_sales
				(
                transactions_id	INT PRIMARY KEY,
                sale_date DATE,
                sale_time TIME,
                customer_id	INT,
                gender VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantiy	INT,
                price_per_unit FLOAT,	
                cogs FLOAT,
                total_sale FLOAT
                );

-- Checking for null values --
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL;

-- Delete null values if there
DELETE FROM retail_sales
WHERE transactions_id IS NULL;

-- Q1 How many unique customers we have?
SELECT count(distinct(customer_id))
FROM retail_sales;

-- Q2 How many unique customers we have?
SELECT count(distinct(category))
FROM retail_sales;

-- Q3 What are the category names?
SELECT distinct category
FROM retail_sales;

-- Q4 Retrieve all sales made on 5th November, 2022
SELECT *
FROM retail_sales
WHERE sale_date = "2022-11-05";

-- Q5 Retrieve all sales in clothing category and more than 3 units are sold on Nov, '22
SELECT *
FROM retail_sales
WHERE category = "clothing" AND sale_date LIKE "2022-11-%" AND quantiy >= 4;

-- Q5 Calculate total sales for each category
SELECT category, sum(total_sale)
FROM retail_sales
GROUP BY category;

-- Q6 Calculate average age of customers from beauty category
SELECT  avg(age)
FROM retail_sales
WHERE category = "Beauty";

-- Q7 Find all transactions where total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q8 Find total transactions made by each gender in each category
SELECT category, gender, count(*) AS num
FROM retail_sales
GROUP BY gender, category
ORDER BY category;

-- Q9 Find average sales each month find best selling year
WITH CTE_1 AS
	(
	SELECT YEAR(sale_date), MONTH(sale_date), avg(total_sale),
	RANK() OVER(partition by YEAR(sale_date) ORDER BY avg(total_sale) DESC) as crank
	FROM retail_sales
	GROUP BY 1,2
	)
SELECT * FROM CTE_1
WHERE crank = 1;

-- Q10 Find top 5 customers based on their sales
SELECT customer_id, sum(total_sale)
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q11 How many unique customers purchase from each category?
SELECT category, count(distinct customer_id)
FROM retail_sales
GROUP BY category;

-- Q12 Create shifts <12, 12-17, >17 and number of orders in each shift?
WITH CTE_1 AS
(
SELECT transactions_id, HOUR(sale_time),
CASE
WHEN HOUR(sale_time) < 12 THEN "Morning"
WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN "Afternoon"
WHEN HOUR(sale_time) >17 THEN "Evening"
END AS Shift
FROM retail_sales
)
SELECT Shift, count(*)
FROM CTE_1
GROUP BY Shift;



