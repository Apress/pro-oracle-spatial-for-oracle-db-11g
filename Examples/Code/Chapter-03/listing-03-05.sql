-- Listing 3-5. Geocoding Addresses to Obtain Explicit Spatial Information
UPDATE customers
SET location =
SDO_GCDR.GEOCODE_AS_GEOMETRY
(
'SPATIAL',
SDO_KEYWORDARRAY
(
 street_number || ` ` || street_name, -- add whitespace between street_number and street_name
 city || `, ` || state || ` ` || postal_code
),
'US'
) ;
