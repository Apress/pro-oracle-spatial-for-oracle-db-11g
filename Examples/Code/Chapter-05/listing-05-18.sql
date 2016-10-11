-- Listing 5-18. customers.sql File
DROP TABLE customers;
CREATE TABLE customers
(
  id              NUMBER,
  datasrc_id      NUMBER,
  name            VARCHAR2(35),
  category        VARCHAR2(30),
  street_number   VARCHAR2(5),
  street_name     VARCHAR2(60),
  city            VARCHAR2(32),
  postal_code     VARCHAR2(16),
  state           VARCHAR2(32),
  phone_number    VARCHAR2(15),
  customer_grade  VARCHAR2(15)
);
INSERT INTO USER_SDO_GEOM_METADATA VALUES
(
  'CUSTOMERS', -- Table_name
  'LOCATION', -- Column name
  MDSYS.SDO_DIM_INFO_ARRAY -- Diminfo
  (
    MDSYS.SDO_DIM_ELEMENT('Longitude', -180, 180, 0.5), --Longitude dimension
    MDSYS.SDO_DIM_ELEMENT('Latitude', -90, 90, 0.5) --Latitude dimension
  ),
  8307 -- Geodetic SRID
);
