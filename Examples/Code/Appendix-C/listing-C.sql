EXECUTE SDO_TOPO.CREATE_TOPOLOGY('CITY_DATA', 0.00000005, NULL);

CREATE TABLE land_parcels
(
  parcel_name VARCHAR2(30) PRIMARY KEY,
  feature SDO_TOPO_GEOMETRY
);

CREATE TABLE streets
(
  street_name VARCHAR2(30) PRIMARY KEY,
  feature SDO_TOPO_GEOMETRY
);

BEGIN
  -- Add the feature layer for the street network
  SDO_TOPO.ADD_TOPO_GEOMETRY_LAYER (
    'CITY_DATA', -- name of the topology
    'STREETS', 'FEATURE', 'POLYGON' -- names of the feature table, column, and type
  );
END;
/

DESCRIBE sdo_topo_geometry;

EXECUTE SDO_TOPO.INITIALIZE_METADATA('CITY_DATA');

INSERT INTO land_parcels (parcel_name, feature) VALUES
(
  'P1',
  SDO_TOPO_GEOMETRY -- construct using topology elements(no explicit geometry)
  (
    'CITY_DATA', -- topology_name
    3, -- topo_geometry_type for polygon (or multipolygon)
    1, -- feature layer (TG_LAYER) ID representing 'Land Parcels',
    SDO_TOPO_OBJECT_ARRAY -- Array of 2 topo objects (two faces)
    (
      SDO_TOPO_OBJECT -- Constructor for the object
      (
        3, -- element ID (i.e., FACE_ID) from the associated topology
        3 -- element TYPE is 3 (i.e., a FACE)
      ),
      SDO_TOPO_OBJECT -- Constructor for topo object
      (
        6, -- element ID (i.e., FACE_ID) from the associated topology
        3 -- element type is 3 (i.e., a FACE)
      )
    )
  )
);

EXEC SDO_TOPO_MAP.CREATE_TOPO_MAP('CITY_DATA', 'Manhattan Topology');

EXEC SDO_TOPO_MAP.LOAD_TOPO_MAP(
  'Manhattan Topology',
  min_long, min_lat, max_long, max_lat
);

INSERT INTO STREETS (street_name, feature)
  'Fifth Street, Segment11',
  SDO_TOPO_MAP.CREATE_FEATURE(
    'Manhattan Topology',
    'ROAD_NETWORK', -- Table where the feature is stored,
    'FEATURE', -- Column in the table storing the feature
    -- Next, specify the geometry for the Fifth street, segment 11
    -- as line from x1,y1 to x2,y2
    SDO_GEOMETRY(
      2002, 8307, NULL,
      SDO_ELEMENT_INFO_ARRAY(1,2,1),
      SDO_ORDINATE_ARRAY(x1,y,1, x2,y,2)
    )
  );

EXEC SDO_TOPO_MAP.ADD_EDGE('Manhattan Topology', 1, 2, gm);

EXEC SDO_TOPO_MAP.VALIDATE('Manhattan Topology');

EXEC SDO_TOPO_MAP.COMMIT_TOPO_MAP('Manhattan Topology');

EXEC SDO_TOPO_MAP.ROLLBACK_TOPO_MAP('Manhattan Topology');

EXEC SDO_TOPO_MAP.DROP_TOPO_MAP('Manhattan Topology');

SELECT a.parcel_name FROM land_parcels a, rivers b
WHERE SDO_ANYINTERACT (a.feature, b.feature) = 'TRUE';

SELECT a.parcel_name FROM land_parcels a
WHERE SDO_ANYINTERACT (
  a.feature,
  SDO_GEOMETRY
  (
    2003,NULL, NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,3)
    SDO_ORDINATE_ARRAY(14,20,15,22)
  )
) = 'TRUE';

SELECT topology_id, tg_layer_id FROM USER_SDO_TOPO_METADATA
WHERE topology = 'CITY_DATA'
AND table_name='LAND_PARCELS'
AND column_name='FEATURE';
