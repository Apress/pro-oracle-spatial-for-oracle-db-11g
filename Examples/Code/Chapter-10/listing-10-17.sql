-- Listing 10-17. Loading the UNET Network
-- Populate the node table
INSERT INTO unet_nodes (node_id, node_name, geom) VALUES (1, 'N1', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (1,3,NULL), null, null));
INSERT INTO unet_nodes (node_id, node_name, geom) VALUES (2, 'N2', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (2,3,NULL), null, null));
INSERT INTO unet_nodes (node_id, node_name, geom) VALUES (3, 'N3', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (4,3,NULL), null, null));
INSERT INTO unet_nodes (node_id, node_name, geom) VALUES (4, 'N4', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (2,2,NULL), null, null));
INSERT INTO unet_nodes (node_id, node_name, geom) VALUES (5, 'N5', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (3,2,NULL), null, null));
INSERT INTO unet_nodes (node_id, node_name, geom) VALUES (6, 'N6', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (4,2,NULL), null, null));
INSERT INTO unet_nodes (node_id, node_name, geom) VALUES (7, 'N7', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (1,1,NULL), null, null));
INSERT INTO unet_nodes (node_id, node_name, geom) VALUES (8, 'N8', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (3,1,NULL), null, null));
INSERT INTO unet_nodes (node_id, node_name, geom) VALUES (9, 'N9', SDO_GEOMETRY (2001, NULL, SDO_POINT_TYPE (4,1,NULL), null, null));
COMMIT;

-- Populate the link table
INSERT INTO unet_links (link_id, link_name, start_node_id, end_node_id, cost, geom)
  VALUES ( 1, 'L1',  1, 2, 1, SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (1,3, 2,3)));
INSERT INTO unet_links (link_id, link_name, start_node_id, end_node_id, cost, geom)
  VALUES ( 2, 'L2',  2, 3, 2, SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (2,3, 4,3)));
INSERT INTO unet_links (link_id, link_name, start_node_id, end_node_id, cost, geom)
  VALUES ( 3, 'L3',  3, 6, 1, SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (4,3, 4,2)));
INSERT INTO unet_links (link_id, link_name, start_node_id, end_node_id, cost, geom)
  VALUES ( 4, 'L4',  6, 9, 1, SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (4,2, 4,1)));
INSERT INTO unet_links (link_id, link_name, start_node_id, end_node_id, cost, geom)
  VALUES ( 5, 'L5',  9, 8, 1, SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (4,1, 3,1)));
INSERT INTO unet_links (link_id, link_name, start_node_id, end_node_id, cost, geom)
  VALUES ( 6, 'L6',  8, 7, 2, SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (3,1, 1,1)));
INSERT INTO unet_links (link_id, link_name, start_node_id, end_node_id, cost, geom)
  VALUES ( 7, 'L7',  7, 1, 2, SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (1,1, 1,3)));
INSERT INTO unet_links (link_id, link_name, start_node_id, end_node_id, cost, geom)
  VALUES ( 8, 'L8',  7, 4, 1.5, SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (1,1, 2,2)));
INSERT INTO unet_links (link_id, link_name, start_node_id, end_node_id, cost, geom)
  VALUES ( 9, 'L9',  4, 5, 1, SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (2,2, 3,2)));
INSERT INTO unet_links (link_id, link_name, start_node_id, end_node_id, cost, geom)
  VALUES (10, 'L10', 5, 6, 1, SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (3,2, 4,2)));
INSERT INTO unet_links (link_id, link_name, start_node_id, end_node_id, cost, geom)
  VALUES (11, 'L11', 5, 8, 1, SDO_GEOMETRY (2002, NULL, NULL, SDO_ELEM_INFO_ARRAY (1,2,1), SDO_ORDINATE_ARRAY (3,2, 3,1)));
COMMIT;
