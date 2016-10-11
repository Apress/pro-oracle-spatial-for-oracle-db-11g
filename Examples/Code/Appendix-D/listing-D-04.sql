-- Listing D-4. Creating a Trigger to Populate the Raster Data Table
-- Not needed in 11g.
call SDO_GEOR_UTL.createDMLTrigger('BRANCHES','GEORASTER');
