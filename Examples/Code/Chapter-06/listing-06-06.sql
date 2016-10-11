-- Listing 6-6. Example of Calling the GEOCODE Function
SELECT SDO_GCDR.GEOCODE
(
  'SPATIAL',
  SDO_KEYWORDARRAY('Clay Street', 'San Francisco, CA'),
  'US',
  'DEFAULT'
)
FROM DUAL;
