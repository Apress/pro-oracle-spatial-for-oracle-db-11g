-- Listing 8-76. Creating an R-tree Index on Three-Dimensional City Data
CREATE INDEX city_bldg_sidx ON city_buildings(geom)
  INDEXTYPE IS MDSYS.SPATIAL_INDEX
  PARAMETERS ('SDO_INDX_DIMS=3');
