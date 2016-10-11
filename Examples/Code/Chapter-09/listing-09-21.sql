-- Listing 9-21. Coverage of the Sales Regions: Performing a Union of All the Sales Regions
CREATE TABLE sales_region_coverage (coverage SDO_GEOMETRY);
DECLARE
  coverage SDO_GEOMETRY := NULL;
BEGIN
  FOR g IN (SELECT geom FROM sales_regions) LOOP
    coverage := SDO_GEOM.SDO_UNION(coverage, g.geom, 0.5);
  END LOOP;
  INSERT INTO sales_region_coverage values (coverage);
  COMMIT;
END;
/
