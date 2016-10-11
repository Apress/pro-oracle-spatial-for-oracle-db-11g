REM Listing 10-45. Starting the Network Editor
set JAVA_ORACLE_HOME=D:\Oracle\Ora111
set JAR_LIBS=%JAVA_ORACLE_HOME%/md/jlib/sdondme.jar;%JAVA_ORACLE_HOME%/lib/xmlparserv2.jar;%JAVA_ORACLE_HOME%/jdbc/lib/ojdbc14.jar;%JAVA_ORACLE_HOME%\md/jlib/sdonm.jar;%JAVA_ORACLE_HOME%/md/jlib/sdoapi.jar;%JAVA_ORACLE_HOME%/md/jlib/sdoutl.jar
java -Xms512M -Xmx512M -cp %JAR_LIBS% oracle.spatial.network.editor.NetworkEditor
