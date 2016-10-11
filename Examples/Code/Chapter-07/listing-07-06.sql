-- Listing 7-6. Rectangle Constructor
CREATE OR REPLACE FUNCTION rectangle (
  ctr_x NUMBER, ctr_y NUMBER, exp_x NUMBER, exp_y NUMBER, srid NUMBER)
RETURN SDO_GEOMETRY
DETERMINISTIC
IS
  r SDO_GEOMETRY;
BEGIN
  r := SDO_GEOMETRY (
    2003, srid, NULL,
    SDO_ELEM_INFO_ARRAY (1, 1003, 3),
    SDO_ORDINATE_ARRAY (
      ctr_x - exp_x, ctr_y - exp_y,
      ctr_x + exp_x, ctr_y + exp_y));
  RETURN r;
END;
/
