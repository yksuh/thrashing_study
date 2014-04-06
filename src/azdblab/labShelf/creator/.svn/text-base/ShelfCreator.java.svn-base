package azdblab.labShelf.creator;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;

import azdblab.Constants;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.InternalTable;
import azdblab.labShelf.TableDefinition;
import azdblab.model.dataDefinition.ForeignKey;


public class ShelfCreator {
//	/**
//	 * Young (yksuh) is a super man as of 09/02/11
//	 * Do 'grant all privileges to yksuh' to create labshelf on sqlplus manually.
//	 */
//	private final String _LABSHELF_SUPER_MAN 	 = "yksuh";
//	/***
//	 * LabShelfCreator name 
//	 */
//	private final String _shelf_creator_name 	 = _LABSHELF_SUPER_MAN;	
//	/***
//	 * LabShelfManager password 
//	 */
//	private final String _shelf_creator_passwd   = _LABSHELF_SUPER_MAN;	
	/***
	 * sodbvm1 connection string 
	 */
	private String _conn_str;

	/***
	 * Connection object
	 */
	private Connection connect;
	/***
	 * Statement object
	 */
	private Statement stmt;
	/***
	 * LabShelf internal tables
	 */
	InternalTable INTERNAL_TABLES[] = TableDefinition.INTERNAL_TABLES;
	/***
	 * Constructor
	 * @param connectString	labshelf connection string
	 */
	public ShelfCreator(String connectString) {
		_conn_str = connectString;
	}

	/***
	 * Makes a connection to labshelves
	 * @param userName	labShelf name
	 * @param password	labShelf password
	 * @return true or false
	 */
	public boolean testConnect(String userName, String password) {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			connect = DriverManager.getConnection(_conn_str, userName, password);
			stmt = connect.createStatement();
			stmt.close();
			connect.close();
			return true;
		} catch (Exception e) {
			return false;
		}
	}
//	/****
//	 * Creates a lab shelf 
//	 * @param labShelfName shelf name
//	 * @param labShelfPasswd shelf password
//	 * @return	true or false
//	 */
//	public boolean createLabShelf(String labShelfName, String labShelfPasswd) {
//		try {
//			Class.forName("oracle.jdbc.driver.OracleDriver");
//			connect = DriverManager.getConnection(_conn_str, _shelf_creator_name, _shelf_creator_passwd);
//			stmt = connect.createStatement();
//
//			String sql = "Create user " + labShelfName + " identified by " + labShelfPasswd;
//			stmt.execute(sql); // user
//			
//			sql = "GRANT CREATE SESSION to " + labShelfName;
//			stmt.execute(sql);// gives right to connect
//
//			sql = "GRANT CREATE TABLE to " + labShelfName;
//			stmt.execute(sql); // gives the right to create tables in their tablespace
//
//			// gives the right to create sequence
//			sql = "GRANT CREATE SEQUENCE TO " + labShelfName;
//			stmt.execute(sql); // gives the right to create tables in their tablespace
//			
//			sql = "GRANT CREATE VIEW to " + labShelfName;
//			stmt.execute(sql); // gives the right to create views in their tablespace
//			
////			sql = "ALTER USER " + labShelfName + " QUOTA 100M ON USERS";
//			sql = "ALTER USER " + labShelfName + " QUOTA UNLIMITED ON USERS";
//			//space quota exceeded for tablespace 'USERS'
//			//ORA-01536: space quota exceeded for tablespace 'USERS'
//			
//			stmt.execute(sql);
//
//			connect.commit();
//			stmt.close();
//			connect.close();
//			return true;
//
//		} catch (Exception e) {
//			e.printStackTrace();
//			return false;
//		}
//	}
//	/****
//	 * Drops a lab shelf
//	 * @param labShelfName shelf name
//	 * @param labShelfPasswd shelf password
//	 * @return	true or false
//	 */
//	public boolean dropLabShelf(String labShelfName, String labShelfPasswd) {
//		try {
//			Class.forName("oracle.jdbc.driver.OracleDriver");
//			connect = DriverManager.getConnection(_conn_str, _shelf_creator_name, _shelf_creator_passwd);
//			stmt = connect.createStatement();
//
//			String sql = "Drop user " + labShelfName + " cascade";
//			stmt.execute(sql); // user
//			stmt.close();
//			connect.close();
//			return true;
//		} catch (Exception e) {
//			e.printStackTrace();
//			return false;
//		}
//	}
	
	/****
	 * Installs all internal tables	for the shelf
	 * @param labShelf	shelf name
	 * @param labShelfPasswd shelf password
	 * @throws Exception
	 */
	public void install(String labShelfName, String labShelfPasswd) throws Exception {
		Class.forName("oracle.jdbc.driver.OracleDriver");
		connect = DriverManager.getConnection(_conn_str, labShelfName, labShelfPasswd);
		stmt = connect.createStatement();
		System.out.println("Beginning install");
		installAll();
		insertVersion();
		insertScenarioVersion();
		connect.commit();
		stmt.close();
		connect.close();
		
	}
	
	/****
	 * Uninstalls all internal tables
	 * @throws Exception
	 */
	public void uninstall(String labShelfName, String passwd) throws Exception {
		Class.forName("oracle.jdbc.driver.OracleDriver");
		System.out.println(_conn_str);
		System.out.println(labShelfName);
		System.out.println(passwd);
		connect = DriverManager.getConnection(_conn_str, labShelfName, passwd);
		stmt = connect.createStatement();
		System.out.println("Beginning uninstall");
		removeAll();
		stmt.close();
		connect.close();
	}

	/****
	 * Drops all tables if they exist
	 * @throws Exception
	 */
	private void removeAll() throws Exception {
		for (int i = 0; i < INTERNAL_TABLES.length; i++) {
			if (tableExists(INTERNAL_TABLES[i].TableName)) {
				stmt.executeUpdate("DROP TABLE " + INTERNAL_TABLES[i].TableName
						+ " CASCADE CONSTRAINTS");
				System.out.println(INTERNAL_TABLES[i].TableName + " Dropped");
			}
			if (INTERNAL_TABLES[i].strSequenceName != null) {
				dropSequence(INTERNAL_TABLES[i].strSequenceName);
			}
		}
	}
	
