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
* Benjamin Dicken (benjamindicken.com, bddicken@gmail.com)
*/
package azdblab.labShelf.dataModel;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Vector;

import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.TableDefinition;

public class User extends TableDefinition{

	private String user_name_;
	private String create_date_;

	public User(String username, String createDate) {
		user_name_ = username;
		create_date_ = createDate;
	}

	public void deleteNotebook(String notebookName) {
		String[] columnNames = new String[] { "UserName", "NotebookName" };
		String[] columnValues = new String[] { user_name_, notebookName };
		int[] columnDataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR };

		LabShelfManager.getShelf().deleteRows(NOTEBOOK.TableName, columnNames,
				columnValues, columnDataTypes);
		LabShelfManager.getShelf().deleteRows(DEFINEDASPECT.TableName,
				columnNames, columnValues, columnDataTypes);
		LabShelfManager.getShelf().deleteRows(DEFINEDANALYTIC.TableName,
				columnNames, columnValues, columnDataTypes);
		LabShelfManager.getShelf().commitlabshelf();
	}

	/**
	 * 
	 * @param userName
	 * @param aspectName
	 * @return
	 */
	public int getAspectID(String aspectName) {

		try {

			String sqlID = "SELECT AspectID " + "FROM "
					+ DEFINEDASPECT.TableName + " " + "WHERE UserName = '"
					+ user_name_ + "' AND AspectName = '" + aspectName + "'";

			ResultSet rsID = LabShelfManager.getShelf().executeQuerySQL(sqlID);

			if (rsID != null && rsID.next()) {
				int id = rsID.getInt(1);
				rsID.close();
				return id;
			}
			return -1;

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return -1;
		}

	}

	public String getUserName() {
		return user_name_;
	}

	/**
	 * 
	 * @param userName
	 * @return
	 */
	public List<Notebook> getNotebooks() {

		Vector<Notebook> result = new Vector<Notebook>();
		String columnNotebookName = "NotebookName";
		String columnCreateDate = "CreateDate";

		String[] columnNames = new String[] { "UserName" };
		String[] columnValues = new String[] { user_name_ };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR };

		try {
			// Queries the DBMS for the test results of an experiment.
			ResultSet rs = LabShelfManager.getShelf().executeSimpleQuery(
					NOTEBOOK.TableName,
					new String[] { columnNotebookName, columnCreateDate },
					columnNames, columnValues, dataTypes);

			while (rs.next()) {
				String strnotebookname = rs.getString(1);
				String strdescription = "default description set in azdblab.labShelf.dataModel.User";
				String createdate = new SimpleDateFormat(Constants.NEWDATEFORMAT).format(rs.getDate(2));
				Notebook n = new Notebook(user_name_, strnotebookname,
						createdate, strdescription);
				result.add(n);
			}

			rs.close();

			return result;

		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}		


	public Notebook getNotebook(String notebookName) {
		for (Notebook n : getNotebooks()) {
			if (n.getNotebookName().equals(notebookName)) {
				return n;
			}
		}
		return null;
	}

	public List<PredefinedQuery> getPredefinedQuerys() {
		Vector<PredefinedQuery> result = new Vector<PredefinedQuery>();
		try {
			String sql = "Select QueryID, Query, Description, QueryName from "
					+ Constants.TABLE_PREFIX + Constants.TABLE_PREDEFINED_QUERY
					+ " where username = '" + user_name_ + "'";
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				PredefinedQuery n = new PredefinedQuery(user_name_, rs
						.getString(4), rs.getString(2), rs.getString(3), rs
						.getInt(1));
				result.add(n);
			}
			rs.close();
			return result;

		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}

	public PredefinedQuery getPredefinedQuery(String queryName) {
		for (PredefinedQuery p : getPredefinedQuerys()) {
			if (p.getQueryName().equals(queryName)) {
				return p;
			}
		}
		return null;
	}

	public List<InstantiatedQuery> getInstantiatedQuerys() {
		Vector<InstantiatedQuery> result = new Vector<InstantiatedQuery>();
		try {
			String sql = "Select inst.queryID, inst.InstantiatedQueryID, inst.UserName, inst.NotebookName, inst.ExperimentName, pd.QueryName from "
					+ Constants.TABLE_PREFIX
					+ Constants.TABLE_INSTANTIATED_QUERY
					+ " inst, "
					+ Constants.TABLE_PREFIX
					+ Constants.TABLE_PREDEFINED_QUERY
					+ " pd  where pd.username = '"
					+ user_name_
					+ "' and inst.queryID = pd.queryID";
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				InstantiatedQuery n = new InstantiatedQuery(rs.getInt(1), rs
						.getInt(2), rs.getString(3), rs.getString(4), rs
						.getString(5), rs.getString(6));
				result.add(n);
			}
			rs.close();
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

	}

	/**
	 * 
	 * @param userName
	 * @param analyticName
	 * @return
	 */
	public int getAnalyticID(String analyticName) {

		try {

			String sqlID = "SELECT AnalyticID " + "FROM "
					+ DEFINEDANALYTIC.TableName + " " + "WHERE UserName = '"
					+ user_name_ + "' AND AnalyticName = '" + analyticName
					+ "'";

			ResultSet rsID = LabShelfManager.getShelf().executeQuerySQL(sqlID);

			if (rsID != null && rsID.next()) {
				int id = rsID.getInt(1);
				rsID.close();
				return id;
			}
			return -1;

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return -1;
		}

	}

	public List<String> getAspectNamesByUser() {

		Vector<String> result = new Vector<String>();

		String sqlQuery = "SELECT AspectName " + "FROM "
				+ DEFINEDASPECT.TableName + " " + "WHERE UserName = '"
				+ user_name_ + "'";

		try {

			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sqlQuery);

			while (rs.next()) {
				result.add(rs.getString(1));
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
	 * @param userName
	 * @param notebookName
	 * @param create_date
	 * @param description
	 */
	public void insertNotebook(String notebookName, String create_date,
			String description) {

		try {

			String[] columnNames = new String[] { "UserName", "NotebookName",
					"CreateDate" };
			String[] columnValues = new String[] { user_name_, notebookName,
					create_date };
			int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_DATE };

			// inserts a change point into the the internal tables.
			LabShelfManager.getShelf().insertTupleToNotebook(
					NOTEBOOK.TableName, columnNames, columnValues, dataTypes);
			LabShelfManager.getShelf().commitlabshelf();
		} catch (SQLException e) {
			Main._logger.reportError("Failed to insert labshelf");
			e.printStackTrace();
			System.exit(1); // programmer/dbsm error
		}
	}

	/**
	 * @return the strUserName
	 */
	public String getStrUserName() {
		return user_name_;
	}

	/**
	 * @return the strDateCreate
	 */
	public String getStrDateCreate() {
		return create_date_;
	}

	/**
	 * 
	 * @param userName
	 * @param queryID
	 * @param aspectName
	 * @param aspectValue
	 */
	public void insertSatisfiedAspect(int queryID, String aspectName,
			long aspectValue) {

		int aspectID = getUser(this.user_name_).getAspectID(aspectName);

		if (aspectID == -1) {
			Main._logger.reportError("insert Satisfied Aspect Err.");
			return;
		}

		if (satisfiedAspectExists(queryID, aspectID)) {

			Main._logger.outputLog("Satisfied Aspect already exists.");
			return;

		}

		String[] columnNames = new String[] { "QueryID", "AspectID",
				"AspectValue" };

		String[] columnValues = new String[] { String.valueOf(queryID),
				String.valueOf(aspectID), String.valueOf(aspectValue) };

		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_NUMBER };

		try {
			// inserts a change point into the the internal tables.
			LabShelfManager.getShelf().insertTupleToNotebook(SATISFIESASPECT.TableName, columnNames,
					columnValues, dataTypes);
			LabShelfManager.getShelf().commitlabshelf();

		} catch (SQLException e) {
			Main._logger.reportError("Failed to insert satisifed aspect");
			e.printStackTrace();
			System.exit(1); // programmer/dbsm error
		}

	}

	/**
	 * 
	 * @param queryID
	 * @param aspectID
	 * @return
	 */
	public boolean satisfiedAspectExists(int queryID, int aspectID) {

		String[] selectColumns = new String[] { "QueryID", "AspectID" };

		String[] columnNames = new String[] { "QueryID", "AspectID" };

		String[] columnValues = new String[] { String.valueOf(queryID),
				String.valueOf(aspectID) };

		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_NUMBER };

		try {
			// inserts a change point into the the internal tables.
			ResultSet rs = LabShelfManager.getShelf().executeSimpleQuery(SATISFIESASPECT.TableName,
					selectColumns, columnNames, columnValues, dataTypes);

			if (rs == null || !rs.next()) {
				return false;
			}
			return true;
		} catch (SQLException sqlex) {
			return false;
		}
	}

	public void deleteAspect(String aspectName) {

		String[] columnNames = null;
		String[] columnValues = null;
		int[] columnDataTypes = null;

		columnNames = new String[] { "UserName", "AspectName" };
		columnValues = new String[] { user_name_, aspectName };
		columnDataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR };
		// This delete cascades
		LabShelfManager.getShelf().deleteRows(DEFINEDASPECT.TableName,
				columnNames, columnValues, columnDataTypes);
		// myLabShelf.deleteRows(ASPECTVALUE.TableName, columnNames,
		// columnValues, columnDataTypes);
		LabShelfManager.getShelf().commitlabshelf();
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param analyticName
	 */
	public void deleteAnalytic(String analyticName) {

		String[] columnNames = null;
		String[] columnValues = null;
		int[] columnDataTypes = null;

		columnNames = new String[] { "UserName", "AnalyticName" };
		columnValues = new String[] { user_name_, analyticName };
		columnDataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR };

		// This delete cascades
		LabShelfManager.getShelf().deleteRows(DEFINEDANALYTIC.TableName,
				columnNames, columnValues, columnDataTypes);
		LabShelfManager.getShelf().commitlabshelf();

	}
	
	/**
	 * @return a vector containing the usernames of each user in the LabShelf
	 */
	public static Vector<String> getAllUserNames() {
		
		Vector<String> userNames = new Vector<String>();
		
		Vector<User> users = User.getAllUsers();
		for(User u : users) {
			userNames.add(u.getUserName());
		}
		
		return userNames;
	}
	
	/**
	 * @return a vector containing the usernames of each user in the LabShelf
	 */
	public static Vector<String> getAllUserNames(LabShelfManager shelf) {
		
		Vector<String> userNames = new Vector<String>();
		
		Vector<User> users = User.getAllUsers(shelf);
		for(User u : users) {
			userNames.add(u.getUserName());
		}
		
		return userNames;
	}

	/**
	 * 
	 * @return a vector containing all the users
	 */
	public static Vector<User> getAllUsers() {

		Vector<User> result = new Vector<User>();
		String columnUserName = "UserName";
		String columnCreateDate = "CreateDate";

		try {
			// Queries the DBMS for the test results of an experiment.
			ResultSet rs = LabShelfManager.getShelf().executeSimpleQuery(
					Constants.TABLE_PREFIX + Constants.TABLE_USER,
					new String[] { columnUserName, columnCreateDate }, null,
					null, null);

			while (rs.next()) {
				String userName = rs.getString(1);
				String createDate = new SimpleDateFormat(Constants.NEWDATEFORMAT).format(rs.getDate(2));
				System.out.println(userName + " : " + createDate);
				result.add(new User(userName, createDate));
			}

			rs.close();

			return result;

		} catch (Exception ex) {
			System.out.println(ex.getMessage() + "\n\n");
			//System.out.println(ex.getCause().toString() + "\n\n");
			ex.printStackTrace();
			//System.out.println("what");
			return null;
		}
	}
	
	
	/**
	 * 
	 * @return a vector containing all the users
	 */
	public static Vector<User> getAllUsers(LabShelfManager shelf) {

		Vector<User> result = new Vector<User>();
		String columnUserName = "UserName";
		String columnCreateDate = "CreateDate";

		try {
			// Queries the DBMS for the test results of an experiment.
			ResultSet rs = shelf.executeSimpleQuery(
					Constants.TABLE_PREFIX + Constants.TABLE_USER,
					new String[] { columnUserName, columnCreateDate }, null,
					null, null);

			while (rs.next()) {
				String userName = rs.getString(1);
				String createDate = new SimpleDateFormat(Constants.NEWDATEFORMAT).format(rs.getDate(2));
				System.out.println(userName + " : " + createDate);
				result.add(new User(userName, createDate));
			}

			rs.close();

			return result;

		} catch (Exception ex) {
			System.out.println(ex.getMessage() + "\n\n");
			//System.out.println(ex.getCause().toString() + "\n\n");
			ex.printStackTrace();
			//System.out.println("what");
			return null;
		}
	}

	public static User getUser(String username) {
		for (User u : getAllUsers()) {
			if (u.getStrUserName().equals(username)) {
				return u;
			}
		}
		return null;
	}
	
	public static User getUser(String username, LabShelfManager shelf) {
		for (User u : getAllUsers(shelf)) {
			if (u.getStrUserName().equals(username)) {
				return u;
			}
		}
		return null;
	}

}
