-- Listing 8-75. Inserting Metadata for the city_buildings Table (Extents in all Three Dimensions Are Entered)
insert into user_sdo_geom_metadata values (
  'CITY_BUILDINGS',
  'GEOM',
  SDO_DIM_ARRAY(
    SDO_DIM_ELEMENT('X', 29214140, 29219040, 0.05),
    SDO_DIM_ELEMENT('Y', 43364000, 43372640, 0.05),
    SDO_DIM_ELEMENT('Z', 0, 2000, 0.05)
  ),
  7407);
