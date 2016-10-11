-- Listing 2-6. Finding the Five Nearest Restaurants on I-795 Using the Spatial Index
SELECT poi_name
FROM us_interstates I, us_restaurants P
WHERE I.interstate = 'I795'
AND SDO_NN(P.location, I.geom) ='TRUE'
AND ROWNUM <= 5;
