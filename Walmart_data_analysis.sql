-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;
use walmartSales;


-- Create table
CREATE TABLE IF NOT EXISTS sale(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct decimal(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct decimal(11,9),
    gross_income DECIMAL(12, 4),
    rating int
);
select * from sale;

---------------------------------------------

-- Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening. 

---------------------------------------------

select time from sale;



select time,
case 
when time between "00:00:00" and "12:00:00" then "Morning"
when time between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening"
end as time_of_day
from sale;

alter table sale add column time_of_day varchar(20);
update sale set time_of_day= (
case 
when time between "00:00:00" and "12:00:00" then "Morning"
when time between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening" 
end);

select date,monthname(date) from sale;

alter table sale add  column Month varchar(12);

update sale set month= monthname(date) ;

-- How many unique cities does the data have?
select count(distinct(city)) from sale;

-- In which city is each branch?
select branch,city  from sale ; 

-- How many unique product lines does the data have?
select distinct(product_line) from sale;

-- What is the most common payment method?

-- What is the most selling product line? 
select sum(quantity),product_line from sale group by product_line order by sum(quantity) desc limit 1;

-- What is the total revenue by month?

select Month, sum(total) as Total_Revenue from sale group by month order by sum(total) desc;

-- What month had the largest COGS?

select month,sum(cogs) from sale group by month order by sum(cogs) desc limit 1;

-- -- What product line had the largest revenue? 
select product_line,sum(total) as Total_revenue from sale group by product_line order by sum(total) desc limit 1; 

-- What is the city with the largest revenue?
select city,sum(total) as Total_revenue from sale group by city order by sum(total) desc limit 1; 

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales


select avg(quantity) from sale;


SELECT 
    product_line,
    AVG(quantity),
    CASE
        WHEN
            AVG(quantity) > (SELECT 
                    AVG(quantity)
                FROM
                    sale)
        THEN
            'Good'
        ELSE 'Bad'
    END AS quality
FROM
    sale
GROUP BY product_line;

--  Which branch sold more products than average product sold?

select branch, sum(quantity) from sale group by branch  having sum(quantity)>(select avg(quantity) from sale) ;

-- What is the most common product line by gender?
select (product_line),gender,sum(quantity) from sale group by gender,product_line order by  sum(quantity) desc ;

-- What is the average rating of each product line?
select product_line, avg(rating) from sale group by product_line order by avg(rating);


-- How many unique customer types does the data have?

select distinct(customer_type) from sale;

-- How many unique payment methods does the data have? 
select distinct(payment) from sale;

-- What is the most common customer type? 

SELECT customer_type, COUNT(*) AS count
FROM sale
GROUP BY customer_type
ORDER BY count DESC
LIMIT 1;

-- Which customer type buys the most? 

select customer_type,sum(payment) from sale group by customer_type order by sum(payment);

-- What is the gender of most of the customers?
 select gender, count(*) as common from sale  group by gender order by common desc limit 1; 
 
 -- Which time of the day do customers give most ratings?
 select time_of_day,count(rating) from sale  group by time_of_day order by count(rating) desc;
 
 -- Which time of the day do customers give most ratings per branch?
  select time_of_day,count(rating),branch from sale  group by time_of_day,branch order by count(rating) desc;
  
  -- Which day for the week has the best avg ratings?
  
 SELECT DAYNAME(date) AS day_of_week, AVG(rating) AS avg_rating
FROM sale
WHERE rating IS NOT NULL
GROUP BY day_of_week
ORDER BY avg_rating DESC
LIMIT 1;
  


