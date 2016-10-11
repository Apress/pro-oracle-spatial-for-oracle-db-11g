-- Listing 2-1. Creating the us_restaurants_new Table
CREATE TABLE us_restaurants_new
(
  id NUMBER,
  poi_name VARCHAR2(32),
  location SDO_GEOMETRY -- New column to store locations
);
