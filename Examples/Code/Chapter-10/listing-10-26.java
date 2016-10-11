// Listing 10-26. Using the allPaths()Method

// Get all paths between nodes 3 and 4
maxDepth = 1000;
maxCost = 1000;
maxSolutions = 1000;
Path[] pathArray =
NetworkManager.allPaths(uNet, 3, 4, maxDepth, maxCost, maxSolutions);;

// Display the solutions found
for (int i = 0; i < pathArray.length; i++)
{
  Path p = pathArray[i];
  int numLinks = p.getNoOfLinks();
  double cost = p.getCost();
  System.out.println (" path["+i+"] links:" + numLinks + ", path cost "+ cost);
}
