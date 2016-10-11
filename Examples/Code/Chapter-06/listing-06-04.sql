-- Listing 6-4. Using the GEOCODE_AS_GEOMETRY Function with an Invalid House Number
SELECT SDO_GCDR.GEOCODE_AS_GEOMETRY
(
  'SPATIAL',
  SDO_KEYWORDARRAY('4500 Clay Street', 'San Francisco, CA'),
  'US'
)
FROM DUAL;
