select *
from space_missions$

--calculate mission per decade
SELECT year(date)/10*10 as decade, count(mission) as mission_per_decade
from [Space Data].[dbo].[space_missions$]
group by year(date)/10*10
order by decade

--calculate mission by company
select company, count(mission) misson_per_com
from [Space Data].[dbo].[space_missions$]
group by company



--calculate ressults of mission totals
select MissionStatus, count(mission) mission_status_count
from space_missions$
group by MissionStatus

--seperate out locaion
select
PARSENAME(REPLACE(location, ',','.'), 2) as state_province,
PARSENAME(REPLACE(location, ',','.'), 1) as country
from [Space Data].[dbo].[space_missions$]

alter table space_missions$
add Country nvarchar(255)

update space_missions$
set Country = PARSENAME(REPLACE(location, ',','.'), 1)

alter table space_missions$
add State_Province nvarchar(255)

update space_missions$
set State_Province = PARSENAME(REPLACE(location, ',','.'), 2)

--the company astra's address is different so it did not seperate out country 
select company
from space_missions$
where country is null

select company, isnull(country,'USA')
from space_missions$
where company = 'astra'

update space_missions$
set country = 'USA'
where country is null



--calculate percent mission success per country per decade

with success(country, decade, sucessful_missions) as
(select m.country, year(m.date)/10*10 as decade, count(m.mission) as successful_missions
from space_missions$ as m
Where MissionStatus = 'Success' 
group by m.Country, year(m.date)/10*10),



totals (country, decade, total_missions) as
(select country, year(date)/10*10 as decade, count(mission) as total_missions
from space_missions$
group by country, year(date)/10*10)


select t.country, t.decade, s.sucessful_missions, t.total_missions, convert(decimal(3,0), (Cast(s.sucessful_missions as numeric)/cast(t.total_missions as numeric)*100)) as success_percentage
from totals as t
join success as s
on t.country = s. country and t.decade = s.decade
group by t.country, t.decade, t.total_missions, s.sucessful_missions
order by t.country, t.decade

--calculate how many missions each rocket could do by company
select m.Country, m.Company, m.rocket, count(m.Rocket) as mission_per_rocket, t.missions_sucessful, RocketStatus
from space_missions$ as m
join (select rocket, count(missionstatus) as missions_sucessful
from space_missions$
where missionstatus = 'success'
group by Rocket) as T
on m.rocket = T.Rocket
group by m.Country, m.Company,m. Rocket, t.missions_sucessful, RocketStatus
order by m.Country, m.company, RocketStatus

--active rocket count by company
select country, count(rocketstatus) as num_rockets_active
from space_missions$
where rocketstatus = 'active'
group by country 

