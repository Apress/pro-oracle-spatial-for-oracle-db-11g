-- Listing D-18. Creating a Predefined Theme for the georaster Column in the branches Table
INSERT INTO user_sdo_themes VALUES
(
'BRANCHES_Images',      -- Theme name
'Tiff Image',           -- Description
'BRANCHES',             -- Base table name
'GEORASTER',            -- Column name storing georaster object in table
'<?xml version="1.0" standalone="yes"?>
<styling_rules theme_type="georaster" raster_table="BRANCHES_RDT"
raster_id="1" >
</styling_rules>'       -- Theme style definition
);
