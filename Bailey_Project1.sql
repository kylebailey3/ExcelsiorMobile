/*
Project 1: Excelsior Mobile Report
Kyle Bailey
*/

USE ExcelsiorMobile;

-- 1 (Visualizations)

-- A
-- Return the first and last names of customers along with their usage of minutes, data, text and the total of their bill.
SELECT CONCAT(FirstName, ' ' ,LastName) AS 'Customer', Minutes, DataInMB, Texts, Total
FROM Subscriber AS S, LastMonthUsage AS LMU, Bill AS B
WHERE S."MIN" = LMU."MIN" AND LMU."MIN" = B."MIN"
ORDER BY Customer;

-- B
-- Return each city's average usage of minutes, data, and text along with their total bill.
SELECT City, AVG(Minutes) AS 'AvgMinutes', AVG(DataInMB) AS 'AvgData', AVG(Texts) AS 'AvgTexts', SUM(Total) AS 'TotalBill'
FROM Subscriber AS S, LastMonthUsage AS LMU, Bill AS B
WHERE S."MIN" = LMU."MIN" AND LMU."MIN" = B."MIN"
GROUP BY City
ORDER BY City;

-- C
-- Return each cities total minutes, data, texts and bill.
SELECT City, SUM(Minutes) AS 'TotalMinutes', SUM(DataInMB) AS 'TotalData', SUM(Texts) AS 'TotalTexts', SUM(Total) AS 'TotalBill'
FROM Subscriber AS S, LastMonthUsage AS LMU, Bill AS B
WHERE S."MIN" = LMU."MIN" AND LMU."MIN" = B."MIN"
GROUP BY City
ORDER BY City;

-- D
-- Return the average usage of minutes, data, and texts and total bill by mobile plan
SELECT PlanName, AVG(Minutes) AS 'AvgMinutes', AVG(DataInMB) AS 'AvgData', AVG(Texts) AS 'AvgTexts', SUM(Total) AS 'TotalBill'
FROM Subscriber AS S, LastMonthUsage AS LMU, Bill AS B
WHERE S."MIN" = LMU."MIN" AND LMU."MIN" = B."MIN"
GROUP BY PlanName
ORDER BY PlanName;

-- E
-- Returnt the sum of minutes, data, and text usage and totla bills by mobile plan
SELECT PlanName, SUM(Minutes) AS 'TotalMinutes', SUM(DataInMB) AS 'TotalData', SUM(Texts) AS 'TotalTexts', SUM(Total) AS 'TotalBill'
FROM Subscriber AS S, LastMonthUsage AS LMU, Bill AS B
WHERE S."MIN" = LMU."MIN" AND LMU."MIN" = B."MIN"
GROUP BY PlanName
ORDER BY PlanName;

-- 1 (Without Visualizations)

-- A
-- Return which two cities there are the most subscribers in
SELECT TOP(2) City, COUNT(City) AS 'SubscriberTotal'
FROM Subscriber
GROUP BY City
ORDER BY 'SubscriberTotal' DESC;

-- B
-- Return the cities with the least amount of subscribers
SELECT TOP(3) City, COUNT(City) AS 'SubscriberTotal'
FROM Subscriber
GROUP BY City
ORDER BY COUNT(City) ASC;

-- C
-- Return the cell phone plans with the most users (independant from city they live in)
SELECT TOP(3) PlanName, COUNT(PlanName) AS 'NumberOfUsers'
FROM Subscriber
GROUP BY PlanName
ORDER BY 'NumberOfUsers'  DESC;

-- 2

-- A
-- Return the count of cell phone types among all customers and the most used phone type.
SELECT Type, COUNT(Type) AS 'Users'
FROM Device
GROUP BY Type
ORDER BY 'Users' DESC;

-- B 
-- Return the customers who use the least used phone type
SELECT CONCAT(FirstName, ' ' ,LastName) AS 'Customer'
FROM Subscriber AS S, DirNums AS DN, Device AS D
WHERE S.MDN = DN.MDN AND DN.IMEI = D.IMEI
GROUP BY CONCAT(FirstName, ' ' ,LastName), Type
HAVING Type = 'Apple';

-- C 
-- Return the customers and the year of their phones that were released before 2018
SELECT  CONCAT(FirstName, ' ' ,LastName) AS 'Customer', YearReleased
FROM Subscriber AS S, DirNums AS DN, Device AS D
WHERE S.MDN = DN.MDN AND DN.IMEI = D.IMEI
AND YearReleased < 2018
ORDER BY 'Customer';

-- 3

-- A
-- Return the top three cities for data usage where none of the customers use unlimited data plans
SELECT TOP(3) SUM(DataInMB) AS 'UsageInMB', MP.Data AS 'DataPlan', City
FROM Subscriber AS S, LastMonthUsage AS LMU, MPlan AS MP
WHERE S.PlanName = MP.PlanName AND S."MIN" = LMU."MIN"
AND MP.Data != 'Unlimited'
GROUP BY MP.Data, City
ORDER BY 'UsageInMB' DESC;

-- 4

-- A
-- Return the first and last name of the customer whose bill is the most expensive every month
SELECT TOP(1) CONCAT(FirstName, ' ' ,LastName) AS 'Customer'
FROM Subscriber AS S, Bill AS B
WHERE S."MIN" = B."MIN"
ORDER BY Total DESC;

-- B
-- Return which mobile plan brings in the most revenue each month
SELECT TOP(1) PlanName, SUM(Total) AS 'Revenue'
FROM Subscriber AS S, Bill AS B
WHERE S."MIN" = B."MIN"
GROUP BY PlanName
ORDER BY Revenue DESC;

-- 5

-- A
-- Return which area code uses the most minutes and show how many minutes
SELECT TOP(1) ZipCode, SUM("Minutes") AS 'TotalMinutes'
FROM Subscriber AS S, LastMonthUsage AS LMU
WHERE S."MIN" = LMU."MIN"
GROUP BY ZipCode
ORDER BY TotalMinutes DESC;

-- B
-- Return which cities have the biggest difference in terms of minutes usage, use the difference of customers who use < 200 minutes and who use > 700 minutes
SELECT DISTINCT City 
FROM Subscriber AS S, LastMonthUsage AS LMU
WHERE S."MIN" = LMU."MIN"
	AND City IN
		(SELECT DISTINCT City
		FROM Subscriber AS S, LastMonthUsage AS LMU
		WHERE S."MIN" = LMU."MIN"
		GROUP BY City, LMU."Minutes"
		HAVING LMU."Minutes" < 200)
GROUP BY City, LMU."Minutes"
HAVING LMU."Minutes" > 700;