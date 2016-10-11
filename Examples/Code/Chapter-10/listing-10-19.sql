-- Listing 10-19. Loading the DNET Network
-- Populate the node table
INSERT INTO dnet_nodes (node_id, node_name, geom) VALUES (1, 'N1', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (1,3,NULL), NULL, NULL));
INSERT INTO dnet_nodes (node_id, node_name, geom) VALUES (2, 'N2', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (2,3,NULL), NULL, NULL));
INSERT INTO dnet_nodes (node_id, node_name, geom) VALUES (3, 'N3', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (4,3,NULL), NULL, NULL));
INSERT INTO dnet_nodes (node_id, node_name, geom) VALUES (4, 'N4', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (2,2,NULL), NULL, NULL));
INSERT INTO dnet_nodes (node_id, node_name, geom) VALUES (5, 'N5', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (3,2,NULL), NULL, NULL));
INSERT INTO dnet_nodes (node_id, node_name, geom) VALUES (6, 'N6', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (4,2,NULL), NULL, NULL));
INSERT INTO dnet_nodes (node_id, node_name, geom) VALUES (7, 'N7', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (1,1,NULL), NULL, NULL));
INSERT INTO dnet_nodes (node_id, node_name, geom) VALUES (8, 'N8', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (3,1,NULL), NULL, NULL));
INSERT INTO dnet_nodes (node_id, node_name, geom) VALUES (9, 'N9', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (4,1,NULL), NULL, NULL));
COMMIT;

-- Populate the link table
INSERT INTO dnet_links (link_id, link_name, start_node_id, end_node_id, cost, geom, bidirected)
  VALUES ( 1, 'L1',  2, 1, 1,    SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (2,3, 1,3)), 'N');
INSERT INTO dnet_links (link_id, link_name, start_node_id, end_node_id, cost, geom, bidirected)
  VALUES ( 2, 'L2',  3, 2, 2,    SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (4,3, 2,3)), 'N');
INSERT INTO dnet_links (link_id, link_name, start_node_id, end_node_id, cost, geom, bidirected)
  VALUES ( 3, 'L3',  3, 6, 1,    SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (4,3, 4,2)), 'Y');
INSERT INTO dnet_links (link_id, link_name, start_node_id, end_node_id, cost, geom, bidirected)
  VALUES ( 4, 'L4',  6, 9, 1,    SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (4,2, 4,1)), 'Y');
INSERT INTO dnet_links (link_id, link_name, start_node_id, end_node_id, cost, geom, bidirected)
  VALUES ( 5, 'L5',  9, 8, 1,    SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (4,1, 3,1)), 'Y');
INSERT INTO dnet_links (link_id, link_name, start_node_id, end_node_id, cost, geom, bidirected)
  VALUES ( 6, 'L6',  8, 7, 3,    SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (3,1, 1,1)), 'N');
INSERT INTO dnet_links (link_id, link_name, start_node_id, end_node_id, cost, geom, bidirected)
  VALUES (-6, 'L6',  7, 8, 2,    SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (1,1, 3,1)), 'N');
INSERT INTO dnet_links (link_id, link_name, start_node_id, end_node_id, cost, geom, bidirected)
  VALUES ( 7, 'L7',  1, 7, 2,    SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (1,3, 1,1)), 'N');
INSERT INTO dnet_links (link_id, link_name, start_node_id, end_node_id, cost, geom, bidirected)
  VALUES ( 8, 'L8',  4, 7, 1.5,  SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (2,2, 1,1)), 'N');
INSERT INTO dnet_links (link_id, link_name, start_node_id, end_node_id, cost, geom, bidirected)
  VALUES ( 9, 'L9',  5, 4, 1,    SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (3,2, 2,2)), 'N');
INSERT INTO dnet_links (link_id, link_name, start_node_id, end_node_id, cost, geom, bidirected)
  VALUES (10, 'L10', 5, 6, 1,    SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (3,2, 4,2)), 'N');
INSERT INTO dnet_links (link_id, link_name, start_node_id, end_node_id, cost, geom, bidirected)
  VALUES (11, 'L11', 8, 5, 1,    SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (3,1, 3,2)), 'N');
COMMIT;

