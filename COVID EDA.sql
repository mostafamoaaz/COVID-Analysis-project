<<<<<<< HEAD
-- percentage of death along the timeline of every country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from [covid project]..CovidDeaths$ 
order by 1 ,2

-- percentage of death along the timeline of egypt
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from [covid project]..CovidDeaths$ 
where location like 'egypt'
order by 2

-- percentage of infection along the timeline of every country

select location, date, total_cases, population, (total_cases/population)*100 as infection_rate
from [covid project]..CovidDeaths$ 
order by 1 ,2

-- percentage of infection along the timeline of every egypt

select location, date, total_cases, population, (total_cases/population)*100 as infection_rate
from [covid project]..CovidDeaths$ 
where location like 'egypt'
order by 2

-- highest infection rate across the countries

select location, max(total_cases) as highest_infection_count, population, max((total_cases/population)*100) as infection_rate
from [covid project]..CovidDeaths$ 
group by location, population
order by infection_rate desc

-- highest death counts across the countries

select location, max(cast(total_deaths as int )) as highest_death_count, population
from [covid project]..CovidDeaths$ 
where continent is not null
group by location, population
order by highest_death_count desc

-- highest death counts across the continents

select location, max(cast(total_deaths as int )) as highest_death_count
from [covid project]..CovidDeaths$ 
where continent is null
group by location
order by highest_death_count desc

-- global (every covid record and every death along the time line day by day)

select date, max(new_cases) as recorded_covid, max(cast(new_deaths as int )) as recorded_dead
from [covid project]..CovidDeaths$ 
group by date
order by 1

-- global total cases recorded covid and total death since the epidemic and percentage of dying from covid

select sum(new_cases) as recorded_covid, sum(cast(new_deaths as int )) as recorded_dead, (sum(cast(new_deaths as int ))/sum(new_cases) * 100) as death_percentage
from [covid project]..CovidDeaths$
where continent is not null

-- total population vs new vaccinations every day in each country

select dea.continent ,dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as accumulated_vaccinations
from [covid project]..CovidDeaths$ dea
join [covid project]..CovidVaccinations$ vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- create CTE for the previous complex query 

with pop_vac (continent, location, date, population, new_vaccinations, accumulated_vaccinations)
as
(
select dea.continent ,dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as accumulated_vaccinations
from [covid project]..CovidDeaths$ dea
join [covid project]..CovidVaccinations$ vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null

)

select location, population, max(accumulated_vaccinations) as people_vaccinated, max(accumulated_vaccinations/population)*100 as vaccinated_percentage
from pop_vac
group by location, population
order by vaccinated_percentage desc

-- create temp table for the previous complex query (function same as CTE but it is stored as physical table)

drop table if exists #pop_vac
create table #pop_vac
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
accumulated_vaccinations numeric
)

insert into #pop_vac
select dea.continent ,dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as accumulated_vaccinations
from [covid project]..CovidDeaths$ dea
join [covid project]..CovidVaccinations$ vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null

select location, population, max(accumulated_vaccinations) as people_vaccinated, max(accumulated_vaccinations/population)*100 as vaccinated_percentage
from #pop_vac
group by location, population
order by vaccinated_percentage desc


-- create a view for visualization purposes 

create view pop_vac as 
select dea.continent ,dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as accumulated_vaccinations
from [covid project]..CovidDeaths$ dea
join [covid project]..CovidVaccinations$ vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null


select location, population, max(accumulated_vaccinations) as people_vaccinated, max(accumulated_vaccinations/population)*100 as vaccinated_percentage
from pop_vac
group by location, population
order by vaccinated_percentage desc
=======
select *
from [covid project]..CovidDeaths$
order by 3, 4

select *
from [covid project]..CovidVaccinations$
order by 3, 4

select location, date, total_cases, new_cases, total_deaths, population
from [covid project]..CovidDeaths$
order by 1, 2

-- showing the death precentage of getting covid virus 
-- in other word how likely an infected person can die from covid
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_precentage
from [covid project]..CovidDeaths$
where location like '%egypt%'
order by 1, 2

-- total cases vs population

select location, date, population, total_cases, (total_cases/population)*100 as covid_percentage
from [covid project]..CovidDeaths$
where location = 'Egypt'
order by 1, 2

-- comparing countries highest infection rate per population

select location, population, MAX(total_cases) as highest_infection_count, MAX((total_cases/population))*100 as covid_percentage
from [covid project]..CovidDeaths$
group by location, population
order by covid_percentage desc

-- comparing countries highest death count per population

select location, MAX(cast(total_deaths as int)) as highest_death_count
from [covid project]..CovidDeaths$
where continent is not null
group by location
order by highest_death_count desc

-- comparing continents highest death count per population

select continent, MAX(cast(total_deaths as int)) as highest_death_count
from [covid project]..CovidDeaths$
where continent is not null
group by continent
order by highest_death_count desc


-- comparing continents highest infection rate per population

select continent, MAX(total_cases) as highest_infection_count, MAX((total_cases/population))*100 as covid_percentage
from [covid project]..CovidDeaths$
where continent is not null 
group by continent
order by covid_percentage desc

-- Global numbers 

-- cases adn deaths per day globaly

select date, SUM(new_cases) as new_cases_sum, SUM(cast(new_deaths as int)) as new_deaths_sum, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as death_percentage
from [covid project]..CovidDeaths$
where continent is not null 
group by date
order by 1, 2
>>>>>>> c57f30f8ab92f9288332e48b44ba9a240a9a157f
