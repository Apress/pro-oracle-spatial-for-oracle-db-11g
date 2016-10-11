-- Listing 3-8. Creating the us_states Table
CREATE TABLE us_states
(
state VARCHAR2(26),
state_abrv VARCHAR2(2),
totpop NUMBER,
landsqmi NUMBER,
poppssqmi NUMBER,
medage NUMBER,
medhhinc NUMBER,
avghhinc NUMBER,
geom SDO_GEOMETRY
);
