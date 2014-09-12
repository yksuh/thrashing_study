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
package azdblab.labShelf.dataModel;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.Vector;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

import javax.swing.JOptionPane;

import oracle.jdbc.OracleResultSet;

import azdblab.Constants;
import azdblab.exception.dbms.DBMSInvalidConnectionParameterException;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.InternalTable;
import azdblab.labShelf.PlanNode;
import azdblab.plugins.experimentSubject.ExperimentSubject;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.objectNodes.AbortedRunNode;
import azdblab.swingUI.objectNodes.ExecutorNode;
import azdblab.swingUI.objectNodes.PausedExecutorNode;
import azdblab.swingUI.objectNodes.PausedRunNode;
import azdblab.swingUI.objectNodes.PendingRunNode;
import azdblab.swingUI.objectNodes.RunStatusNode;
import azdblab.swingUI.objectNodes.RunningRunNode;

public abstract class LabShelfManager extends ExperimentSubject {

	public static String strVersionName = Constants.AZDBLAB_VERSION;

	private static LabShelfManager shelf;
	private static LabShelfManager expsub_shelf_;

	private static String exp_user_name_;
	private static String exp_password_;
	private static String exp_connect_string_;

	private static String user_name_;
	private static String password_;
	private static String connect_string_;
	private static String machine_name;

	// ///////////////////////////////////////////////////
	protected Statement labStatement;
	protected Statement regStatement;
	protected Statement reg_ParellelStatement;
	protected Connection labConnection;
	protected Connection regConnection;

	// /////////////////////////////////////////////////////

	public static final String[] INTERNAL_TABLES = new String[] {
			Constants.TABLE_PREFIX + Constants.TABLE_VERSION,
			Constants.TABLE_PREFIX + Constants.TABLE_EXECUTOR,
			Constants.TABLE_PREFIX + Constants.TABLE_EXECUTORLOG,
			Constants.TABLE_PREFIX + Constants.TABLE_USER,
			Constants.TABLE_PREFIX + Constants.TABLE_NOTEBOOK,
			Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENT,
			Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTRUN,
			Constants.TABLE_PREFIX + Constants.TABLE_RUNLOG,
			Constants.TABLE_PREFIX + Constants.TABLE_QUERY,
			Constants.TABLE_PREFIX + Constants.TABLE_QUERYRESULT,
			Constants.TABLE_PREFIX + Constants.TABLE_QUERYHASPARAMETER,
			Constants.TABLE_PREFIX + Constants.TABLE_QUERYEXECUTION,
			Constants.TABLE_PREFIX + Constants.TABLE_PLAN,
			Constants.TABLE_PREFIX + Constants.TABLE_PLANOPERATOR,
			Constants.TABLE_PREFIX + Constants.TABLE_QUERYEXECUTIONHASPLAN,
			Constants.TABLE_PREFIX + Constants.TABLE_QUERYEXECUTIONHASSTAT,
			Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTSPEC,
			Constants.TABLE_PREFIX + Constants.TABLE_REFERSEXPERIMENTSPEC,
			Constants.TABLE_PREFIX + Constants.TABLE_DEFINEDASPECT,
			Constants.TABLE_PREFIX + Constants.TABLE_SATISFIESASPECT,
			Constants.TABLE_PREFIX + Constants.TABLE_DEFINEDANALYTIC,
			Constants.TABLE_PREFIX + Constants.TABLE_ANALYTICVALUEOF,
			Constants.TABLE_PREFIX + Constants.TABLE_PREDEFINED_QUERY,
			Constants.TABLE_PREFIX + Constants.TABLE_PAPER,
			Constants.TABLE_PREFIX + Constants.TABLE_FIGURE,
			Constants.TABLE_PREFIX + Constants.TABLE_TABLE,
			Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS,
			Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_QUERY,
			Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_SCRIPT,
			Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_RUN,
			Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_RESULT };

	/**
	 * reestablish connection and statement if network failure happens
	 */
	protected abstract void reestablishConnection();

	public static LabShelfManager getShelf() {
		return shelf;
	}

	public static LabShelfManager getShelf(String userName, String password,
			String connectString, String machineName) {
		user_name_ = userName;
		password_ = password;
		connect_string_ = connectString;
		machine_name = machineName;
		shelf = createShelf(userName, password, connectString, machineName, false);
		return shelf;
	}

	public static LabShelfManager resetShelf() {
		return getShelf(user_name_, password_, connect_string_, machine_name);
	}

	public static LabShelfManager getExpSubShelf(String userName,
			String password, String connectString) {
		exp_user_name_ = userName;
		exp_password_ = password;
		exp_connect_string_ = connectString;
		return createExpSubShelf(userName, password, connectString);
	}

	public static LabShelfManager getExpSubShelf() {
		return expsub_shelf_;
	}

	public static LabShelfManager resetExpSubShelf() {
		return createExpSubShelf(exp_user_name_, exp_password_,
				exp_connect_string_);
	}

	public static LabShelfManager getNewShelf(String userName, String password,
			String connectString, String machineName) {
		return createShelf(userName, password, connectString, machineName, false);
	}

