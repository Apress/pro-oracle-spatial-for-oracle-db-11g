-- Listing 9-26. Area of the Intersection Region of Sales Region 43 and Sales Region 51
SELECT SDO_GEOM.SDO_AREA (
  SDO_GEOM.SDO_INTERSECTION(sra.geom, srb.geom, 0.5), 0.5, ' unit=sq_yard ' ) area
FROM sales_regions srb, sales_regions sra
WHERE sra.id=51
AND srb.id=43;
