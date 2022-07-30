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