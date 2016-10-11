-- Listing 6-14. Using the GEOCODE Function to Find a POI
SET SERVEROUTPUT ON
BEGIN
  FORMAT_GEO_ADDR (
    SDO_GCDR.GEOCODE (
      'SPATIAL',
      SDO_KEYWORDARRAY('Transamerica Pyramid', 'San Francisco, CA'),
      'US',
      'DEFAULT'
    )
  );
END;
/
