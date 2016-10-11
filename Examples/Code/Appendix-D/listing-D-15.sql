-- Listing D-15. Generating and Populating the Spatial Extent of the georaster Column
DECLARE
  extent SDO_GEOMETRY;
BEGIN
  SELECT SDO_GEOR.GENERATESPATIALEXTENT(a.georaster) INTO extent
  FROM branches b WHERE b.id=1 FOR UPDATE;
  UPDATE branches b SET b.georaster.spatialextent = extent WHERE b.id=1;
  COMMIT;
END;
/
