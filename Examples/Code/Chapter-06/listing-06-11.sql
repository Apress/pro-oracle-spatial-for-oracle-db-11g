-- Listing 6-11. Using the GEOCODE Function with an Invalid House Number
SET SERVEROUTPUT ON
BEGIN
  FORMAT_GEO_ADDR (
    SDO_GCDR.GEOCODE (
      'SPATIAL',
      SDO_KEYWORDARRAY('4500 Clay Street', 'San Francisco, CA'),
      'US',
      'DEFAULT'
    )
  );
END;
/
