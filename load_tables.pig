-- Load the state, county, mcd, place and zip
state = 
    LOAD '/vol/automed/data/uscensus1990/state.tsv' 
    AS (code:int,abbr:chararray,name:chararray);

county = 
    LOAD '/vol/automed/data/uscensus1990/county.tsv' 
    AS (state_code:int,fips_code:int,name:chararray,type:chararray,population:int,housing_units:int,land_area:int,water_area:int,latitude:double,longitude:double);

place = 
    LOAD '/vol/automed/data/uscensus1990/place.tsv' 
    AS (state_code:int,fips_code:int,name:chararray,type:chararray,population:int,housing_units:int,land_area:int,water_area:int,latitude:double,longitude:double);

mcd = 
    LOAD '/vol/automed/data/uscensus1990/mcd.tsv' 
    AS (state_code:int,fips_code:int,fips_subdivision_code:int,name:chararray,type:chararray,population:int,housing_units:int,land_area:int,water_area:int,latitude:double,longitude:double);

zip = 
    LOAD '/vol/automed/data/uscensus1990/zip.tsv' 
    AS (state_code:int,zip_code:int,zip_name:chararray,longitude:double,latitude:double,population:int,allocation_factor:double);



-- Find the counties of all states, but include states without any counties
-- state_and_county =
--    JOIN state BY code LEFT OUTER, 
--         county BY state_code;

--DUMP state_and_county;
