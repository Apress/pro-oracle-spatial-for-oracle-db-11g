-- Listing 6-24. Populating the location Column of the branches Table for German Addresses
UPDATE branches
SET location = SDO_GCDR.GEOCODE_AS_GEOMETRY
(
  'SPATIAL',
  SDO_KEYWORDARRAY
  ( street_name || ' ' || street_number || postal_code || ' ' || city),
  'DE'
);
COMMIT;
