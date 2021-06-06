--This SQl is focus on the situation of Tourism in Thailand 
SELECT *
FROM PortfolioProjects..NumberTourist

SELECT *
FROM PortfolioProjects..RevenueTourist

SELECT Year,SUM(Number_of_Tourist) as Number_Tourist_Per_Year
FROM PortfolioProjects..NumberTourist
Group by Year

SELECT Year,SUM(Number_of_Tourist) as Number_Tourist_Per_Year
FROM PortfolioProjects..NumberTourist
Group by Year
Order by Year desc

SELECT Year,SUM(Revenue) as Revenue_Tourist_Per_Year
FROM PortfolioProjects..RevenueTourist
Group by Year
Order by Year desc

With Percentage( Month, Year, Number_of_tourist, Revenue)
as
(
SELECT Num.Month, Num.Year, Num.Number_of_Tourist, Rev.Revenue
FROM PortfolioProjects..NumberTourist as Num
JOIN PortfolioProjects..RevenueTourist as Rev
	ON Num.Month = Rev.Month
	and Num.Year = Rev.Year
)
Select Year, SUM(Number_of_Tourist) as Number_of_Tourist_per_year, SUM(Revenue) as Revenue_Tourist_per_year
FROM Percentage
GROUP BY Year

SELECT 
	Num.Month, 
	Num.Year, 
	Num.Number_of_Tourist, 
	Rev.Revenue
Into 
	ThailandTourist
FROM 
	PortfolioProjects..NumberTourist as Num
JOIN PortfolioProjects..RevenueTourist as Rev
	ON Num.Month = Rev.Month
	and Num.Year = Rev.Year


SELECT
    * 
FROM
    sys.tables 
WHERE
    name
LIKE
    '%Thailand%'


SELECT *
FROM ThailandTourist
Order by Year 

--Calculate percentage chage by month and year for Number of Tourist
-- and Revenue
SELECT Month,
		Year, 
		(Number_of_Tourist - LAG(Number_of_Tourist,1) over (ORDER BY Year, Month)) / LAG(Number_of_Tourist,1) over (ORDER BY Year, Month) * 100 as mom_number,
		(Number_of_Tourist - LAG(Number_of_Tourist,12) over (ORDER BY Year, Month)) / LAG(Number_of_Tourist,12) over (ORDER BY Year, Month) * 100 as yoy_number,
		(Revenue - LAG(Revenue,1) over (ORDER BY Year, Month)) / LAG(Revenue,1) over (ORDER BY Year, Month) * 100 as mom_Revenue,
		(Revenue - LAG(Revenue,12) over (ORDER BY Year, Month)) / LAG(Revenue,12) over (ORDER BY Year, Month) * 100 as yoy_Revenue
FROM ThailandTourist
WHERE Number_of_Tourist <> 0 and Revenue <> 0

--Create View to use further in Visullization by Tableau
Create View PercentageChange as
SELECT Month,
		Year, 
		(Number_of_Tourist - LAG(Number_of_Tourist,1) over (ORDER BY Year, Month)) / LAG(Number_of_Tourist,1) over (ORDER BY Year, Month) * 100 as mom_number,
		(Number_of_Tourist - LAG(Number_of_Tourist,12) over (ORDER BY Year, Month)) / LAG(Number_of_Tourist,12) over (ORDER BY Year, Month) * 100 as yoy_number,
		(Revenue - LAG(Revenue,1) over (ORDER BY Year, Month)) / LAG(Revenue,1) over (ORDER BY Year, Month) * 100 as mom_Revenue,
		(Revenue - LAG(Revenue,12) over (ORDER BY Year, Month)) / LAG(Revenue,12) over (ORDER BY Year, Month) * 100 as yoy_Revenue
FROM ThailandTourist
WHERE Number_of_Tourist <> 0 and Revenue <> 0

Create View NumberAndRevenueOfTourism as
SELECT *
FROM ThailandTourist







