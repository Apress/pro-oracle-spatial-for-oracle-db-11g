// Listing 10-25. Using the mcst()Method

// Compute the Minimum Spanning Cost Tree
Network mcstNet = NetworkManager.mcst(uNet);

// Inspect the resulting network
System.out.println (" Nodes: " + mcstNet.getNoOfNodes());
System.out.println (" Links: " + mcstNet.getNoOfLinks());

// Display MCST network links
Link[] linkArray = mcstNet.getLinkArray();
double treeCost = 0;
for (int i = 0; i < linkArray.length; i++) {
  System.out.println (" Link " + linkArray[i].getID() + "\t"
    + linkArray[i].getName()+ "\t"
    + linkArray[i].getCost());
treeCost = treeCost + linkArray[i].getCost();
}
System.out.println (" Total cost: \t\t" + treeCost);
