SELECT DATABASE();
SHOW TABLES;
-- Q1. Count of records

SELECT * FROM foodprice LIMIT 5;

-- Q2. Find out from how many states data are taken 

SELECT distinct(admin1) AS 'States/UT' FROM foodprice
WHERE admin1 is not null;

-- Q3.states which have the highest prices of Rice under 
-- cereals and tubers category - Retail purchases

SELECT * FROM foodprice LIMIT 5;

SELECT admin1 AS State, MAX(price) AS Max_Price from foodprice 
WHERE commodity='Rice' and category='cereals and tubers' and pricetype='Retail' 
GROUP BY State
ORDER BY Max_Price DESC;

-- Q4. Find out the states and market which have had the highest prices of Rice
 -- under cereals and tubers category- Wholesale purchases

SELECT * FROM foodprice LIMIT 20;

SELECT admin1 AS State,market,MAX(price) AS Max_Price from foodprice 
WHERE commodity='Rice' and category='cereals and tubers' and pricetype='Wholesale' 
GROUP BY State,market
ORDER BY Max_Price DESC;

-- Q5.Find out the states and market which have had the highest prices of Milk under 
-- milk and dairy category- Retail purchases only

SELECT admin1 AS state,market,max(price) as max_price from foodprice
WHERE  commodity='Milk' and category='milk and dairy' and pricetype='Retail'
GROUP BY state,market
ORDER BY max_price DESC; 

-- Q6.Find out the states and market which have had the highest prices of Milk (pasteurized) 
SELECT admin1 AS state,market,max(price) as max_price from foodprice
WHERE  commodity='Milk (pasteurized)'
GROUP BY state,market
ORDER BY max_price DESC; 

-- Q7. Find out the states and market which have had the highest prices of Ghee (vanaspati)
-- under oil and fats- Retail purchases only
SELECT admin1 AS state,market,max(price) as max_price from foodprice
WHERE  commodity='Ghee (vanaspati)'
GROUP BY state,market
ORDER BY max_price DESC; 

-- Q8. Find out the avegarge price of oil and fats as whole
SELECT avg(price) AS Avg_Price FROM foodprice
WHERE category='oil and fats';

-- Q9. Find out the average prices for each type of oil under oil and fats
SELECT avg(price) AS Avg_Price ,commodity FROM foodprice
WHERE category='oil and fats'
GROUP BY commodity
ORDER BY Avg_Price DESC;

-- Q10. Find out the average prices of lentils
SELECT avg(price) AS Avg_Price,commodity  FROM foodprice
WHERE commodity='chickpeas' or commodity='Lentils (moong)' or
 commodity='Lentils (urad)' or commodity='Lentils (masur)'
 GROUP BY commodity
 ORDER BY Avg_Price DESC;
 
 -- Q11. Finding out the average price of Onions and tomatoes
 SELECT AVG(price) AS Avg_Price,commodity FROM foodprice
 WHERE category="vegetables and fruits"
 GROUP BY commodity
 ORDER BY Avg_Price DESC;
 
 -- Q12. Find out which commodity has the highest price 
 SELECT commodity,year(`date`) AS `Year`,max(price) as Max_Price 
 FROM foodprice WHERE pricetype = "Retail" 
 GROUP BY commodity,`date`
 ORDER BY Max_Price DESC;
 
 -- Q13 Find out the commodities which has the highest prices recently year 2022
 -- Tea comes first,oil comes second, lentils comes third
 SELECT commodity,max(price) as Max_Price 
 FROM foodprice WHERE pricetype = "Retail" and year(`date`)='2022'
 GROUP BY commodity
 ORDER BY Max_Price DESC;
 
 -- Q14 Create a table for zones
-- Select city and State from food prices and table and insert it into zones table

DROP TABLE IF EXISTS zones;

CREATE TABLE zones(
`City` varchar(50),
`State` varchar(50),
`zone` varchar(50),
PRIMARY KEY(`City`,`State`)
);

INSERT INTO zones
SELECT DISTINCT admin2,admin1,NULL FROM foodprice
WHERE admin2 IS NOT NULL;

DESC zones;
SELECT * from zones;

SET SQL_SAFE_UPDATES = 0;

UPDATE `zones` SET zone ='South'  WHERE State LIKE 'Tamil Nadu';
UPDATE `zones` SET zone ='South'  WHERE State LIKE 'Telangana';
UPDATE `zones` SET zone ='South'  WHERE State LIKE 'Andhra Pradesh';
UPDATE `zones` SET zone ='South'  WHERE State LIKE 'Kerala';
UPDATE `zones` SET zone ='South'  WHERE State LIKE 'Karnataka';

