-- Listing 5-16. Migrating location Column Data in the customers Table to the Current Format (10g)
EXECUTE SDO_MIGRATE.TO_CURRENT('customers', 'location', 100);
