-- Listing 10-40. Defining a Directory Object
CREATE DIRECTORY constraints_classes_dir AS 'D:\Files\Code\Constraints';
GRANT READ ON DIRECTORY constraints_classes_dir TO spatial;
