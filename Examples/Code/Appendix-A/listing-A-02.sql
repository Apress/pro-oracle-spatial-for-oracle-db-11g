-- Listing A-2. Tiling a Two-Dimensional Space by Specifying the Number of Divisions Along x- and y-axes
SELECT * FROM TABLE
(SDO_SAM.TILED_BINS(-77.1027, -76.943996, 38.820813, 38.95911, NULL, 8307, 2, 3 ));
