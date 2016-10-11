-- Listing 10-9. Creating the Path and Path Link Tables
CREATE TABLE net_paths (
  path_id         NUMBER,
  start_node_id   NUMBER NOT NULL,
  end_node_id     NUMBER NOT NULL,
  cost            NUMBER,
  simple          VARCHAR2(1),
  path_geom       SDO_GEOMETRY,
  CONSTRAINT net_paths_pk PRIMARY KEY (path_id)
);
CREATE TABLE net_path_links (
  path_id         NUMBER,
  link_id         NUMBER,
  seq_no          NUMBER,
  CONSTRAINT net_path_links_pk PRIMARY KEY (path_id, link_id)
);
