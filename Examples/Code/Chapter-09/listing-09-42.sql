-- Listing 9-42. Computing the Centroid for the State of New Hampshire
SELECT SDO_GEOM.SDO_CENTROID(st.geom, 0.5) ctrd
FROM us_states st WHERE st.state_abrv='NH';
