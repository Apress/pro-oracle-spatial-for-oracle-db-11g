-- Listing 9-3. Identifying Customers Within a Quarter-Mile of a Competitor Location
SELECT ct.id, ct.name
FROM competitors comp, customers ct
WHERE comp.id=1
AND SDO_GEOM.SDO_DISTANCE(ct.location, comp.location, 0.5, 'unit=mile') < 0.25
ORDER BY ct.id;
