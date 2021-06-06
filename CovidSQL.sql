--The data is collected from https://ourworldindata.org/coronavirus
Select *
From PortfolioProjects..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From PortfolioProjects..CovidVaccinations
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProjects..CovidDeaths
Where continent is not null
order by 1,2


--looking at total_cases vs total deaths
-- Show the likelihood of death if you lived in Thailand
Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
From PortfolioProjects..CovidDeaths
Where location like 'Thai%'
and continent is not null
order by 1,2


-- Looking at total cases vs population
--Show what percentage of population got covid

Select location, date, total_cases, Population, (total_cases/population) * 100 as PercentPopulationInfected
From PortfolioProjects..CovidDeaths
Where location like 'Thai%'
order by 1,2


Select location, date, total_cases, Population, (total_cases/population) * 100 as PercentPopulationInfected
From PortfolioProjects..CovidDeaths
--Where location like 'Thai%'
order by 1,2


-- Looking at country with highest infection rate compared to population
Select location, Population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population)) * 100 as PercentPopulationInfected
From PortfolioProjects..CovidDeaths
Group by location, Population
order by PercentPopulationInfected desc


--Showing Countries with the highest death count per Population
Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProjects..CovidDeaths
Where continent is not null
Group by location
order by TotalDeathCount desc

----Showing continents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProjects..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc


-- Global Numbers

Select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int)) / SUM(new_cases) * 100 as DeathPercentage
From PortfolioProjects..CovidDeaths
Where continent is not null
--Group by date
order by 1,2



--Looking at total population vs vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (rollingPeopleVaccinated/population) * 100
From PortfolioProjects..CovidDeaths as dea
Join PortfolioProjects..CovidVaccinations as vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2, 3


--Use CTE (Common table expression)
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths as dea
Join PortfolioProjects..CovidVaccinations as vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population) * 100
From PopvsVac;


--Temp table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255), 
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths as dea
Join PortfolioProjects..CovidVaccinations as vac
	On dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--Order by 2,3
Select *, (RollingPeopleVaccinated/Population) * 100
From #PercentPopulationVaccinated





--Create View to store data for later visualization

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths as dea
Join PortfolioProjects..CovidVaccinations as vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Create View GlobalNumber as
Select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int)) / SUM(new_cases) * 100 as DeathPercentage
From PortfolioProjects..CovidDeaths
Where continent is not null


Create View HighestDeathPerCountContinent as
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProjects..CovidDeaths
Where continent is not null
Group by continent

Select * 
From PercentPopulationVaccinated
