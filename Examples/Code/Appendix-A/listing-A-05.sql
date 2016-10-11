-- Listing A-5. Estimating the Population in Sales Region 1 Using the Demographic Information in the zip5_dc Table
SELECT SDO_SAM.AGGREGATES_FOR_GEOMETRY
('ZIP5_DC', 'GEOM', 'SUM', 'POPULATION', a.geom) population
FROM sales_regions a WHERE a.id=1;
