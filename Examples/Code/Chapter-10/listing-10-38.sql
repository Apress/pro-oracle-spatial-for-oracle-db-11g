-- Listing 10-38. Defining a network constraint for use by the PL/SQL API
INSERT INTO user_sdo_network_constraints (constraint, description, class_name)
VALUES (
  'NetworkTraceConstraint',
  'Tracing network algorithms',
  'NetworkTraceConstraint'
);
COMMIT;
