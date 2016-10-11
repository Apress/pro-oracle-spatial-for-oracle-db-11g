-- Listing 10-37. Creating a Network Using the PL/SQL API
DECLARE
  network_name VARCHAR2(20) := 'MY_NET';
BEGIN
  -- Create the network object in memory
  SDO_NET_MEM.NETWORK_MANAGER.CREATE_LOGICAL_NETWORK(
    network_name,          -- network_name
    1,                     -- no_of_hierarchy_levels
    'TRUE',                -- is_directed
    network_name||'_NODE', -- node_table_name
    'COST',                -- node_cost_column
    network_name||'_LINK', -- link_table_name
    'COST',                -- link_cost_column
    network_name||'_PATH', -- path_table_name
    network_name||'_PLINK',-- path_link_table_name
    'FALSE'                -- is_complex
  );

  -- Create and add the nodes
  SDO_NET_MEM.NETWORK.ADD_NODE(network_name, 1, 'N1', 0, 0);
  SDO_NET_MEM.NETWORK.ADD_NODE(network_name, 2, 'N2', 0, 0);
  SDO_NET_MEM.NETWORK.ADD_NODE(network_name, 3, 'N3', 0, 0);
  SDO_NET_MEM.NETWORK.ADD_NODE(network_name, 4, 'N4', 0, 0);
  SDO_NET_MEM.NETWORK.ADD_NODE(network_name, 5, 'N5', 0, 0);
  SDO_NET_MEM.NETWORK.ADD_NODE(network_name, 6, 'N6', 0, 0);
  SDO_NET_MEM.NETWORK.ADD_NODE(network_name, 7, 'N7', 0, 0);
  SDO_NET_MEM.NETWORK.ADD_NODE(network_name, 8, 'N8', 0, 0);
  SDO_NET_MEM.NETWORK.ADD_NODE(network_name, 9, 'N9', 0, 0);

  -- Create and add the links
  SDO_NET_MEM.NETWORK.ADD_LINK(network_name,  1, 'L1',  1, 2, 1);
  SDO_NET_MEM.NETWORK.ADD_LINK(network_name,  2, 'L2',  2, 3, 2);
  SDO_NET_MEM.NETWORK.ADD_LINK(network_name,  3, 'L3',  3, 6, 1);
  SDO_NET_MEM.NETWORK.ADD_LINK(network_name,  4, 'L4',  6, 9, 1);
  SDO_NET_MEM.NETWORK.ADD_LINK(network_name,  5, 'L5',  9, 8, 1);
  SDO_NET_MEM.NETWORK.ADD_LINK(network_name,  6, 'L6',  8, 7, 2);
  SDO_NET_MEM.NETWORK.ADD_LINK(network_name,  7, 'L7',  7, 1, 2);
  SDO_NET_MEM.NETWORK.ADD_LINK(network_name,  8, 'L8',  7, 4, 1.5);
  SDO_NET_MEM.NETWORK.ADD_LINK(network_name,  9, 'L9',  4, 5, 1);
  SDO_NET_MEM.NETWORK.ADD_LINK(network_name, 10, 'L10', 5, 6, 1);
  SDO_NET_MEM.NETWORK.ADD_LINK(network_name, 11, 'L11', 5, 8, 1);

  -- Write the network (this also creates the tables and writes the metadata)
  SDO_NET_MEM.NETWORK_MANAGER.WRITE_NETWORK(network_name);
END;
/