	public static LabShelfManager getShelfForAjaxManager(String userName,
			String password, String connectString, URL[] urls) {
		// String classpath = System.getProperty("java.class.path");
		// System.setProperty("java.class.path", classpath +
		// System.getProperty("path.seperator") +
		// "/usr/share/tomcat5/webapps/azdblab/WEB-INF/lib");
		try {

			Class<?> targetClass = null;
			ClassLoader classLoader;
			classLoader = LabShelfManager.class.getClassLoader();
			ClassLoader classLoader2 = new URLClassLoader(urls, classLoader);
			targetClass = classLoader2.loadClass("plugins.OracleSubject");

			Class<?> partypes[] = new Class[3];
			partypes[0] = String.class;
			partypes[1] = String.class;
			partypes[2] = String.class;

			Constructor<?> constructor = targetClass.getConstructor(partypes);

			Object arglist[] = new Object[3];
			arglist[0] = userName;
			arglist[1] = password;
			arglist[2] = connectString;

			shelf = (LabShelfManager) constructor.newInstance(arglist);
			shelf.OpenLabShelf();
		} catch (ClassNotFoundException cnfexp) {
			cnfexp.printStackTrace();
		} catch (IllegalAccessException iaexp) {
			iaexp.printStackTrace();
		} catch (InstantiationException instexp) {
			instexp.printStackTrace();
		} catch (NoSuchMethodException nsmexp) {
			nsmexp.printStackTrace();
		} catch (InvocationTargetException itexp) {
			itexp.printStackTrace();
		}

		return shelf;
		// LabShelf lnl = new OracleSubject(userName, password,
		// connectString);
		// lnl.open();
		// LabShelf.shelf = lnl;
		// return lnl;
	}

	private static LabShelfManager createShelf(String userName,
			String password, String connectString, String machineName, boolean ajaxManager) {
		// System.err.println("usr:" +userName + "\npass:" + password +
		 //"\nconnect:"+ connectString);
		try {

			Class<?> targetClass = null;
			ClassLoader classLoader;
			URL urls[] = { new URL("file:" + Constants.DIRECTORY_PLUGINS
					+ "OracleSubject_06_12_2008_12_12_34.jar") };
			classLoader = new URLClassLoader(urls);
			targetClass = classLoader.loadClass("plugins.OracleSubject");

			Class<?> partypes[] = new Class[4];
			partypes[0] = String.class;
			partypes[1] = String.class;
			partypes[2] = String.class;
			partypes[3] = String.class;

			Constructor<?> constructor = targetClass.getConstructor(partypes);

			Object arglist[] = new Object[4];
			arglist[0] = userName;
			arglist[1] = password;
			arglist[2] = connectString;
			arglist[3] = machineName;

			shelf = (LabShelfManager) constructor.newInstance(arglist);
			shelf.OpenLabShelf();
		} catch (ClassNotFoundException cnfexp) {
			cnfexp.printStackTrace();
		} catch (IllegalAccessException iaexp) {
			iaexp.printStackTrace();
		} catch (InstantiationException instexp) {
			instexp.printStackTrace();
		} catch (NoSuchMethodException nsmexp) {
			nsmexp.printStackTrace();
		} catch (InvocationTargetException itexp) {
			itexp.printStackTrace();
		} catch (MalformedURLException muexp) {
			muexp.printStackTrace();
		}
		return shelf;
	}

	private static LabShelfManager createExpSubShelf(String userName,
			String password, String connectString) {

		try {

			Class<?> targetClass = null;
			ClassLoader classLoader;
			URL urls[] = { new URL("file:" + Constants.DIRECTORY_PLUGINS
					+ "OracleSubject_06_12_2008_12_12_34.jar") };
			classLoader = new URLClassLoader(urls);
			targetClass = classLoader.loadClass("plugins.OracleSubject");

			Class<?> partypes[] = new Class[3];
			partypes[0] = String.class;
			partypes[1] = String.class;
			partypes[2] = String.class;

			Constructor<?> constructor = targetClass.getConstructor(partypes);

			Object arglist[] = new Object[3];
			arglist[0] = userName;
			arglist[1] = password;
			arglist[2] = connectString;

			expsub_shelf_ = (LabShelfManager) constructor.newInstance(arglist);
			expsub_shelf_.OpenLabShelf();
		} catch (ClassNotFoundException cnfexp) {
			cnfexp.printStackTrace();
		} catch (IllegalAccessException iaexp) {
			iaexp.printStackTrace();
		} catch (InstantiationException instexp) {
			instexp.printStackTrace();
		} catch (NoSuchMethodException nsmexp) {
			nsmexp.printStackTrace();
		} catch (InvocationTargetException itexp) {
			itexp.printStackTrace();
		} catch (MalformedURLException muexp) {
			muexp.printStackTrace();
		}

		return expsub_shelf_;
	}

	protected LabShelfManager(String userName, String password,
			String connectString, String machineName) {
		super(userName, password, connectString, machineName);
	}

	/**
	 * Puts a document into the DBMS. Anytype of File can be uploaded to the
	 * DBMS. There should be no limit on the size of the document.
	 * 
	 * @param tableName
	 *            The name of the table that will contain the document.
	 * @param documentColumnName
	 *            The name of the column that holds the document.
	 * @param columnNames
	 *            The name of column used to determine if the document already
	 *            exists.
	 * @param columnValues
	 *            The values of the column used to determine if the document
	 *            already exists.
	 * @param columnDataTypes
	 *            The data types of the above columns.
	 * @param document
	 *            A FileInputStream to the document. This is used to read the
	 *            file and upload it into the DBMS.
	 */
	public abstract int putDocument(String tableName,
			String documentColumnName, String[] columnNames,
			String[] columnValues, int[] columnDataTypes,
			FileInputStream document);

	public abstract int putDocument(String tableName,
			String documentColumnName, String[] columnNames,
			String[] columnValues, int[] columnDataTypes, String content);

