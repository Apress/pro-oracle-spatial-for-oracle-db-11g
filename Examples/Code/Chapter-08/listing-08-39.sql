-- Listing 8-39. Typical Query from MapViewer Using the SDO_FILTER Operator
SELECT location
FROM customers
WHERE SDO_FILTER
(
  location,
  SDO_GEOMETRY
  (
    2003, 8307, null,
    SDO_ELEM_INFO_ARRAY(1, 1003, 3), -- Rectangle query window
    SDO_ORDINATE_ARRAY(-122.43886,37.78284,-122.427195,37.79284)
  )
) = 'TRUE';
