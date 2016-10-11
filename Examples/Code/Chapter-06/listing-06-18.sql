-- Listing 6-18. Example of Calling the GEOCODE_ADDR Function
SELECT SDO_GCDR.GEOCODE_ADDR
(
  'SPATIAL',
  SDO_GEO_ADDR 
  (
    'US',               -- COUNTRY
    'DEFAULT',          -- MATCHMODE
    '1200 Clay Street', -- STREET
    'San Francisco',    -- SETTLEMENT
    NULL,               -- MUNICIPALITY
    'CA',               -- REGION
    '94108'             -- POSTALCODE
  )
)
FROM DUAL;
