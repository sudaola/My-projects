


Select *
from Portfolio_file..CovidDeaths$
order by 3,4

--Select *
--from Portfolio_file..CovidVaccinations$
--order by 3,4

-- select data we will be needing

select location, date, total_cases, new_cases, population
from Portfolio_file..CovidDeaths$
order by 1,2

---looking at the total cases vs total deaths

select location, date, total_cases, total_deaths,(total_deaths/total_cases)* 100 as DeathRates
from Portfolio_file..CovidDeaths$
where location like '%states%'--- specific country
Order by 1,2 

----looking at total cases vs population i.e percentage of poulation that got covids
select location, date, population, total_cases, (total_cases/population)*100 as TotalRates
from Portfolio_file..CovidDeaths$
where location like '%states%'
order by 1,2


----looking at the country with the highest infection rate
select location, population, MAX((total_cases/population))*100 as infectedpopulation, MAX(total_cases) as infectionRates
from Portfolio_file..CovidDeaths$
---where location like '%states%'
Group by location, population
order by infectedpopulation desc


---showing countries with highest death count per population--
select location, MAX(cast(total_deaths as int)) as highestDeathCount
from Portfolio_file..CovidDeaths$
where continent is not null
Group by location, population
Order by highestDeathCount Desc


----lets break things down by continent
---showing continents with highest death counts per population--

select continent, MAX(cast(total_deaths as int)) as highestDeathCount
from Portfolio_file..CovidDeaths$
where continent is not null
Group by continent
Order by highestDeathCount Desc

---WORLD DATA--
Select SUM(new_cases) as totalnewcases, SUM(cast(new_deaths as int)) as totalnewdeaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
from Portfolio_file..CovidDeaths$
where continent is not null
--group by  date
order by 1,2




----looking at total population vs vaccination---

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as peoplevaccination
from Portfolio_file..CovidDeaths$ dea
join Portfolio_file..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


----USE CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from Portfolio_file..CovidDeaths$ dea
join Portfolio_file..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select * ,(RollingPeopleVaccinated/population)*100
From PopvsVac

---temp table
Drop table if exists #percentpopulationvaccinated
Create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
RollingPeoplevaccinated numeric
)
Insert into #percentpopulationvaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from Portfolio_file..CovidDeaths$ dea
join Portfolio_file..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select * ,(RollingPeopleVaccinated/population)*100
From #percentpopulationvaccinated



















































