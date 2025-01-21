1-- Nesting Aggregate Function(or not!)
-- Explore how we can calculate the average number of subscriptions per customer without a CTE.

 SELECT 
    customer_id, 
    COUNT(*) as num_subS
FROM 
    subscriptions
GROUP By
    1

-- 2.Explore how we can calculate the average number of subscriptions per customer with a CTE.
with subs_per_customer as(
    SELECT 
        customer_id, 
        COUNT(*) as num_subS
    FROM 
        subscriptions
    GROUP By
        1
)
SELECT 
   avg(subs_per_customer) as avg_num_subs_per_customer
FROM
    subs_per_customer 
--3.  Descriptive Statistics w/ Aggregate Functions
-- Case Study: Finding the Distribution of a Variable
-- Imagine the marketing team is running an email campaign, and they've already determined how many users have participated in the campaign by opening the email and clicking on the CTA (call to action) link within the email.
--  After clicking the link, some users did in fact purchase a subscription on the website, but the conversion rate (click to buy ratio) was lower than expected.  They've brought up an interesting question: 
--     Is it possible that some users revisited the website through the email multiple times? In other words, maybe some users returned to the email multiple times to click on the link and get more information. 
--     If a user returned and clicked multiple times, it may indicate that they're very interested in getting more information and are still considering a purchase. 
--     Let's look at the distribution of email clicks to see if there are even any users who have clicked the link multiple times. We have to understand the past/current user behavior to determine what business actions to take next.


-- Pull descriptive statistics for the monthly revenues. You'll first have to aggregate (sum) revenue by month, and then pull descriptive stats on those monthly revenue. 
-- Consider using aggregate functions such as min(), max(), avg(), stddev(), median(), and percentile_cont().
with month_revenue as(
SELECT
    date_trunc('month',order_date)as order_month,
    sum(revenue) as month_renenue
from 
    subscriptions 
group by    
    1
)
select
    min(month_renenue) as min_renenue,
    max(month_renenue) as max_renenue,
    avg(month_renenue) as Avg_renenue,
    stddev(month_renenue) as stddev_renenue,
    median(month_renenue) as max_renenue,
    percentile_cont(0.25)WITHIN GROUP(ORDER BY month_renenue) as perc_25,
    percentile_cont(0.50)WITHIN GROUP(ORDER BY month_renenue) as perc_50,
    percentile_cont(0.75)WITHIN GROUP(ORDER BY month_renenue) as perc_75,
    perc_75-perc_25 as IQR
from 
    month_revenue