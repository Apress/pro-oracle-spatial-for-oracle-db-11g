-- Listing 12-8. Creating a Cache on an External MapViewer Server

INSERT INTO user_sdo_cached_maps (name, description, tiles_table,
  is_online, is_internal, definition, base_map)
VALUES (
  'ELOCATION_MAP',
  'Map Cache external Mapviewer data source',
  'TILES_ELOCATION_MAP',
  'YES',
  'YES',
  '<cache_instance name="ELOCATION_MAP" image_format="PNG" antialias="true">
    <external_map_source
      url="http://elocation.oracle.com/elocation/lbs"
      adapter_class="mcsadapter.MVAdapter"
      proxy_host="www-proxy.us.oracle.com"
      proxy_port="80"
      timeour="5000"
    >
      <properties>
        <property name="data_source" value="elocation"/>
        <property name="base_map" value="us_base_map"/>
      </properties> />
    </external_map_source>
    <cache_storage root_path=""/>
    <coordinate_system srid="8307" minX="-180" maxX="180"
      minY="-90" maxY="90"/>
    <tile_image width="512" height="512"/>
    <zoom_levels levels="10" min_scale="1000" max_scale="25000000">
    </zoom_levels>
  </cache_instance>',
  'ELOCATION_MAP'
);
