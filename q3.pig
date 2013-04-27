--Load the state, county, mcd, place and zip
RUN load_tables.pig


-- Find the places of all states
state_and_place =
    JOIN state BY code,
        place BY state_code;
        
-- Group by state name
state_and_place_groupByState = 
    GROUP state_and_place
    BY state::name;
        
        
-- count the number of city, town, village in each state, and project just those columns necessary for the query
state_and_nocity_and_notown_and_novillage =
    FOREACH state_and_place_groupByState{
        city = 
            FILTER state_and_place
            BY place::type =='city';
        town = 
            FILTER state_and_place
            BY place::type =='town';
        village = 
            FILTER state_and_place
            BY place::type =='village';
        GENERATE group AS state_name,
             COUNT(city.place::name) AS no_city,
             COUNT(town.place::name) AS no_town,
             COUNT(village.place::name) AS no_village;
    }
             

-- Sort by state name
state_and_nocity_and_notown_and_novillage_ordered =
    ORDER state_and_nocity_and_notown_and_novillage
    BY state_name;

STORE state_and_nocity_and_notown_and_novillage_ordered INTO 'q3' USING PigStorage(',');

