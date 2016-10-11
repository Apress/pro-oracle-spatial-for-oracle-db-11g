-- Listing 5-39. Validating After Removing the Duplicate Vertices
SELECT SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT
(
  SDO_UTIL.REMOVE_DUPLICATE_VERTICES(a.geom, 0.5),
  0.5
) is_valid
FROM sales_regions a
WHERE id=10000;
