-- Listing 6-16. Using GEOCODE_ALL over an Ambiguous Address
SET SERVEROUTPUT ON SIZE 32000
BEGIN
  FORMAT_ADDR_ARRAY (
    SDO_GCDR.GEOCODE_ALL (
      'SPATIAL',
      SDO_KEYWORDARRAY('12 Presidio', 'San Francisco, CA'),
      'US',
      'DEFAULT'
    )
  );
END;
/
