-- Listing 16-10. Computing the Aggregate Unions Grouped by the ROWNUM Pseudo-column
SELECT SDO_AGGR_UNION(sdoaggrtype(geom, 0.5)) union_geom
FROM us_counties
WHERE state_abrv='MA'
GROUP BY MOD(ROWNUM,10);
