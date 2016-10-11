// Listing 10-28. Using the SystemConstraint Class

// Set up a system constraint with a list of nodes to avoid and a cost limit
int[] avoidNodes = {5}; // Nodes to avoid
SystemConstraint myConstraint = new SystemConstraint (uNet, avoidNodes);
myConstraint.setMaxCost(10);

// Get shortest path from node N4 to N3 considering the constraint
Path path = NetworkManager.shortestPath (uNet, 3, 4, myConstraint);

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
