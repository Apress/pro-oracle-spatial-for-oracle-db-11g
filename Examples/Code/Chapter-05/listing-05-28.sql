-- Listing 5-28. Script for Extruding Three-Dimensional Buildings from Their Footprints
-- For buildings 4,5,9,13,16,17, set topheight to 500
insert into city_buildings
select id, type,
  sdo_util.extrude(footprint,
    SDO_NUMBER_ARRAY(0),
    SDO_NUMBER_ARRAY(500),
    'TRUE', 0.05)
from building_footprints
where id in (4,5, 9, 13, 16, 17);

-- For buildings 3,10,15, set topheight to 400
insert into city_buildings
select id, type,
  sdo_util.extrude(footprint,
    SDO_NUMBER_ARRAY(0),
    SDO_NUMBER_ARRAY(400),
    'TRUE', 0.05)
from building_footprints
where id in (3, 10, 15);

-- For buildings 14, set topheight to 900
insert into city_buildings
select id, type,
  sdo_util.extrude(footprint,
    SDO_NUMBER_ARRAY(0),
    SDO_NUMBER_ARRAY(900),
    'TRUE', 0.05)
from building_footprints
where id=14 ;

-- For buildings 6,7,8,11,12, set topheight to 650
insert into city_buildings
select id, type,
  sdo_util.extrude(footprint,
    SDO_NUMBER_ARRAY(0),
    SDO_NUMBER_ARRAY(650),
    'TRUE', 0.05)
from building_footprints
where id in (6, 7, 8, 11, 12) ;

-- For rest of buildings set topheight to 600

insert into city_buildings
select id, type,
  sdo_util.extrude(footprint,
    SDO_NUMBER_ARRAY(0),
    SDO_NUMBER_ARRAY(600),
'TRUE', 0.05) from building_footprints
where id in (17, 18, 19) ;

-- Update the srid to 7407 and commit
update city_buildings a set a.geom.sdo_srid=7407;
commit;
