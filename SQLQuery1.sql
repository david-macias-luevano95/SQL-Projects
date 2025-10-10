SELECT  * 
FROM ProjectClean..CovidDeaths$
ORDER BY 3,4


select *
from ProjectClean..CovidVaccinations$
order by 3,4

-- select data that we are going to be using 

select Location, date, total_cases, new_cases, total_deaths, population
from ProjectClean..CovidDeaths
order by 1,2


--loking at Total Cases vs Total Deaths

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from ProjectClean..CovidDeaths$
where location like '%Mexico%'
order by 1,2

 --Loking at Total Cases vs Population
 -- show what percentage of population got covid

select Location, Population,  total_cases, (total_deaths/population)*100 as DeathPercentage
from ProjectClean..CovidDeaths$
where location like '%states'
order by 1,2


--Looking at contries with highest infection rate compared to population 

select Location,Population, Max(total_cases) as HighestInfectionCount, Max ((total_cases/population))*100 as PercentPopulationInfected
from ProjectClean..CovidDeaths$
--where location like '%Mexico%' 
where continent  is  not null
group by Location, Population 
order by PercentPopulationInfected desc

-- let's break things down by continent

-- Showing Continent with highest death count per Population

select continent, max(cast(Total_deaths as int)) as TotalDeathCount
from ProjectClean..CovidDeaths$
--where location like '%states%'
where continent is not null
group by continent 
order by TotalDeathCount desc


-- 



select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from ProjectClean..CovidDeaths$
where location like '%States%'
order by 1,2


-- Global Numbers

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int)) /sum(new_cases)*100 as DeathsPercentage, as pd
from ProjectClean..CovidDeaths$
where continent is not null 
Group By date
order by 1,2


--Looking at total pupulation vs vaccinations


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location,
	dea.date) as RollingPeopleVaccinated
from ProjectClean..CovidDeaths$ dea
join ProjectClean..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date= vac.date
where dea.continent is not null 
order by 2,3


-- Used CTE
with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location,
	dea.date) as RollingPeopleVaccinated
from ProjectClean..CovidDeaths$ dea
join ProjectClean..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date= vac.date
where dea.continent is not null 
--order by 2,3
)

select * 
from PopvsVac
where Continent like '%Asia%'


--temp table 
Drop Table if exists #PercentPopulationVaccined
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255), 
Date datetime , 
Population numeric, 
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location,
	dea.date) as RollingPeopleVaccinated
from ProjectClean..CovidDeaths$ dea
join ProjectClean..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date= vac.date
where dea.continent is not null 
--order by 2,3

select * 
from #PercentPopulationVaccinated

-- Creating Visualization for later 

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location order by dea.location,
	dea.date) as RollingPeopleVaccinated
from ProjectClean..CovidDeaths$ dea
join ProjectClean..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date= vac.date
where dea.continent is not null 
--order by 2,3

















