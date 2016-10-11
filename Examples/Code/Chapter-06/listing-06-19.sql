-- Listing 6-19. A Function Producing an SDO_GEO_ADDR Object
CREATE OR REPLACE FUNCTION geo_addr_poi (
  country  VARCHAR2,
  poi_name VARCHAR2
)
RETURN SDO_GEO_ADDR
AS
  geo_addr SDO_GEO_ADDR := SDO_GEO_ADDR();
BEGIN
  geo_addr.country := country;
  geo_addr.placename := poi_name;
  geo_addr.matchmode := 'DEFAULT';
return geo_addr ;
end;
/
