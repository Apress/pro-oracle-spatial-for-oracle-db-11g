-- Listing 8-54. Creating a Deterministic Function to Return an SDO_GEOMETRY Using Address Attributes of the customers Table
CREATE or REPLACE FUNCTION gcdr_geometry(
  street_number   varchar2,
  street_name     varchar2,
  city            varchar2,
  state           varchar2,
  postal_code     varchar2
)
RETURN MDSYS.SDO_GEOMETRY DETERMINISTIC is
BEGIN
  RETURN (
    sdo_gcdr.geocode_as_geometry(
      'SPATIAL',
      sdo_keywordarray(
        street_number || ' ' ||street_name ,
        city || ' ' || state || ' ' || postal_code
      ),
      'US')
  );
END;
/
