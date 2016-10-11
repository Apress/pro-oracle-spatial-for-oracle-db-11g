-- Listing 10-41. Removing a network constraint using DEREGISTER_CONSTRAINT()
EXECUTE SDO_NET_MEM.NETWORK_MANAGER.DEREGISTER_CONSTRAINT ( -
    'MyConstraint' -
);
