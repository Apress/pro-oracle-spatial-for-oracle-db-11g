-- Listing 7-4. Manipulating VARRAYs
SET SERVEROUTPUT ON
DECLARE

  -- Declare a type for the VARRAT
  TYPE MY_ARRAY_TYPE IS VARRAY(10) OF NUMBER;

  -- Declare a varray variable
  V               MY_ARRAY_TYPE;

  -- Other variables
  I               NUMBER;
  K               NUMBER;
  L               NUMBER;
  ARRAY_CAPACITY  NUMBER;
  N_ENTRIES       NUMBER;

BEGIN
  -- Initialize the array
  V := MY_ARRAY_TYPE (1,2,3,4);

  -- Get the value of a specific entry
  DBMS_OUTPUT.PUT_LINE('* Values for specific array entries');
  K := V(3);
  DBMS_OUTPUT.PUT_LINE('V(3)='|| V(3));
  I := 2;
  L := V(I+1);
  DBMS_OUTPUT.PUT_LINE('I=' || I);
  DBMS_OUTPUT.PUT_LINE('V(I+1)=' || V(I+1));

  -- Find the capacity of a VARRAY:
  DBMS_OUTPUT.PUT_LINE('* Array capacity');
  ARRAY_CAPACITY := V.LIMIT();
  DBMS_OUTPUT.PUT_LINE('Array Capacity: V.LIMIT()='||V.LIMIT());
  N_ENTRIES := V.COUNT();
  DBMS_OUTPUT.PUT_LINE('Current Array Size: V.COUNT()='||V.COUNT());

  -- Range over all values in a VARRAY
  DBMS_OUTPUT.PUT_LINE('* Array Content');
  FOR I IN 1..V.COUNT() LOOP
    DBMS_OUTPUT.PUT_LINE('V('||I||')=' || V(I));
  END LOOP;

  FOR I IN V.FIRST()..V.LAST() LOOP
   DBMS_OUTPUT.PUT_LINE('V('||I||')=' || V(I));
  END LOOP;

  I := V.COUNT();
  WHILE I IS NOT NULL LOOP
    DBMS_OUTPUT.PUT_LINE('V('||I||')=' || V(I));
    I := V.PRIOR(I);
  END LOOP;

  -- Extend the VARRAY
  DBMS_OUTPUT.PUT_LINE('* Extend the array');
  I := V.LAST();
  V.EXTEND(2);
  V(I+1) := 5;
  V(I+2) := 6;

  DBMS_OUTPUT.PUT_LINE('Array Capacity: V.LIMIT()='||V.LIMIT());
  DBMS_OUTPUT.PUT_LINE('Current Array Size: V.COUNT()='||V.COUNT());
  FOR I IN 1..V.COUNT() LOOP
    DBMS_OUTPUT.PUT_LINE('V('||I||')='|| V(I));
  END LOOP;

  -- Shrink the VARRAY
  DBMS_OUTPUT.PUT_LINE('* Trim the array');
  V.TRIM();

  DBMS_OUTPUT.PUT_LINE('Array Capacity: V.LIMIT()='||V.LIMIT());
  DBMS_OUTPUT.PUT_LINE('Current Array Size: V.COUNT()='||V.COUNT());
  FOR I IN 1..V.COUNT() LOOP
    DBMS_OUTPUT.PUT_LINE('V('||I||')='|| V(I));
  END LOOP;

  -- Delete all entries from the VARRAY
  DBMS_OUTPUT.PUT_LINE('* Empty the array');
  V.DELETE();

  DBMS_OUTPUT.PUT_LINE('Array Capacity: V.LIMIT()='||V.LIMIT());
  DBMS_OUTPUT.PUT_LINE('Current Array Size: V.COUNT()='||V.COUNT());
  FOR I IN 1..V.COUNT() LOOP
    DBMS_OUTPUT.PUT_LINE('V('||I||')='|| V(I));
  END LOOP;
END;
/
