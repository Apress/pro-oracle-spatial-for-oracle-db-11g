-- Listing 7-7. Line Constructor
CREATE OR REPLACE FUNCTION line (
  first_x NUMBER, first_y NUMBER, next_x NUMBER, next_y NUMBER, srid NUMBER)
RETURN SDO_GEOMETRY
DETERMINISTIC
IS
  l SDO_GEOMETRY;
BEGIN
  l := SDO_GEOMETRY (
    2002, srid, NULL,
    SDO_ELEM_INFO_ARRAY (1, 2, 1),
    SDO_ORDINATE_ARRAY (
      first_x, first_y,
      next_x, next_y));
  RETURN l;
END;
/
