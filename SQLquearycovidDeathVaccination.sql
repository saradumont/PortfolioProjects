
--Select Data
select location, date, total_cases, new_cases, total_deaths, population
from covid_deaths
order by location, date

--Total Cases vs Total Deaths (likelihood of dying if covid is contracted) in Canada
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from covid_deaths
where location like 'canada'
order by location, date


--Total Cases Vs Population in Canada
select location, date, population, total_cases, (total_cases/population)*100 as infection_rate
from covid_deaths
where location like 'canada'
order by location, date

--Countries with Highest Infection Rate vs Popultion
select location, population, max(total_cases) as highest_infection_count, max((total_cases/population))*100 as infection_rate
from covid_deaths
group by location, population
order by infection_rate DESC

--Countries with the Highest Death Rate
select location, max(cast(total_deaths as int)) as total_death_count
from covid_deaths
where continent is not null
group by location, population
order by total_death_count DESC

--Total Death Rate by Continent
select location, max(cast(total_deaths as int)) as total_death_rate
from covid_deaths
where continent is Null and location NOT LIKE '%income'
group by location
order by total_death_rate DESC

--Global Numbers
select sum(new_cases), sum(cast(new_deaths as int)), sum(cast(new_deaths as int))/sum(new_cases) *100 as death_percentage
from covid_deaths
where continent is not null
order by 1,2


-- Vaccination Rate
select death.continent, death.location, death.date, death.population, vac.new_vaccinations, 
sum(convert(bigint, vac.new_vaccinations)) over (partition by death.location order by death.location, death.date) as rolling_people_vac
from covid_deaths as death
join covid_vaccinations as vac
on death.location = vac.location and death.date = vac.date
where death.continent is not null
order by 2,3

--Use CTE
WITH pop_vs_vac (continent, location, date, population, new_vaccination, rolling_people_vac)
as
(
select death.continent, death.location, death.date, death.population, vac.new_vaccinations, 
sum(convert(bigint, vac.new_vaccinations)) over (partition by death.location order by death.location, death.date) as rolling_people_vac
from covid_deaths as death
join covid_vaccinations as vac
on death.location = vac.location and death.date = vac.date
where death.continent is not null
)
select*, (rolling_people_vac/population)*100 as vac_rate
from pop_vs_vac


DROP Table if exists #vaccination_rate
create table #vaccination_rate
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vac numeric)
insert into #vaccination_rate
select death.continent, death.location, death.date, death.population, vac.new_vaccinations, 
sum(convert(bigint, vac.new_vaccinations)) over (partition by death.location order by death.location, death.date) as rolling_people_vac
from covid_deaths as death
join covid_vaccinations as vac
on death.location = vac.location and death.date = vac.date
where death.continent is not null



--create view tp store for later visulizations

Create View vaccination_rate as
select death.continent, death.location, death.date, death.population, vac.new_vaccinations, 
sum(convert(bigint, vac.new_vaccinations)) over (partition by death.location order by death.location, death.date) as rolling_people_vac
from covid_deaths as death
join covid_vaccinations as vac
on death.location = vac.location and death.date = vac.date
where death.continent is not null
