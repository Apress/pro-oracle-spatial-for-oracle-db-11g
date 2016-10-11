-- Listing 10-18. Defining the DNET Network
BEGIN
  SDO_NET.CREATE_SDO_NETWORK (
    NETWORK                   => 'DNET',
    NO_OF_HIERARCHY_LEVELS    => 1,
    IS_DIRECTED               => TRUE,
    NODE_TABLE_NAME           => 'DNET_NODES',
    NODE_GEOM_COLUMN          => 'GEOM',
    NODE_COST_COLUMN          => NULL,
    LINK_TABLE_NAME           => 'DNET_LINKS',
    LINK_COST_COLUMN          => 'COST',
    LINK_GEOM_COLUMN          => 'GEOM',
    PATH_TABLE_NAME           => 'DNET_PATHS',
    PATH_GEOM_COLUMN          => 'GEOM',
    PATH_LINK_TABLE_NAME      => 'DNET_PLINKS'
  );
END;
/
