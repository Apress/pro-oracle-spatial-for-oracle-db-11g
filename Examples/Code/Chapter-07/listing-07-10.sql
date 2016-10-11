-- Listing 7-10. Getting the First,Middle, and Last Points of a Line String

-- Getting the first point of a line string
SELECT get_point(geom) p
FROM us_interstates
WHERE interstate='I95';

-- Getting the last point of a line string
SELECT get_point(geom, get_num_points(geom)) p
FROM us_interstates
WHERE interstate='I95';

-- Getting the middle point of a line string
SELECT get_point(geom, ROUND(get_num_points(geom)/2)) p
FROM us_interstates
WHERE interstate='I95';
