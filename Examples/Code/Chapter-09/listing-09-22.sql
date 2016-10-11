-- Listing 9-22. SDO_DIFFERENCE of Competitor Region 2 with Sales Region 6
CREATE TABLE exclusive_region_for_comp_2 AS
SELECT SDO_GEOM.SDO_DIFFERENCE(b.geom, a.geom, 0.5) geom
FROM sales_regions sr, competitors_sales_regions csr
WHERE csr.id=2 and sr.id=6 ;
