-- Listing 12-7. Creating a Cache on an External WMS

INSERT INTO user_sdo_cached_maps (name, description, tiles_table,
  is_online, is_internal, definition, base_map)
VALUES (
  'USGS_SHADED_RELIEF',
  'Map Cache external Mapviewer data source',
  'TILES_USGS_SHADED_RELIEF',
  'YES',
  'YES',
  '<cache_instance name="USGS_SHADED_RELIEF" image_format="PNG" antialias="true">
    <external_map_source
      url="http://gisdata.usgs.gov:80/wmsconnector/com.esri.wms.Esrimap/USGS_EDC_Elev_GTOPO"
      adapter_class="mcsadapter.WMSAdapter"
      proxy_host="www-us.oracle.com"
      proxy_port="80"
      timeout="5000"
    >
      <properties>
        <property name="srs" value="EPSG:4326"/>
        <property name="serviceName" value="USGS_WMS_GTOPO"/>
        <property name="layers" value="GLOBAL.GTOPO60_COLOR_RELIEF"/>
        <property name="format" value="image/png"/>
        <property name="transparent" value="false"/>
      </properties> />
    </external_map_source>
    <cache_storage root_path=""/>
    <coordinate_system srid="4326" minX="-180" maxX="180"
      minY="-90" maxY="90"/>
    <tile_image width="512" height="512"/>
    <zoom_levels levels="10" min_scale="1000" max_scale="25000000">
    </zoom_levels>
  </cache_instance>',
  'USGS_SHADED_RELIEF'
);
