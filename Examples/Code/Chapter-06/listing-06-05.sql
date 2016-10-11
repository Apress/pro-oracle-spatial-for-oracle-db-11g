-- Listing 6-5. Using the GEOCODE_AS_GEOMETRY Function with an Invalid Street Name
SELECT SDO_GCDR.GEOCODE_AS_GEOMETRY
(
  'SPATIAL',
  SDO_KEYWORDARRAY('Cloy Street', 'San Francisco, CA'),
  'US'
)
FROM DUAL;
