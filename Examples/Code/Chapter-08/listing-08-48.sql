-- Listing 8-48. Adding the SDO_LEVEL=6 Parameter to an SDO_RELATE Query
SELECT COUNT(*)
FROM us_states st, competitors_sales_regions comp
WHERE st.state_abrv='DC'
AND SDO_RELATE(comp.geom, st.geom, 'MASK=INSIDE SDO_LEVEL=6' )='TRUE' ;
