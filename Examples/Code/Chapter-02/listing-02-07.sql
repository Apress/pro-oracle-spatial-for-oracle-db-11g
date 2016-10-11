-- Listing 2-7. Identifying All Restaurants in a 50 km Radius Around I-795
SELECT POI_NAME
FROM us_interstates I, us_restaurants P
WHERE
SDO_ANYINTERACT
(
 P.location,
 SDO_GEOM.SDO_BUFFER(I.geom, 50, 0.5, 'UNIT=KM')
) ='TRUE'
AND I.interstate='I795' ;