update `zones`set zone = 'North' WHERE State = 'Himachal Pradesh';
update `zones`set zone = 'North' WHERE State = 'Punjab';
update `zones`set zone = 'North' WHERE State = 'Uttarakhand';
update `zones`set zone = 'North' WHERE State = 'Uttar Pradesh';
update `zones`set zone = 'North' WHERE State = 'Haryana';

update `zones`set zone = 'East' WHERE State = 'Bihar';
update `zones`set zone = 'East' WHERE State = 'Orissa';
update `zones`set zone = 'East' WHERE State = 'Jharkhand';
update `zones`set zone = 'East' WHERE State = 'West Bengal';

update `zones`set zone = 'West' WHERE State = 'Rajasthan';
update `zones`set zone = 'West' WHERE State = 'Gujarat';
update `zones`set zone = 'West' WHERE State = 'Goa';
update `zones`set zone = 'West' WHERE State = 'Maharashtra';

update `zones`set zone = 'Central' WHERE State = 'Madhya Pradesh';
update `zones`set zone = 'Central' WHERE State = 'Chhattisgarh';

update `zones`set zone = 'North East' WHERE State = 'Assam';
update `zones`set zone = 'North East' WHERE State = 'Sikkim';
update `zones`set zone = 'North East' WHERE State = 'Manipur';
update `zones`set zone = 'North East' WHERE State = 'Meghalaya';
update `zones`set zone = 'North East' WHERE State = 'Nagaland';
update `zones`set zone = 'North East' WHERE State = 'Mizoram';
update `zones`set zone = 'North East' WHERE State = 'Tripura';
update `zones`set zone = 'North East' WHERE State = 'Arunachal Pradesh';

update `zones`set zone = 'Union Territory' WHERE State = 'Chandigarh';
update `zones`set zone = 'Union Territory' WHERE State = 'Delhi';
update `zones`set zone = 'Union Territory' WHERE State = 'Puducherry';
update `zones`set zone = 'Union Territory' WHERE State = 'Andaman and Nicobar';

SELECT * from zones;
SELECT * from foodprice LIMIT 5;

-- Q15 JOIN zones table and food_prices_ind AND Create a view
-- drop view commodity_prices;
Create view commodity_prices as
SELECT  fo.date,zo.City,zo.State,fo.market,zo.zone,fo.category,fo.commodity,fo.unit,fo.priceflag,fo.pricetype,fo.currency,fo.price,fo.usdprice
FROM foodprice fo
INNER JOIN  zones zo
WHERE fo.admin1 = zo.State;

select DISTINCT market from commodity_prices;

-- Q16 Average price of commodities zone wise 

SELECT zone AS Zone,commodity AS Commodity,AVG(price) AS Avg_Price
FROM commodity_prices
WHERE Zone is not null
GROUP BY Zone,Commodity
ORDER BY Commodity,Avg_Price DESC;

-- Q17 Find out the price differences between  2022 and 2012 

DROP table if exists PriceDifferenceB;

CREATE table PriceDifferenceB
(State varchar(255),
 zone varchar(255),
 category varchar(255),
 commodity varchar(255),
 avg_price_2012 double);
 
INSERT into PriceDifferenceB
SELECT State,zone,category,commodity,round(avg(price)) AS avg_price_2012
FROM commodity_prices
WHERE year(`date`)=2012 AND pricetype='Retail'
GROUP BY State,zone,category,commodity
;

SELECT * FROM PriceDifferenceB;
 
 CREATE table PriceDifferenceC
(State varchar(255),
 zone varchar(255),
 category varchar(255),
 commodity varchar(255),
 avg_price_2022 double);

INSERT into PriceDifferenceC
SELECT State,zone,category,commodity,round(avg(price)) AS avg_price_2022
FROM commodity_prices
WHERE year(`date`)=2022 AND pricetype='Retail'
GROUP BY State,zone,category,commodity
;

SELECT * FROM PriceDifferenceC;

SELECT b.State,b.zone,b.category,b.commodity,b.avg_price_2012,c.avg_price_2022,(c.avg_price_2022-b.avg_price_2012) AS diff_between_prices
FROM PriceDifferenceB b
JOIN PriceDifferenceC c
WHERE b.category = c.category and b.commodity = c.commodity
ORDER BY zone;

-- Q18 Find out the average prices of each category food products zone wise

SELECT zone,category,avg(price) as Avg_price 
FROM commodity_prices
WHERE pricetype='retail' and zone is not null
GROUP BY zone,category
ORDER BY category,Avg_price DESC
;

-- Q19 Find out the average prices of each commodity zone wise

SELECT zone,commodity,avg(price) as Avg_price 
FROM commodity_prices
WHERE pricetype='retail' and zone is not null
GROUP BY zone,commodity
ORDER BY commodity,Avg_price DESC
;

