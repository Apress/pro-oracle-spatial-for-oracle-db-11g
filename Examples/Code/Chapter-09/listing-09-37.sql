-- Listing 9-37. Computing the Extent of a Three-Dimensional Object
SELECT SDO_GEOM.SDO_MBR(geom) extent
FROM city_buildings cbldg
WHERE id=1;
