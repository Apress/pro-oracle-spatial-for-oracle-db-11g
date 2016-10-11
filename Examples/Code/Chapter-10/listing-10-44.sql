-- Listing 10-44. Using the SHORTEST_PATH() Function with a network constraint
DECLARE
  test_net      VARCHAR2(30) := 'UNET';
  start_node_id NUMBER  := 7;
  end_node_id   NUMBER  := 5;
  constraint    VARCHAR2(30) := 'LinkLevelConstraint';
  path          NUMBER;
  link_array    SDO_NUMBER_ARRAY;
  node_array    SDO_NUMBER_ARRAY;
BEGIN
  -- Get shortest path between two nodes
  path := SDO_NET_MEM.NETWORK_MANAGER.SHORTEST_PATH (test_net, start_node_id, end_node_id, constraint);

  -- Make sure we have a result
  IF path IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('No path found');
    RETURN;
  END IF;

  -- Show path cost and number of links
  DBMS_OUTPUT.PUT_LINE('Target link level: ' || link_level_constraint.get_target_level());
  DBMS_OUTPUT.PUT_LINE('Path cost: ' || SDO_NET_MEM.PATH.GET_COST(test_net, path));
  DBMS_OUTPUT.PUT_LINE('Number of links: ' || SDO_NET_MEM.PATH.GET_NO_OF_LINKS(test_net, path));
  DBMS_OUTPUT.PUT_LINE('Simple path? ' || SDO_NET_MEM.PATH.IS_SIMPLE(test_net, path));

  -- Show the links traversed
  DBMS_OUTPUT.PUT_LINE('Links traversed:');
  link_array := SDO_NET_MEM.PATH.GET_LINK_IDS(test_net, path);
  FOR i IN link_array.first..link_array.last LOOP
    DBMS_OUTPUT.PUT_LINE('* Link ' || link_array(i) || ' ' ||
      SDO_NET_MEM.LINK.GET_NAME (test_net, link_array(i)) || ' ' ||
      SDO_NET_MEM.LINK.GET_LEVEL (test_net, link_array(i)) || ' ' ||
      SDO_NET_MEM.LINK.GET_COST (test_net, link_array(i))
    );
  END LOOP;

  -- Show the nodes traversed
  DBMS_OUTPUT.PUT_LINE('Nodes traversed:');
  node_array := SDO_NET_MEM.PATH.GET_NODE_IDS(test_net, path);
  FOR i IN node_array.first..node_array.last LOOP
    DBMS_OUTPUT.PUT_LINE('* Node ' || node_array(i) || ' ' ||
       SDO_NET_MEM.NODE.GET_NAME (test_net, node_array(i)) || ' ' ||
       SDO_NET_MEM.NODE.GET_COST (test_net, node_array(i))
    );
  END LOOP;
END;
/
