-- Listing 16-5. Renaming and Re-creating the us_streets Table
DROP INDEX us_streets_sidx;
RENAME us_streets TO us_streets_dup;
-- Re-create the us_streets with the same fields as in us_streets_dup;
CREATE TABLE us_streets AS SELECT * FROM us_streets_dup where rownum<=0;
