-- Listing 5-20. Converting from an SDO_GEOMETRY to WKT Format
SELECT a.location.GET_WKT() wkt FROM customers a WHERE id=1;
SELECT SDO_UTIL.TO_WKTGEOMETRY(a.location) wkt FROM customers a WHERE id=1;
