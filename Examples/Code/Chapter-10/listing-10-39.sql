-- Listing 10-39. Defining a network constraint using REGISTER_CONSTRAINT()
EXECUTE SDO_NET_MEM.NETWORK_MANAGER.REGISTER_CONSTRAINT ( -
    'MyConstraint', -
    'NetworkTraceConstraint', -
    'CONSTRAINTS_CLASSES_DIR', -
    'Tracing network algorithms' -
)
