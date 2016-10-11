-- Listing 3-15. Inserting Metadata for the Spatial Layer Corresponding to the location Column of the
customers Table
INSERT INTO USER_SDO_GEOM_METADATA VALUES
(
'CUSTOMERS', -- TABLE_NAME
'LOCATION', -- COLUMN_NAME
SDO_DIM_ARRAY -- DIMINFO attribute for storing dimension bounds, tolerance
(
 SDO_DIM_ELEMENT
 (
 'LONGITUDE', -- DIMENSION NAME for first dimension
 -180, -- SDO_LB for the dimension
 180, -- SDO_UB for the dimension
 0.5 -- Tolerance of 0.5 meters
 ),
 SDO_DIM_ELEMENT
 (
 'LATITUDE', -- DIMENSION NAME for second dimension
 -90, -- SDO_LB for the dimension
 90, -- SDO_UB for the dimension
 0.5 -- Tolerance of 0.5 meters
 )
),
8307 -- SRID value for specifying a geodetic coordinate system
);
