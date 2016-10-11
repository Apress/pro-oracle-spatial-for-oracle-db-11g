-- Listing 8-60. Creating a Partitioned Table
DROP INDEX customers_sidx; -- Drop the spatial index
RENAME customers TO customers_old; -- Store old data
CREATE TABLE customers
(
  NAME VARCHAR2(64),
  ID NUMBER,
  STREET_NUMBER VARCHAR2(14),
  STREET_NAME VARCHAR2(80),
  CITY VARCHAR2(64),
  STATE VARCHAR2(64),
  POSTAL_CODE VARCHAR2(16),
  CUSTOMER_GRADE VARCHAR2(15),
  LOCATION SDO_GEOMETRY
)
PARTITION by RANGE(CUSTOMER_GRADE)
(
  PARTITION GOLD VALUES LESS THAN ('GOLDZZZZZZ'),
  PARTITION PLATINUM VALUES LESS THAN ('PLATINUMZZZZZZ'),
  PARTITION SILVER VALUES LESS THAN ('SILVERZZZZZZ')
);
INSERT INTO customers
  SELECT name, id, street_number, street_name, city, state,
    postal_code, customer_grade, location
  FROM customers_old;
COMMIT;
