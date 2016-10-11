-- Listing 12-4. Creating a Cache in SQL

INSERT INTO user_sdo_cached_maps (name, description, tiles_table,
  is_online, is_internal, definition, base_map)
VALUES (
  'US_ROAD_MAP',
  'Map Cache for overview US Road Map',
  'TILES_US_ROAD_MAP',
  'YES',
  'YES',
  '<cache_instance name="US_ROAD_MAP" image_format="PNG" antialias="true">
    <internal_map_source base_map="US_ROAD_MAP" data_source="SPATIAL"/>
    <cache_storage root_path=""/>
    <coordinate_system srid="8307" minX="-180" maxX="180"
      minY="-90" maxY="90"/>
    <tile_image width="256" height="256"/>
    <zoom_levels levels="10" min_scale="1000" max_scale="25000000">
    </zoom_levels>
    </cache_instance>',
  'US_ROAD_MAP'
);
