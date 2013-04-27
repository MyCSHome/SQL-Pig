--Load the state, county, mcd, place and zip
RUN load_tables.pig


-- Find the counties of all states
state_and_county =
    JOIN state BY code,
        county BY state_code;
        
-- Group by state name
state_and_county_groupByState = 
    GROUP state_and_county
    BY state::name;
        
        
-- Sum up the population and land area in each group and project just those columns necessary for the query
state_and_population_and_land =
    FOREACH state_and_county_groupByState
    GENERATE group AS state_name,
             SUM(state_and_county.county::population) AS population,
             SUM(state_and_county.county::land_area) AS land_area;
             

-- Sort by state name
state_and_population_and_land_ordered =
    ORDER state_and_population_and_land
    BY state_name;

STORE state_and_population_and_land_ordered INTO 'q2' USING PigStorage(',');

