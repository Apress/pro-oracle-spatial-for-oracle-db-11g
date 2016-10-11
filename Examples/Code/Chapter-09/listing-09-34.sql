-- Listing 9-34. Volume of Building 1 (in Default Units of Cubic Feet)
set numwidth 15
SELECT SDO_GEOM.SDO_VOLUME(
  GEOM, -- INPUT GEOMETRY
  0.05 -- TOLERANCE VALUE
) VOLUME
FROM city_buildings
WHERE id=1;