//	public void grantSeqPrivilege(String labShelfName){
//		try{
//			// switch to labshelf manager
//			Connection shelf_mgm_conn = DriverManager.getConnection(_conn_str, _shelf_creator_name, _shelf_creator_passwd);
//			Statement shelf_mgm_st = shelf_mgm_conn.createStatement();
//			// grant sequence creation
//			for (int i = 0; i < INTERNAL_TABLES.length; i++) {
//				if (INTERNAL_TABLES[i].strSequenceName != null) {
//					shelf_mgm_st.execute("GRANT SEQUENCE " + INTERNAL_TABLES[i].strSequenceName + " TO " + labShelfName);
//					System.out.println(INTERNAL_TABLES[i].strSequenceName + " is granted..");
//				}
//			}
//			shelf_mgm_conn.commit();
//			shelf_mgm_st.close();
//			shelf_mgm_conn.close();
//		}catch(SQLException sqe){
//			sqe.printStackTrace();
//		}
//	}
	
	/***
	 * Installs all internal tables
	 * @throws Exception
	 */
	private void installAll() throws Exception {
		for (int i = 0; i < INTERNAL_TABLES.length; i++) {
System.out.println(INTERNAL_TABLES[i].TableName + " Creating...");
			createTable(INTERNAL_TABLES[i].TableName,
					INTERNAL_TABLES[i].columns,
					INTERNAL_TABLES[i].columnDataTypes,
					INTERNAL_TABLES[i].columnDataTypeLengths,
					INTERNAL_TABLES[i].columnNullable,
					INTERNAL_TABLES[i].uniqueConstraintColumns,
					INTERNAL_TABLES[i].primaryKey,
					INTERNAL_TABLES[i].foreignKey);
System.out.println(INTERNAL_TABLES[i].TableName + " Created");
			if (INTERNAL_TABLES[i].strSequenceName != null) {
				createSequence(INTERNAL_TABLES[i].strSequenceName);
			}
		}
	}
	/***
	 * Drops sequence 
	 * @param seqName	sequence name
	 */
	private void dropSequence(String seqName) {
		String dropSequence = "DROP SEQUENCE " + seqName;
		try {
			stmt.execute(dropSequence);
		} catch (SQLException e) {
			if (e.getErrorCode() == 2289) {
				// Sequence does NOT exist
				return;
			}
			e.printStackTrace();
		}
	}
	/**
	 * Inserts the version specified in MetaData.AZDBLAB_VERSION to the corresponding labShelf
	 * 
	 * @throws Exception
	 */
	private void insertVersion() throws Exception {
		String version = Constants.AZDBLAB_VERSION;

		SimpleDateFormat creationDateFormater = new SimpleDateFormat(
				Constants.NEWTIMEFORMAT);
		String date = creationDateFormater.format(new Date(System
				.currentTimeMillis()));

		String sql = "INSERT INTO " + TableDefinition.VERSION.TableName
				+ " VALUES ('" + version + "', to_date('" + date + "', '"
				+ Constants.DATEFORMAT + "'))";
		stmt.execute(sql);
		System.out.println("Inserted Version:" + version);
	}
	/**
	 * Inserts all the scenario versions
	 * @throws Exception
	 */
	private void insertScenarioVersion() throws Exception {
		for(int i = 0; i < Constants.SCENARIOVERSIONS.length; i++){
			String scenarioName = Constants.SCENARIOVERSIONS[i][0];
			String versionName = Constants.SCENARIOVERSIONS[i][1];
			SimpleDateFormat creationDateFormater = new SimpleDateFormat(
					Constants.NEWTIMEFORMAT);
			String date = creationDateFormater.format(new Date(System
					.currentTimeMillis()));
			String sql = "INSERT INTO " + TableDefinition.SCENARIOVERSION.TableName
			+ " VALUES ('" + scenarioName + "', '"+versionName+"', to_date('" + date + "', '"
			+ Constants.DATEFORMAT + "'))";
			stmt.execute(sql);
		}
		System.out.println("All Scenario Versions Inserted");
	}
	/**
	 * Creates a DBMS table named tableName with the characteristics described
	 * by the parameters. All parameters that are arrays must be the same
	 * length. If they are not the same length an AZDBLab will terminate. Also,
	 * the index i for each array represents information about column i.
	 * 
	 * @param tableName
	 *            The name of the table that will be created.
	 * @param columnNames
	 *            The names of the columns that belong to the table.
	 * @param columnDataTypes
	 *            The data types of the columns that belong to the table.
	 * @param columnDataTypeLengths
	 *            The number of characters/digits that each column will use.
	 * @param primaryKey
	 *            The columns that will be part of the primary key.
	 * @param foreignKeys
	 *            The foreign keys for this table.
	 * @param Table_Record_Table
	 *            The table used to keep track of all relevant tables in the
	 *            AZDBLab
	 */
	private void createTable(String tableName, String[] columnNames,
			int[] columnDataTypes, int[] columnDataTypeLengths,
			int[] columnNullable, String[] uniqueConstraintColumns,
			String[] primaryKey, ForeignKey[] foreignKeys) {
		if (tableExists(tableName)) {
			System.err.println("Tables exist, terminating application");
			System.exit(1);
		}
		// If all arrays are not the same length exit
		if ((columnNames.length != columnDataTypes.length)
				|| (columnDataTypes.length != columnDataTypeLengths.length)) {
			System.err
					.println("createTable: Parameter Arrays must have same length");
			System.exit(1); // programmer bug, should be able to create a table
		}
		// assemble the CREATE TABLE statement
		String createTable = "CREATE TABLE " + tableName + " ( ";
		for (int i = 0; i < columnNames.length; i++) {
			createTable += columnNames[i]
					+ " "
					+ getDataTypeAsString(columnDataTypes[i],
							columnDataTypeLengths[i]);
			if (columnNullable[i] == 0) {
				createTable += " NOT NULL";
			} else if (columnNullable[i] == 1) {
				createTable += " NULL";
			}
			if (i == columnNames.length - 1)
				break;
			createTable += ", ";
		}
		if (uniqueConstraintColumns != null
				&& uniqueConstraintColumns.length > 0) {
			String constraint = ", CONSTRAINT unique_" + tableName
					+ " UNIQUE (";
			for (int i = 0; i < uniqueConstraintColumns.length; i++) {
				constraint += uniqueConstraintColumns[i];
				if (i == uniqueConstraintColumns.length - 1) {
					break;
				}
				constraint += ",";
			}
			constraint += ")";
			createTable += constraint;
		}
		// creating the primary key SQL
		if (primaryKey != null) {
			createTable += ", PRIMARY KEY(";
			for (int i = 0; i < primaryKey.length; i++) {
				createTable += primaryKey[i];
				if (i == primaryKey.length - 1)
					break;
				createTable += ", ";
			}
			createTable += ")";
		}
		// creating the Foreign Key SQL
		if (foreignKeys != null) {
			for (int i = 0; i < foreignKeys.length; i++) {
				createTable += ", FOREIGN KEY(";
				if (foreignKeys[i].columns.length != foreignKeys[i].columnsReferenced.length) {
					System.err
							.println("The two arrays in a Foreign Key Object must be the same length");
					System.exit(1);
				}
				for (int j = 0; j < foreignKeys[i].columns.length; j++) {
					createTable += foreignKeys[i].columns[j];
					if (j == foreignKeys[i].columns.length - 1)
						break;
					createTable += ", ";
				}
				createTable += ") REFERENCES " + foreignKeys[i].tableReferenced
						+ " (";
				for (int j = 0; j < foreignKeys[i].columnsReferenced.length; j++) {
					createTable += foreignKeys[i].columnsReferenced[j];
					if (j == foreignKeys[i].columnsReferenced.length - 1)
						break;
					createTable += ", ";
				}
				createTable += ")";
				if (foreignKeys[i].strCascadeOption != null) {
					createTable += foreignKeys[i].strCascadeOption;
				}
			}
		}
		createTable += ")";

		// Executing the SQL to create the table
		try {
			stmt.executeUpdate(createTable);
			connect.commit();
		} catch (SQLException e) {
			System.out.println(createTable);
			e.printStackTrace();
			System.exit(1);
		}
	}
	/****
	 * Gets data type as string	
	 * @param dataType column type
	 * @param length column length
	 * @return data type as string
	 */
	private String getDataTypeAsString(int dataType, int length) {
		switch (dataType) {
		case GeneralDBMS.I_DATA_TYPE_NUMBER: {
			return GeneralDBMS.NUMBER + "(" + length + ")";
		}
		case GeneralDBMS.I_DATA_TYPE_VARCHAR: {
			return GeneralDBMS.VARCHAR + "(" + length + ")";
		}
		case GeneralDBMS.I_DATA_TYPE_CLOB: {
			return GeneralDBMS.CLOB;
		}
		case GeneralDBMS.I_DATA_TYPE_XML: {
			return GeneralDBMS.XMLTYPE;
		}
		case GeneralDBMS.I_DATA_TYPE_TIMESTAMP: {
			return GeneralDBMS.TIMESTAMP;
		}
		case GeneralDBMS.I_DATA_TYPE_DATE: {
			return GeneralDBMS.DATE;
		}
		default: {
			System.err.println("UnknownDataType");
			System.exit(1);
			// problem with xml schema. should have been caught
			return null;
		}
		}
	}
	/***
	 * Checks if a given table exists in the labShelf
	 * @param table table name
	 * @return true or false
	 */
	private boolean tableExists(String table) {
		try {
			// attempts to create the table. If it fails, the table exists and
			// an exception will be thrown.
			stmt.executeUpdate("CREATE TABLE " + table + " (Name varchar(1))");
			// if the table was created, drop it again.
			stmt.executeUpdate("DROP TABLE " + table);
			return false;
		} catch (SQLException e) {
			return true;
		}
	}
	/***
	 * Creates sequence
	 * @param seqName	sequence name
	 */
	private void createSequence(String seqName) {
		String createSequence = "CREATE SEQUENCE " + seqName + " START WITH 1 NOMAXVALUE";
		try {
			stmt.execute(createSequence);
			System.out.println(seqName + " Created");
		} catch (SQLException e) {
			System.out.println(seqName + " already Exists");
		}
	}
}
