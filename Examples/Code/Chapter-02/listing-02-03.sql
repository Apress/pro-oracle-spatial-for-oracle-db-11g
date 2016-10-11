-- Listing 2-3. Converting Address Data (Implicit Spatial Information) to the SDO_GEOMETRY (Explicit
Spatial Information) Object
SELECT
SDO_GCDR.GEOCODE_AS_GEOMETRY
(
 'SPATIAL', -- Spatial schema storing the geocoder data
 SDO_KEYWORDARRAY -- Object combining different address components
 (
 '3746 CONNECTICUT AVE NW',
 'WASHINGTON, DC 20008'
 ),
 'US' -- Name of the country
) geom
FROM DUAL ;
