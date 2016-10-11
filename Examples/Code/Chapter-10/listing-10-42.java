// Listing 10-42. Network Constraint for the PL/SQL API

import java.util.*;
import oracle.spatial.network.*;

/**
 * The following network constraint assumes that
 * 1. each link has a link level (stored as LINK_LEVEL in { 1,2,3 })
 * 2. for a given target level (in { 1,2,3 } ), the following must hold:
 *    target Level 1 can only travel on link Level 1
 *    target Level 2 can travel on link Level 1 and 2
 *    target Level 3 can travel on link Level 1, 2, and 3
 */

public class LinkLevelConstraint implements NetworkConstraint {
  static int targetLevel = 0; // Default; no restriction

  public LinkLevelConstraint () {
  }

  public LinkLevelConstraint (int newTargetLevel) {
    targetLevel = newTargetLevel;
  }

  public static void setTargetLevel (int newTargetLevel) {
    targetLevel = newTargetLevel;
  }

  public static int getTargetLevel () {
    return targetLevel;
  }

  public boolean requiresPathLinks() {
    return false ;
  }

  public boolean isSatisfied (AnalysisInfo info) {
    if ( targetLevel == 0 ) // no restriction
      return true ;
    Link link = info.getNextLink() ; // potential link candidate
    int linkLevel = link.getLinkLevel(); // get link Level
    if ( link != null && targetLevel >= linkLevel )
      return true;
    else
      return false;
  }
}
