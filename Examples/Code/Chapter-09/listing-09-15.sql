-- Listing 9-15. RELATE Function Complementing the SDO_RELATE Operator
SELECT sra.id,
       SDO_GEOM.RELATE(sra.geom, 'DETERMINE', srb.geom, 0.5) relationship
FROM sales_regions srb, sales_regions sra
WHERE srb.id=51
AND sra.id<>51
AND SDO_RELATE (
  sra.geom, srb.geom,
 'mask=TOUCH+OVERLAPBDYDISJOINT+OVERLAPBDYINTERSECT'
) = 'TRUE'
ORDER BY sra.id;
