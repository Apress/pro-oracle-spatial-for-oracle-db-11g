-- Listing 9-12. Using the J3D_Geometry.anyinteractMethod to Determine the Buildings That Intersect the Helicopter Trajectory
// Assume ids of the buildings from city_buildings table
// are fetched into the ArrayList idarr;
// and corresponding geom column is fetched into the ArrayList bldgarr
for (int i=0; i<bldg_geom.size(); i++) {
  J3D_Geometry bldg = (J3D_Geometry) bldgarr.get(i);
  int id = idarr.get(i);
  if (traj.anyInteract(bldg, tol) = true) // tol is the tolerance value
  System.out.println(id);
}
