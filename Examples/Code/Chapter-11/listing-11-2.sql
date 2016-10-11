-- Listing 11-2. Defining a Network over the Routing Data

CREATE OR REPLACE VIEW route_node_sf_v AS
  SELECT  node_id,
          geometry,
          partition_id
  FROM    node;

CREATE OR REPLACE VIEW route_edge_sf_v AS
  SELECT  edge_id AS link_id,
          start_node_id,
          end_node_id,
          partition_id,
          func_class,
          length,
          speed_limit,
          geometry,
          name AS link_name,
          divider
  FROM    edge;

DELETE FROM user_sdo_network_metadata
WHERE network = 'NET_ROUTE_SF';

INSERT INTO user_sdo_network_metadata (
  NETWORK,
  NETWORK_CATEGORY,
  GEOMETRY_TYPE,
  NODE_TABLE_NAME,
  NODE_GEOM_COLUMN,
  LINK_TABLE_NAME,
  LINK_GEOM_COLUMN,
  LINK_DIRECTION,
  LINK_COST_COLUMN
)
VALUES (
  'NET_ROUTE_SF',
  'SPATIAL',
  'SDO_GEOMETRY',
  'ROUTE_NODE_SF_V',
  'GEOMETRY',
  'ROUTE_EDGE_SF_V',
  'GEOMETRY',
  'DIRECTED',
  'LENGTH'
);
COMMIT;

