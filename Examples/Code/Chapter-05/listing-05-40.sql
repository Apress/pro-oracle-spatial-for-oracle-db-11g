-- Listing 5-40. Extracting the Second Element from a Geometry
SELECT SDO_UTIL.EXTRACT
(
  SDO_GEOMETRY
  (
    2007, -- multipolygon collection type geometry
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY
    (
      1,1003,3, -- first element descriptor triplet: for rectangle polygon
      -- (see Figure 4-10 and the accompanying listing in Chapter 4)
      5, 1003, 1 -- second element descriptor triplet:
      -- starting offset 5 means it starts at the 5th ordinate
    ),
    SDO_ORDINATE_ARRAY
    (
      1,1,2,2, -- first element ordinates (four for mbr)
      3,3, 4, 3, 4,4, 3,4, 3,4,3,3 -- second element starting at 5th ordinate:
      -- this second element is returned
    )
  ), -- End of the Geometry
  2 -- specifies the element number to extract
) second_elem
FROM dual;
