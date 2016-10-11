-- Listing 4-3. Example of the SDO_GTYPE in the location Column of the customers Table
SELECT ct.location.sdo_gtype FROM customers ct WHERE id=1;
