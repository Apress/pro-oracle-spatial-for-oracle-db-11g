-- Listing 9-40. Obtaining MIN_ORDINATE and MAX_ORDINATE in the Third Dimension
SELECT SDO_GEOM.SDO_MIN_MBR_ORDINATE(geom, 3) min_extent,
SDO_GEOM.SDO_MAX_MBR_ORDINATE(geom, 3) max_extent
FROM city_buildings cbldg
WHERE id=1;
