-- Listing 8-42. SDO_RELATE Operator Identifying All Competitors in the D.C. Region
SELECT COUNT(*)
FROM us_states st, competitors_sales_regions comp
WHERE st.state_abrv='DC'
AND SDO_RELATE(comp.geom, st.geom, 'MASK=ANYINTERACT ' )='TRUE';
