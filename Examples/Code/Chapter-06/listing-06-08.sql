-- Listing 6-8. Example of Using the FORMAT_GEO_ADDR Procedure
SET SERVEROUTPUT ON
BEGIN
  FORMAT_GEO_ADDR (
    SDO_GCDR.GEOCODE (
      'SPATIAL',
      SDO_KEYWORDARRAY('Clay Street', 'San Francisco, CA'),
      'US',
      'DEFAULT'
    )
  );
END;
/
