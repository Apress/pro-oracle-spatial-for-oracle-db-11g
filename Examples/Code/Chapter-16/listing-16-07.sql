-- Listing 16-7. Using the linear_key Function to Order Geometry Rows Based on a "Spatial" Ordering
CREATE OR REPLACE FUNCTION linear_key
(
  location SDO_GEOMETRY,
  diminfo SDO_DIM_ARRAY
)
RETURN RAW DETERMINISTIC
IS
  ctr SDO_GEOMETRY;
  rval RAW(48);
  lvl INTEGER;
BEGIN
  -- Compute the centroid of the geometry
  -- Alternately, you can use the 'faster' sdo_pointonsurface function
  ctr := SDO_GEOM.SDO_CENTROID(location, diminfo);
  lvl := 8; -- Specifies the encoding level for hhcode function
  rval :=
  MD.HHENCODE
  ( -- Specify value, lower and upper bounds, encoding level for each dimension
    location.sdo_point.x, diminfo(1).sdo_lb, diminfo(1).sdo_ub, lvl,
    location.sdo_point.y, diminfo(2).sdo_lb, diminfo(2).sdo_ub, lvl
  );
  RETURN rval;
END;
/
