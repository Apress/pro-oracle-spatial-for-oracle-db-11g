-- Listing 10-1. Creating a Spatial Network Using Default Table Names
BEGIN
  SDO_NET.CREATE_SDO_NETWORK (
    NETWORK                 => 'US_ROADS',
    NO_OF_HIERARCHY_LEVELS  => 1,
    IS_DIRECTED             => TRUE,
    NODE_WITH_COST          => FALSE
  );
END;
/
