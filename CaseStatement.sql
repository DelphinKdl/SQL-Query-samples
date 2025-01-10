--2. CASE STATEMENT
/* Case statements are one of my favorite skills in SQL because they're one of the most versatile tools that can be applied to many concepts. 
They're fancy if statements that can intake unlimited conditions and produce an output based on the input. Every CASE statement ends with END. 
Don't forget that! You can (and should) also follow with as and a column name, aka an alias. 
Syntax:
case
   when [condition1] then [output]
   when [condition2] then [output]
   ...
   else ...
   end as column_name */

-- The default output if none of the conditions are met is NULL-- so be sure to take this into consideration based on your business problem.
-- Do NULLs make sense? If not, you can add an optional ELSE condition and specify a default return value if none of the other conditions are met. 
-- Sometimes 0, 'n/a', or 'Unknown' is a best fit. If you're coding an analysis for non-technical stakeholders (like for a front-facing dashboard), 
-- it's sometimes useful to make a descriptive string the default value since it's easily interpretable for stakeholders (as opposed to NULLs!).

-- 2.1 Categorizing Data
-- Categorize each subscription based on the revenue size using less than 1000 for small, 1000 - 4999 for medium, 5000 - 9,999 as large, and 10,000+ as extra large.
-- Is there a risk with putting extra large in else vs. hard coding when revenue >= 10000 then 'extra large' ?

SELECT 
    subscription_id,
    customer_id,
    revenue,
    case
        when revenue < 1000 then 'small'
        when revenue >= 1000 and revenue < 5000 then 'medium'
        when revenue >= 5000 and revenue < 10000 then 'large'
        when revenue >= 10000 then 'extra-large'
        else 'unknown'
        end as subscription_size
FROM subscriptions

-- 2.2 Why Order Matters
-- See what happens when you change the order of the conditions. Do you get different results?
-- Do you get different results if you don't clearly define the lower and upper interval and instead rely on waterfall logic?
-- NOTE: KEEP in mind waterfall logic, which is sequential steps that depend on the previous ones. 

SELECT 
    subscription_id,
    customer_id,
    revenue,
    case
        when revenue < 1000 then 'small'
        when revenue < 5000 then 'medium'
        when revenue < 10000 then 'large'
        when revenue >= 10000 then 'extra-large'
        end as subscription_size
FROM subscriptions


--2.3 Summarizing Categorical Data
-- Count the number of customers and subscriptions in each of the subscription size categories we created with the CASE statement.
-- Which counting method(s) should be using here for each of these counts?

SELECT 
    case
        when revenue < 1000 then 'small'
        when revenue < 5000 then 'medium'
        when revenue < 10000 then 'large'
        when revenue >= 10000 then 'extra-large'
        end as subscription_size,
    count(subscription_size) AS num_subs,
    count(distinct  customer_id) AS num_cust

FROM 
    subscriptions
GROUP BY
    1
-- 2.4 Creating Binary Columns
-- Case Statements Case Study: Payment Completions
-- Finance came to your team and is complaining about all of the customers who have signed up and have been set up
-- but haven't successfully completed payment yet. This is a huge issue in the business because they've already gained access, but their payment hasn't been completed yet.
-- It's possible that some of the users may be in their dunning period (a term popular in SaaS to describe the time where a company tries to collect payment after a failed payment or declined credit card) 
-- or maybe some just haven't started the workflow yet. It's also possible that some  may have started the payment workflow and abandoned it without completion for some reason. 
-- It's up to you to get to the bottom of it!

-- The subscriptions table logs and updates the current_payment_status for each subscription from the payment_status_log for easy access. 
-- We can answer this question using ONLY the subscriptions table, but we'll use the payment_status_log later on in the course.


SELECT 
    case 
        when current_payment_status = 5 then 1 -- Has completed payment process
        when current_payment_status != 5   then 0 -- have not completed
        end as complete_payment,
    count(*) as num_subs

FROM 
    subscriptions
WHERE 
    current_payment_status is not null
GROUP BY 
    1

