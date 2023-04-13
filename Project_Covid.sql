SELECT
  *
FROM
  PortfolioProject..CovidDeaths
WHERE
  continent is not null
ORDER BY
  3,4


--SELECT
--  *
--FROM
--  PortfolioProject..CovidVaccinations
--ORDER BY
--  3,4


--Selecting the data we are using

SELECT
  location,
  date,
  total_cases,
  new_cases,
  total_deaths,
  population
FROM
  PortfolioProject..CovidDeaths
WHERE
  continent is not null
ORDER BY
  1,2


--Total Cases vs Total Deaths
--Probability of dying if you have Covid in South Africa

SELECT
  location,
  date,
  total_cases,
  total_deaths,
  (total_deaths/total_cases)*100 AS Death_Rate
FROM
  PortfolioProject..CovidDeaths
WHERE
  location='South Africa'
ORDER BY
  1,2 


--Total Cases vs Population
--Probability of contracting Covid

SELECT
  location,
  date,
  total_cases,
  population,
  (total_cases/population)*100 AS Cumulative_Incidence
FROM
  PortfolioProject..CovidDeaths
WHERE
  location='South Africa'
ORDER BY
  1,2 


--Countries with highest infection rate compared to population

SELECT
  location,
  population,
  MAX(total_cases) AS Highest_Infection_Count,
  MAX((total_cases/population))*100 AS Infection_Rate
FROM
  PortfolioProject..CovidDeaths
--WHERE
--  location='South Africa'
WHERE
  continent is not null
GROUP BY
  location,
  population
ORDER BY
  Infection_Rate DESC 


--Countries with the highest daeth count per population

SELECT
  location,
  MAX(CAST(total_deaths AS int)) AS Total_Death_Count
FROM
  PortfolioProject..CovidDeaths
--WHERE
--  location='South Africa'
WHERE
  continent is not null
GROUP BY
  location
ORDER BY
  Total_Death_Count DESC 


--BY CONTINENT

SELECT
  continent,
  MAX(CAST(total_deaths AS int)) AS Total_Death_Count
FROM
  PortfolioProject..CovidDeaths
--WHERE
--  location='South Africa'
WHERE
  continent is not null
GROUP BY
  continent
ORDER BY
  Total_Death_Count DESC 


--GLOBAL NUMBERS

SELECT
  SUM(new_cases) as Total_cases,
  SUM(CAST(new_deaths AS int)) as Total_deaths,
  SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS Death_Rate
FROM
  PortfolioProject..CovidDeaths
--WHERE
--  location='South Africa'
WHERE
  continent is not null
--GROUP BY
--  date
ORDER BY
  1,2 


--  Total Population vs Vaccination

SELECT
  dea.continent,
  dea.location,
  dea.date,
  dea.population,
  vac.new_vaccinations,
  SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition by dea.location ORDER BY dea.location,
  dea.date) AS cumulative_vaccinated
FROM
  PortfolioProject..CovidDeaths AS dea
JOIN
  PortfolioProject..CovidVaccinations AS vac
ON
  dea.location=vac.location
  and dea.date=vac.date
WHERE
  dea.continent is not null
ORDER BY
  2,3


--USE CTE

WITH
  PopVsVac (continent, loacation, date, population,new_vaccinations, cumulative_vaccinated)
AS
(
SELECT
  dea.continent,
  dea.location,
  dea.date,
  dea.population,
  vac.new_vaccinations,
  SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition by dea.location ORDER BY dea.location,
  dea.date) AS cumulative_vaccinated
  --(cumulative_vaccinated/population)*100
FROM
  PortfolioProject..CovidDeaths AS dea
JOIN
  PortfolioProject..CovidVaccinations AS vac
ON
  dea.location=vac.location
  and dea.date=vac.date
WHERE
  dea.continent is not null
  )

SELECT
  *,
  (cumulative_vaccinated/population)*100
FROM
  PopVsVac


--USE Temp table

DROP table if exists #population_vaccinated
CREATE table #population_vaccinated
  (
  continent nvarchar(100),
  location nvarchar(100),
  date datetime,
  population numeric,
  new_vaccinations numeric,
  cumulative_vaccinated numeric,
  )
INSERT INTO #population_vaccinated
SELECT
  dea.continent,
  dea.location,
  dea.date,
  dea.population,
  vac.new_vaccinations,
  SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition by dea.location ORDER BY dea.location,
  dea.date) AS cumulative_vaccinated
  --(cumulative_vaccinated/population)*100
FROM
  PortfolioProject..CovidDeaths AS dea
JOIN
  PortfolioProject..CovidVaccinations AS vac
ON
  dea.location=vac.location
  and dea.date=vac.date
WHERE
  dea.continent is not null

SELECT
  *, (cumulative_vaccinated/population)*100  
FROM  
  #population_vaccinated



--Creating view for later visualizations

Create View population_vaccinated AS 
SELECT
  dea.continent,
  dea.location,
  dea.date,
  dea.population,
  vac.new_vaccinations,
  SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition by dea.location ORDER BY dea.location,
  dea.date) AS cumulative_vaccinated
  --(cumulative_vaccinated/population)*100
FROM
  PortfolioProject..CovidDeaths AS dea
JOIN
  PortfolioProject..CovidVaccinations AS vac
ON
  dea.location=vac.location
  and dea.date=vac.date
WHERE
  dea.continent is not null

