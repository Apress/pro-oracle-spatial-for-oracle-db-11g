-- Listing 11-3. Setting up the rights for partitioning

-- Create the directory
CREATE DIRECTORY sdo_router_log_dir AS 'D:\Work';
-- Grant access to the user that will perform the partitioning
GRANT READ, WRITE ON DIRECTORY sdo_router_log_dir TO spatial;
-- Grant java write access on the file
exec dbms_java.grant_permission( 'SPATIAL', 'SYS:java.io.FilePermission', 'D:\Work\sdo_router_partition.log', 'write' )
-- Also to MDSYS
exec dbms_java.grant_permission( 'MDSYS', 'SYS:java.io.FilePermission', 'D:\Work\sdo_router_partition.log', 'write' )
