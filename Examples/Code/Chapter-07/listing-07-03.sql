-- Listing 7-3. Sample Application in PL/SQL
DECLARE
  b_long            NUMBER;
  b_lat             NUMBER;
  new_long          NUMBER;
  new_lat           NUMBER;
  new_branch_loc    SDO_GEOMETRY;
  sales_region      SDO_GEOMETRY;
  route             SDO_GEOMETRY;

BEGIN
  -- Obtain Old location for branch id=1
  SELECT br.location.sdo_point.x, br.location.sdo_point.y
  INTO b_long, b_lat
  FROM branches br
  WHERE id=1;

  -- Compute new coordinates: say the location is displaced by 0.0025 degrees
  new_long := b_long+ 0.0025;
  new_lat := b_lat + 0.0025;

  -- Create new branch location using old location
  new_branch_loc :=
    point
    (
      X=>    new_long,
      Y=>    new_lat,
      SRID=> 8307
     ) ;

  -- Compute sales region for this branch
  sales_region :=
    rectangle
    (
      CTR_X=> new_long,
      CTR_Y=> new_lat,
      EXP_X=> 0.005,
      EXP_Y=> 0.0025,
      SRID=>  8307
    ) ;

  -- Create Delivery Route
  route :=
    line
    (
      FIRST_X=> -122.4804,
      FIRST_Y=> 37.7805222,
      NEXT_X=> -123,
      NEXT_Y=> 38,
      SRID=>  8307
    ) ;

  -- Update Delivery Route by adding new point
  route :=
    add_to_line
    (
      GEOM=> route,
      POINT => POINT(-124, 39, 8307)
    ) ;

  -- Perform additional analysis such as length of route,
  -- or # of customers in sales region (we will see examples in Chapters 8 and 9)
  -- ...
  -- Update geometry in branches table
  UPDATE branches SET LOCATION = new_branch_loc WHERE id=1;

END;
/
