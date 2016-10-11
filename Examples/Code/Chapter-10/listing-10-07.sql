-- Listing 10-7. Existing Water Network Tables
CREATE TABLE valves (
  valve_id      NUMBER PRIMARY KEY,
  valve_type    VARCHAR2(20),
  location      SDO_GEOMETRY
  -- ... other columns ...
);
CREATE TABLE pipes (
  pipe_id       NUMBER PRIMARY KEY,
  diameter      NUMBER,
  length        NUMBER,
  start_valve   NUMBER NOT NULL REFERENCES valves,
  end_valve     NUMBER NOT NULL REFERENCES valves,
  pipe_geom     SDO_GEOMETRY
  -- ... other columns ...
);
