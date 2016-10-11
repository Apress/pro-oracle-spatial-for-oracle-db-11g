-- Listing 5-45. Finding the Number of Elements in a Geometry
SELECT SDO_UTIL.GETNUMELEM(geom) nelem
FROM sales_regions
WHERE id=10000;

SELECT SDO_UTIL.GETNUMVERTICES(geom) nverts
FROM sales_regions
WHERE id=10000;
