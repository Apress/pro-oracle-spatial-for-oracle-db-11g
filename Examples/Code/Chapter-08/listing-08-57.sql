-- Listing 8-57. Creating a Spatial Index on a Function Returning an SDO_GEOMETRY
CREATE INDEX customers_spatial_fun_idx ON customers
(
  gcdr_geometry(street_number, street_name, city, state, postal_code)
)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS ('LAYER_GTYPE=POINT');
