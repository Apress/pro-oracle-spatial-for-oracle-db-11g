-- Listing 6-22. Adding a Spatial Column
ALTER TABLE customers ADD (location SDO_GEOMETRY);
ALTER TABLE branches ADD (location SDO_GEOMETRY);
ALTER TABLE competitors ADD (location SDO_GEOMETRY);
