-- Listing 6-9. Getting Street Details from the Geocode Reference Data
SELECT road_id, name, postal_code, start_hn, center_hn, end_hn
FROM   gc_road_us
WHERE  name = 'CLAY ST'
AND    postal_code like '94%'
ORDER BY start_hn;
