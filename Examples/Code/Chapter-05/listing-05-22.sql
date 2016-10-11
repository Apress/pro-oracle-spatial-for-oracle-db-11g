-- Listing 5-22. Converting an SDO_GEOMETRY to a GML Document
SELECT TO_CHAR(SDO_UTIL.TO_GMLGEOMETRY(location)) gml_location
FROM customers
WHERE id=1;
