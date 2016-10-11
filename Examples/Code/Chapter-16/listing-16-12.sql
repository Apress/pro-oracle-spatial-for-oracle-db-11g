-- Listing 16-12. Computing the Aggregate Union in a Pipelined Fashion
SELECT SDO_AGGR_UNION(SDOAGGRTYPE(ugeom,0.5)) ugeom
FROM
(
  SELECT SDO_AGGR_UNION(SDOAGGRTYPE(ugeom,0.5)) ugeom
  FROM
  (
    SELECT SDO_AGGR_UNION(SDOAGGRTYPE(ugeom,0.5)) ugeom
    FROM
    (
      SELECT SDO_AGGR_UNION(SDOAGGRTYPE(geom,0.5)) ugeom
      FROM us_counties
      GROUP BY MOD (ROWNUM, 1000)
    )
    GROUP BY MOD (ROWNUM, 100)
  )
  GROUP BY MOD (ROWNUM, 10)
);
