-- Q1 returns (state_name,name)
SELECT state.name AS state_name, place.name AS name 
FROM place join state ON place.state_code=state.code
WHERE place.name LIKE '%City' AND type<>'city'
;

-- Q2 returns (type)
SELECT place.type
FROM place 
EXCEPT
SELECT mcd.type
FROM mcd
;

-- Q3 returns (state_name,no_city,no_town,no_village)
SELECT state.name AS state_name, 
	   COUNT(CASE WHEN place.type='city' THEN place.name ELSE null END) AS no_city,
	   COUNT(CASE WHEN place.type='town' THEN place.name ELSE null END) AS no_town,
       COUNT(CASE WHEN place.type='village' THEN place.name ELSE null END) AS no_village	   
FROM place JOIN state ON place.state_code=state.code
GROUP BY state.name
; 

-- Q4 returns (name,population,pc_population)
SELECT state.name AS name, 
	COALESCE(SUM(county.population),0) AS population, 
	COALESCE(ROUND(100*SUM(county.population)/total_population.total,1),0.0) AS pc_population
FROM state LEFT JOIN county ON county.state_code=state.code, 
	(SELECT SUM(population) AS total FROM county)total_population
GROUP BY state.name, total_population.total
;

-- Q5 returns (state_name,no_big_city,big_city_population)
SELECT state.name AS state_name, COUNT(place.name) AS no_big_city,	
		SUM(place.population) AS big_city_population 
FROM place JOIN state ON place.state_code=state.code
WHERE place.population>=100000 AND place.type='city'
GROUP BY state.name
HAVING COUNT(place.name)>=5 OR SUM(place.population)>=1000000
;


-- Q6 returns (state_name,county_name,population)
SELECT state.name AS state_name,county.name AS county_name, county.population
FROM state JOIN county ON state.code=county.state_code 
WHERE county.name IN (
		SELECT county_copy.name
		FROM county county_copy
		WHERE county_copy.state_code = state.code
		ORDER BY county_copy.population DESC
		LIMIT 5)
ORDER BY state.name,county.population DESC
;
						

