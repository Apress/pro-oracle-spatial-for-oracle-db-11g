// Listing 10-27. Using the shortestPaths()Method

// Get the shortest paths between node 4 and all other nodes
Path[] pathArray = NetworkManager.shortestPaths(uNet, 4);
for (int i = 0; i < pathArray.length; i++)
{
  Path p = pathArray[i];
  int endNodeId = p.getEndNode().getID();
  int numLinks = p.getNoOfLinks();
  double cost = p.getCost();
  System.out.println (" path["+i+"] to node " + endNodeId + ", links:"
    + numLinks + ", path cost "+ cost);
}
