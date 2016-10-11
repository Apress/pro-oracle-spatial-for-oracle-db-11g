// Listing 10-24. Using the findReachableNodes()Method

// Find nodes that can be reached from node N4
Network testNet = uNet;
nodeId = 4;
Node[] nodeArray = NetworkManager.findReachableNodes (testNet, nodeId);

// Display the results
System.out.println (" " + nodeArray.length + " nodes in network "
  + testNet.getName() + " are reachable from node " + nodeId);
for (int i = 0; i < nodeArray.length; i++)
  System.out.println(" node " + nodeArray[i].getID());
