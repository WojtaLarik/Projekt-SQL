/*
 * 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 */

SELECT payroll_year,
	ROUND (AVG(cp.value)) AS `average_salary`,
	ROUND(((MAX(value) / MIN(value)) -1)*100) AS `percentage_increase`,
	cp.industry_branch_code,
	cpib.name
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib
	ON cp.industry_branch_code = cpib.code
WHERE cp.value_type_code = 5958
GROUP BY payroll_year, cpib.name
ORDER BY payroll_year;


DROP TABLE t_vojta_s_salary;


/*
 * 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první
 * a poslední srovnatelné období v dostupných datech cen a mezd?
 */

SELECT
	YEAR(date_from) AS year,
	cpc.name,
	cprice.value,
	cpc.price_unit
FROM czechia_price cprice
JOIN czechia_price_category cpc
	ON cprice.category_code = cpc.code
WHERE cpc.name = 'Mléko polotučné pasterované' OR cpc.name = 'Chléb konzumní kmínový'
GROUP BY year, cpc.name;

/*
 * Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
 */

SELECT cpc.name,
	cp.value,
	MIN(value) AS minimum,
	MAX(value) AS maximum,	
	ROUND(((MAX(value) / MIN(value)) -1)*100) AS percentage_increase
FROM czechia_price cp
JOIN czechia_price_category cpc
	ON cp.category_code = cpc.code
GROUP BY cpc.name
ORDER BY percentage_increase;