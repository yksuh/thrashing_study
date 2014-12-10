/*
* Copyright (c) 2012, Arizona Board of Regents
* 
* See LICENSE at /cs/projects/tau/azdblab/license
* See README at /cs/projects/tau/azdblab/readme
* AZDBLab, http://www.cs.arizona.edu/projects/focal/ergalics/azdblab.html
* This is a Laboratory Information Management System
* 
* Authors:
* Matthew Johnson 
* Rui Zhang (http://www.cs.arizona.edu/people/ruizhang/)
*/
package azdblab.labShelf;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

import java.sql.ResultSet;

import azdblab.Constants;
import azdblab.exception.dbms.DBMSInvalidConnectionParameterException;
import azdblab.executable.Main;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.model.dataDefinition.ForeignKey;
import azdblab.model.experiment.Table;
import azdblab.plugins.Plugin;

/**
 * <p>
 * The GeneralDBMS abstract class is intended to make AZDBLab port easily to other DBMSs.
 * JDBC is the underlying interface used by AZDBLab to access the DBMS.  Operations performed
 * by AZDBLab through JDBC may vary from DBMS to DBMS.  JDBC provides a common interface to all 
 * DBMSs but many operations take a simple string parameter.  If the string must contain DBMS
 * specific commands.  Thus, AZDBLab provides an additional layer of indirection to provide a truly
 * DBMS independent interface.  This abstract class must be implemented by each DBMS that AZDBLab supports.
 * </p>
 * 
 */
public abstract class GeneralDBMS extends Plugin{
  /**
   * The constructor specifies the connecting string to the JDBC driver
   * @param user_name The user name for the database account that stores the tables of AZDBLab.
   * @param password The password to authenticate with the DBMS.
   * @param connect_string The connect string specifies the drivers, port, ip, and other critical information
   * to connect using JDBC.  See oracle documentation for specific information on what information should 
   * be included here.
   */
  public GeneralDBMS(String user_name, String password, String connect_string) {
    strUserName = user_name;
    strPassword = password;
    strConnectString = connect_string;
  }
      
  public GeneralDBMS(String connect_string) {
    strConnectString  = connect_string;
  }
    
