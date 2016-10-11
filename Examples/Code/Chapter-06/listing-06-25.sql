-- Listing 6-25. Address Geocoding and Correction
SET SERVEROUTPUT ON SIZE 320000
DECLARE
  type match_counts_t is table of number;

  input_address     sdo_geo_addr;         -- Input address to geocode

  geo_addresses     sdo_addr_array;       -- Array of maching geocoded addresses
  geo_address       sdo_geo_addr;         -- Matching address
  geo_location      sdo_geometry;         -- Geographical location

  address_count     number;               -- Addresses processed
  geocoded_count    number;               -- Addresses successfully geocoded
  corrected_count   number;               -- Addresses geocoded and corrected
  ambiguous_count   number;               -- Ambiguous addresses (multiple matches)
  error_count       number;               -- Addresses rejected

  match_counts      match_counts_t        -- Counts per matchcode
    := match_counts_t();

  update_address    boolean;              -- Should update address ?

BEGIN

  -- Clear counters
  address_count := 0;
  geocoded_count := 0;
  error_count := 0;
  corrected_count := 0;
  ambiguous_count := 0;
  match_counts.extend(20);
  for i in 1..match_counts.count loop
    match_counts(i) := 0;
  end loop;

  -- Range over the customers
  for b in
    (select * from customers)
  loop

    -- Format the input address
    input_address := sdo_geo_addr();
    input_address.streetname  := b.street_name;
    input_address.housenumber := b.street_number;
    input_address.settlement  := b.city;
    input_address.postalcode  := b.postal_code;
    input_address.region      := b.state; 
    input_address.country     := 'US'; 
    input_address.matchmode   := 'DEFAULT'; 

    -- Geocode the address
    geo_addresses := sdo_gcdr.geocode_addr_all (
      'SPATIAL', 
      input_address
    );

    -- Check results
    update_address := false;
    address_count := address_count + 1;

    if geo_addresses.count() > 1 then

      -- Address is ambiguous: reject
      geo_location := NULL;
      ambiguous_count := ambiguous_count + 1;

    else
      -- Extract first or only match
      geo_address := geo_addresses(1);

      -- Keep counts of matchcodes seen
      match_counts(geo_address.matchcode) :=
        match_counts(geo_address.matchcode) + 1;

      -- The following matchcodes are accepted:
      --   1 = exact match
      --   2 = only street type or suffix/prefix is incorrect
      --  10 = only postal code is incorrect
      if geo_address.matchcode in (1,2,10) then
        -- Geocoding succeeded: construct geometric point
        geo_location := sdo_geometry (2001, 8307, sdo_point_type (
          geo_address.longitude, geo_address.latitude, null),
          null, null);
        geocoded_count := geocoded_count + 1;

        -- If wrong street type or postal code (matchcodes 2 or 10)
        -- accept the geocode and correct the address in the database
        if geo_address.matchcode <> 1 then
          update_address := true;
          corrected_count := corrected_count + 1;
        end if;

      else
        -- For all other matchcoded, reject the geocode
        error_count := error_count + 1;
        geo_location := NULL;
      end if;

    end if;

    -- Update location and corrected address in database
    if update_address then
      update customers
      set location = geo_location,
          street_name = geo_address.streetname,
          postal_code = geo_address.postalcode
      where id = b.id;
    else
      update customers
      set location = geo_location
      where id = b.id;
    end if;

  end loop;

  -- Display counts of records processed
  dbms_output.put_line ('Geocoding completed');
  dbms_output.put_line (address_count || ' Addresses processed');
  dbms_output.put_line (geocoded_count || ' Addresses successfully geocoded');
  dbms_output.put_line (corrected_count || ' Addresses corrected');
  dbms_output.put_line (ambiguous_count || ' ambiguous addresses rejected');
  dbms_output.put_line (error_count || ' addresses with errors');

  for i in 1..match_counts.count loop
    if match_counts(i) > 0 then
      dbms_output.put_line ('Match code '|| i || ': ' || match_counts(i));
    end if;
  end loop;

END;
/
