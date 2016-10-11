-- Listing 16-8. Aggregate Union of All Geometries in the us_counties Table
SELECT SDO_AGGR_UNION(SDOAGGRTYPE(geom, 0.5)) union_geom
FROM us_counties ;
