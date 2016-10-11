Listing 10-34 Functions to get and set the maximum Java heap size
CREATE OR REPLACE PROCEDURE set_max_memory_size(bytes NUMBER) AS
 LANGUAGE JAVA 
 NAME 'oracle.aurora.vm.OracleRuntime.setMaxMemorySize(long)';
/

CREATE OR REPLACE FUNCTION get_max_memory_size RETURN NUMBER AS
 LANGUAGE JAVA 
 NAME 'oracle.aurora.vm.OracleRuntime.getMaxMemorySize() returns long';
/
