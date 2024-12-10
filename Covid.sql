Use PortfolioProject;

Select *
From CovidDeaths
Order by 3,4;

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Order by 1,2;

-- Checking likelihood of dying if you contract covid in India
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths
Where Location like 'India'
Order by 1,2;

-- Checking percentage of population that got covid
Select Location, date, total_cases, Population, (total_cases/population)*100 as PercentagePopulationInfected
From CovidDeaths
Where Location like 'India'
Order by 1,2;

-- Countries with highest infection rate compares to population
Select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc;

-- Countries with Highest Death Count per population
Select Location, Max(cast(total_deaths as Signed)) as TotalDeathCount
From CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc;

-- Continent Breakdown
Select continent, Max(cast(total_deaths as Signed)) as TotalDeathCount
From CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc;

-- Global Numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as Signed)) as total_deaths, SUM(cast(new_deaths as Signed))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
where continent is not null 
order by 1,2; 

 -- Diving into Vaccination Data
 -- Population vs Vaccinations
 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as signed)) OVER (Partition by dea.Location Order by dea.location, dea.Date)
as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;

-- CTE to perform further calculation on partition
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as signed)) 
OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac;

-- Utilizing Temporary Tables
DROP Temporary Table if exists PercentPopulationVaccinated;
Create Temporary Table PercentPopulationVaccinated (
Continent VARCHAR(255) CHARACTER SET UTF8MB4, 
Location VARCHAR(255) CHARACTER SET UTF8MB4,
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, STR_TO_DATE(dea.date, '%m/%d/%Y'), dea.population, vac.new_vaccinations
, SUM(cast(CASE WHEN vac.new_vaccinations REGEXP '^[0-9]+$' THEN vac.new_vaccinations
                  ELSE 0
                END AS SIGNED)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and STR_TO_DATE(dea.date, '%m/%d/%Y') = STR_TO_DATE(vac.date, '%m/%d/%Y');
    
Select *, (RollingPeopleVaccinated/Population)*100 AS PercentPopulationVaccinated
From PercentPopulationVaccinated;

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as signed)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null ;
