-- Listing 9-28. Surface Area of Building 1 (in Default Units of Square Feet)
SELECT id, SDO_GEOM.SDO_AREA(geom, 0.05) SURFACE_AREA
FROM city_buildings
WHERE id=1;
