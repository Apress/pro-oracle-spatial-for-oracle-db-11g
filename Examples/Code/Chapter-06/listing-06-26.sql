-- Listing 6-26. Automatic Geocoding of the branches Table Using a Simple Trigger
CREATE OR REPLACE TRIGGER branches_geocode
  BEFORE INSERT OR UPDATE OF street_name, street_number, postal_code, city
  ON branches
  FOR EACH ROW
DECLARE
  geo_location SDO_GEOMETRY;
BEGIN
  geo_location := SDO_GCDR.GEOCODE_AS_GEOMETRY (
    'SPATIAL',
    SDO_KEYWORDARRAY (
      :new.street_number || ' ' || :new.street_name,
      :new.city || ' ' || :new.postal_code),
    'US'
  );
  :new.location := geo_location;
END;
/
