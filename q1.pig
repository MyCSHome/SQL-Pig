-- Load the state, county, mcd, place and zip
RUN load_tables.pig


-- Find the counties of all states, but include states without any counties
state_and_county =
    JOIN state BY code LEFT OUTER,
        county BY state_code;
        
-- Find the states without any county records
state_without_county_records = 
    FILTER state_and_county
    BY county::state_code IS NULL;
        
        
-- Project just those columns necessary for the query
state_name_without_county_records =
    FOREACH state_without_county_records
    GENERATE state::name AS state_name;
             

-- Sort by state name
state_name_without_county_records_ordered =
    ORDER state_name_without_county_records
    BY state_name;

STORE state_name_without_county_records_ordered INTO 'q1' USING PigStorage(',');
