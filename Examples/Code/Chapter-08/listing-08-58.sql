-- Listing 8-58. Setting Session Parameters to Enable Query Rewrite on Function-Based Indexes (Not Necessary in Oracle 10g (and Newer)
-- Not needed in 11g.
ALTER SESSION SET QUERY_REWRITE_INTEGRITY = TRUSTED;
ALTER SESSION SET QUERY_REWRITE_ENABLED = TRUE;

