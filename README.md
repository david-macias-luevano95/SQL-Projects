# SQL Projects
# Nashville Housing Data Cleaning Project

This project demonstrates a full end-to-end SQL data cleaning workflow using Microsoft SQL Server. The dataset used is the **Nashville Housing** dataset, which contains property sales records. The objective of this project is to clean and prepare the data for further analysis and visualization.

---

## 📌 **Project Overview**

This project focuses on applying essential data cleaning techniques in SQL, including:

* Standardizing date formats
* Handling missing values
* Splitting complex address fields
* Normalizing categorical values
* Removing duplicates using window functions
* Dropping unnecessary columns

All transformations were performed in SQL Server using the `PortfolioProject.dbo.NashvilleHousing` table.

---

## 🛠️ **Tech Stack**

* **SQL Server 2022**
* **T-SQL** for data cleaning
* **SSMS (SQL Server Management Studio)** for database management

---

## ✅ **Steps Performed**

### 1. **Standardize Date Format**

The `SaleDate` column was converted from datetime to a clean `DATE` format. A new column `SaleDateConverted` was added when the original column could not be overwritten.

### 2. **Populate Missing Property Addresses**

Missing `PropertyAddress` values were filled by matching records with the same `ParcelID`. A self-join was used along with `ISNULL()`.

### 3. **Split Address Into Separate Columns**

The `PropertyAddress` and `OwnerAddress` fields were split into:

* Street Address
* City
* State

Methods used:

* `SUBSTRING()` + `CHARINDEX()` for property addresses
* `PARSENAME()` (after replacing commas with periods) for owner addresses

### 4. **Normalize "SoldAsVacant" Values**

Values "Y" and "N" were standardized to "Yes" and "No" using a `CASE` expression.

### 5. **Remove Duplicate Records**

A `ROW_NUMBER()` window function was used to identify duplicate rows based on:

* ParcelID
* PropertyAddress
* SalePrice
* SaleDate
* LegalReference

Rows where `row_num > 1` were identified as duplicates.

### 6. **Drop Unused Columns**

Columns no longer needed were removed:

* `OwnerAddress`
* `TaxDistrict`
* `PropertyAddress`
* `SaleDate`

### 7. **(Optional) Importing Data Using BULK INSERT / OPENROWSET**

Advanced import methods were explored, including:

* `BULK INSERT`
* `OPENROWSET`

These options require SQL Server configuration changes.

---

## 📂 **Project Files**

* `DataCleaning.sql` – Full SQL script for all transformations (included above)
* This README file

---

## 📈 **What You Learn From This Project**

* Hands-on SQL data cleaning techniques
* How to structure and optimize ETL steps
* Practical use of string functions, window functions, and joins
* Techniques to prepare raw data for analytics or Power BI dashboards

---

## 🚀 **Future Improvements**

Potential future enhancements include:

* Automating the cleaning pipeline using SQL Server Agent
* Loading the cleaned data into a Power BI model
* Adding data validation rules or constraints

---

## 💬 **Contact**

If you have any questions or want to collaborate on data projects, feel free to reach out!

**Author:** David Macias

-----------------------------------------------------






#  COVID-19 Data Analysis with SQL

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
