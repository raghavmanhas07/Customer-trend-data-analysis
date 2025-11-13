show tables;
select * from customer limit 5;
select gender, sum(purchase_amount) as revenue 
from customer group by gender;

-- cutomers with purchases greater than avg amount
select customer_id, purchase_amount
from customer 
where discount_applied = 'Yes' and purchase_amount >= (select avg(purchase_amount) from customer);

-- top 5 products with highest review rating
select item_purchased, round(avg(review_rating), 2) as "Average product Rating"
from customer 
group by item_purchased
order by avg(review_rating) desc
limit 5;

-- Compare the avg purchase amounts between Standard and Express Shipping
select shipping_type,
round(AVG(purchase_amount),2) as average_purchase from customer 
where shipping_type in ('Standard', 'Express')
group by shipping_type;

-- Do subscribed customers spend more? Compare average spend and total revenue between subscribers and non-subs
select subscription_status,
count(customer_id) as total_customers,
round(avg(purchase_amount), 2) as avg_spend,
round(sum(purchase_amount), 2) as total_spend
from customer group by subscription_status
order by avg_spend, total_spend desc;

-- Which 5 products have the highest percentage of purchases with discounts applied?
select item_purchased,
round(sum(case when discount_applied = 'Yes' then 1 else 0 end)/ count(*) * 100,2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;

-- Segment customers into new, Returning, and Loyal based on their
-- total number of purchases and show the count of each segment.
with customer_type as (
select customer_id, previous_purchases,
case 
when previous_purchases = 1 then 'New'
when previous_purchases between 2 and 10 then 'Returning'
else 'Loyal'
end as customer_segment
from customer
)
select customer_segment, count(*) as "Number of Customers"
from customer_type
group by customer_segment;

-- Top 3 most purchased products within each category
with item_counts as (
select category,
item_purchased, count(customer_id) as total_orders,
ROW_NUMBER() over(partition by category order by count(customer_id) desc) as item_rank
from customer group by category, item_purchased
)
select item_rank, category, item_purchased, total_orders from item_counts
where item_rank <= 3;

-- Revenue contribution of each age group
select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;




