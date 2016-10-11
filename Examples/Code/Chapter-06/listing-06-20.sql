-- Listing 6-20. Example of Calling the GEOCODE_ADDR Function
SELECT SDO_GCDR.GEOCODE_ADDR
(
  'SPATIAL',
  GEO_ADDR_POI 
  (
    'US',               -- COUNTRY
    'Moscone Center'    -- POI_NAME
  )
)
FROM DUAL;

