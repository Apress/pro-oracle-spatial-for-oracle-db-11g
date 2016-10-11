-- Listing 2-5. Creating an Index on Locations (SDO_GEOMETRY Column) of Restaurants
DROP INDEX us_restaurants_sidx;
CREATE INDEX us_restaurants_sidx ON us_restaurants(location)
INDEXTYPE IS mdsys.spatial_index;
