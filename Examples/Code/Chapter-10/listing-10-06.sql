-- Listing 10-6. Setting Up Metadata for a Time-Based Road Network
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
  'US_ROADS_TIME',    -- network (primary key)
  'SPATIAL',          -- network_category
  'SDO_GEOMETRY',     -- geometry_type
  1,                  -- no_of_hierarchy_levels
  1,                  -- no_of_partitions
  'DIRECTED',         -- link_direction
  'US_INTERSECTIONS', -- node_table_name
  'LOCATION',         -- node_geom_column
  NULL,               -- node_cost_column (no cost at node level)
  'US_STREETS',       -- link_table_name
  'STREET_GEOM',      -- link_geom_column
  'TRAVEL_TIME',      -- link_cost_column
  'US_PATHS',         -- path_table_name
  'PATH_GEOM',        -- path_geom_column
  'US_PATH_LINKS'     -- path_link_table_name
);
COMMIT;
