-- Listing 10-36. Using the TSP_PATH() Function
DECLARE
  test_net        VARCHAR2(30) := 'UNET';
  node_ids        SDO_NUMBER_ARRAY := SDO_NUMBER_ARRAY(7,2,3,5);
  is_closed       CHAR(5) := 'TRUE';
  use_exact_cost  CHAR(5) := 'TRUE';
  path            NUMBER;
  link_array      SDO_NUMBER_ARRAY;
  node_array      SDO_NUMBER_ARRAY;
BEGIN
  --  Traveling Salesperson Problem: nodes N7, N2, N3, N5, then back to N7
  path := SDO_NET_MEM.NETWORK_MANAGER.TSP_PATH (test_net, node_ids, is_closed, use_exact_cost);

  -- Make sure we have a result
  IF path IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('No path found');
    RETURN;
  END IF;

  -- Show path cost and number of links
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

END;
/

