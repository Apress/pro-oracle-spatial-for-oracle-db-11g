-- Listing 6-10. Using the GEOCODE Function with aValid House Number
SET SERVEROUTPUT ON
BEGIN
  FORMAT_GEO_ADDR (
    SDO_GCDR.GEOCODE (
    'SPATIAL',
    SDO_KEYWORDARRAY('1350 Clay', 'San Francisco, CA'),
    'US',
    'DEFAULT'
    )
  );
END;
/
