/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [order_details_id]
      ,[order_id]
      ,[pizza_id]
      ,[quantity]
  FROM [pizza].[dbo].[order_details$]

  select pizza_id, count(quantity) as quantity
  from [pizza].[dbo].[order_details$]
  group by pizza_id
  order by quantity desc, pizza_id

   select pizza_id, count(quantity) as quantity
  from [pizza].[dbo].[order_details$]
  where pizza_id like 'the_greek%' 
  group by pizza_id
  order by quantity desc
  
  
  select pizza_id, substring(pizza_id,11, CHARINDEX('_',pizza_id)) as pizza_size
  from [pizza].[dbo].[order_details$]
  where pizza_id like 'the_greek%'

  select pizza_id, (parsename(replace(pizza_id,) , 1)), parsename(replace(pizza_id,'_','.') , 1.)
  from [pizza].[dbo].[order_details$]

  with pizza_quantity(pizza_id, quantity) as
  (select pizza_id, count(quantity) as quantity
  from [pizza].[dbo].[order_details$]
  group by pizza_id)
	**       

  select count
  from pizza_quantity



  --total number of pizzas sold
  select distinct count(order_id)
  from [pizza].[dbo].[order_details$]


-- Average amount of pizza's ordered per order
with pizza_order (order_id, pizza_per_order) as
(
select order_id, count(quantity) as pizza_per_order
from  [pizza].[dbo].[order_details$]
group by order_id)

select avg(pizza_per_order)
from pizza_order


---percent of orders per day of the week
  select weekday, convert(decimal(3,2),(convert(decimal(7,2), count(weekday))/(select distinct convert(decimal(7,2),count(order_id)) from orders$))) as percentage_per_weekday
  from order_weekday
  group by weekday
  order by weekday DESC

--Average cost per order
select  d.order_details_id, d.pizza_id, d.quantity, p.price
from [pizza].[dbo].[order_details$] as d
join [pizza].[dbo].[pizzas$] as p
on d.pizza_id = d.pizza_id
order by order_details_id

select  d.order_id, sum(p.price)
from [pizza].[dbo].[order_details$] as d
join [pizza].[dbo].[pizzas$] as p
on d.pizza_id = d.pizza_id
group by order_id


--creat new table with all pizza iformation
  select p_t.pizza_type_id, p.pizza_id, p_t.name as pizza_name, p.size, p.price, p_t.category
  into pizza_merge
  from [pizza].[dbo].[pizza_types$] as p_t
  join pizzas$ as p
  on p_t.pizza_type_id = p.pizza_type_id

select*
from pizza_merge;

select *
from [pizza].[dbo].[order_details$]


with order_date_time (order_id, date_time) as
(select order_id, DATEADD(day, 0, date) + DATEADD(day, 0-DATEDIFF(day, 0, time), time) as date_time
from [pizza].[dbo].[orders$])


select o_d.order_details_id, o_d.order_id, o_d.pizza_id, o_d.quantity, d.date_time
into order_merge
from [pizza].[dbo].[order_details$] as o_d
join order_date_time as d
on o_d.order_id = d.order_id

select*
from order_merge;
select*
from pizza_merge

select o.order_id, o.order_details_id, o.pizza_id,p.category, o.quantity, o.date_time, p.pizza_name, p.size, p.price
into pizza_order
from order_merge as o
join pizza_merge as p
on o.pizza_id = p.pizza_id

select *
from pizza_order

 -- pizza ordered the most 
  select pizza_name, count(pizza_name)
  from pizza_order
  group by pizza_name
  order by count(pizza_name) desc

  --find out average cost per order 

  with cte (order_id, price_per_order)
  as
 ( select  order_id, sum(quantity*price) as price_per_order
  from pizza_order
  group by order_id)

select convert(decimal(4,2), avg(price_per_order))
from cte


select *
from pizza_order

--find out percent pizza ordered per hour
with cte (order_id, hour_ordered) as 
(
select distinct order_id, DATEPART(hh, date_time) as hour_ordered
from pizza_order
)

with cte (order_id, hour_ordered) as 
(
select distinct order_id, DATEPART(hh, date_time) as hour_ordered
from pizza_order
)


select  hour_ordered, convert(decimal(4,3) ,(convert(decimal(8,2), (count(hour_ordered))))/(convert(decimal(10,2), (select count(hour_ordered) from cte)))) as percent_ordered_per_hour
from cte
group by hour_ordered
order by hour_ordered


select *
from pizza_order


--find out most ordered size
select size, convert(decimal(4,3) ,(convert(decimal(7,2) ,count(size))/convert(decimal(8,2) ,(select count(size) from pizza_order)))) as percent_size_ordered
from pizza_order
group by size


--pizza's ordered per month

with cte (order_id, month_ordered) as 
(
select distinct order_id, DATENAME(month, date_time) as month_ordered
from pizza_order
)

select  month_ordered, convert(decimal(4,3) ,(convert(decimal(8,2), (count(month_ordered))))/(convert(decimal(10,2), (select count(month_ordered) from cte)))) as percent_ordered_per_hour
from cte
group by month_ordered
order by month_ordered


select * from pizza_order
---meat verse veggie pizza ordered
with cte(category, count) as 
(select category, count(category) as count
from pizza_order
group by category)

select (select sum(count) 
from cte
where category != 'Veggie')as meat_pizza_count, (select sum(count) 
from cte
where category = 'Veggie') as Veggie_pizza_count
from cte