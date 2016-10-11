-- Listing 9-4. Using the SDO_DISTANCE Function with the SDO_WITHIN_DISTANCE Spatial Operator in SQL
SELECT ct.id, ct.name,
  SDO_GEOM.SDO_DISTANCE(ct.location, comp.location, 0.5, 'unit=yard') distance
FROM competitors comp, customers ct
WHERE comp.id=1
AND SDO_WITHIN_DISTANCE (ct.location, comp.location, 'distance=0.25 unit=mile')='TRUE'
ORDER BY ct.id;
