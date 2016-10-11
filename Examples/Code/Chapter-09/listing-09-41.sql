-- Listing 9-41. Computing the Convex Hull for the State of New Hampshire
SELECT SDO_GEOM.SDO_CONVEXHULL(st.geom, 0.5) cvxhl
FROM us_states st
WHERE st.state_abrv='NH';
