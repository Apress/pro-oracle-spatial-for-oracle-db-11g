// Listing 10-20. Using the shortestPath()Method

// Get shortest path from node N4 to N3
Network testNet = uNet;
startNodeId = 4;
endNodeId = 3;
Path path = NetworkManager.shortestPath (testNet, startNodeID ,endNodeId);

// Show path cost and number of links
System.out.println ("Path cost: " + path.getCost() );
System.out.println ("Number of links: "+ path.getNoOfLinks());
System.out.println ("Simple path? "+ path.isSimple());

// Show the links traversed
System.out.println ("Links traversed:");
Link[] linkArray = path.getLinkArray();
for (int i = 0; i < linkArray.length; i++)
  System.out.println (" Link " + linkArray[i].getID() + "\t"
    + linkArray[i].getName() +"\t" + linkArray[i].getCost());

// Show the nodes traversed
System.out.println (" Nodes traversed:");
Node [] nodeArray = path.getNodeArray();
for (int i = 0; i < nodeArray.length; i++)
  System.out.println (" Node " + nodeArray[i].getID() + "\t"
    + nodeArray[i].getName() +"\t" + nodeArray[i].getCost());
