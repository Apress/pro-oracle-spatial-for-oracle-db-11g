-- Listing 9-43. Obtaining a Point on the Surface of the Geometry of the State of Massachusetts
SELECT SDO_GEOM.SDO_POINTONSURFACE(st.geom, 0.5) pt
FROM us_states st
WHERE state_abrv='MA';

