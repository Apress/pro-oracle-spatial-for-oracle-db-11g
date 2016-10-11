// Listing 9-8. Finding the Closest Points Using the J3D_Geometry Java API
// Assume traj and bldg16 represent the J3D_Geometry objects
// for trajectory and building 16
ArrayList closest_pts = traj.closestPoints(bldg16, tol); // tol is the tolerance
J3D_Geometry pt1 = (J3D_Geometry) closest_pts.get(0);
J3D_Geometry pt2 = (J3D_Geometry) closest_pts.get(1);
Double dist = pt1.distance(pt2, tol);
