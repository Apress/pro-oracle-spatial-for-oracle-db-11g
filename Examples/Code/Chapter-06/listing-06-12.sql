-- Listing 6-12. Using the GEOCODE Function with an Invalid Postal Code
SET SERVEROUTPUT ON
BEGIN
  FORMAT_GEO_ADDR (
    SDO_GCDR.GEOCODE (
      'SPATIAL',
      SDO_KEYWORDARRAY('1350 Clay St', 'San Francisco, CA 99130'),
      'US',
      'DEFAULT'
    )
  );
END;
/
