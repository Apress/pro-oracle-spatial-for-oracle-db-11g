-- Listing 6-21. Example of Calling the REVERSE_GEOCODE Function
SET SERVEROUTPUT ON
BEGIN
  FORMAT_GEO_ADDR (
    SDO_GCDR.REVERSE_GEOCODE (
      'SPATIAL',
      SDO_GEOMETRY (
        2001,
        8307,
        SDO_POINT_TYPE (-122.4152166, 37.7930, NULL),
        NULL, NULL
      ),
      'US'
    )
  );
END;
/
