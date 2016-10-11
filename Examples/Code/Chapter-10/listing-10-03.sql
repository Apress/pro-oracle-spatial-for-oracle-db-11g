-- Listing 10-3. Network Creation with Explicit Table and Column Names
BEGIN
  SDO_NET.CREATE_SDO_NETWORK (
    NETWORK                 => 'US_ROADS',
    NO_OF_HIERARCHY_LEVELS  => 1,
    IS_DIRECTED             => TRUE,
    NODE_TABLE_NAME         => 'US_INTERSECTIONS',
    NODE_GEOM_COLUMN        => 'LOCATION',
    NODE_COST_COLUMN        => NULL,
    LINK_TABLE_NAME         => 'US_STREETS',
    LINK_GEOM_COLUMN        => 'STREET_GEOM',
    LINK_COST_COLUMN        => 'STREET_LENGTH',
    PATH_TABLE_NAME         => 'US_PATHS',
    PATH_GEOM_COLUMN        => 'PATH_GEOM',
    PATH_LINK_TABLE_NAME    => 'US_PATH_LINKS'
  );
END;
/
