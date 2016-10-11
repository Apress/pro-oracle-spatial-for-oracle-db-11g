-- Listing 9-27. Inserting a New Building of Dimensions 200 Feet by 200 Feet by 400 Feet into city_buildings
insert into city_buildings (id, geom)
values (
  1, -- ID of the building
  sdo_geometry(3008, 7407, null,
    sdo_elem_info_array(1,1007,3), -- 3 represents a Solid Box representation using just the corner points
    sdo_ordinate_array(
      27731202, 42239124, 0,    -- Min values for x, y, z
      27731402, 42239324, 400   -- Max values for x, y, z
    )
  )
);
commit;
