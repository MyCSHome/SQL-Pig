--Load the state, county, mcd, place and zip
RUN load_tables.pig

--select all cities from place table
place_city = 
    FILTER place
    BY type == 'city';

-- Find the cities of all states
state_and_placecity =
    JOIN state BY code,
        place_city BY state_code;

-- Group by state name
state_and_placecity_groupByState =
    GROUP state_and_placecity
    BY state::name;


-- Find the 5 biggest cities in each state, and order in descending order
statename_and_fivebigcity= 
    FOREACH state_and_placecity_groupByState { 
        ordered = ORDER state_and_placecity by place_city::population DESC; 
        topfive = LIMIT ordered 5; 
        GENERATE group as state_name, topfive; 
} 

-- Flatten the topfive table
statename_and_fivebigcity_flattened = 
    FOREACH statename_and_fivebigcity
    GENERATE FLATTEN(topfive);

-- Project necessary columns
statename_and_city_and_population = 
    FOREACH statename_and_fivebigcity_flattened
    GENERATE topfive::state::name as state_name, topfive::place_city::name as city, topfive::place_city::population as population; 

-- Sort by state name
statename_and_city_and_population_ordered =
    ORDER statename_and_city_and_population
    BY state_name;

STORE statename_and_city_and_population_ordered INTO 'q4' USING PigStorage(',');


