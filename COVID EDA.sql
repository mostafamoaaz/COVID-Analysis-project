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

-- cases and deaths per day globaly

select date, SUM(new_cases) as new_cases_sum, SUM(cast(new_deaths as int)) as new_deaths_sum, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as death_percentage
from [covid project]..CovidDeaths$
where continent is not null 
group by date
order by 1, 2

-- total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location 
order by dea.location, dea.date) as total_people_vaccinated
from [covid project]..CovidDeaths$ dea
join [covid project]..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2, 3


-- CTE to show vaccinated percentage vs population

with pop_vs_vac (continent, location, date, population, new_vaccinations, total_people_vaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location 
order by dea.location, dea.date) as total_people_vaccinated
from [covid project]..CovidDeaths$ dea
join [covid project]..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select * ,(total_people_vaccinated/population)*100 as vaccinated_percentage
from pop_vs_vac



-- temp table 
drop table if exists #percent_population_vaccinated
create table #percent_population_vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
vaccinated_percentage numeric
)


insert into #percent_population_vaccinated

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location 
order by dea.location, dea.date) as total_people_vaccinated
from [covid project]..CovidDeaths$ dea
join [covid project]..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select * ,(vaccinated_percentage/population)*100 as vaccinated_percentage
from #percent_population_vaccinated


select *
from #percent_population_vaccinated



-- create view for later work wizualizations 

create view percent_population_vaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location 
order by dea.location, dea.date) as total_people_vaccinated
from [covid project]..CovidDeaths$ dea
join [covid project]..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null


select *
from percent_population_vaccinated