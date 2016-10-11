-- Listing 16-32. Determining the SRIDValue for a Spatial Layer (Specified by table_name, column_name)
SELECT srid FROM USER_SDO_GEOM_METADATA
WHERE table_name='CUSTOMERS' AND column_name='LOCATION';
