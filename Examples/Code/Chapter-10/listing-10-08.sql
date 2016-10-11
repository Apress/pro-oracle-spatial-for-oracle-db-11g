-- Listing 10-8. Views over Existing Tables
CREATE VIEW net_valves (node_id, valve_type, location) AS
  SELECT valve_id,
         valve_type,
         location
         -- ...other columns ...
  FROM valves;
CREATE VIEW net_pipes (link_id, start_node_id, end_node_id, length, pipe_geom) AS
  SELECT pipe_id,
         start_valve,
         end_valve,
         length,
         pipe_geom
         -- ... other columns ...
  FROM pipes;
