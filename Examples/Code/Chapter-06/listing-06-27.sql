-- Listing 6-27. Automatic Geocoding with Address Correction
CREATE OR REPLACE TRIGGER branches_geocode
  BEFORE INSERT OR UPDATE OF street_name, street_number, postal_code, city, state 
  ON branches
  FOR EACH ROW

DECLARE
  input_address SDO_GEO_ADDR;
  geo_location SDO_GEOMETRY;
  geo_addresses SDO_ADDR_ARRAY;
  geo_address SDO_GEO_ADDR;
  update_address BOOLEAN;

BEGIN
  -- Format the input address
  input_address := sdo_geo_addr();
  input_address.streetname  := :new.street_name;
  input_address.housenumber := :new.street_number;
  input_address.settlement  := :new.city;
  input_address.postalcode  := :new.postal_code;
  input_address.region      := :new.state; 
  input_address.country     := 'US'; 
  input_address.matchmode   := 'DEFAULT'; 
  
  -- Geocode the address
  geo_addresses := sdo_gcdr.geocode_addr_all (
    'SPATIAL', 
    input_address
  );

  -- Check results
  if geo_addresses.count() > 1 then
    -- Address is ambiguous: reject
    geo_location := NULL;
  else
    -- Extract first or only match
    geo_address := geo_addresses(1);
    -- The following matchcodes are accepted:
    --   1 = exact match
    --   2 = only street type or suffix/prefix is incorrect
    --  10 = only postal code is incorrect
    if geo_address.matchcode in (1,2,10) then
      -- Geocoding succeeded: construct geometric point
      geo_location := sdo_geometry (2001, 8307, sdo_point_type (
        geo_address.longitude, geo_address.latitude, null),
        null, null);
      -- If wrong street type or postal code (matchcodes 2 or 10)
      -- accept the geocode and correct the address in the database
      if geo_address.matchcode <> 1 then
        update_address := true;
      end if;
    else
      -- For all other matchcodes, reject the geocode
      geo_location := NULL;
    end if;
  end if;

  -- Update loaction
  :new.location := geo_location;
  -- If needed, correct address
  :new.street_name := geo_address.streetname;
  :new.postal_code := geo_address.postalcode;

END;
/
