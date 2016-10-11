-- Listing 9-7. Obtaining the Closest Points on Building 16 and Helicopter Trajectory
set serverout on
declare
  traj sdo_geometry;
  bldg16 sdo_geometry;
  dist number;
  trajpt sdo_geometry;
  bldg16pt sdo_geometry;
begin
  select geom INTO bldg16 from city_buildings where id=16;
  select trajectory into traj from trip_route where rownum<=1;
  bldg16.sdo_srid:=null;      -- Workaround for Bug 6201938
  traj.sdo_srid:=null;        -- Workaround for Bug 6201938
  sdo_geom.sdo_closest_points(
    traj, bldg16, 0.05, 'UNIT=FOOT',
    dist, trajpt, bldg16pt);
  dbms_output.put_line('Distance= ' || TO_CHAR(dist));
  dbms_output.put_line('Pt on Trajectory:' ||
    TO_CHAR(trajpt.sdo_point.x) || ', ' ||
    TO_CHAR(trajpt.sdo_point.y) || ', ' ||
    TO_CHAR(trajpt.sdo_point.z));
  dbms_output.put_line('Pt on Bldg16:' ||
    TO_CHAR(bldg16pt.sdo_point.x) || ', ' ||
    TO_CHAR(bldg16pt.sdo_point.y) || ', ' ||
    TO_CHAR(bldg16pt.sdo_point.z));
end;
/
