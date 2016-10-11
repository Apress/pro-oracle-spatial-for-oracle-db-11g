-- Listing 8-47. Verifying That a Sales Region Touches Another Sales Region (id=51)
SELECT a.id
FROM sales_regions b, sales_regions a
WHERE b.id=51
AND a.id <> 51
AND SDO_RELATE(a.geom, b.geom, 'MASK=TOUCH' )='TRUE' ;
