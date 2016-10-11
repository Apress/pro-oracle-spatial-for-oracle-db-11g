// Listing 10-21. Using the nearestNeighbors()Method

// Find the two nearest neighbors of node N4
Network testNet = uNet;
startNodeId = 4;
numNeighbors = 2;
Path[] pathArray =
NetworkManager.nearestNeighbors (testNet, startNodeId, numNeighbors);

// Display the resulting paths
System.out.println (" " + pathArray.length + " nearest neighbors of node "
  + startNodeId + " in network " + testNet.getName());
for (int i = 0; i < pathArray.length; i++)
{
  Path path = pathArray[i];
  System.out.println(" node " + path.getEndNode().getID() +
    ", path cost " + path.getCost());
}
