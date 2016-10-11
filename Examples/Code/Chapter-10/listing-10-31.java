// Listing 10-31. Using the Network Constraint

// Set up network constraint
int targetLevel = 1;
LinkLevelConstraint netConstraint = new LinkLevelConstraint (targetLevel);

// Get shortest path from node N7 to N5
Network testNet = uNet;
startNodeId = 7;
endNodeId = 5;
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
    + linkArray[i].getName() +"\t"
    + linkArray[i].getLinkLevel() + "\t"
    + linkArray[i].getCost() );

// Show the nodes traversed
System.out.println (" Nodes traversed:");
Node [] nodeArray = path.getNodeArray();
for (int i = 0; i < nodeArray.length; i++)
  System.out.println (" Node " + nodeArray[i].getID() + "\t"
    + nodeArray[i].getName() +"\t"
    + nodeArray[i].getCost());
