// Listing 10-23. Using the tspPath()Method

// Traveling Salesperson Problem: nodes N7, N2, N3, N5, then back to N7
Network testNet = uNet;
int[] nodeIds = {7,2,3,5};
boolean isClosed = true;
boolean useExactCost = true;
Path tspPath = NetworkManager.tspPath (testNet, nodeIds, isClosed,
  useExactCost, null);

// Display the resulting path
Link[] linkArray = tspPath.getLinkArray();
System.out.println ("  Path cost: " + tspPath.getCost() );
System.out.println ("  Number of links: "+ tspPath.getNoOfLinks());
System.out.println ("  Simple path? "+ tspPath.isSimple());
for (int i = 0; i < linkArray.length; i++)
  System.out.println ("    Link " + linkArray[i].getID() + "\t"
    + linkArray[i].getName()
    + "\t(cost: " + linkArray[i].getCost() + ")" );

// Display the visitation order
Node[]visitedNodes =  tspPath.getTspNodeOrder();
System.out.println ("  Actual node visitation order : " );
for (int i = 0; i < visitedNodes.length; i++)
  System.out.println ("    Node " + visitedNodes [i].getID() + "\t" +
     visitedNodes [i].getName());
