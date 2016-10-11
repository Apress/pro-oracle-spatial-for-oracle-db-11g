-- Listing 4-32. SQL for Three-Dimensional Polygon in Figure 4-23 (a)
INSERT INTO geometry_examples (name, description, geom) VALUES
(
  '3-D Polygon',
  '3-dimensional Polygon from coordinates (2,0,2) to (4,0, 4) ',
  SDO_GEOMETRY
  (
    3003,       -- SDO_GTYPE format: D00T. Set to 3003 for a 3-dimensional line
    NULL,       -- No coordinate system
    NULL,       -- No data in SDO_POINT attribute
    SDO_ELEM_INFO_ARRAY(
      1,        -- Offset for ordinates in SDO_ORDINATE_ARRAY
      3,        -- Polygon type
      1         -- Connected by straight lines
    ),
    SDO_ORDINATES_ARRAY
    (
      2, 0, 2,  -- coordinate values for first point
      2, 0, 4,  -- coordinate values for second point
      4, 0, 4,  -- coordinate values for third point
      4, 0, 2,  -- coordinate values for fourth point
      2, 0, 2   -- coordinate values for first point
    )
  )
);
