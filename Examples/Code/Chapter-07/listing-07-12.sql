-- Listing 7-12. Adding a Point in a Line String (add_to_line in Listing 7-3)
CREATE OR REPLACE FUNCTION add_to_line (
  geom         SDO_GEOMETRY,
  point        SDO_GEOMETRY,
  point_number NUMBER DEFAULT 0
) RETURN SDO_GEOMETRY
IS
  g   SDO_GEOMETRY;        -- Updated geometry
  d   NUMBER;              -- Number of dimensions in line geometry
  t   NUMBER;              -- Geometry type
  p   NUMBER;              -- Insertion point into ordinates array
  i   NUMBER;

BEGIN
  -- Get the number of dimensions from the gtype
  d := SUBSTR (geom.SDO_GTYPE, 1, 1);

  -- Get index in ordinates array
  -- If 0, then we want the last point
  IF point_number = 0 THEN
    p := geom.SDO_ORDINATES.COUNT() + 1;
  ELSE
    p := (point_number-1) * d + 1;
  END IF;

  -- Verify that the insertion point exists
  IF point_number <> 0 THEN
    IF p > geom.SDO_ORDINATES.LAST()
    OR p < geom.SDO_ORDINATES.FIRST() THEN
      RAISE_APPLICATION_ERROR (-20000, 'Invalid insertion point');
    END IF;
  END IF;

  -- Initialize output line with input line
  g := geom;

  -- Step 1: Extend the ordinates array
  g.SDO_ORDINATES.EXTEND(d);

  -- Step 2: Shift the ordinates "down".
  FOR i IN REVERSE p..g.SDO_ORDINATES.COUNT()-d LOOP
    g.SDO_ORDINATES(i+d) := g.SDO_ORDINATES(i);
  END LOOP;

  -- Step 3: Store the new point
  g.SDO_ORDINATES(p) := point.SDO_POINT.X;
  g.SDO_ORDINATES(p+1) := point.SDO_POINT.Y;
  IF d = 3 THEN
    g.SDO_ORDINATES(p+2) := point.SDO_POINT.Z;
  END IF;

  -- Return the new line string
  RETURN g;
END;
/
