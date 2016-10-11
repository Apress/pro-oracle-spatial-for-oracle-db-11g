-- Listing 10-13. Adding Spatial Metadata to Network Tables
BEGIN
  SDO_NET.INSERT_GEOM_METADATA (
    'US_ROADS',
    SDO_DIM_ARRAY (
      SDO_DIM_ELEMENT ('Long', -180, +180, 1),
      SDO_DIM_ELEMENT ('Lat', -90, +90, 1)
    ),
    8307
  );
END;
/
COMMIT;
