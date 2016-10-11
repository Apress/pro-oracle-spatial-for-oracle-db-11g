-- Listing 6-2. Geocoding and Normalizing an Address
SELECT SDO_GCDR.GEOCODE
(
  'SPATIAL',
  SDO_KEYWORDARRAY
  (
    '3746 CONNECTICT AVE NW',
    'WASHINGTON, DC 20348'
  ),
  'US',
  'DEFAULT'
) geom
FROM DUAL ;