--2.5 Aggregate Functions w/ CASE
-- What % of overall subscriptions have completed their payment status? (Hint: you'll need an aggregate function to calculate the %)
-- How can we interpret the null values in the current_payment_status column in the subscriptions table? How should we handle then? Test multiple ways.


SELECT 
   avg(case 
        when current_payment_status = 5 then 1 -- Has completed payment process
        when current_payment_status != 5   then 0 -- have not completed
        end) * 100 as perc_complete_payment

FROM 
    subscriptions
WHERE 
    current_payment_status is not null

-- 2.6 Marketing Lead Scoring
-- Case Statements Case Study: Marketing Lead Scoring
-- It's conference season and the marketing team is super stressed going into their conference this weekend. They've just beat down your door (or Zoom room) with an URGENT request!
-- You need to figure out who are the best prospects to target at the conference. They've asked you to help them score each prospect based on their requirements on who would be the best prospect for their new launch. They want you to pull a list of users based on the following business requirements:
-- Has purchased a decent amount of total users -- bigger revenue opportunity!
-- Only has purchased 2 products and has room to be upsold into others
-- Is a reliable payer -- we want someone who will pay us!
-- Want to exclude customer_ids that are not in the right market fit ('33667', '82772', '10010')

SELECT
    subs.customer_id,
    customer_name,
    sum(purchased_users) as total_users,
    case 
        when  sum(purchased_users) > 1200 and min(current_payment_status) = 5  then 'A'
        else 'B'
        end as upsell_oppportunity
FROM 
    subscriptions subs
JOIN
    customers cust
    ON subs.customer_id = cust.customer_id
WHERE 
    subs.customer_id not in ('33667', '82772', '10010')
GROUP BY
    1,2
HAVING 
    sum(purchased_users) > 1000 
    and  count(distinct product_id) <=2 
    and max(current_payment_status) = 5
ORDER BY 
    upsell_oppportunity asc

-- 2.7 Pivoting Data w/ CASE
-- Pivoting Data with CASE


-- One of the most powerful super powers of CASE is being able to Pivot data when combined with aggregate functions. We can turn a bunch of rows into aggregated columns-- kind of like making a pivot table in Excel! By wrapping CASE with aggregate functions, we can aggregate columns based on a condition. We can aggregate using sum(), max(), min(), count(), avg()-- any aggregate function! It really comes down to the business problem you want to solve. There also exists PIVOT & UNPIVOT in many SQL dialects, but I usually opt to use CASE and aggregate functions for ease. 


-- Here's a quick example that aggregates sales based on dates and outputs a column for each year (2023 & 2024):
SELECT
    product_category,
    SUM(CASE WHEN year = 2023 THEN sales_amount ELSE 0 END) AS sales_2023,
    SUM(CASE WHEN year = 2024 THEN sales_amount ELSE 0 END) AS sales_2024
FROM
    sales
GROUP BY
    product_category;

-- Case Study: Marketing Email Click Rates
-- Our marketing team has launched an email campaign and wants to track success using some events created in the frontend_event_log table. 
-- They're tracking who is clicking the email CTA (event_id = 5), who clicks the CTA on the landing page (event_id = 6), who clicks the view more button on the landing page (event_id = 7),
--  and who watches the video on the landing page (event_id = 8). Since it's possible that users can click buttons and complete events multiple times, they want to know how many times each user has completed each event.


--  Create a pivot table using CASE and an aggregate function that answers the business question: How many times has each user completed each of the marketing events? Use frontend_event_log to track the events defined in the frontend_events table. 
--  How does your answer change if you answer the business question: Has each user completed each of the marketing events? (Think yes or no for each event -- binary!).

SELECT 
    user_id,
    SUM(case when event_id = 5 then 1 else 0 end) as email_cta,
    SUM(case when event_id = 6 then 1 else 0 end) as landing_page_cta,
    SUM(case when event_id = 7 then 1 else 0 end) as landing_page_view_cta,
    SUM(case when event_id = 8 then 1 else 0 end) as landing_page_watch_video_cta
FROM
    FRONTEND_EVENT_LOG events
WHERE   
    event_id IN(5,6,7,8)
GROUP BY 
    1