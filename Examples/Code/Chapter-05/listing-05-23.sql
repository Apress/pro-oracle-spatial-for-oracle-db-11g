-- Listing 5-23. Converting a Three-Dimensional Solid SDO_GEOMETRY to GML311
SELECT TO_CHAR(
  SDO_UTIL.TO_GML311GEOMETRY (
    SDO_GEOMETRY
    (
      3008, -- SDO_GTYPE format: D00T. Set to 3008 for a 3-dimensional Solid
      NULL, -- No coordinate system
      NULL, --- No data in SDO_POINT attribute
      SDO_ELEM_INFO_ARRAY (
        1, -- Offset of a Simple solid element
        1007, --- Etype for a Simple solid
        3 -- Indicates an axis-aligned box
      ),
      SDO_ORDINATE_ARRAY (
        0,0,0, --min-corners for box
        4,4,4 --min-corners for box
      )
    )
  )
) AS GML_GEOMETRY FROM DUAL;
