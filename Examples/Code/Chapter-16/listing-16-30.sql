-- Listing 16-30. Computing the Nearest Neighbor on a Subquery Returning a Subset of Customers
SELECT ct.id, ct.name FROM (
SELECT ct.id, ct.name, SDO_GEOM.DISTANCE(comp.geom, ct.location, 0.5) dist
FROM competitors_sales_regions comp,
(SELECT c.name FROM customers c WHERE c.name LIKE '%SCHOOL') ct
WHERE comp.id=1
ORDER BY dist
)
WHERE rownum <= 1; -- substitute 1 by k for k-nearest neighbors
