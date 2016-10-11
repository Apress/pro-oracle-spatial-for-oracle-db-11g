-- Listing 10-10. Metadata for a Network on Existing Structures
INSERT INTO USER_SDO_NETWORK_METADATA (
  NETWORK,
  NETWORK_CATEGORY,
  GEOMETRY_TYPE,
  NO_OF_HIERARCHY_LEVELS,
  NO_OF_PARTITIONS,
  LINK_DIRECTION,
  NODE_TABLE_NAME,
  NODE_GEOM_COLUMN,
  NODE_COST_COLUMN,
  LINK_TABLE_NAME,
  LINK_GEOM_COLUMN,
  LINK_COST_COLUMN,
  PATH_TABLE_NAME,
  PATH_GEOM_COLUMN,
  PATH_LINK_TABLE_NAME
)
VALUES (
  'WATER_NET',        -- network (primary key)
  'SPATIAL',          -- network_category
  'SDO_GEOMETRY',     -- geometry_type
  1,                  -- no_of_hierarchy_levels
  1,                  -- no_of_partitions
  'UNDIRECTED',       -- link_direction
  'NET_VALVES',       -- node_table_name
  'LOCATION',         -- node_geom_column
  NULL,               -- node_cost_column (no cost at node level)
  'NET_PIPES',        -- link_table_name
  'PIPE_GEOM',        -- link_geom_column
  'LENGTH',           -- link_cost_column
  'NET_PATHS',        -- path_table_name
  'PATH_GEOM',        -- path_geom_column
  'NET_PATH_LINKS'    -- path_link_table_name
);
COMMIT;
