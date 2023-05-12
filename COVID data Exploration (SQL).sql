Select * 
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4

--Select * 
--From PortfolioProject..CovidVaccinations
--Order by 3,4

--Selecting columns to use

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

--Total Cases vs Total Deaths
--percentage of covid deaths over time in United States

Select location, date, total_cases, total_deaths, ROUND(total_deaths/total_cases, 4)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
Order by 1,2

--Total Cases vs Population
--Infection rate over time in United States
Select location, date, total_cases, Population, ROUND(total_cases/Population, 4)*100 as InfectionRate
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Order by 1,2

--Countries with the highest Infection Rate compared to population
Select location, Population, MAX(total_cases)as HighestInfectionCount, MAX(ROUND(total_cases/Population, 4))*100 as InfectionRate
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
Order by InfectionRate desc

--Showing Countries with highest death count per population
Select location, MAX(Total_Deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location
Order by TotalDeathCount desc

--Showing Continent with highest death count 
Select location, MAX(Total_Deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null
Group by location
Order by TotalDeathCount desc



--COVID total cases and total deaths with percentage

Select location, MAx(total_cases) as total_cases, MAx(total_deaths) as total_deaths, ROUND(MAx(total_deaths)/MAx(total_cases),4)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
WHere location is not null
GROUP BY location
ORDER BY 2,3



-- Total Population vs Vaccination

Select d.continent, d.location, d.date, d.population,v.new_vaccinations,
SUM(Cast(v.new_vaccinations as bigint)) OVER (Partition by d.location Order by d.location, d.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths d
join PortfolioProject..CovidVaccinations v
	On d.location = v.location
	and d.date = v.date
Where d.continent is not null
order by 2,3



--USE of CTE

with PopvsVac (Continent, Location, date, population, new_vaccinations, RollingPeopleVaccinated)
as (

Select d.continent, d.location, d.date, d.population,v.new_vaccinations,
SUM(Cast(v.new_vaccinations as bigint)) OVER (Partition by d.location Order by d.location, d.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths d
join PortfolioProject..CovidVaccinations v
	On d.location = v.location
	and d.date = v.date
Where d.continent is not null
--order by 2,3

)
Select *, (RollingPeopleVaccinated/population)*100
From popvsvac

-- Temp table

Drop table if exists #PercentPopulationVaccinated 
Create table #PercentPopulationVaccinated
(
Continent varchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select d.continent, d.location, d.date, d.population,v.new_vaccinations,
SUM(Cast(v.new_vaccinations as bigint)) OVER (Partition by d.location Order by d.location, d.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths d
join PortfolioProject..CovidVaccinations v
	On d.location = v.location
	and d.date = v.date
Where d.continent is not null
order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated

-- View to store data for visualization
USE PortfolioProject
Go
Create View PercentPopulationVaccinated as
Select d.continent, d.location, d.date, d.population,v.new_vaccinations,
SUM(Cast(v.new_vaccinations as bigint)) OVER (Partition by d.location Order by d.location, d.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths d
join PortfolioProject..CovidVaccinations v
	On d.location = v.location
	and d.date = v.date
Where d.continent is not null
--order by 2,3

select * 
From PercentPopulationVaccinated