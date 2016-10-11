-- Listing 12-5. Creating a Cache in SQL with Detailed Zoom Levels

INSERT INTO user_sdo_cached_maps (name, description, tiles_table,
  is_online, is_internal, definition, base_map)
VALUES (
  'US_ROAD_MAP',
  'Map Cache for detailed US Road Map covering the lower 48 states only',
  'TILES_US_ROAD_MAP',
  'YES',
  'YES',
  '<cache_instance name="US_ROAD_MAP" image_format="PNG" antialias="true">
    <internal_map_source base_map="US_ROAD_MAP" data_source="SPATIAL"/>
    <cache_storage root_path=""/>
    <coordinate_system srid="8307" minX="-180" maxX="180"
      minY="-90" maxY="90"/>
    <tile_image width="256" height="256"/>
    <zoom_levels levels="20" min_scale="1000" max_scale="25000000">
      <zoom_level level_name="level0" scale="25000000"/>
      <zoom_level level_name="level1" scale="22000000"/>
      <zoom_level level_name="level2" scale="20000000"/>
      <zoom_level level_name="level3" scale="15000000"/>
      <zoom_level level_name="level4" scale="10000000"/>
      <zoom_level level_name="level5" scale=" 7500000"/>
      <zoom_level level_name="level6" scale=" 5000000"/>
      <zoom_level level_name="level7" scale=" 2000000"/>
      <zoom_level level_name="level8" scale=" 1500000"/>
      <zoom_level level_name="level9" scale=" 1000000"/>
      <zoom_level level_name="level10" scale=" 500000"/>
      <zoom_level level_name="level11" scale=" 200000"/>
      <zoom_level level_name="level12" scale=" 100000"/>
      <zoom_level level_name="level13" scale=" 80000"/>
      <zoom_level level_name="level14" scale=" 50000"/>
      <zoom_level level_name="level15" scale=" 20000"/>
      <zoom_level level_name="level16" scale=" 10000"/>
      <zoom_level level_name="level17" scale=" 5000"/>
      <zoom_level level_name="level18" scale=" 2000"/>
      <zoom_level level_name="level19" scale=" 1000"/>
    </zoom_levels>
  </cache_instance>',
  'US_ROAD_MAP'
);
