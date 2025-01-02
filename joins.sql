-- 1. Join Types


-- In SQL, there are many different ways to join tables.


-- INNER JOIN: Returns rows that have matching values in both tables. You should use it when you want to find matching rows between two tables.
-- LEFT JOIN: Returns all rows from the left table even if there are no matches in the right table. Use when you want to retrieve all rows from the left table, even if there are no matches in the right table. This method ensures you don't lose any rows in the left table.
-- RIGHT JOIN: Returns all rows from the right table, even if there are no matches in the left table. This is the opposite of a left join but isn't used much at all in the real world, so we won't practice them in this course. Use when you want to retrieve all rows from the right table, even if there are no matches in the left table (e.g., finding products without any sales).
-- FULL OUTER JOIN: Returns all rows when there is a match in either left or right table. Use when you want to combine all rows from both tables, regardless of whether there are matches.
-- SELF JOIN: Joins a table to itself to compare data within the same table. Use when you want to compare data within a single table (e.g., finding parent-child relationships).
-- ANTI JOIN: Returns all the rows in the left table that are NOT in the right table (where the right table key is null).


-- 1. 1INNER JOIN

-- Join the subscriptions and products table using the common column between both tables, product_ID, as a key to match & connect them.
SELECT
    *

FROM  subscriptions 
JOIN -- INNERJOIN because we only want keep subscription in the product table and vice verse
    products 
    ON subscriptions.product_id = products.product_id


-- 1.2 Aliases
-- Implement clear aliases into your lesson 1 query if you haven't already.
SELECT
     sub.subscription_id,
     sub.product_id,
     prod.product_id,
     prod.product_name

FROM  subscriptions as sub
JOIN -- INNERJOIN because we only want keep subscription in the product table and vice verse
    products as prod
    ON sub.product_id = prod.product_id

-- 1.3 Counting Basics w/ Inner Joins
--  Count subscriptions by product name using an inner join and explore different counting methods.
SELECT
    product_name,
    COUNT(*) as num_subs, -- counts all records in table(including nulls)
    COUNT(subscription_id) as num_subs2, -- counts non null values
    COUNT(upgraded_sub) as num_upgrated_subs
FROM 
    subscriptions subs
JOIN
    products  prod
    ON subs.product_id = prod.product_id
GROUP BY
    1 -- mean first column in selection 

-- 1.4 LEFT JOINS
-- Count subscriptions by product name using a left join and explore different counting methods. Compare these results to the inner join. What's different?

SELECT
    prod.product_name,
    count(subs.subscription_id) as num_subs,
FROM
    subscriptions subs
LEFT JOIN
    products prod
    ON subs.product_id = prod.product_id
group by
    1

-- 1.5 Anti Join
-- Are there any products that haven't had any subscriptions yet? 

SELECT
    prod.product_id,
    prod.product_name,
    subs.subscription_id
FROM
    products prod 
LEFT JOIN
    subscriptions subs
    ON prod.product_id = subs.product_id
WHERE 
    subs.product_id IS NULL

-- 1.6 Tables with No Overlap

-- Explore subscription_product_1 and subscription_product_2 with different joins. Do they have any keys in common? How do you interpret this?
SELECT
    *
FROM subscription_product_1 sp1

JOIN 
    subscription_product_2 sp2
    ON sp1.subscription_id = sp2.subscription_id

-- no return was displayed, which means there was not common subscription_id in both table


-- 1.7 Full Outer Join
--  If subscription_product_1 and subscription_product_2 have no keys in common, how can we return everything in both tables?

SELECT
    *
FROM
    SUBSCRIPTION_PRODUCT_1 sp1
FULL OUTER JOIN 
    SUBSCRIPTION_PRODUCT_2 sp2
    ON sp1.subscription_id = sp2.subscription_id

-- 1.8 The Diabolical Right Join
-- What's the opposite of a left join?

SELECT
    prod.product_id,
    prod.product_name,
    subs.subscription_id
FROM
    products prod 
RIGHT JOIN
    subscriptions subs
    ON prod.product_id = subs.product_id

-- 2.9 Multiple Join Conditions

-- Join the products table to the subscriptions table on their matching keys, and only join the products that have not been discontinued discontinued =  0 .
SELECT
    *
FROM products prod
JOIN 
    subscriptions subs
    ON prod.product_id = subs.product_id
    AND prod.discontinued = 0

-- 1.10 Filtering Data w/ ON vs. WHERE

-- Join the products table to the subscriptions table on their matching keys, and filter for only subscriptions placed in 2024 or later. Use 2 different methods to filter the data. 

SELECT
    subscription_id,
    subs.product_id as products_id_subs,
    prod.product_id as product_id_prod,
    product_name,
    subs.order_date,
FROM 
    products prod
JOIN
    subscriptions subs
    ON prod.product_id = subs.product_id
    AND subs.order_date >= '2024-01-01'

-- 1.11 oin Multiple Tables
-- Using your subscriptions and products table join, bring in the customer_name field from the customers table.

 SELECT
    subscription_id,
    subs.product_id as products_id_subs,
    prod.product_id as product_id_prod,
    product_name,
    subs.customer_id as customer_id_subs,
    cust.customer_id as customer_id_cust,
    cust.customer_name as customer_name
FROM 
    products prod
JOIN
    subscriptions subs
    ON prod.product_id = subs.product_id
JOIN 
    CUSTOMERS cust
    ON subs.customer_id = cust.customer_id

    