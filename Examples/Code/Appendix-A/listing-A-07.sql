-- Listing A-7. Finding Three Clusters for Customer Locations
SELECT ID, GEOMETRY FROM TABLE
(SDO_SAM.SPATIAL_CLUSTERS('CUSTOMERS', 'LOCATION', 3));
