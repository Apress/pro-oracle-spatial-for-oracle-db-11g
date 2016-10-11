-- Listing 9-31. Length of the Building 1 (in Units of Feet) with count_shared_edges Set to 1
SELECT SDO_GEOM.SDO_LENGTH(
  geom,         -- input geometry
  0.05,         -- tolerance value
  'UNIT=FOOT',  -- units parameter
  1             -- count_shared_edges only once
) LENGTH
FROM city_buildings
WHERE id=1;
