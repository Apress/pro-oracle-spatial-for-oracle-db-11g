// Listing 9-33. Length of Building 1 (in Default Units of Feet) in Java

// Assume bldg1 is loaded into the J3D_Geometry object as described in Chapter 7.
int count_shared_edges = 1; // count shared edges only once
double area = bldg1.length(count_shared_edges, tol); // tol is the tolerance value

