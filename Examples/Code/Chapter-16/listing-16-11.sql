-- Listing 16-11. Computing the Aggregate Union of Aggregate Unions Grouped by the ROWNUM Pseudocolumn
SELECT SDO_AGGR_UNION(SDOAGGRTYPE(union_geom, 0.5))
FROM
(
  SELECT SDO_AGGR_UNION(SDOAGGRTYPE(geom, 0.5)) union_geom
  FROM us_counties
  WHERE state_abrv='MA'
  GROUP BY MOD(ROWNUM,10)
);
