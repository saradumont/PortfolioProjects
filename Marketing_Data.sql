--Clean Data

Select *
from marketing_data$


select *
from marketing_data$
where id is null or year_birth is null or education is null or Marital_Status is null or [ Income ]  is null 

select Education, [ Income ]
from marketing_data$
where Education = 'master'

--There are NUlls in income but the range of salaries per education is to great so I would exclude those rows if analysing data or track data down if needed.
 select *
 from marketing_data$
 where Kidhome is null or teenhome is null or Dt_Customer is null or recency is null or mntwines is null or mntfruits is null
 
 select *
 from marketing_data$
 where MntMeatProducts is null or MntFishProducts is null or MntSweetProducts is null or MntSweetProducts is null or MntGoldProds is null or NumDealsPurchases is null

 select*
 from marketing_data$
 where NumWebPurchases is null or NumCatalogPurchases is null or NumStorePurchases is null or NumWebVisitsMonth is null or AcceptedCmp3 is null
	
 select*
 from marketing_data$
 where AcceptedCmp4 is null or AcceptedCmp5 is null or AcceptedCmp1 is null or AcceptedCmp2 is null or Response is null or Complain is null or Country is null

 --check for dulicates
 select id, count(id) as id_count
 from marketing_data$
 group by id
 having id > 1

 select *
 from marketing_data$
 where id = '6818'

 select *
 from marketing_data$
 where id = '9888'

--create new table with no duplicates
	select distinct *  
	into Distinct_marketing_data
	from marketing_data$

	select *
	from Distinct_marketing_data

--ids are different lengths not relevant to analysis

--checking data for consistancy 
select distinct education
from Distinct_marketing_data

select Distinct Marital_Status, count(marital_status)
from Distinct_marketing_data
group by Marital_Status

select distinct year_birth
from distinct_marketing_data

select distinct country
from Distinct_marketing_data

select distinct (complain)
from Distinct_marketing_data

select [ Income ]
from Distinct_marketing_data
order by [ Income ] desc

--one income way higher then rest will leave out of analysis for income

--fix inconsistancy

update Distinct_marketing_data
set 
	Marital_Status = replace(marital_status, 'YOLO', 'Single')

	update Distinct_marketing_data
set 
	Marital_Status = replace(marital_status, 'Absurd', 'Single')

		update Distinct_marketing_data
set 
	Marital_Status = replace(marital_status, 'Alone', 'Single')


	---find factors influencing web purchases
select *
from Distinct_marketing_data
order by NumWebPurchases DESC


select sum(NumWebPurchases) as amount_web_purchase, Country
from Distinct_marketing_data
group by country
order by sum(NumWebPurchases) desc

select sum(NumWebPurchases) as amount_web_purchase, Marital_Status
from Distinct_marketing_data
group by Marital_Status
order by sum(NumWebPurchases) desc

select sum(NumWebPurchases) as amount_web_purchase, NumDealsPurchases
from Distinct_marketing_data
group by NumDealsPurchases
order by sum(NumWebPurchases) desc


select sum(NumWebPurchases) as amount_web_purchase, Year_Birth
from Distinct_marketing_data
group by Year_Birth
order by sum(NumWebPurchases) desc

select sum(NumWebPurchases) as amount_web_purchase, Kidhome
from Distinct_marketing_data
group by Kidhome
order by sum(NumWebPurchases) desc

select sum(NumWebPurchases) as amount_web_purchase, Teenhome
from Distinct_marketing_data
group by Teenhome
order by sum(NumWebPurchases) desc

select sum(NumWebPurchases) as amount_web_purchase, NumWebVisitsMonth
from Distinct_marketing_data
group by NumWebVisitsMonth
order by sum(NumWebPurchases) desc


select*
from Distinct_marketing_data

-- Which marketing compagne where the most sucessful

select sum(acceptedcmp1) as FIRST, sum(acceptedcmp2) as SECOND, sum(acceptedcmp3) as THIRD, sum(acceptedcmp4) AS FOURTH, sum(acceptedcmp5) AS FIFTH
from Distinct_marketing_data

--AVERAGE COSTOMER
SELECT round(AVG(YEAR_BIRTH),2) as avg_birth_year,  round(AVG([ Income ]),2) as avg_income, round(AVG(KIDHOME),2) as avg_kids, round(AVG(TEENHOME),2) as avg_teen
from Distinct_marketing_data
where [ Income ] is not null and [ Income ] <200000;

select count(marital_status), Marital_Status
from Distinct_marketing_data
group by Marital_Status;

select count(education), education
from Distinct_marketing_data
group by Education

---Which product is best preforming

select sum(MntFishProducts)as fish, sum(MntFruits) as fruits, sum(MntGoldProds) as gold, sum(MntMeatProducts) as meat, sum(MntSweetProducts) as sweets, sum(MntWines) as wine
from Distinct_marketing_data

--Which chanels are under proforming

select sum(NumCatalogPurchases) as catalog_purchases, sum(NumDealsPurchases) as deal_purchases, sum(NumStorePurchases) as store_purchases, sum(NumWebPurchases) as web_purchases
from Distinct_marketing_data



--- There are NUlls and outliers in income I lef them out of my analysis as there was lots of other data.
--- There was duplicate data so I did my analysis on a new table with distinc data.
--- Customers from Spain, who were married and who had no kids at home were more likely to make web purchases.
--- The fourth campagne was the most sucessful, third and fifthcampagne were a close second.
--- The avergage customer is born in 1968, has an income of 51 969.86, ha no kids, is married and education is graduation.
--- The best preforming product is wine with meat coming in second.
--- The most under preforming channel are catalog purchase and then web purchases.