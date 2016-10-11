-- Listing 10-4. Manual Network Creation

-- Create the node table
CREATE TABLE us_intersections (
  node_id         NUMBER,
  location        SDO_GEOMETRY,
  CONSTRAINT us_intersections_pk PRIMARY KEY (node_id)
);

-- Create the link table
CREATE TABLE us_streets (
  link_id         NUMBER,
  start_node_id   NUMBER NOT NULL,
  end_node_id     NUMBER NOT NULL,
  active          CHAR(1),
  street_geom     SDO_GEOMETRY,
  street_length   NUMBER,
  travel_time     NUMBER,
  bidirected      CHAR(1),
  CONSTRAINT us_streets_pk PRIMARY KEY (link_id)
);

-- Create path table
CREATE TABLE us_paths (
  path_id         NUMBER,
  start_node_id   NUMBER NOT NULL,
  end_node_id     NUMBER NOT NULL,
  cost            NUMBER,
  simple          VARCHAR2(1),
  path_geom       SDO_GEOMETRY,
  CONSTRAINT us_paths_pk PRIMARY KEY (path_id)
);

-- Create path link table
CREATE TABLE us_path_links (
  path_id         NUMBER,
  link_id         NUMBER,
  seq_no          NUMBER,
  CONSTRAINT us_path_links_pk PRIMARY KEY (path_id, link_id)
);
