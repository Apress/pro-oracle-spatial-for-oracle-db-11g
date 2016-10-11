-- Listing 6-17. Using GEOCODE_ALL over an Ambiguous Address
SET SERVEROUTPUT ON SIZE 10000
BEGIN
  FORMAT_ADDR_ARRAY (
    SDO_GCDR.GEOCODE_ALL (
    'SPATIAL',
    SDO_KEYWORDARRAY('YMCA', 'San Francisco, CA'),
    'US',
    'DEFAULT'
  )
);
END;
/
