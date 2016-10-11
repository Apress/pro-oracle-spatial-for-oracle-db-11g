-- Listing 10-43. Defining PL/SQL wrappers
CREATE OR REPLACE PACKAGE link_level_constraint AS
  PROCEDURE set_target_level (new_target_level NUMBER);
  FUNCTION get_target_level RETURN NUMBER;
END;
/
CREATE OR REPLACE PACKAGE BODY link_level_constraint AS
  PROCEDURE set_target_level (new_target_level NUMBER)
    AS LANGUAGE JAVA
    NAME 'LinkLevelConstraint.setTargetLevel(int)';

  FUNCTION get_target_level RETURN NUMBER
    AS LANGUAGE JAVA
    NAME 'LinkLevelConstraint.getTargetLevel() return int';
END;
/
