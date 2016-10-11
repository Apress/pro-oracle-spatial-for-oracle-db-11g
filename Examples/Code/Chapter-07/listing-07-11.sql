-- Listing 7-11. remove_point Function
CREATE OR REPLACE FUNCTION remove_point (
  geom SDO_GEOMETRY, point_number NUMBER
) RETURN SDO_GEOMETRY
IS
  g MDSYS.SDO_GEOMETRY; -- Updated Geometry
  d NUMBER; -- Number of dimensions in geometry
  p NUMBER; -- Index into ordinates array
  i NUMBER; -- Index into ordinates array

BEGIN
  -- Get the number of dimensions from the gtype
  d := SUBSTR (geom.SDO_GTYPE, 1, 1);

  -- Get index in ordinates array
  -- If 0 then we want the last point
  IF point_number = 0 THEN
    p := geom.SDO_ORDINATES.COUNT() - d + 1;
  ELSE
    p := (point_number-1) * d + 1;
  END IF;

  -- Verify that the point exists
  IF p > geom.SDO_ORDINATES.COUNT() THEN
    RETURN NULL;
  END IF;

  -- Initialize output line with input line
  g := geom;

  -- Step 1: Shift the ordinates "up"
  FOR i IN p..g.SDO_ORDINATES.COUNT()-d LOOP
    g.SDO_ORDINATES(i) := g.SDO_ORDINATES(i+d);
  END LOOP;

  -- Step 2: Trim the ordinates array
  g.SDO_ORDINATES.TRIM (d);

  -- Return the updated geometry
  RETURN g;
END;
/