  /**
   * Closes the DBMS connection that was opened by the open call.
   */
  public void close() {
    try {
      if(_connection != null)
    	  _connection.commit();
      if(_statement != null)
    	  _statement.close();
      if(_connection != null)
    	  _connection.close();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    _connection = null;
  }
  
  /**
   * Closes the DBMS connection that was opened by the open call.
   */
  public void NewClose() {
    try {
      if(_connection != null)
      _connection.close();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    _connection = null;
  }
    
  /**
   * Commits all update operations made to the dbms.  This must be called for inserts statements to be seen.
   */
  public void commit() {
    try {
      if (_connection != null && !_connection.isClosed())
        _connection.commit();
    } catch (SQLException e) {
      Main._logger.reportError("Commit failed");
      e.printStackTrace();
    }
  }
  
//  public void open(String strdrvname) {
//    boolean isOpened = false;
//    while (!isOpened) {
//      try {
//        Class.forName(strdrvname);
//        _connection = DriverManager.getConnection(strConnectString, strUserName, strPassword);
//        //turn off auto-commit.  If this is turned on there will be a huge performance hit for inserting tuples 
//        //into the DBMS.
//        _connection.setAutoCommit(false);
//        _statement = _connection.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
//        isOpened  = true;
//        return;
//      } catch (SQLException sqlex) {
//        sqlex.printStackTrace();
//        isOpened  = false;
//        //throw new DBMSInvalidConnectionParameterException(error);
//      } catch (ClassNotFoundException e) {
//        e.printStackTrace();
//        System.exit(1); //programmer/dbms error
//      }
//    }
//  }
  
//	/**
//	 * Opens the connection to the DBMS.
//	 * 
//	 * @throws DBMSInvalidConnectionParameterException
//	 */
//  	public void open(boolean auto_commit) {
//		boolean isOpened = false;
//		while (!isOpened) {
//			try {
//				String strdrvname = getDBMSDriverClassName();
//				// Main._logger.outputLog("login details: " + strConnectString +
//				// ", " +
//				// strUserName + ", " + strPassword + ", " + strdrvname);
//				Class.forName(strdrvname);
//				_connection = DriverManager.getConnection(strConnectString,
//						strUserName, strPassword);
//				// turn off auto-commit. If this is turned on there will be a
//				// huge performance hit for inserting tuples
//				// into the DBMS.
//				_connection.setAutoCommit(auto_commit);
//				_statement = _connection
//						.createStatement(ResultSet.TYPE_FORWARD_ONLY,
//								ResultSet.CONCUR_UPDATABLE);
//				isOpened = true;
//				return;
//			} catch (SQLException sqlex) {
//				sqlex.printStackTrace();
//				isOpened = false;
//				Main._logger.outputLog("login details: " + strConnectString
//						+ ", " + strUserName + ", " + strPassword);
//				// throw new DBMSInvalidConnectionParameterException(error);
//			} catch (ClassNotFoundException e) {
//				e.printStackTrace();
//				System.exit(1); // programemer/dbsm error
//			}
//		}
//	}
  
  /**
	 * Opens the connection to the DBMS.
	 * 
	 * @throws DBMSInvalidConnectionParameterException
	 */
	public void open(boolean auto_commit) {
		boolean isOpened = false;
		
		int numTryCounts = 10;
		int count = 1;
		int waitTime = 1000; // ms
		do {
			try{
				String strdrvname = getDBMSDriverClassName();
				// Main._logger.outputLog("login details: " + strConnectString +  ", " +  strUserName + ", " + strPassword + ", " + strdrvname);
				Class.forName(strdrvname);
				_connection = DriverManager.getConnection(strConnectString,
						strUserName, strPassword);
				// 	turn off auto-commit. If this is turned on there will be a
				// 	huge performance hit for inserting tuples
				// into the DBMS.
				_connection.setAutoCommit(auto_commit);
				_statement = _connection
						.createStatement(ResultSet.TYPE_FORWARD_ONLY,
								ResultSet.CONCUR_UPDATABLE);
				isOpened = true;
				return;
			} catch (SQLException sqlex) {
				//sqlex.printStackTrace();
				isOpened = false;
//				Main._logger.outputLog("login details: " + strConnectString + ", " + strUserName + ", " + strPassword);
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
				System.exit(1); // programemer/dbsm error
			}
			count++;
			waitTime *= 2;
			// wait 2^(count) seconds
			try {
				Thread.sleep(waitTime);
			} catch (InterruptedException e) {
				continue;
			}
		} while (count <= numTryCounts && !isOpened);
		
		if (!isOpened) {
			Main._logger
					.reportError("Failed to fetch a result from AZDBLAB due to network failure");
			try {
				throw new SQLException();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
      
  /**
   * Retrieve the name and version of the DBMS.
   */
  public abstract String getDBVersion();

  public void createTable(
      String tableName, String[] columnNames, int[] columnDataTypes,
      int[] columnDataTypeLengths, int[] columnNullable,
      String[] uniqueConstraintColumns, String[] primaryKey,
      ForeignKey[] foreignKeys) {};
  
  public void createIndex(Table tbl){};
  
//  public void createTable(Table tbl) {
//	  String tableName = tbl.table_name;
//	  String[] columnNames = tbl.getColumnNames();
//	  int[] columnDataTypes = tbl.getColumnDataTypes();
//	  int[] columnDataTypeLengths = tbl.getColumnDataTypeLengths();
//	  String[] primaryKey = tbl.getPrimaryKeys();
//	  ForeignKey[] foreignKeys = tbl.getForeignKeys();
//	  
////	  String[] sortedOns = tbl.getSortedOns();
////	  String[] hashIdxColumns = tbl.getHashIndexColumns();
////	  String[] btreeIdxColumns = tbl.getBtreeIndexColumns();
//	  String[] uniqueColumns = tbl.getUniqueColumns();
//		  
//	  if(tableExists(tableName)){
//		  return;
//	  }
//	  
//	  //If all arrays are not the same length exit
//	  if ((columnNames.length != columnDataTypes.length) ||
//			  (columnDataTypes.length != columnDataTypeLengths.length)) {
//		  System.err.println("createTable: Parameter Arrays must have same length");
//		  System.exit(1); //programmer bug, should be able to create a table
//	  }
//	  
//	  //assemble the CREATE TABLE statement
//	  String createTable = "CREATE TABLE " + tableName + " ( ";
//	  for (int i = 0; i < columnNames.length; i++) {
//	      createTable += columnNames[i] + " " + 
//	                     getDataTypeAsString(columnDataTypes[i],
//	                                         columnDataTypeLengths[i]);
//	      if (i == columnNames.length - 1) {
//	        break;
//	      }
//	      createTable += ", ";
//	  }
//	  
//	  if (uniqueColumns != null) {
//		  createTable += ", UNIQUE(";
//	      for (int i = 0; i < uniqueColumns.length; i++) {
//	    	  createTable += uniqueColumns[i];
//	    	  if (i == uniqueColumns.length - 1) {
//	    		  break;
//	    	  }
//	      }
//	      createTable += ", ";
//	  }
//	  
//	  createTable += ")";
//	  if (Main.verbose) {
//		  Main._logger.outputLog("Creating Table: " + tableName);
//	  }
//	  
//	  //Executing the SQL to create the table
//	  try {
//		  Main._logger.outputLog("sql to create table: " + createTable);
//	      _statement.executeUpdate(createTable);
//	  } catch (SQLException e) {
//		  System.err.println(createTable);
//		  e.printStackTrace();
//		  System.exit(1);
//	  }
//  }
      
  /** Creates a DBMS table named tableName with the characteristics described by the parameters.  All
   * parameters that are arrays must be the same length.  If they are not the same length an AZDBLab will terminate.
   * Also, the index i for each array represents information about column i.
   * @param tableName The name of the table that will be created.
   * @param columnNames The names of the columns that belong to the table.
   * @param columnDataTypes The data types of the columns that belong to the table.
   * @param columnDataTypeLengths The number of characters/digits that each column will use.
   * @param primaryKey The columns that will be part of the primary key.
   * @param foreignKeys The foreign keys for this table.
   * @param Table_Record_Table The table used to keep track of all relevant tables in the AZDBLab
   */
  public void createTable(
      String tableName, String[] columnNames, int[] columnDataTypes,
      int[] columnDataTypeLengths, String[] primaryKey,
      ForeignKey[] foreignKeys) {
    if (tableExists(tableName)){
      return;
    }
    //If all arrays are not the same length exit
    if ((columnNames.length != columnDataTypes.length) ||
        (columnDataTypes.length != columnDataTypeLengths.length)) {
    	Main._logger.outputLog("createTable: Parameter Arrays must have same length");
      System.exit(1); //programmer bug, should be able to create a table
    }
    //assemble the CREATE TABLE statement
    String createTable = "CREATE TABLE " + tableName + " ( ";
    for (int i = 0; i < columnNames.length; i++) {
      boolean flag = false;
      String strCol = columnNames[i];
      if (primaryKey != null) {
	      for (int j = 0; j < primaryKey.length; j++) {
//	    	  Main._logger.outputLog("col: " + strCol + ", primary key: " + primaryKey[j]);
	    	  if(strCol.equalsIgnoreCase(primaryKey[j])){
	    		  flag = true;
	    		  break;
	    	  }
	      }
      }
      createTable += strCol + " " + 
                     getDataTypeAsString(columnDataTypes[i],
                                         columnDataTypeLengths[i]);
      if(flag)
    	  createTable += " NOT NULL";
      
      if (i == columnNames.length - 1) {
        break;
      }
      createTable += ", ";
    }
    
//    USING INDEX (create index ai on a (a1)));
    
    //creating the primary key SQL
    if (primaryKey != null) {
      createTable += ", PRIMARY KEY(";
      for (int i = 0; i < primaryKey.length; i++) {
        createTable += primaryKey[i];
        if (i == primaryKey.length - 1) {
          break;
        }
        createTable += ", ";
      }
      createTable += ")";
	//  oracle: CREATE TABLE a (a1 INT, a2 INT, PRIMARY KEY (a1) USING INDEX (create index ai on a (a1)))
    //           http://infolab.stanford.edu/~ullman/fcdb/oracle/or-nonstandard.html
    //           Oracle automatically creates an index for each UNIQUE or PRIMARY KEY declaration
    //  DB2: CREATE TABLE a (a1 INT not null, a2 INT, PRIMARY KEY (a1))
    //       CREATE TABLE a (a1 INT, a2 INT) + CREATE UNIQUE INDEX a_pk_idx on a(a1) 
    // more investigation on the other dbmses..
    // SQLServer: http://databases.about.com/od/sqlserver/a/indextuning.htm
    // Postgres: http://www.java2s.com/Code/PostgreSQL/Constraints/PRIMARYKEYwillcreateimplicitindex.htm
    //http://bytes.com/topic/mysql/answers/74529-primary-key-index
//    CREATE TABLE ft_HT1 (id1 INT, id2 INT, id3 INT, id4 INT, 
//	   PRIMARY KEY (id1) USING INDEX (create index ft_HT1_pk_idx on ft_HT1 (id1)));
//      createTable += " USING INDEX (CREATE INDEX " + tableName + "_pk_idx" + " on " + tableName + "(";
//      for (int i = 0; i < primaryKey.length; i++) {
//    	 createTable += primaryKey[i];
//		 if (i == primaryKey.length - 1) {
//		   break;
//		 }
//		 createTable += ", ";
//      }
//      createTable += ")";      
    }
    //creating the Foreign Key SQL
    if (foreignKeys != null) {
      for (int i = 0; i < foreignKeys.length; i++) {
        createTable += ", FOREIGN KEY(";
        if (foreignKeys[i].columns.length != foreignKeys[i].columnsReferenced.length) {
        	Main._logger.reportError("The two arrays in a Foreign Key Object must be the same length");
          System.exit(1);
        }
        for (int j = 0; j < foreignKeys[i].columns.length; j++) {
          createTable += foreignKeys[i].columns[j];
          if (j == foreignKeys[i].columns.length - 1) {
            break;
          }
          createTable += ", ";
        }
        createTable += ") REFERENCES " + foreignKeys[i].tableReferenced + " (";
        for (int j = 0; j < foreignKeys[i].columnsReferenced.length; j++) {
          createTable += foreignKeys[i].columnsReferenced[j];
          if (j == foreignKeys[i].columnsReferenced.length - 1) {
            break;
          }
          createTable += ", ";
        }
        createTable += ")";
        if (foreignKeys[i].strCascadeOption != null) {
          createTable += foreignKeys[i].strCascadeOption;
        }
      }
    }
    createTable += ")";
    if (Main.verbose) {
    	Main._logger.outputLog("Creating Table: " + tableName);
    }
    //Executing the SQL to create the table
    try {
    	Main._logger.outputLog("sql to create table: " + createTable);
      _statement.executeUpdate(createTable);
      // yksuh added commit as below
      commit();
    } catch (SQLException e) {
    	Main._logger.reportError(createTable);
      e.printStackTrace();
      System.exit(1);
    }
  }
   
  
  /** Creates a DBMS table named tableName with the characteristics described by the parameters.  All
   * parameters that are arrays must be the same length.  If they are not the same length an AZDBLab will terminate.
   * Also, the index i for each array represents information about column i.
   * @param tableName The name of the table that will be created.
   * @param columnNames The names of the columns that belong to the table.
   * @param columnDataTypes The data types of the columns that belong to the table.
   * @param columnDataTypeLengths The number of characters/digits that each column will use.
   * @param primaryKey The columns that will be part of the primary key.
   * @param foreignKeys The foreign keys for this table.
   * @param Table_Record_Table The table used to keep track of all relevant tables in the AZDBLab
   */
  public void createTable(
      String tableName, 
      String[] columnNames, 
      int[] columnDataTypes,
      int[] columnDataTypeLengths, 
      String[] uniqueCols, 
      int[] nullableCols, 
      String[] primaryKey, 
      ForeignKey[] foreignKeys) {
    if (tableExists(tableName)){
      return;
    }
    //If all arrays are not the same length exit
    if ((columnNames.length != columnDataTypes.length) ||
        (columnDataTypes.length != columnDataTypeLengths.length)) {
    	Main._logger.outputLog("createTable: Parameter Arrays must have same length");
      System.exit(1); //programmer bug, should be able to create a table
    }
    //assemble the CREATE TABLE statement
    String createTable = "CREATE TABLE " + tableName + " ( ";
    for (int i = 0; i < columnNames.length; i++) {
      boolean isNullable = true;
      String strCol = columnNames[i];
      if (nullableCols != null) {
    	  if(nullableCols[i] == 0){
    		  isNullable = false;
    	  }
      }
      createTable += strCol + " " + 
                     getDataTypeAsString(columnDataTypes[i],
                                         columnDataTypeLengths[i]);
      if(!isNullable)
    	  createTable += " NOT NULL";
      
      if (i == columnNames.length - 1) {
        break;
      }
      createTable += ", ";
    }
    
//    USING INDEX (create index ai on a (a1)));
    
    //creating the primary key SQL
    if (primaryKey != null) {
      createTable += ", PRIMARY KEY(";
      for (int i = 0; i < primaryKey.length; i++) {
        createTable += primaryKey[i];
        if (i == primaryKey.length - 1) {
          break;
        }
        createTable += ", ";
      }
      createTable += ")";
    
	//  oracle: CREATE TABLE a (a1 INT, a2 INT, PRIMARY KEY (a1) USING INDEX (create index ai on a (a1)))
    //           http://infolab.stanford.edu/~ullman/fcdb/oracle/or-nonstandard.html
    //           Oracle automatically creates an index for each UNIQUE or PRIMARY KEY declaration
    //  DB2: CREATE TABLE a (a1 INT not null, a2 INT, PRIMARY KEY (a1))
    //       CREATE TABLE a (a1 INT, a2 INT) + CREATE UNIQUE INDEX a_pk_idx on a(a1) 
    // more investigation on the other dbmses..
    // SQLServer: http://databases.about.com/od/sqlserver/a/indextuning.htm
    // Postgres: http://www.java2s.com/Code/PostgreSQL/Constraints/PRIMARYKEYwillcreateimplicitindex.htm
    //http://bytes.com/topic/mysql/answers/74529-primary-key-index
//    CREATE TABLE ft_HT1 (id1 INT, id2 INT, id3 INT, id4 INT, 
//	   PRIMARY KEY (id1) USING INDEX (create index ft_HT1_pk_idx on ft_HT1 (id1)));
//      createTable += " USING INDEX (CREATE INDEX " + tableName + "_pk_idx" + " on " + tableName + "(";
//      for (int i = 0; i < primaryKey.length; i++) {
//    	 createTable += primaryKey[i];
//		 if (i == primaryKey.length - 1) {
//		   break;
//		 }
//		 createTable += ", ";
//      }
//      createTable += ")";      
    }
  
  // unique columns
  if (uniqueCols != null) {
      createTable += ", UNIQUE(";
      for (int i = 0; i < uniqueCols.length; i++) {
        createTable += uniqueCols[i];
        if (i == uniqueCols.length - 1) {
          break;
        }
        createTable += ", ";
      }
      createTable += ")";
  }
  
    //creating the Foreign Key SQL
    if (foreignKeys != null) {
      for (int i = 0; i < foreignKeys.length; i++) {
        createTable += ", FOREIGN KEY(";
        if (foreignKeys[i].columns.length != foreignKeys[i].columnsReferenced.length) {
        	Main._logger.reportError("The two arrays in a Foreign Key Object must be the same length");
          System.exit(1);
        }
        for (int j = 0; j < foreignKeys[i].columns.length; j++) {
          createTable += foreignKeys[i].columns[j];
          if (j == foreignKeys[i].columns.length - 1) {
            break;
          }
          createTable += ", ";
        }
        createTable += ") REFERENCES " + foreignKeys[i].tableReferenced + " (";
        for (int j = 0; j < foreignKeys[i].columnsReferenced.length; j++) {
          createTable += foreignKeys[i].columnsReferenced[j];
          if (j == foreignKeys[i].columnsReferenced.length - 1) {
            break;
          }
          createTable += ", ";
        }
        createTable += ")";
        if (foreignKeys[i].strCascadeOption != null) {
          createTable += foreignKeys[i].strCascadeOption;
        }
      }
    }
    createTable += ")";
    if (Main.verbose) {
    	Main._logger.outputLog("Creating Table: " + tableName);
    }
    //Executing the SQL to create the table
    try {
    	Main._logger.outputLog("sql to create table: " + createTable);
      _statement.executeUpdate(createTable);
      // yksuh added commit as below
      commit();
    } catch (SQLException e) {
    	Main._logger.reportError(createTable);
      e.printStackTrace();
      System.exit(1);
    }
  }
  
  /****
   * Young's thesis for tpcc loading
   * @param tableName
   * @param columnNames
   * @param columnDataTypes
   * @param columnDataTypeLengths
   * @param columnDataTypeDecimalPoints
   * @param primaryKey
   * @param foreignKeys
   * @param unique
   * @param index
   */
  protected void createTable(String tableName, String[] columnNames,
			int[] columnDataTypes, int[] columnDataTypeLengths,
			int[] columnDataTypeDecimalPoints, String[] primaryKey,
			ForeignKey[] foreignKeys, String[] unique, String[] index) {
		if (tableExists(tableName)){
	        return;
	      }
	      //If all arrays are not the same length exit
	      if ((columnNames.length != columnDataTypes.length) ||
	          (columnDataTypes.length != columnDataTypeLengths.length)) {
	      	Main._logger.outputLog("createTable: Parameter Arrays must have same length");
	        System.exit(1); //programmer bug, should be able to create a table
	      }
	      //assemble the CREATE TABLE statement
	      String createTable = "CREATE TABLE " + tableName + " ( ";
	      for (int i = 0; i < columnNames.length; i++) {
	        boolean flag = false;
	        String strCol = columnNames[i];
	        if (primaryKey != null) {
	  	      for (int j = 0; j < primaryKey.length; j++) {
//	  	    	  Main._logger.outputLog("col: " + strCol + ", primary key: " + primaryKey[j]);
	  	    	  if(strCol.equalsIgnoreCase(primaryKey[j])){
	  	    		  flag = true;
	  	    		  break;
	  	    	  }
	  	      }
	        }
	        
//	        if(columnDataTypeLengths[i] > -1){
//	        	int digit = columnDataTypeLengths[i]-columnDataTypeDecimalPoints[i];
//	        	createTable += " decimal(" + digit + "," + columnDataTypeDecimalPoints[i] + ")";
//	        }else{
//	        	createTable += strCol + " " + 
//	                       getDataTypeAsString(columnDataTypes[i],
//	                                           columnDataTypeLengths[i]);
//	        }
	        createTable += strCol + " " + 
                    getDataTypeAsString(columnDataTypes[i],
                                        columnDataTypeLengths[i]);
	        
	        //if(flag)
	      	  createTable += " NOT NULL";
	        
	        if (i == columnNames.length - 1) {
	          break;
	        }
	        createTable += ", ";
	      }
	      
//	      USING INDEX (create index ai on a (a1)));
	      
	      //creating the primary key SQL
	      if (primaryKey != null) {
	        createTable += ", PRIMARY KEY(";
	        for (int i = 0; i < primaryKey.length; i++) {
	          createTable += primaryKey[i];
	          if (i == primaryKey.length - 1) {
	            break;
	          }
	          createTable += ", ";
	        }
	        createTable += ")";
	  	//  oracle: CREATE TABLE a (a1 INT, a2 INT, PRIMARY KEY (a1) USING INDEX (create index ai on a (a1)))
	      //           http://infolab.stanford.edu/~ullman/fcdb/oracle/or-nonstandard.html
	      //           Oracle automatically creates an index for each UNIQUE or PRIMARY KEY declaration
	      //  DB2: CREATE TABLE a (a1 INT not null, a2 INT, PRIMARY KEY (a1))
	      //       CREATE TABLE a (a1 INT, a2 INT) + CREATE UNIQUE INDEX a_pk_idx on a(a1) 
	      // more investigation on the other dbmses..
	      // SQLServer: http://databases.about.com/od/sqlserver/a/indextuning.htm
	      // Postgres: http://www.java2s.com/Code/PostgreSQL/Constraints/PRIMARYKEYwillcreateimplicitindex.htm
	      //http://bytes.com/topic/mysql/answers/74529-primary-key-index
//	      CREATE TABLE ft_HT1 (id1 INT, id2 INT, id3 INT, id4 INT, 
//	  	   PRIMARY KEY (id1) USING INDEX (create index ft_HT1_pk_idx on ft_HT1 (id1)));
//	        createTable += " USING INDEX (CREATE INDEX " + tableName + "_pk_idx" + " on " + tableName + "(";
//	        for (int i = 0; i < primaryKey.length; i++) {
//	      	 createTable += primaryKey[i];
//	  		 if (i == primaryKey.length - 1) {
//	  		   break;
//	  		 }
//	  		 createTable += ", ";
//	        }
//	        createTable += ")";      
	      }
	      //creating the Foreign Key SQL
	      if (foreignKeys != null) {
	        for (int i = 0; i < foreignKeys.length; i++) {
	          createTable += ", FOREIGN KEY(";
	          if (foreignKeys[i].columns.length != foreignKeys[i].columnsReferenced.length) {
	          	Main._logger.reportError("The two arrays in a Foreign Key Object must be the same length");
	            System.exit(1);
	          }
	          for (int j = 0; j < foreignKeys[i].columns.length; j++) {
	            createTable += foreignKeys[i].columns[j];
	            if (j == foreignKeys[i].columns.length - 1) {
	              break;
	            }
	            createTable += ", ";
	          }
	          createTable += ") REFERENCES " + foreignKeys[i].tableReferenced + " (";
	          for (int j = 0; j < foreignKeys[i].columnsReferenced.length; j++) {
	            createTable += foreignKeys[i].columnsReferenced[j];
	            if (j == foreignKeys[i].columnsReferenced.length - 1) {
	              break;
	            }
	            createTable += ", ";
	          }
	          createTable += ")";
	          if (foreignKeys[i].strCascadeOption != null) {
	            createTable += foreignKeys[i].strCascadeOption;
	          }
	        }
	      }
	      createTable += ")";
	      if (Main.verbose) {
	      	Main._logger.outputLog("Creating Table: " + tableName);
	      }
	      //Executing the SQL to create the table
	      try {
	      	Main._logger.outputLog("sql to create table: " + createTable);
	        _statement.executeUpdate(createTable);
	        // yksuh added commit as below
	        commit();
	      } catch (SQLException e) {
	      	Main._logger.reportError(createTable);
	        e.printStackTrace();
	        System.exit(1);
	      }
	}
  
  
  /** 
   * Drops table <code>tableName</code> from the database.
   * @param tableName The name of the table that will be dropped from the DBMS.
   * @param Table_Record_Table the table used to keep track of the relevant tables in AZDBLab
   * when deleting, the corresponding table record should be deleted from <code>Table_Record_Table</code> as well.
   */
  public void dropTable(String tableName) {
    if (Main.verbose) {
    	Main._logger.outputLog("Dropping Table: " + tableName);
    }
    try {
      //drop the table from the DBMS.
      _statement.executeUpdate("DROP TABLE " + tableName);
      // yksuh added commit as below
      commit();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    Main._logger.outputLog(tableName + " Dropped.");
  }
      
  public void createSequence(String seqName) {
    String createSequence = "CREATE SEQUENCE " + seqName +
                            " START WITH 1 NOMAXVALUE";
    try {
    	Main._logger.outputLog("Creating sequence: " + seqName);
      _statement.execute(createSequence);
    } catch (SQLException e) {
      e.printStackTrace();
    }
  }
      
  public void dropSequence(String seqName) {
    String  dropSequence  = "DROP SEQUENCE " + seqName;
    try {
    	Main._logger.outputLog("Dropping sequence: " + seqName);
      _statement.execute(dropSequence);
    } catch (SQLException e) {
      if (e.getErrorCode() == 2289) {
        // Sequence does NOT exist
        return;
      }
      e.printStackTrace();
    }
  }
      
  public int getSequencialID(String seqName) {
    String  getSeqID  = "SELECT " + seqName + ".NEXTVAL FROM DUAL";
//System.out.println(getSeqID);
    try {
      ResultSet  rs  = _statement.executeQuery(getSeqID);
      int      id  = -1;
      if (rs.next()) {
        id = rs.getInt(1);
      }
      rs.close();
      return id;
    } catch (SQLException e) {
      e.printStackTrace();
      return -1;
    }
  }
      
  public long getSequencialIDToLong(String seqName) {
	    String  getSeqID  = "SELECT " + seqName + ".NEXTVAL FROM DUAL";
	    try {
	      ResultSet  rs  = _statement.executeQuery(getSeqID);
	      long      id  = -1;
	      if (rs.next()) {
	        id = rs.getLong(1);
	      }
	      rs.close();
	      return id;
	    } catch (SQLException e) {
	      e.printStackTrace();
	      return -1;
	    }
	  }
  
  /**
   * Used to determine whether a table exists in the DBMS.
   * @param tableName The name of the table that is tested for existence.
   * @return true - if the table exists.<BR>
   * false - if the table does not exist.
   */
  public boolean tableExists(String tableName){
		try {
			// attempts to create the table. If it fails, the table exists and
			// an exception will be thrown.
			_statement.executeUpdate("CREATE TABLE " + tableName
					+ " (Name char(1))");
			commit();
			// if the table was created, drop it again.
			_statement.executeUpdate("DROP TABLE " + tableName);
			commit();
			return false;
		} catch (SQLException e) {
			String errMsg = (e.getMessage()).toLowerCase();
			if(!(errMsg.contains("already") 
			  || errMsg.contains("exist") 
			  || errMsg.contains("creat"))){ // this is not a real error!
//				e.printStackTrace();
				Main._logger.reportError(e.getMessage());
			}
//			try {
				if(_statement == null){ 
//						|| _statement.isClosed()){
					reset();
				}
				else{
					commit();
				}
//			} catch (SQLException e1) {
//				// TODO Auto-generated catch block
//				Main._logger.reportError2(e1.toString());
//			}
			return true;
		}
  }
  public void reset(){
	  close();
	  open(false);
  }
  
  /**
   * Used to insert a row into the DBMS.  
   * Each column in this array will be inside of the select clause.  The from clause simply contains
   * the tableName.  
   * @param tableName The name of the table which will receive a new row.
   * @param columnNames The name of the columns of the row being inserted. 
   * @param columnValues The values of the columns being inserted.
   * @param columnDataTypes The data types of the columns being inserted.
   * @throws SQLException Thrown if the insertion fails.
   */
  public String NewInsertTuple(
      String tableName, String[] columnNames, String[] columnValues, 
      int[] columnDataTypes) throws SQLException {
    String insertSQL = buildInsertSQL(tableName, columnNames, columnValues,
                                      columnDataTypes);
Main._logger.writeIntoLog(insertSQL);	    
    _statement.executeUpdate(insertSQL);
    return insertSQL;
  }
  
  /**
   * Used to insert a row into the DBMS.  
   * Each column in this array will be inside of the select clause.  The from clause simply contains
   * the tableName.  
   * @param tableName The name of the table which will receive a new row.
   * @param columnNames The name of the columns of the row being inserted. 
   * @param columnValues The values of the columns being inserted.
   * @param columnDataTypes The data types of the columns being inserted.
   * @throws SQLException Thrown if the insertion fails.
   */
  public void insertTuple(
      String tableName, String[] columnNames, String[] columnValues, 
      int[] columnDataTypes) throws SQLException {
    String insertSQL = buildInsertSQL(tableName, columnNames, columnValues,
                                      columnDataTypes);
    _statement.executeUpdate(insertSQL);
  }
     
  /**
    * The method transforms the parameters into a valid SQL statement 
    * that performs an insert statement
    * @param tableName The name of the table.
    * @param columnNames The name of the columns for the row to be inserted.
    * @param columnValues The values to be inserted.
    * @param columnDataTypes The data types of the columns
    * @return An SQL string that will insert the specified tuple into the database.
    */
  protected String buildInsertSQL(
      String tableName, String[] columnNames, String[] columnValues,
      int[] columnDataTypes) {
    if ((columnNames.length != columnValues.length) ||
        (columnValues.length != columnDataTypes.length)) {
      Main._logger.reportError("build insertRow: Parameter arrays must be same length");
      System.exit(1); //this is a programmers bug
    }
    //assembling the INSERT SQL statement
    String insertSQL = "INSERT INTO " + tableName + "(";
    for (int i = 0; i < columnNames.length; i++) {
      insertSQL += columnNames[i];
      if (i == columnNames.length - 1) {
        break;
      }
      insertSQL += ", ";
    }
    insertSQL += ") VALUES (";
    for (int i = 0; i < columnValues.length; i++) {
      insertSQL += formatColumnValue(columnValues[i], columnDataTypes[i]);
      if (i == columnNames.length - 1) {
        break;
      }
      insertSQL += ", ";
    }
    insertSQL += ")";
//System.out.println(insertSQL);
    return insertSQL;
  }
     
  /**
   * The method transforms the parameters into a valid SQL statement 
   * that performs an insert statement
   * @param tableName The name of the table.
   * @param columnNames The name of the columns for the row to be inserted.
   * @param columnValues The values to be inserted.
   * @param columnDataTypes The data types of the columns
   * @return An SQL string that will insert the specified tuple into the database.
   */
 protected String buildInsertSQLForClob(
     String tableName, String[] columnNames, String[] columnValues,
     int[] columnDataTypes) {
   if ((columnNames.length != columnValues.length) ||
       (columnValues.length != columnDataTypes.length)) {
     Main._logger.reportError("build insertRow: Parameter arrays must be same length");
     System.exit(1); //this is a programmers bug
   }
   //assembling the INSERT SQL statement
   String insertSQL = "INSERT INTO " + tableName + "(";
   for (int i = 0; i < columnNames.length; i++) {
     insertSQL += columnNames[i];
     if (i == columnNames.length - 1) {
       break;
     }
     insertSQL += ", ";
   }
   insertSQL += ") VALUES (";
   for (int i = 0; i < columnValues.length; i++) {
     insertSQL += formatColumnValue(columnValues[i], columnDataTypes[i]);
     if (i == columnNames.length - 1) {
       break;
     }
     insertSQL += ", ";
   }
   insertSQL += ")";
   return insertSQL;
 }
 
  /**
   * This method augments a value with appropriate extra syntax.  Currently varchar2 is the only
   * data type that requires a change.
   * @param value The column value
   * @param dataType The data type of the column value.
   * @return The augmented value.
   */
  protected String formatColumnValue(String value, int dataType) {
    if (dataType == GeneralDBMS.I_DATA_TYPE_VARCHAR) {
      return "'" + value + "'";
    }
    else if(dataType == GeneralDBMS.I_DATA_TYPE_DATE){
    	return "to_date('" + value + "', '"+ Constants.DATEFORMAT + "')";
    }else if(dataType == GeneralDBMS.I_DATA_TYPE_TIMESTAMP){
    	return "to_timestamp('" + value + "', '"+ Constants.TIMESTAMPFORMAT + "')";
    }else if (dataType == GeneralDBMS.I_DATA_TYPE_CLOB) {
    	return "empty_clob()";
    }
    else {
      return value;
    }
  }

  /**
   * Given AZDBLab's integer representation of a data type, this produces an DBMS specific
   * representation of the data type.
   * @param dataType The data type
   * @param length The number of digits for this value.
   * @return A string representation of this data type/length.  This value can be used in a create table
   * statement.
   */
  protected abstract String getDataTypeAsString(int dataType, int length);
       
  /**
   * 
   * @return
   */
  public abstract String getDBMSDriverClassName();
       
  /**
   * The number data type for a column data type.
   */
  public static final int I_DATA_TYPE_NUMBER = 0;
  
  /**
   * The character data type for a column data type.
   */
  public static final int I_DATA_TYPE_VARCHAR = 1;
  /**
   * The clob data type for a column data type.
   */
  public static final int I_DATA_TYPE_CLOB = 2;
      
  /**
   * The date data type for a column data type.
   */
  public static final int I_DATA_TYPE_DATE = 3;
      
  public static final int I_DATA_TYPE_SEQUENCE = 4;
  /**
   * The XMLdata type for a column data type.
   */
  public static final int I_DATA_TYPE_XML = 5;
  /**
   * The date data type for a column data type.
   */
  public static final int I_DATA_TYPE_TIMESTAMP = 6;
	public static final String XMLTYPE = "XMLType";
	public static final String CLOB = "CLOB";
	public static final String NUMBER = "NUMBER";
	public static final String VARCHAR = "VARCHAR2";
	public static final String DATE = "DATE";
	public static final String TIMESTAMP = "TIMESTAMP";
      
  /**
   * The ID of oracle dbms.
   */
//  public static final int DBMS_ORACLE    = 0;
//      
//  /**
//   * The ID of mysql dbms.
//   */
//  public static final int DBMS_MYSQL    = 1;
//
//  /**
//   * The ID of sqlserver dbms.
//   */
//  public static final int DBMS_SQLSERVER  = 2;
//      
//  /**
//   * The ID of db2 dbms.
//   */
//  public static final int DBMS_DB2    = 3;
//      
//  /**
//   * The ID of pgsql dbms.
//   */
//  public static final int DBMS_PGSQL    = 4;
//
//  /**
//   * The ID of teradata dbms.
//   */
//  public static final int DBMS_TERADATA    = 5;
//      
//  
//  /**
//   * Used by AZDBLab to represent the DB2 database.
//   */
//  public static final String DBMS_TYPE_SQLSERVER = "sqlserver";
//            
//  /**
//   * Used by AZDBLab to represent the Oracle database.
//   */
//  public static final String DBMS_TYPE_ORACLE = "oracle";
//      
//  /**
//   * Used by AZDBLab to represent the MySQL database.
//   */
//  public static final String DBMS_TYPE_MYSQL = "mysql";
//      
//  /**
//   * Used by AZDBLab to represent the MySQL database.
//   */
//  public static final String DBMS_TYPE_PGSQL = "pgsql";
//      
//  /**
//   * Used by AZDBLab to represent the MySQL database.
//   */
//  public static final String DBMS_TYPE_DB2 = "DB2";
//
//  /**
//   * Used by AZDBLab to represent the MySQL database.
//   */
//  public static final String DBMS_TYPE_TERADATA = "teradata";  
  
  /**
   * A handle to the connection to the DBMS.
   */
  protected Connection _connection;

  /**
   * A handle to the statement.  AZDBLab only uses one statement.
   */
  protected Statement _statement;
      
  /**
   * The connect string to specify the location of DBMS
   */
  protected String strConnectString = null;

  /**
   * The password that is used to connect to the DBMS.
   */
  protected String strPassword = null;
  
  /**
   * The username that is used to connect to the DBMS.
   */
  protected String strUserName = null;
  
  public abstract void deleteRows(String tableName, String[] columnNames,
		  						 String[] columnValues, int[] columnDataTypes);

  public abstract ResultSet executeQuerySQL(String sql);
	
	/**
	 * The can be used to execute a simple select-project query.  The select clause is build using the selectColumns
	 * parameter.  Each column in this array will be inside of the select clause.  The from clause simply contains
	 * the tableName.  The where clause is built as follows.  For each index i, columnNames[i]=columnValues[i]. 
	 * The columnDataTypes[i] is used to add other syntax need for a specific data type.
	 * @param tableName The name of the table that will appear in the from clause.
	 * @param selectColumns The name of the columns that will be in the select clause.
	 * @param indexOfOrderedColumn The index column you wish to have the results ordered by.  For example, if you wish 
	 * to have the result ordered by column 1 in the select clause, then you would use the number 1 here.
	 * @param orderedDataType The data type of the column that is used to determine the order of the output result.
	 * @param columnNames The names of the columns used in the where clause.
	 * @param columnValues The values of the columns used in the where clause.
	 * @param columnDataTypes The data types of the columns.
	 * @return A result set which is the result of executing the query.
	 */
	public abstract ResultSet executeSimpleOrderedQuery(String tableName,
			String[] selectColumns, int indexOfOrderedColumn, int orderedDataType, String[] columnNames,
			String[] columnValues, int[] columnDataTypes);

	/**
	 * Using the parameters this method builds an SQL query.  Each column in this array will be inside of the select clause.  The from clause simply contains
	 * the tableName.  The where clause is built as follows.  For each index i, columnNames[i]=columnValues[i]. 
	 * The columnDataTypes[i] is used to add other syntax need for a specific data type.
	 * @param tableName
	 * @param selectColumns
	 * @param columnNames
	 * @param columnValues
	 * @param columnDataTypes
	 * @return The JDBC Result that corresponds to this query.
	 */
	public abstract ResultSet executeSimpleQuery(String tableName,
			String[] selectColumns, String[] columnNames, String[] columnValues, int[] columnDataTypes);


//	public Connection getConnection(){
//		return _connection;
//	}
	
	public abstract void executeUpdateSQL(String sql);
	
//	public ResultSet executeSelectQuery(String querySQL) throws SQLException {
//		return LabShelf.getShelf().executeQuerySQL(querySQL);		
//	}
	
	public abstract void executeDeleteSQL(String sql) throws SQLException;
	
	public void executeUpdateQuery(String querySQL) throws SQLException {
		LabShelfManager.getShelf().executeUpdateSQL(querySQL);
		LabShelfManager.getShelf().commitlabshelf();
	}
	
	public String getUserName(){ return strUserName;}
	public String getPassword(){ return strPassword;}
	public String getConnectionString(){ return strConnectString;}

}
