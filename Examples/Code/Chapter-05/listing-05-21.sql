-- Listing 5-21. Using TO_WKTGEOMETRY to Convert from an SDO_GEOMETRY to WKT Format
SELECT SDO_UTIL.TO_WKTGEOMETRY(a.location) wkt FROM customers a WHERE id=1;
SELECT SDO_UTIL.TO_WKTGEOMETRY(a.location) wkt FROM customers a WHERE id=1;
