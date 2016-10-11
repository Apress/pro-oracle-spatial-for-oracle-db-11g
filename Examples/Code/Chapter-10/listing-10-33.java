// Listing 10-33. Creating a Network Using the Java API

// Create the network object
String networkName = "MY_NET";
Network myNet = NetworkFactory.createLogicalNetwork(
  networkName,                  // networkName
  1,                            // noOfHierarchyLevels
  true,                         // isDirected
  networkName+"_NODE",          // nodeTableName
  "COST",                       // nodeCostColumn
  networkName+"_LINK",          // linkTableName
  "COST",                       // linkCostColumn
  networkName+"_PATH",          // pathTableName
  networkName+"_PLINK"          // pathLinkTableName
);

// Create the nodes
Node n1 = NetworkFactory.createNode (1, "N1");
Node n2 = NetworkFactory.createNode (2, "N2");
Node n3 = NetworkFactory.createNode (3, "N3");
Node n4 = NetworkFactory.createNode (4, "N4");
Node n5 = NetworkFactory.createNode (5, "N5");
Node n6 = NetworkFactory.createNode (6, "N6");
Node n7 = NetworkFactory.createNode (7, "N7");
Node n8 = NetworkFactory.createNode (8, "N8");
Node n9 = NetworkFactory.createNode (9, "N9");

// Create the links
Link l1 = NetworkFactory.createLink ( 1, "L1", n1, n2, 1);
Link l2 = NetworkFactory.createLink ( 2, "L2", n2, n3, 2);
Link l3 = NetworkFactory.createLink ( 3, "L3", n3, n6, 1);
Link l4 = NetworkFactory.createLink ( 4, "L4", n6, n9, 1);
Link l5 = NetworkFactory.createLink ( 5, "L5", n9, n8, 1);
Link l6 = NetworkFactory.createLink ( 6, "L6", n8, n7, 2);
Link l7 = NetworkFactory.createLink ( 7, "L7", n7, n1, 2);
Link l8 = NetworkFactory.createLink ( 8, "L8", n7, n4, 1.5);
Link l9 = NetworkFactory.createLink ( 9, "L9", n4, n5, 1);
Link l10 = NetworkFactory.createLink (10, "L10", n5, n6, 1);
Link l11 = NetworkFactory.createLink (11, "L11", n5, n8, 1);

// Add the nodes to the network
myNet.addNode (n1);
myNet.addNode (n2);
myNet.addNode (n3);
myNet.addNode (n4);
myNet.addNode (n5);
myNet.addNode (n6);
myNet.addNode (n7);
myNet.addNode (n8);
myNet.addNode (n9);

// Add the links to the network
myNet.addLink (l1);
myNet.addLink (l2);
myNet.addLink (l3);
myNet.addLink (l4);
myNet.addLink (l5);
myNet.addLink (l6);
myNet.addLink (l7);
myNet.addLink (l8);
myNet.addLink (l9);
myNet.addLink (l10);
myNet.addLink (l11);

// Create the network tables in the database
NetworkFactory.createNetworkTables (dbConnection, myNet);

// Write the network (this also writes the metadata)
NetworkManager.writeNetwork (dbConnection, myNet);
