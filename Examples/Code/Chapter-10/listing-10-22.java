// Listing 10-22. Using the withinCost()Method

// Find nodes that are less than 3 'cost units' from node N2
Network testNet = uNet;
startNodeId = 2;
maxCost = 3;
Path[] pathArray =
NetworkManager.withinCost (testNet, startNodeId, maxCost);

// Display the resulting paths
System.out.println (" " + pathArray.length + " nodes from node "
  + startNodeId + " in network " + testNet.getName() +
  " within a cost of " + maxCost + ": ");
for (int i = 0; i < pathArray.length; i++)
{
  Path path = pathArray[i];
  System.out.println(" node " + path.getEndNode().getID() +
    ", path cost " + path.getCost());
}
