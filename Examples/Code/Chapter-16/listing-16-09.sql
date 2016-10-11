-- Listing 16-9. Computing the Aggregate Unions for Multiple Groups
SELECT SDO_AGGR_UNION(SDOAGGRTYPE(geom, 0.5)), SUBSTR(county,1,1)
FROM us_counties
WHERE state_abrv='MA'
GROUP BY (SUBSTR(county,1,1));
