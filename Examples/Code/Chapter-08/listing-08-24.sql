-- Listing 8-24. Getting the Streets Around 0.25 Miles of the Competitor Store
SELECT s.street_name
FROM competitors comp, map_streets s
WHERE comp.id=1
AND SDO_WITHIN_DISTANCE
(s.geometry, comp.location,
'DISTANCE=0.25 UNIT=MILE min_resolution=200 max_resolution=500 ' )='TRUE'
ORDER BY s.street_name;
