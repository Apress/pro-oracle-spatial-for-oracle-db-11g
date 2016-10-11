-- Listing 7-8. Counting the Number of Points in a Geometry
CREATE OR REPLACE FUNCTION get_num_points (
  g SDO_GEOMETRY)
RETURN NUMBER
IS
BEGIN
  RETURN g.SDO_ORDINATES.COUNT() / SUBSTR(g.SDO_GTYPE,1,1);
END;
/
