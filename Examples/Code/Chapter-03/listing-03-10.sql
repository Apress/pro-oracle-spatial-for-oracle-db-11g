-- Listing 3-10. Creating the us_interstates Table
CREATE TABLE us_interstates
(
id NUMBER,
interstate VARCHAR2(35),
geom SDO_GEOMETRY
);
CREATE TABLE us_streets
(
id NUMBER,
street_name VARCHAR2(35),
city VARCHAR2(32),
state VARCHAR2(32),
geom SDO_GEOMETRY
);

