SELECT * 
FROM PortofolioProject..CovidDeaths
ORDER BY 3,4;

/*SELECT * 
FROM PortofolioProject..CovidVaccinations
ORDER BY 3,4;
*/

SELECT Location, Date, total_cases, new_cases, total_deaths, population
FROM PortofolioProject..CovidDeaths
ORDER BY 1,2;


-- Perbadingan Total Kasus dan Total Kematian
SELECT
	Location,
	Date,
	total_cases,
	new_cases,
	total_deaths,
	population,
	ROUND((total_deaths/total_cases), 3) * 100 AS DeathPercentage
FROM PortofolioProject..CovidDeaths
ORDER BY 1,2;

-- Perbandingan Populasi yang Terjangkit Covid
SELECT
	Location,
	Date,
	population,
	total_cases,
	ROUND((total_cases/population), 3) * 100 AS CasesPercentage
FROM PortofolioProject..CovidDeaths
ORDER BY 1,2;

-- Negara dengan tingkat infeksi tertinggi dibandingkan dengan Populasi
	SELECT
		Location,
		population,
		MAX(total_cases) AS HighestInfectionCount,
		MAX((total_cases/population))*100 AS PercentPopulationInfection
	FROM PortofolioProject..CovidDeaths
	GROUP BY location, population
	ORDER BY PercentPopulationInfection DESC

-- Negara dengan tingkat Kematian tertinggi dibandingkan dengan Populasi
SELECT
	Location,
	MAX(CAST(total_deaths AS INT)) AS TotalDeathCount,
	MAX((total_deaths/population))*100 AS PercentPopulationDeath
FROM PortofolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Perbandingan Kematian terhadap Benua

-- Benua dengan tingkat kematian tertinggi dibandingkan dengan Populasi

SELECT
	continent,
	MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortofolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

 --Perbandingan Global

 SELECT
	Date,
	SUM(new_cases), 
	SUM(CAST(new_deaths AS INT)),
	SUM(CAST(new_deaths AS INT))/SUM(new_cases) * 100 AS DeathPercentage
FROM PortofolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;


-- Join Table Death And Vaccinate

SELECT *
FROM PortofolioProject..CovidDeaths AS dea
JOIN PortofolioProject..CovidVaccinations AS vac
	ON dea.location = vac.location
	AND
	dea.date = vac.date

-- Looking at total population and vaccination
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS INT)) 
		OVER(
			PARTITION BY dea.location
			ORDER BY dea.location,dea.date ) AS RollingVaccinations
	
FROM PortofolioProject..CovidDeaths AS dea
JOIN PortofolioProject..CovidVaccinations AS vac
	ON dea.location = vac.location
	AND
	dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;


WITH PopulationVSVaccination (continent, Location, Date,Population, New_Vaccination, RollingVaccinations)
AS
(
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS INT)) 
		OVER(
			PARTITION BY dea.location
			ORDER BY dea.location,dea.date ) AS RollingVaccinations
	
FROM PortofolioProject..CovidDeaths AS dea
JOIN PortofolioProject..CovidVaccinations AS vac
	ON dea.location = vac.location
	AND
	dea.date = vac.date
WHERE dea.continent IS NOT NULL
)

SELECT
	* ,
	(RollingVaccinations/Population)*100 AS RollingPercentage
FROM PopulationVSVaccination

CREATE VIEW TotalDeathCount AS
SELECT
	continent,
	MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortofolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
