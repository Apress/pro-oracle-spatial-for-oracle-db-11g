-- Listing E-12. Creating tin_blktab As the Block Table for the TIN Data
CREATE TABLE tin_blktab AS SELECT * FROM MDSYS.SDO_TIN_BLK_TABLE;
