-- Listing 4-5. Example of SDO_GTYPE in the location Column of the us_states Table
SELECT s.geom.sdo_gtype FROM us_states s WHERE state_abrv='NH';
