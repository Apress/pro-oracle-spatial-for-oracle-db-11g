-- Listing 2-4. Finding the Five Nearest Restaurants on I-795
SELECT poi_name
FROM
(
 SELECT poi_name,
 SDO_GEOM.SDO_DISTANCE(P.location, I.geom, 0.5) distance
 FROM us_interstates I, us_restaurants P
 WHERE I.interstate = 'I795'
 ORDER BY distance
)
WHERE ROWNUM <= 5;
