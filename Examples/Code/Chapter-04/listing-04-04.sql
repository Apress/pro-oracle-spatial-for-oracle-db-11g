-- Listing 4-4. Example of SDO_GTYPE in the geom Column of the us_interstates Table
SELECT i.geom.sdo_gtype FROM us_interstates i WHERE rownum=1;
