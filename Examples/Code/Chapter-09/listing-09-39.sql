-- Listing 9-39. Obtaining the MIN_ORDINATEs and MAX_ORDINATEs in a Specific Dimension
SELECT SDO_GEOM.SDO_MIN_MBR_ORDINATE(sr.geom, 1) min_extent,
SDO_GEOM.SDO_MAX_MBR_ORDINATE(sr.geom, 1) max_extent
FROM sales_regions sr WHERE sr.id=1;
