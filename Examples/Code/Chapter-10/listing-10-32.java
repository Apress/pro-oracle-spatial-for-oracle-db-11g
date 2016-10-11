// Listing 10-32. Network Constraint for Tracing and Debugging

/*
  This shows how to use the NetworkConstraint mechanism to trace and
  observe the search process used by the network API.
  It does not alter the search process: all it does is to dump out
  context information whenever it is called.
 */

import java.util.*;
import oracle.spatial.network.*;

public class NetworkTraceConstraint implements NetworkConstraint {

  private boolean firstCall = true;

  public boolean requiresPathLinks() {
    return false ;
  }

  public boolean isSatisfied (AnalysisInfo info) {
    this.dumpContext(info);
    return true;
  }

  private void dumpContext(AnalysisInfo info) {
    Link    cl  = info.getCurrentLink();
    Node    cn  = info.getCurrentNode();
    Link    nl  = info.getNextLink();
    Node    nn  = info.getNextNode();
    String  dbg = "";
    if (cn != null)
      dbg += "# " + cn.getID();
    else
      dbg += "# NULL";
    dbg += "\t" + info.getCurrentCost();
    dbg += "\t" + info.getCurrentDepth();
    dbg += "\t" + info.getCurrentDuration();
    if (nl != null)
      dbg += "\t" + nl.getID();
    else
      dbg += "\tNULL";
    if (nn != null)
      dbg += "\t" + nn.getID();
    else
      dbg += "\tNULL";
    dbg += "\t" + info.getNextCost();
    dbg += "\t" + info.getNextDepth();
    dbg += "\t" + info.getNextDuration();
    if (firstCall) {
      System.out.println ("# Trace level "+traceLevel);
      System.out.println ("# CNode\tCCost\tCDepth\tCDur\tNLink\tNnode\tNCost\tNDepth\tNDur");
      firstCall = false;
    }
    System.out.println (dbg);
  }
}
