-- Listing 10-16. Defining the UNET Network
BEGIN
  SDO_NET.CREATE_SDO_NETWORK (
    NETWORK                   => 'UNET',
    NO_OF_HIERARCHY_LEVELS    => 1,
    IS_DIRECTED               => FALSE,
    NODE_TABLE_NAME           => 'UNET_NODES',
    NODE_GEOM_COLUMN          => 'GEOM',
    NODE_COST_COLUMN          => NULL,
    LINK_TABLE_NAME           => 'UNET_LINKS',
    LINK_COST_COLUMN          => 'COST',
    LINK_GEOM_COLUMN          => 'GEOM',
    PATH_TABLE_NAME           => 'UNET_PATHS',
    PATH_GEOM_COLUMN          => 'GEOM',
    PATH_LINK_TABLE_NAME      => 'UNET_PLINKS'
  );
END;
/
