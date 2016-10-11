-- Listing 3-9. Creating the us_counties Table
CREATE TABLE us_counties
(
id NUMBER NOT NULL,
county VARCHAR2(31),
state VARCHAR2(30),
state_abrv VARCHAR2(2),
landsqmi NUMBER,
totpop NUMBER,
poppsqmi NUMBER,
geom SDO_GEOMETRY
);
