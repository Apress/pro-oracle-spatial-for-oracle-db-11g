-- Listing 8-55. SQL Example Where a Deterministic Function is Evaluated Only Once Even When Called Twice
SELECT
  gcdr_geometry(street_number,street_name,city,state,postal_code).sdo_point.x,
  gcdr_geometry(street_number,street_name,city,state,postal_code).sdo_point.y
FROM customers
WHERE id=1;
