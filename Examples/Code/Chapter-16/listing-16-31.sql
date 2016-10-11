-- Listing 16-31. Determining the SRIDValue in the Location (Geometry) Columns of a Table
SELECT ct.location.sdo_srid FROM customers ct WHERE ROWNUM=1;
