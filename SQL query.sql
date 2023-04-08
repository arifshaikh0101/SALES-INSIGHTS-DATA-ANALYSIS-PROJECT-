use `gdb023`;
select * from dim_customer;
select * from dim_product;
select * from fact_gross_price;
select * from fact_manufacturing_cost;
select * from fact_sales_monthly;


1.Provide the list of markets in which customer "Atliq Exclusive" operates its
business in the APAC region.

select  market from dim_customer where customer="Atliq Exclusive" and region="APAC";

2. What is the percentage of unique product increase in 2021 vs. 2020? The
final output contains these fields,
unique_products_2020
unique_products_2021
percentage_chg



select distinct count(product_code) as 'unique_products_2020' from fact_sales_monthly 
where date<='2020-12-31' and date>='2020-01-01';

select distinct count(product_code) as 'unique_products_2021' from fact_sales_monthly 
where date<='2021-12-31' and date>='2021-01-01';



3. Provide a report with all the unique product counts for each segment and
sort them in descending order of product counts. The final output contains 2 fields,
segment
product_count?



select distinct segment,count(product_code) as "product_count" from dim_product 
group by segment order by count(product_code) desc ;


5. 5.Get the products that have the highest and lowest manufacturing costs.
The final output should contain these fields,
product_code
product
manufacturing_cost

select dp.product_code,dp.product,
max(manufacturing_cost) as Max_manufacturing_cost, 
min(manufacturing_cost) as min_manufacturing_cost
from fact_manufacturing_cost fmc
join dim_product dp on fmc.product_code=dp.product_code;



8. In which quarter of 2020, got the maximum total_sold_quantity? The final
output contains these fields sorted by the total_sold_quantity,
Quarter
total_sold_quantity?



select *,count(sold_quantity) as 'total_sold', quarter(date) as 'quarter_sale'
from fact_sales_monthly 
where  date>='2020-01-01' and date<='2020-12-31' group by product_code;


ans=
select max(tsq.total_sold),tsq.quarter_sale
from
(select *,sum(sold_quantity) as 'total_sold', quarter(date) as 'quarter_sale'
from fact_sales_monthly 
where  date>='2020-01-01' and date<='2020-12-31' group by product_code) as tsq 
order by total_sold desc;



9. Which channel helped to bring more gross sales in the fiscal year 2021
and the percentage of contribution? The final output contains these fields,
channel
gross_sales_mln
percentage


ans=
select dc.channel,fgp.fiscal_year,
max(total_sales.total_sold*fgp.gross_price) as "total_gross_price" ,
(total_sales.sold_quantity/total_sales.total_sold)*100 as "percentage"
from fact_gross_price  fgp
join 
(select *,sum(sold_quantity) as 'total_sold'
from fact_sales_monthly where date>='2021-01-01' and date<='2021-12-31' group by product_code) as total_sales 
on fgp.product_code=total_sales.product_code
join dim_customer dc on total_sales.customer_code=dc.customer_code
where fgp.fiscal_year="2021";


10.Get the Top 3 products in each division that have a high
total_sold_quantity in the fiscal_year 2021? The final output contains these
fields,
division
product_code
product
total_sold_quantity
rank_order

select * from dim_customer;
select * from dim_product;
select * from fact_gross_price;
select * from fact_manufacturing_cost;
select * from fact_sales_monthly;

select dp.division,dp.product_code,dp.product,
total_sales.total_sold as total_sold_quantity,
rank() over(partition by division order by total_sales.total_sold ) as rank_order
from dim_product dp 
join
(
select *,sum(sold_quantity) as 'total_sold',
from fact_sales_monthly 
where date>='2021-01-01' and date<='2021-12-31' 
group by product_code) as total_sales 
on dp.product_code=total_sales.product_code 
group by dp.division
limit 9;