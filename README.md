# 🧠 COVID-19 Data Analysis with SQL

This project is part of my **Data Analytics Portfolio**, showcasing the use of **SQL** to explore and analyze global COVID-19 data.  
The analysis focuses on understanding infection trends, death rates, and vaccination progress across different countries and continents.

---

## 📊 Project Overview

Using data from *Our World in Data*, this project explores:

- Total COVID-19 cases, deaths, and population impact  
- Infection and death percentages by country and continent  
- Global vaccination progress over time  
- Aggregated trends ready for visualization and reporting

---

## 🎯 Objectives

- Perform **data cleaning and exploration** in SQL  
- Calculate **death and infection percentages**  
- Use **window functions** to create rolling totals  
- Compare global vaccination efforts  
- Create **views** and **temporary tables** for further visualization in Power BI

---

## ⚙️ Tools & Technologies

- **Microsoft SQL Server**
- **SQL Server Management Studio (SSMS)**
- **COVID-19 Dataset (Our World in Data)**
- **Power BI** (for future visualizations)

---

## 🧩 SQL Concepts Applied

| Concept | Description |
|----------|--------------|
| **SELECT, WHERE, ORDER BY** | Data exploration and filtering |
| **GROUP BY, SUM(), MAX()** | Aggregations and summarization |
| **Window Functions** | Calculating rolling vaccination totals |
| **CTE (Common Table Expressions)** | Simplifying complex queries |
| **Temporary Tables** | Storing intermediate results |
| **Views** | Preparing datasets for visualization |

---

## 📈 Sample Queries

### 1. Total Cases vs Total Deaths
```sql
SELECT Location, date, total_cases, total_deaths, 
       (total_deaths / total_cases) * 100 AS DeathPercentage
FROM ProjectClean..CovidDeaths$
WHERE location LIKE '%Mexico%'
ORDER BY 1, 2;
```
### 2. Highest Infection Rate by Country
```sql
SELECT Location, Population, 
       MAX(total_cases) AS HighestInfectionCount, 
       MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM ProjectClean..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;
```

### 3. Rolling People Vaccinated (CTE Example)
```sql
WITH PopvsVac AS (
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
           SUM(CONVERT(INT, vac.new_vaccinations)) 
               OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
    FROM ProjectClean..CovidDeaths$ dea
    JOIN ProjectClean..CovidVaccinations$ vac
         ON dea.location = vac.location AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT * 
FROM PopvsVac
WHERE Continent LIKE '%Asia%';
```



## 🌍 Insights

Smaller countries often show higher infection rates relative to population.

Death percentages vary significantly by continent.

Rolling vaccination totals help identify regions with steady progress.

## 📦 Repository Structure

## 📁 SQL-Covid19-Analysis
│
├── 📄 README.md
├── 📄 CovidDeaths_Clean.sql
├── 📄 CovidVaccinations_Clean.sql
├── 📄 Covid_Analysis.sql
└── 📊 PowerBI_Dashboard (coming soon)