	/**
	 * Used to replace an existing document. The old document is deleted and the
	 * document is uploaded again. The where clause is built as follows. For
	 * each index i, columnNames[i]=columnValues[i]. The columnDataTypes[i] is
	 * used to add other syntax need for a specific data type.
	 * 
	 * @param tableName
	 *            The name of the table that contains the document.
	 * @param documentColumnName
	 *            The column that contains the document.
	 * @param columnNames
	 *            The names of the columns used to identify the correct
	 *            document.
	 * @param columnValues
	 *            The values of the columns used to identify the correct
	 *            document.
	 * @param columnDataTypes
	 *            The data types of the columns.
	 * @param document
	 *            The document that is to replace the existing document.
	 */
	public abstract void updateDocument(String tableName,
			String documentColumnName, String[] columnNames,
			String[] columnValues, int[] columnDataTypes,
			FileInputStream document);

	/**
	 * Used to replace an existing document. The old document is deleted and the
	 * document is uploaded again. The where clause is built as follows. For
	 * each index i, columnNames[i]=columnValues[i]. The columnDataTypes[i] is
	 * used to add other syntax need for a specific data type.
	 * 
	 * @param tableName
	 *            The name of the table that contains the document.
	 * @param documentColumnName
	 *            The column that contains the document.
	 * @param columnNames
	 *            The names of the columns used to identify the correct
	 *            document.
	 * @param columnValues
	 *            The values of the columns used to identify the correct
	 *            document.
	 * @param columnDataTypes
	 *            The data types of the columns.
	 * @param contentStream
	 *            The document content as ByteArrayInputStream.
	 */
	public abstract void updateDocument(String tableName,
			String documentColumnName, String[] columnNames,
			String[] columnValues, int[] columnDataTypes,
			ByteArrayInputStream contentStream);

	/**
	 * Retrieves a document from the DBMS. The content of the document is
	 * understood only by the user. The where clause is built as follows. For
	 * each index i, columnNames[i]=columnValues[i]. The columnDataTypes[i] is
	 * used to add other syntax need for a specific data type.
	 * 
	 * @param tableName
	 *            The name of the table that contains the document
	 * @param documentColumnName
	 *            The name of the column that contains the document.
	 * @param columnNames
	 *            The name of the columns that will be used in the WHERE clause
	 *            to identify the document that the user wishes to retrieve.
	 * @param columnValues
	 *            The values of the columns that will be used in the WHERE
	 *            clause to identify the document that the user wishes to
	 *            retrieve.
	 * @param columnDataTypes
	 *            The data types for each of these columns.
	 * @return An input stream to the document. This input stream can be used to
	 *         read the contents of the document.
	 */
	public abstract InputStream getDocument(String tableName,
			String documentColumnName, String[] columnNames,
			String[] columnValues, int[] columnDataTypes);

	public abstract void insertTupleToNotebook(String tableName,
			String[] columnNames, String[] columnValues, int[] columnDataTypes)
			throws SQLException;

	public abstract void closelabshelf();

	/**
	 * Commits all update operations made to the dbms. This must be called for
	 * inserts statements to be seen.
	 */
	public abstract void commitlabshelf();

	/**
	 * Opens the connection to the DBMS.
	 * 
	 * @throws DBMSInvalidConnectionParameterException
	 */
	public abstract void openlabshelf()
			throws DBMSInvalidConnectionParameterException;

	public abstract void exportResultData(String expFacilityPath,
			String resultFile);

	public abstract void importResultData(String impFacilityPath,
			String inputFile);

	/**
	 * 
	 * @param userName
	 */
	public void deleteUser(String userName) {
		String[] columnNames = new String[] { "UserName" };
		String[] columnValues = new String[] { userName };
		int[] columnDataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR };

