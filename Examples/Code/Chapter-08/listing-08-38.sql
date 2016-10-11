-- Listing 8-38. SDO_FILTER Operator Retrieving All Customers Within a Competitor’s Service Area
SELECT ct.id, ct.name
FROM competitors_regions comp, customers ct
WHERE comp.id=1
AND SDO_FILTER(ct.location, comp.geom)='TRUE'
ORDER BY ct.id;
