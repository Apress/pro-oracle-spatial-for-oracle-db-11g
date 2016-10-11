-- Listing 4-6. Example of SDO_GTYPE in the location Column of the us_states Table
SELECT c.geom.sdo_gtype FROM us_cities c WHERE state_abrv='TX';
