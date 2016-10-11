-- Listing 9-44. Obtaining a Point on Building 1
SELECT SDO_GEOM.SDO_POINTONSURFACE(geom, 0.05) pt
FROM city_buildings cbldg
WHERE id=1;
