# COVID-19 Data Analysis Project

## Overview
This project utilizes SQL to analyze COVID-19 data, focusing on deaths, cases, and vaccinations. The analysis explores trends, calculates key metrics, and identifies insights about the pandemic's impact globally, regionally, and by country.

## Objectives
The project aims to:
- Examine global and regional COVID-19 trends.
- Calculate important metrics, such as death rates and infection percentages.
- Analyze vaccination rollout and its relationship to population.
- Use SQL techniques like Common Table Expressions (CTEs), temporary tables, and views for efficient data manipulation and calculation.

## Key Analyses
1. **Global Overview**
   - Summarized global cases, deaths, and calculated death percentages.
   - Breakdown of COVID-19 statistics by continents.

2. **Country-Specific Insights**
   - Determined the likelihood of dying from COVID-19 in specific countries, such as India.
   - Calculated the percentage of the population infected by COVID-19 in various locations.
   
3. **High-Infection and High-Death Regions**
   - Identified countries with the highest infection rates compared to population.
   - Analyzed countries with the highest death counts per population.

4. **Vaccination Analysis**
   - Explored vaccination trends by country and continent.
   - Used rolling sums to track cumulative vaccinations over time.
   - Calculated the percentage of the population vaccinated.

## Methodology
- **Data Sources**: The project uses two datasets, `CovidDeaths` and `CovidVaccinations`, which include daily records for cases, deaths, and vaccinations by location.
- **SQL Features**:
  - Joins: To combine data from deaths and vaccinations datasets.
  - Window Functions: To calculate rolling sums and percentages.
  - Common Table Expressions (CTEs): For modular and readable queries.
  - Temporary Tables: For intermediate calculations and reusable data.
  - Views: To create reusable queries for further analysis.
