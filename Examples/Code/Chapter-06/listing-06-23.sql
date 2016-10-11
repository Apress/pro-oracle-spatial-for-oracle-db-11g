-- Listing 6-23. Populating the location Column of the branches Table
UPDATE branches
SET location = SDO_GCDR.GEOCODE_AS_GEOMETRY
(
  'SPATIAL',
  SDO_KEYWORDARRAY
  ( street_number || ' ' || street_name, city || ' ' || state || ' '
    || postal_code),
  'US'
);
COMMIT;