		getShelf().deleteRows(Constants.TABLE_PREFIX + Constants.TABLE_USER,
				columnNames, columnValues, columnDataTypes);
		getShelf().commitlabshelf();

	}

	/**
	 * 
	 * @return
	 */
	public List<Analytic> getAllAnalytics() {

		Vector<Analytic> result = new Vector<Analytic>();

		String columnName = "UserName, " + "NotebookName, " + "AnalyticName, "
				+ "Style, " + "Description, " + "AnalyticSQL";

		String[] columnNames = new String[] {};
		String[] columnValues = new String[] {};
		int[] dataTypes = new int[] {};

		try {
			// Queries the DBMS for the test results of an experiment.
			ResultSet rs = LabShelfManager.getShelf().executeSimpleQuery(
					Constants.TABLE_PREFIX + Constants.TABLE_DEFINEDANALYTIC,
					new String[] { columnName }, columnNames, columnValues,
					dataTypes);

			while (rs.next()) {

				String userName = rs.getString(1);
				String notebookName = rs.getString(2);
				String analyticName = rs.getString(3);
				String analyticStyle = rs.getString(4);
				String analyticDescription = rs.getString(5);
				Clob clob = rs.getClob(6);

				if (clob == null) {

				}

				char[] data = new char[1024];

				Reader reader = clob.getCharacterStream();

				StringBuffer strbuf = new StringBuffer();

				for (int len; (len = reader.read(data, 0, 1024)) > 0; strbuf
						.append(data, 0, len))
					;

				String analyticSQL = new String(strbuf);

				Analytic anlnode = new Analytic(userName, notebookName,
						analyticName, analyticStyle, analyticDescription,
						analyticSQL);

				result.add(anlnode);
			}

			rs.close();

			return result;

		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}

	/**
	 * 
	 * @param machineName
	 * @param DBMS
	 * @param transactionTime
	 * @param currentStatus
	 * @param command
	 */
	public void insertExecutor(String machineName, String DBMS,
			String transactionTime, String currentStatus, String command) {

		String existSQL = "SELECT * FROM " + Constants.TABLE_PREFIX
				+ Constants.TABLE_EXECUTOR + " WHERE MachineName = '"
				+ machineName + "' AND CurrentDBMSName = '" + DBMS + "'";

		ResultSet rsExist = getShelf().executeQuerySQL(existSQL);

		try {
			if (!rsExist.next()) { // if this is a new executor, insert a new
				// tuple

				String[] columns = new String[] { "MachineName", "CurrentDBMSName",
						"CurrentStatus", "Command" };
				String[] columnValues = new String[] { machineName, DBMS,
						currentStatus, command };
				int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
						GeneralDBMS.I_DATA_TYPE_VARCHAR,
						GeneralDBMS.I_DATA_TYPE_VARCHAR,
						GeneralDBMS.I_DATA_TYPE_VARCHAR };

				// Inserts a test into the DBMS with no test result.
				getShelf().insertTupleToNotebook(
						Constants.TABLE_PREFIX + Constants.TABLE_EXECUTOR,
						columns, columnValues, dataTypes);
				getShelf().commitlabshelf();

			} else { // otherwise leave update the old one with new command and
				// new status.
				String updateExecutor = "UPDATE " + Constants.TABLE_PREFIX
						+ Constants.TABLE_EXECUTOR + " SET CurrentStatus = '"
						+ currentStatus + "', Command = '" + command
						+ "' WHERE MachineName = '" + machineName
						+ "' AND CurrentDBMSName = '" + DBMS + "'";
				getShelf().executeUpdateSQL(updateExecutor);
				getShelf().commitlabshelf();
			}

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}

	}

	// public void insertUserNew(String strusername, String createDate) {
	// String insertSQL = "INSERT INTO " + Constants.TABLE_PREFIX
	// + Constants.TABLE_USER + " VALUES ";
	// insertSQL += "('" + strusername + "'" + "', TO_DATE('" + createDate
	// + "', 'mm/dd/yyyy hh24:mi:ss')";
	// getShelf().executeUpdateSQL(insertSQL);
	// getShelf().commitlabshelf();
	// }

	/**
	 * 
	 * @param usr_name
	 * @param create_date
	 */
	public void insertUser(String usr_name, String create_date) {
		String[] columnNames = new String[] { "UserName", "CreateDate" };
		String[] columnValues = new String[] { usr_name, create_date };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_DATE };
		try {
			// inserts a change point into the the internal tables.
			getShelf().insertTupleToNotebook(
					Constants.TABLE_PREFIX + Constants.TABLE_USER, columnNames,
					columnValues, dataTypes);
			getShelf().commitlabshelf();
		} catch (SQLException e) {
			System.err.println("Failed to insert user");
			e.printStackTrace();
			System.exit(1); // programmer/dbsm error
		}
	}

	public void printTableSchema() {

		try {
			for (int i = 0; i < INTERNAL_TABLES.length; i++) {

				String sqlColumns = "select COLUMN_NAME, DATA_TYPE, DATA_LENGTH, NULLABLE from USER_TAB_COLUMNS where TABLE_NAME='"
						+ INTERNAL_TABLES[i] + "' order by column_id";
				ResultSet rsColumns = getShelf().executeQuerySQL(sqlColumns);

				Main._logger.outputLog("----------- " + INTERNAL_TABLES[i]
						+ " -------------");
				while (rsColumns.next()) {
					Main._logger.outputLog(rsColumns.getString(1) + "\t"
							+ rsColumns.getString(2) + "\t"
							+ rsColumns.getInt(3) + "\t"
							+ rsColumns.getString(4));
				}

				rsColumns.close();

				String sqlConstraints = "SELECT ac.CONSTRAINT_TYPE, acc.COLUMN_NAME FROM ALL_CONSTRAINTS ac, ALL_CONS_COLUMNS acc WHERE acc.TABLE_NAME = '"
						+ INTERNAL_TABLES[i]
						+ "' AND ac.TABLE_NAME = acc.TABLE_NAME AND ac.CONSTRAINT_NAME = acc.CONSTRAINT_NAME ORDER BY acc.CONSTRAINT_NAME, acc.POSITION";
				ResultSet rsConstraints = getShelf().executeQuerySQL(
						sqlConstraints);

				if (rsConstraints != null) {
					Vector<String> primaryKeys = new Vector<String>();
					Vector<String> uniqueKeys = new Vector<String>();
					Vector<String> foreignKeys = new Vector<String>();

					while (rsConstraints.next()) {
						String constraintType = rsConstraints.getString(1);
						if (constraintType.equals("P")) {
							if (!primaryKeys.contains(rsConstraints
									.getString(2))) {
								primaryKeys.add(rsConstraints.getString(2));

							}
						} else if (constraintType.equals("R")) {
							if (!foreignKeys.contains(rsConstraints
									.getString(2))) {
								foreignKeys.add(rsConstraints.getString(2));
							}

						} else if (constraintType.equals("U")) {
							if (!uniqueKeys
									.contains(rsConstraints.getString(2))) {
								uniqueKeys.add(rsConstraints.getString(2));
							}
						}
					}
					rsConstraints.close();

					if (primaryKeys.size() > 0) {
						String res = "Primary Keys : \t ";
						for (int l = 0; l < primaryKeys.size(); l++) {
							res += primaryKeys.get(l) + ", ";
						}
						Main._logger.outputLog(res);
					}
					if (uniqueKeys.size() > 0) {
						String res = "Unique Constraint : \t";
						for (int l = 0; l < uniqueKeys.size(); l++) {
							res += uniqueKeys.get(l) + ", ";
						}
						Main._logger.outputLog(res);
					}
					if (foreignKeys.size() > 0) {

						for (int l = 0; l < foreignKeys.size(); l++) {
							String res = "Foriegn Key : \t ";
							String foriegn_Constraints = "SELECT ac1.TABLE_NAME FROM ALL_CONSTRAINTS ac1, ALL_CONS_COLUMNS acc1 WHERE ac1.CONSTRAINT_TYPE = 'P' AND  acc1.CONSTRAINT_NAME = ac1.CONSTRAINT_NAME AND acc1.COLUMN_NAME = '"
									+ foreignKeys.get(l)
									+ "' AND NOT EXISTS ( SELECT * FROM ALL_CONSTRAINTS ac2, ALL_CONS_COLUMNS acc2 WHERE ac2.CONSTRAINT_TYPE = 'R' AND acc2.CONSTRAINT_NAME = ac2.CONSTRAINT_NAME AND acc2.COLUMN_NAME = acc1.COLUMN_NAME AND ac1.TABLE_NAME = ac2.TABLE_NAME)";
							ResultSet fk = getShelf().executeQuerySQL(
									foriegn_Constraints);
							while (fk.next()) {
								res += foreignKeys.get(l) + ", REFERENCES, "
										+ fk.getString(1);
								break;
							}
							Main._logger.outputLog(res);
							fk.close();
						}
					}
				}

				Main._logger
						.outputLog("-----------------------------------------");
				Main._logger.outputLog("");
				Main._logger.outputLog("");
			}
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}

	}

	/**
	 * 
	 * Open the connections for both labshelf instance and generalDBMS instance
	 */
	public void OpenLabShelf() {
		try {
			openlabshelf();
			open(false);
		} catch (DBMSInvalidConnectionParameterException ex) {
			ex.printStackTrace();
			JOptionPane
					.showMessageDialog(null,
							"LabShelf DBMS Server is down, please try again later.\n@LabShelf");
			System.exit(1);
		}
	}

	/**
	 * 
	 * @param vecFileNames
	 * @param strZipFileName
	 */
	public void zipFiles(Vector<String> vecFileNames, String strZipFileName) {

		// Create a buffer for reading the files
		byte[] buf = new byte[1024];

		try {
			// Create the ZIP file
			ZipOutputStream out = new ZipOutputStream(new FileOutputStream(
					strZipFileName));

			// Compress the files
			for (int i = 0; i < vecFileNames.size(); i++) {

				String fname = vecFileNames.get(i);

				File newfile = new File(fname);

				FileInputStream in = new FileInputStream(fname);

				// Add ZIP entry to output stream.
				out.putNextEntry(new ZipEntry(newfile.getName()));

				// Transfer bytes from the file to the ZIP file
				int len;
				while ((len = in.read(buf)) > 0) {
					out.write(buf, 0, len);
				}

				// Complete the entry
				out.closeEntry();
				in.close();

				newfile.delete();
			}

			// Complete the ZIP file
			out.close();
		} catch (IOException ioex) {
			ioex.printStackTrace();
		}

	}

	/**
	 * 
	 * @param strZippedFile
	 * @return
	 */
	public List<String> unzipFiles(String strZippedFile) {

		Vector<String> vecFileNames = new Vector<String>();
		Enumeration<?> entries;
		ZipFile zipFile;

		try {

			zipFile = new ZipFile(strZippedFile);
			entries = zipFile.entries();

			while (entries.hasMoreElements()) {

				ZipEntry entry = (ZipEntry) entries.nextElement();

				if (entry.isDirectory()) {
					// Assume directories are stored parents first then
					// children.
					System.err.println("Extracting directory: "
							+ entry.getName());
					// This is not robust, just for demonstration purposes.
					(new File(entry.getName())).mkdir();
					continue;
				}

				System.err.println("Extracting file: " + entry.getName());
				File newfile = new File(entry.getName());
				vecFileNames.add(newfile.getAbsolutePath());

				InputStream in = zipFile.getInputStream(entry);
				BufferedOutputStream out = new BufferedOutputStream(
						new FileOutputStream(entry.getName()));

				byte[] buffer = new byte[1024];
				int len;

				while ((len = in.read(buffer)) >= 0) {
					out.write(buffer, 0, len);
				}

				in.close();
				out.close();
			}

			zipFile.close();

			return vecFileNames;

		} catch (IOException ioex) {
			// System.err.println("Unhandled exception:");
			ioex.printStackTrace();
			return null;
		}
	}

	/**
	 * 
	 * @param testSpecName
	 * @param xml_source
	 * @param kind
	 * @return
	 * @throws FileNotFoundException
	 */
	public int insertExperimentSpec(String experimentSpecName, File xml_source,
			String kind) throws FileNotFoundException {

		int experimentSpecID = getShelf().getSequencialID(
				"SEQ_EXPERIMENTSPECID");
		String xmlColumnName = "SourceXML";
		String[] columns = new String[] { "ExperimentSpecID", "Name",
				"FileName", "Kind" };
		String[] columnValues = new String[] {
				String.valueOf(experimentSpecID), experimentSpecName,
				xml_source.getName(), kind };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR };
		FileInputStream source = new FileInputStream(xml_source);
		getShelf().putDocument(
				Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTSPEC,
				xmlColumnName, columns, columnValues, dataTypes, source);
		getShelf().commitlabshelf();

		return experimentSpecID;
	}

	/**
	 * 
	 * @return The current Version of LabShelf
	 */
	public String getLabShelfVersion() {
		String sql = "SELECT VERSIONNAME FROM " + Constants.TABLE_PREFIX
				+ Constants.TABLE_VERSION + " ORDER BY CREATEDATE desc";
		String versionName = "";
		try {
			ResultSet rs = getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				versionName = rs.getString(1);
				break;
			}
			rs.close();

		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return versionName;
	}

	public void populatePlanOperatorTables() {

		Vector<Long> vecPlanIDs = new Vector<Long>();
		String planIDSQL = "SELECT DISTINCT PLANID FROM "
				+ Constants.TABLE_PREFIX + Constants.TABLE_PLAN;
		ResultSet rsPlanID = getShelf().executeQuerySQL(planIDSQL);

		try {
			while (rsPlanID.next()) {
				vecPlanIDs.add(rsPlanID.getLong(1));
			}
			rsPlanID.close();
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}

		for (int i = 0; i < vecPlanIDs.size(); i++) {

			long planID = vecPlanIDs.get(i);

			String columnName = "PlanTree";
			String[] columnNames = new String[] { "PlanID" };
			String[] columnValues = new String[] { String.valueOf(planID) };
			int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER };

			InputStream finStream = getShelf().getDocument(
					Constants.TABLE_PREFIX + Constants.TABLE_PLAN, columnName,
					columnNames, columnValues, dataTypes);

			PlanNode planNode = null;

			try {
				planNode = (PlanNode) PlanNode.loadPlanNode(finStream);
			} catch (Exception ex) {
				ex.printStackTrace();
			}

			HashMap<String, Integer> mapPlanOperators = planNode
					.getPlanOperators();

			Set<String> keys = mapPlanOperators.keySet();

			Iterator<String> iterKeys = keys.iterator();

			while (iterKeys.hasNext()) {

				String tmpKey = iterKeys.next().toString();
				int occurrence = mapPlanOperators.get(tmpKey);
				String sqlInsert = "INSERT INTO " + Constants.TABLE_PREFIX
						+ Constants.TABLE_PLANOPERATOR + " VALUES (" + planID
						+ ", '" + tmpKey + "', " + occurrence + ")";

				getShelf().executeUpdateSQL(sqlInsert);
				getShelf().commitlabshelf();

			}

		}

	}

	public List<ExecutorNode> getAllExecutors() {
		AZDBLabObserver.timerOn = false;
		Vector<ExecutorNode> result = new Vector<ExecutorNode>();

		String sql = "SELECT machineName, currentDBMSName, currentStatus, command FROM " + Constants.TABLE_PREFIX
				+ Constants.TABLE_EXECUTOR;
		
		// System.out.println(sql);
		int stageCnt = 1, stageWaitTime  = Constants.WAIT_TIME; 
		while(stageCnt <= Constants.TRY_COUNTS){	
			try {

				ResultSet rs = reg_ParellelStatement.executeQuery(sql);
				while (rs.next()) {
	
					String machineName = rs.getString(1);
					String dbmsName = rs.getString(2);
					String currentStatus = rs.getString(3);
					String command = rs.getString(4);
					
					if ((currentStatus).toLowerCase().contains("paused") || (currentStatus).toLowerCase().contains("resumed")) {
						result.add(new PausedExecutorNode(machineName, dbmsName, currentStatus, command));
					} else{
						result.add(new ExecutorNode(machineName, dbmsName, currentStatus, command));
					}
				}
				rs.close();
	
				AZDBLabObserver.timerOn = true;
				break;
			} catch (Exception ex) {
				ex.printStackTrace();
				String msg =  ex.getMessage();
				if(msg.toLowerCase().contains("closed")){
					System.err.println("Labshelf server is down due to the scheduled backup. Please rerun observer.");
					System.exit(-1);
				}else{
					stageCnt++;
					stageWaitTime *= 2;
					Main._logger.outputLog("Exponential backoff is performed for : " + stageWaitTime + " (ms)");
					try {
						// wait 2^(count) seconds
						Thread.sleep(stageWaitTime);
					} catch (InterruptedException e) {}
					continue;
				}
				AZDBLabObserver.timerOn = true;
				return null;
			}
		}
		return result;
	}
	
	/**
	 * 
	 * @return
	 */
	public List<RunStatusNode> getAllRuns() {
		AZDBLabObserver.timerOn = false;
		Vector<RunStatusNode> result = new Vector<RunStatusNode>();
		/*
		 * String sql =
		 * "SELECT distinct exp.UserName, exp.NotebookName, exp.ExperimentName, exp.Scenario, exr.DBMS, exr.StartTime, exr.CurrentStage, exr.Percentage, exr.MachineName, exe.CurrentStatus "
		 * + "FROM " + Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENT +
		 * " exp, " + Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTRUN +
		 * " exr, " + Constants.TABLE_PREFIX + Constants.TABLE_EXECUTOR +
		 * " exe " +
		 * "WHERE exp.ExperimentID = exr.ExperimentID AND ((exr.MachineName = exe.MachineName AND exr.DBMS = exe.DBMS) OR exr.CurrentStage = 'Pending')"
		 * ;
		 */// The SQL above is WRONG

		String sql = "SELECT distinct exp.UserName, exp.NotebookName, exp.ExperimentName, exp.Scenario, exr.DBMSName, exr.StartTime, exr.CurrentStage, exr.Percentage, exr.MachineName, exe.CurrentStatus "
				+ "FROM "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_EXPERIMENT
				+ " exp, "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_EXPERIMENTRUN
				+ " exr, "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_EXECUTOR
				+ " exe "
				+ "WHERE exp.ExperimentID = exr.ExperimentID AND (exr.MachineName = exe.MachineName AND exr.DBMSName = exe.CurrentDBMSName) order by exr.StartTime";

		System.out.println(sql);
		int stageCnt = 1, stageWaitTime  = Constants.WAIT_TIME; 
		while(stageCnt <= Constants.TRY_COUNTS){	
			try {
	
	//			ResultSet rs = executeQuerySQL(sql);
				
				ResultSet rs = reg_ParellelStatement.executeQuery(sql);
				while (rs.next()) {
	
					String userName = rs.getString(1);
					String notebookName = rs.getString(2);
					String experimentName = rs.getString(3);
					String scenario = rs.getString(4);
					String dbms = rs.getString(5);
	//				String startTime = rs.getString(6);
					String startTime = new SimpleDateFormat(Constants.TIMEFORMAT).format(rs.getTimestamp(6));
					String currentStage = rs.getString(7);
					// double percentage = rs.getDouble(8);
					String machineName = rs.getString(9);
//					String executorStatus = rs.getString(10);
	
//					if ((!currentStage.equals("Pending"))
//							&& (!currentStage.equals("Completed"))
//							&& (!currentStage.equals("Aborted"))) {
//						if (executorStatus.equals("Paused")
//								|| executorStatus.equals("Terminated")) {
//							result.add(new PausedRunNode(userName, notebookName,
//									experimentName, scenario, machineName, dbms,
//									startTime));
//						} else {
//							result.add(new RunningRunNode(userName, notebookName,
//									experimentName, scenario, machineName, dbms,
//									startTime));
//						}
//					} else if (currentStage.equals("Pending")) {
//						result.add(new PendingRunNode(userName, notebookName,
//								experimentName, scenario, dbms, startTime));
//					} else if (currentStage.equals("Aborted")) {
//						result.add(new AbortedRunNode(userName, notebookName,
//								experimentName, scenario, machineName, dbms,
//								startTime));
//					}
					if ((currentStage).toLowerCase().contains("paused") || (currentStage).toLowerCase().contains("resumed")) {
						result.add(new PausedRunNode(userName, notebookName,
								experimentName, scenario, machineName, dbms,
								startTime));
					} else if (currentStage.equals("Pending")) {
						result.add(new PendingRunNode(userName, notebookName,
								experimentName, machineName, scenario, dbms, startTime));
					} else if (currentStage.equals("Aborted")) {
						result.add(new AbortedRunNode(userName, notebookName,
								experimentName, scenario, machineName, dbms,
								startTime));
					}else{
						if (!currentStage.equals("Completed")) {
							result.add(new RunningRunNode(userName, notebookName,
									experimentName, scenario, machineName, dbms,
									startTime));
						}
					}
				}
				rs.close();
	
	//			sql = "SELECT distinct exp.UserName, exp.NotebookName, exp.ExperimentName, exp.Scenario, exr.DBMS, exr.StartTime, exr.CurrentStage, exr.Percentage "
	//					+ "FROM "
	//					+ Constants.TABLE_PREFIX
	//					+ Constants.TABLE_EXPERIMENT
	//					+ " exp, "
	//					+ Constants.TABLE_PREFIX
	//					+ Constants.TABLE_EXPERIMENTRUN
	//					+ " exr "
	//					+ "WHERE exp.ExperimentID = exr.ExperimentID AND exr.CurrentStage = 'Pending'";
	////			rs = executeQuerySQL(sql);
	//			rs = reg_ParellelStatement.executeQuery(sql);
	//			
	//			while (rs.next()) {
	//
	//				String userName = rs.getString(1);
	//				String notebookName = rs.getString(2);
	//				String experimentName = rs.getString(3);
	//				String scenario = rs.getString(4);
	//				String dbms = rs.getString(5);
	//				String startTime = new SimpleDateFormat(Constants.TIMEFORMAT).format(rs.getTimestamp(6));
	//				String currentStage = rs.getString(7);
	//
	//				if (currentStage.equals("Pending")) {
	//					result.add(new PendingRunNode(userName, notebookName,
	//							experimentName, scenario, dbms, startTime));
	//				}
	//			}
				AZDBLabObserver.timerOn = true;
				break;
			} catch (Exception ex) {
				ex.printStackTrace();
				String msg =  ex.getMessage();
				if(msg.toLowerCase().contains("closed")){
					System.err.println("Labshelf server is down due to the scheduled backup. Please rerun observer.");
					System.exit(-1);
				}else{
					stageCnt++;
					stageWaitTime *= 2;
					Main._logger.outputLog("Exponential backoff is performed for : " + stageWaitTime + " (ms)");
					try {
						// wait 2^(count) seconds
						Thread.sleep(stageWaitTime);
					} catch (InterruptedException e) {}
					continue;
				}
				AZDBLabObserver.timerOn = true;
				return null;
			}
		}
		return result;
	}

	public void installSpecificTable(InternalTable table) {
		createTable(table.TableName, table.columns, table.columnDataTypes,
				table.columnDataTypeLengths, table.primaryKey, table.foreignKey);

	}

	public boolean didInsertTuple(String tableName, String[] columnNames,
			String[] columnValues, int[] columnDataTypes) {

		try {

			this.insertTupleToNotebook(tableName, columnNames, columnValues,
					columnDataTypes);
			this.commitlabshelf();
			return true;

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return false;
		}

	}

	public List<String> getVersionNames() {
		Vector<String> strVerNames = new Vector<String>();

		String sql = "SELECT VersionName from " + Constants.TABLE_PREFIX
				+ Constants.TABLE_VERSION;

		ResultSet rs = executeQuerySQL(sql);

		try {
			while (rs.next()) {
				String verName = rs.getString(1);
				strVerNames.add(verName);
			}
		} catch (SQLException e) {
			Main._logger.reportError("SQL error in LabShelf.getVersionNames");
			e.printStackTrace();
		}
		return strVerNames;
	}

	public ResultSet runQuery(String sql) {
		return getShelf().executeQuerySQL(sql);
	}

	public int getPlanCardinality(int queryID) throws Exception {
		String sql = "select distinct qe.queryid, qp.planid from azdblab_queryexecution qe, azdblab_QUERYEXECUTIONHASPLAN qp where qe.queryexecutionid = qp.queryexecutionid and qe.queryid = "
				+ queryID;
		int num = 0;
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				num++;
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return num;
	}

	public int getPlanOperators(int queryID) throws Exception {
		String sql = "select count(distinct OPERATORNAME) from AZDBLAB_PLANOPERATOR po, azdblab_queryexecution qe, azdblab_QUERYEXECUTIONHASPLAN qp where qp.planid = po.planid and qe.queryexecutionid = qp.queryexecutionid and qe.queryid = "
				+ queryID;
		int toRet = 0;
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			if (rs.next()) {
				toRet = rs.getInt(1);
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return toRet;
	}

	public int hasSuboptimality(int queryID) throws Exception {
		String findSuboptimal = "Select qe1.Cardinality, qe1.Runtime, qe2.Cardinality, qe2.Runtime from "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_QUERYEXECUTION
				+ " qe1, "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_QUERYEXECUTION
				+ " qe2 WHERE qe1.QueryID = "
				+ queryID
				+ " AND qe1.QueryID = qe2.QueryID AND qe2.Runtime > qe1.Runtime AND qe2.Cardinality < qe1.Cardinality";

		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(
				findSuboptimal);
		if (rs.next()) {
			rs.close();
			return 1;
		}
		rs.close();
		return 0;
	}

	protected ResultSet commonExecuteQuerySQL(Statement stmt, String sql) {
		// We should not make a direct call to JDBC.
		// It should be done through AZDBLAB function call.
		ResultSet rs = null;
		int numTryCounts = 10;
		int count = 1;
		int waitTime = 1000; // ms
		do {
			try {
				rs = stmt.executeQuery(sql);
				return rs;
			} catch (SQLException sqlex) {
				Main._logger.reportError("retry " + count + ": " + sql);
				sqlex.printStackTrace();
				reestablishConnection();
				rs = null;
			}
			waitTime = DoExponentialBackOff(count++, numTryCounts, waitTime,
					sql);
			if (waitTime > 0) {
				continue;
			} else {
				break;
			}
			// count++;
			// waitTime *= 2;
			// // wait 2^(count) seconds
			// try {
			// Thread.sleep(waitTime);
			// } catch (InterruptedException e) {
			// continue;
			// }
		} while (count <= numTryCounts && rs == null);

		if (rs == null) {
			Main._logger
					.reportError("Failed to fetch a result from AZDBLAB due to network failure");
			try {
				throw new SQLException();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	public ResultSet executeQuerySQLOnce(String sql) throws Exception {
		return regStatement.executeQuery(sql);
	}

	protected int DoExponentialBackOff(int count, int numTryCounts,
			int waitTime, String msg) {
		if (!Main.bExecutor) {
			return 0;
		}
		if (count > numTryCounts) { // failed, so return null
			Main._logger.reportError("We've retried more than the limit.");
			return -1;
		}
		waitTime *= 2;
		// wait 2^(count) seconds
		try {
			Thread.sleep(waitTime);
			Main._logger.reportError("retry " + count + ": " + msg);
		} catch (InterruptedException e) {
		}
		return waitTime;
	}

	public ResultSet executeQuerySQL(String sql) {
		ResultSet rs = null;
		int numTryCounts = 10;
		int count = 1;
		int waitTime = 1000; // ms
		do {
			try {
				rs = regStatement.executeQuery(sql);
				return rs;
			} catch (SQLException sqlex) {
				// Main._logger.reportError("retry " + count + ": " + sql);
				sqlex.printStackTrace();
				reestablishConnection();
				rs = null;
			}
			waitTime = DoExponentialBackOff(count++, numTryCounts, waitTime,
					sql);
			if (waitTime > 0) {
				continue;
			} else {
				break;
			}
		} while (count <= numTryCounts && rs == null);

		if (rs == null) {
			Main._logger.reportError("Failed to fetch a result from AZDBLAB due to network failure");
			try {
				throw new SQLException();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		return null;
	}

	/**
	 * This helper method returns a string from the specified clob.
	 * 
	 * @param clob
	 * @return
	 * @throws Exception
	 */
	public String getStringFromClob(ResultSet rs, int colIdx) throws Exception {
		Clob clob = ((OracleResultSet) rs).getCLOB(colIdx);
	    BufferedReader reader = new BufferedReader(new InputStreamReader(clob.getAsciiStream()));
		StringBuilder sb = new StringBuilder();
		String line = null;
		while ((line = reader.readLine()) != null)
		  	sb.append(line + "\n");
		return sb.toString();
	}
	
	/**
	 * This helper method returns an input stream from the specified clob.
	 * 
	 * @param clob
	 * @return
	 * @throws Exception
	 */
	public InputStream getInputFromClob(Clob clob) throws Exception {
		return clob.getAsciiStream();
	}

	/***
	 * Insert query execution with clob data for psdiff (renamed prodiff) into labshelf
	 * @param tableName
	 * @param columnNames
	 * @param columnValues
	 * @param columnDataTypes
	 * @throws SQLException
	 */
	public abstract void insertQueryExecution(String tableName,
			String[] columnNames, String[] columnValues, int[] columnDataTypes)
			throws SQLException;


}
