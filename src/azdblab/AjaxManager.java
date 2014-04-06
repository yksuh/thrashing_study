/*
 * Copyright (c) 2012, Arizona Board of Regents
 * 
 * See LICENSE at /cs/projects/tau/azdblab/license
 * See README at /cs/projects/tau/azdblab/readme
 * AZDBLab, http://www.cs.arizona.edu/projects/focal/ergalics/azdblab.html
 * This is a Laboratory Information Management System
 * 
 * Authors:
 * Benjamin Dicken (benjamindicken.com, bddicken@gmail.com)
 * Matthew Johnson 
 * Rui Zhang (http://www.cs.arizona.edu/people/ruizhang/)
 * 
 */
package azdblab;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONValue;
import org.w3c.dom.Document;

import azdblab.executable.Main;
import azdblab.labShelf.dataModel.Executor;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;

public class AjaxManager {

	// private final String connectString =
	// "jdbc:oracle:thin:@sodb7.cs.arizona.edu:1521:notebook";
	private final String connectPassword = "azdblab_6_1";
	private final String connectUsername = "azdblab_6_1";

	// static String davesNotebooks = "nb_D008;nb_D005;nb_D012";
	// static String alexsNotebooks = "notebook1;notebook2;notebook3;notebook4";
	// static String jansNotebooks = "jans_book1A;jans_book2A";
	// static String ericsNotebooks = "Notebook 1;notbook22;ntbk99;NB_00004";

	public static String all = "all";

	public static void main(String[] args) {
		AjaxManager mgr = new AjaxManager();

		/*************** TEST method calls ****************/
		mgr.getExperimentTypesForUserJSON(all);
		mgr.getExperimentTypesForUserJSON("yksuh");
		mgr.getExperimentTypesForUserJSON("Sabah");
		mgr.getExperimentTypesForUserJSON("sdfsdf");
		//mgr.getExperimentTypesJSON();

		// System.out.println(Constants.getLabShelfName());
		// System.out.println("LS : " + mgr.getLSsForUserCredentials("Sabah",
		// "s"));
		// mgr.getSUForUserCredentials("yksuh", "yyy");
	}

	/**
	 * This is the constructor for the AjaxManager Class. This method's primary
	 * purpose is to initialize a connection to the AZDBLab database, because
	 * many of the methods in this class require such a connection.
	 * 
	 * @return
	 * @author Benjamin Dicken
	 */
	public AjaxManager() {
		System.setProperty(
				"java.shelf.path",
				System.getProperty("java.shelf.path")
						+ System.getProperty("path.seperator")
						+ "/cs/projects/tau/installations/azdblab/web/apache-tomcat-7.0.30/webapps/AZDBLAB/WEB-INF/lib");
		Main.setLABCONNECTSTRING(Constants.AZDBLAB_LABSHELF_SERVER);
		Main.setLABPASSWORD(this.connectPassword);
		Main.setLABUSERNAME(this.connectUsername);
		try {
			URL[] urls = {
					new URL(
							"file:///cs/projects/tau/installations/azdblab/web/apache-tomcat-7.0.30/webapps/AZDBLAB/WEB-INF/lib/plugins/"),
					new URL(
							"file:///cs/projects/tau/installations/azdblab/web/apache-tomcat-7.0.30/webapps/ROOT/"),
					new URL(
							"file:///cs/projects/tau/installations/azdblab/web/apache-tomcat-7.0.30/webapps/AZDBLAB/WEB-INF/lib/azdblab.jar"),
					new URL(
							"file:///cs/projects/tau/installations/azdblab/web/apache-tomcat-7.0.30/webapps/AZDBLAB/WEB-INF/lib/libs/") };
			LabShelfManager.getShelfForAjaxManager(this.connectUsername,
					this.connectPassword, Constants.AZDBLAB_LABSHELF_SERVER,
					urls);
		} catch (MalformedURLException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Creates a delimited String of values from a java LIST<String>http://stackoverflow.com/questions
	 *         /1205135/how-to-encrypt-string-in-java
	 * 
	 * @param strings
	 * @param delimiter
	 * @return
	 */
	private String implode(List<String> strings, String delimiter) {
		String result = "";
		for (String s : strings) {
			result += s + delimiter;
		}

		result = result.substring(0, result.length() - delimiter.length());
		return result;
	}

	/**
	 * This method converts an string that was imploded (using the implode()
	 * method in this class) to a JSON-encoded array.
	 * 
	 * @param explode
	 * @param delimiter
	 * @return
	 * @author Benjamin Dicken
	 */
	@SuppressWarnings("unchecked")
	private String convertImplodeToJSON(String explode, String delimiter) {
		String[] result = explode.split(";");
		JSONArray resultJSON = new JSONArray();
		for (int i = 0; i < result.length; i++) {
			resultJSON.add(result[i]);
		}

		return resultJSON.toJSONString();
	}

	/**
	 * If user login is correct, return available Lab shelves, and if not,
	 * return a string indicating that the login attempt failed.
	 * 
	 * @param username
	 * @param pass
	 * @return
	 */
	public String[] getLSSUForUserCredentials(String username, String pass) {
		String[] returnArr = new String[2];
		returnArr[1] = "failure";
		try {
			Document userD = LoginManager.getUserLoginXML(username, pass);
			Vector<String> shelves = LoginManager.getShelvesForUser(userD);
			String su = LoginManager.getSUSForUser(userD);

			if (shelves == null) {
				throw new NullPointerException();
			}
			returnArr[1] = JSONValue.toJSONString(shelves);
			returnArr[0] = su;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnArr;
	}

	/**
	 * If login is correct, return whether or not the user is a super-user
	 * 
	 * @param username
	 * @param pass
	 * @return
	 */
	public String getLoginForUserCredentials(String username, String pass) {
		Document userD = LoginManager.getUserLoginXML(username, pass);
		return JSONValue.toJSONString(LoginManager.getSUSForUser(userD));
	}

	/**
	 * Returns a list of all types of experiments, encoded as a JSON array.
	 * 
	 * @return a JSON encoded string on LS versions
	 * @author Benjamin Dicken
	 */
	public String getExperimentTypesForUserJSON(String uName) {
		List<Run> res = Run.getAllRuns();

		ArrayList<ArrayList<String>> listOfTypes = new ArrayList<ArrayList<String>>();
		String ensureUnique = "";

		// Get all unique types of experiments in this loop
		for (Run x : res) {
			//System.out.println("username: >>>" + x.getUserName() + "<<<");
			if (ensureUnique.lastIndexOf(x.getScenario()) == -1 &&
				(x.getUserName().equals(uName) || uName.equals(all))) {
				ArrayList<String> tempType = new ArrayList<String>();
				tempType.add(x.getScenario());
				listOfTypes.add(tempType);
				ensureUnique += x.getScenario() + "\n";
			}
		}

		System.out.println(JSONValue.toJSONString(listOfTypes));
		return JSONValue.toJSONString(listOfTypes);
	}

	/**
	 * Returns an array with description data for an experiment
	 * 
	 * @return a JSON encoded string on LS versions
	 * @author Benjamin Dicken
	 */
	public String getExperimentDescriptionJSON(String expID) {
		List<Run> res = Run.getAllRuns();

		Run target = null;

		// Get all unique types of experiments in this loop
		for (Run x : res) {
			if (("" + x.getRunID()).compareTo(expID) == 0) {
				target = x;
				break;
			}
		}

		// Get all details about the selected Experiment
		ArrayList<List<String>> result = new ArrayList<List<String>>();
		try {
			ArrayList<String> temp = new ArrayList<String>();
			temp.add("Type");
			temp.add("" + target.getiType());
			result.add(temp);

			temp = new ArrayList<String>();
			temp.add("Start Time");
			temp.add(target.getStartTime());
			result.add(temp);

			temp = new ArrayList<String>();
			temp.add("Run ID");
			temp.add("" + target.getRunID());
			result.add(temp);

			temp = new ArrayList<String>();
			temp.add("DBMS");
			temp.add(target.getDBMS());
			result.add(temp);
			
			temp = new ArrayList<String>();
			temp.add("Username");
			temp.add(target.getUserName());
			result.add(temp);

			temp = new ArrayList<String>();
			temp.add("Notebook Name");
			temp.add(target.getNotebookName());
			result.add(temp);

			temp = new ArrayList<String>();
			temp.add("Experiment Name");
			temp.add(target.getExperimentName());
			result.add(temp);

			temp = new ArrayList<String>();
			temp.add("Scenario");
			temp.add(target.getScenario());
			result.add(temp);

			temp = new ArrayList<String>();
			temp.add("Machine Name");
			temp.add(target.getMachineName());
			result.add(temp);

		} catch (Exception e) {
			System.out.println("error in finding Experiment");
		}

		System.out.println(JSONValue.toJSONString(result));
		return JSONValue.toJSONString(result);
	}

	/**
	 * Returns a list of all experiments for the passed parameters
	 * 
	 * @return a encoded string on LS versions
	 * @author Benjamin Dicken
	 */
	public String getExperimentList(String type, String user) {

		List<Run> res = Run.getAllRuns();

		ArrayList<ArrayList<String>> listOfTypes = new ArrayList<ArrayList<String>>();

		// Get all unique types of experiments in this loop
		for (Run x : res) {
			if (x.getScenario().equals(type) || type.equals(all)) {
				if (x.getUserName().equals(user) || user.equals(all)) {
					ArrayList<String> tempType = new ArrayList<String>();
					tempType.add(x.getExperimentName());
					tempType.add(x.getUserName());
					tempType.add("" + x.getRunID());
					tempType.add("" + x.getiType());
					listOfTypes.add(tempType);
				}
			}
		}
		System.out.println(JSONValue.toJSONString(listOfTypes) + "\n\n"
				+ listOfTypes.size());
		return JSONValue.toJSONString(listOfTypes);
	}

	/**
	 * Returns a list of all experiments for the paList<RunStatusNode> res =
	 * LabShelfManager.getShelf().getAllRuns();
	 * 
	 * @return a JSON encoded string on LS versions
	 * @author Benjamin Dicken
	 */
	public String getExperimentListJSON(String type, String user) {
		return getExperimentList(type, user);
	}

	/**
	 * Returns a list of all executors for the passed parameters
	 * 
	 * @return a encoded JSON string of Executors
	 * @author Benjamin Dicken
	 */
	public String getExecutorListJSON() {

		List<Executor> res = Executor.getAllExecutors();

		ArrayList<ArrayList<String>> listOfExecutors = new ArrayList<ArrayList<String>>();

		// Get all unique types of experiments in this loop
		for (Executor x : res) {
			ArrayList<String> tempEx = new ArrayList<String>();
			tempEx.add(x.getMachineName());
			tempEx.add(x.getDBMS());
			tempEx.add("" + x.getState().strCommand);
			tempEx.add("" + x.getState().strCurrentStatus);
			listOfExecutors.add(tempEx);

		}
		System.out.println(JSONValue.toJSONString(listOfExecutors) + "\n\n"
				+ listOfExecutors.size());
		return JSONValue.toJSONString(listOfExecutors);
	}

	/**
	 * Returns an array with description data for an executor
	 * 
	 * @return a JSON encoded string of executors
	 * @author Benjamin Dicken
	 */
	public String getExecutorDescriptionJSON(String machineName) {
		List<Executor> res = Executor.getAllExecutors();

		Executor target = null;

		// Get all unique types of executors in this loop
		for (Executor x : res) {
			if (("" + x.getMachineName()).compareTo(machineName) == 0) {
				target = x;
				break;
			}
		}

		// Get all details about the selected Executor
		ArrayList<List<String>> result = new ArrayList<List<String>>();
		try {
			ArrayList<String> temp = new ArrayList<String>();
			temp.add("Machine Name");
			temp.add(target.getMachineName());
			result.add(temp);

			temp = new ArrayList<String>();
			temp.add("DBMS");
			temp.add(target.getDBMS());
			result.add(temp);

			temp = new ArrayList<String>();
			temp.add("Current Status");
			temp.add(target.getState().strCurrentStatus);
			result.add(temp);

			temp = new ArrayList<String>();
			temp.add("Command");
			temp.add(target.getState().strCommand);
			result.add(temp);

		} catch (Exception e) {
			System.out.println("error in finding Executor");
			return "An error occured, please try again later.";
		}

		System.out.println(JSONValue.toJSONString(result));
		return JSONValue.toJSONString(result);
	}

	/**
	 * Returns a list of user names.
	 * 
	 * @return String - The list of users.
	 */
	public String getAllUsers() {
		try {
			Vector<User> vecusers = User.getAllUsers();
			List<String> strings = new ArrayList<String>();
			String result;
			if (vecusers.size() > 0) {
				for (User u : vecusers) {
					strings.add(u.getStrUserName());
				}
				result = implode(strings, ";");
			} else {
				result = "";
			}
			return result;
		} catch (Exception ex) {
			return "msg:\n\n " + ex.getMessage() + "   "
					+ ex.getLocalizedMessage() + "   "
					+ ex.getCause().toString();
		}
	}

	/**
	 * Returns a list of user names. Encoded in JSON.
	 * 
	 * @return String - The list of users.
	 * @author Benjamin Dicken
	 */
	public String getAllUsersJSON() {
		return convertImplodeToJSON(getAllUsers(), ";");
	}

	/**
	 * Returns all available lab shelves.
	 * 
	 * @return String, a list of lab shelves.
	 * @author Benjamin Dicken
	 * 
	 *         This method does not work after running ant build. Needs work.
	 */
	public String getAllLabShelves() {

		// For now, return only 6.0
		List<String> res = LabShelfManager.getShelf().getVersionNames();
		return implode(res, ";");

		// For some reason this code does not work once ant build is run...
		// why???
		/*
		 * String res = ""; Vector<String> resLabShelfList = new
		 * Vector<String>(); File pluginDir = new
		 * File(Constants.DIRECTORY_PLUGINS);
		 * 
		 * if (!pluginDir.exists()) { return null; } File[] dbmsConParams =
		 * (pluginDir).listFiles();
		 * 
		 * // testing //return (pluginDir.getPath() + pluginDir.getName() +
		 * pluginDir.isFile() + "  " + dbmsConParams.length + "  " +
		 * dbmsConParams[9].getPath());
		 * //System.out.println(dbmsConParams.toString());
		 * 
		 * try { for (int i = 0; i < dbmsConParams.length; i++) { if
		 * (dbmsConParams[i].getName().contains(".xml")) { Document doc =
		 * XMLHelper.readDocument(dbmsConParams[i]); Element root =
		 * doc.getDocumentElement(); if
		 * (root.getAttribute("TYPE").equals("labShelf")) {
		 * resLabShelfList.add(root.getAttribute("TITLE")); res +=
		 * root.getAttribute("TITLE")+";"; } } } //System.out.print(res); return
		 * res; } catch (Exception e) { e.printStackTrace(); }
		 * 
		 * return "";
		 */
	}

	/**
	 * Call getAllLabshelves(), converts the results to JSON, and then returns
	 * this string.
	 * 
	 * @return String
	 */
	public String getAllLabShelvesJSON() {
		System.out.println("json: "
				+ convertImplodeToJSON(getAllLabShelves(), ";"));
		return convertImplodeToJSON(getAllLabShelves(), ";");
	}

	/**
	 * Returns the list of notebooks for this user.
	 * 
	 * @param userName
	 *            - User you want described.
	 * @return String - list of notebooks.
	 */
	public String getUserNotebooks(String userName) {
		/*
		 * if (userName.compareTo("Dave") == 0) return davesNotebooks; if
		 * (userName.compareTo("Alex") == 0) return alexsNotebooks; if
		 * (userName.compareTo("Jan") == 0) return jansNotebooks; if
		 * (userName.compareTo("Eric") == 0) return ericsNotebooks;
		 * 
		 * return "Notebook A;Notebook B;Notebook C";
		 */

		return null;

	}

	/**
	 * Returns the HTML description tab for this user.
	 * 
	 * @param userName
	 *            - User you want described.
	 * @return String - HTML content.
	 */
	public String getUserDescription(String userName) {

		String result = "User " + userName + " created on ";

		String createDate = "1 Jan, 2000";
		if (userName.compareTo("Dave") == 0)
			createDate = "20 Aug, 2009 - 02:58:44";
		if (userName.compareTo("Alex") == 0)
			createDate = "5 Apr, 2009 - 14:43:16";
		if (userName.compareTo("Jan") == 0)
			createDate = "16 Mar, 2008 - 10:10:19";
		if (userName.compareTo("Eric") == 0)
			createDate = "31 Feb, 999 - 24:61:00";

		return result += createDate + ".";

	}

	/**
	 * Returns the HTML describing the aspect defined by this user.
	 * 
	 * @param userName
	 *            - User that you want analyzed.
	 * @return String - HTML content.
	 */
	public String getUserAspect(String userName) {

		return "Aspect Information for " + userName + ".";

	}

	/**
	 * Returns the HTML describing the analytic defined by this user.
	 * 
	 * @param userName
	 *            - User that you want analyzed.
	 * @return String - HTML content.
	 */
	public String getUserAnalytic(String userName) {

		return "Analytic Information for " + userName + ".";

	}

	/**
	 * Returns the HTML describing this notebook.
	 * 
	 * @param userName
	 *            - Owner of the notebook.
	 * @param notebookName
	 *            - Notebook's name.
	 * @return String - HTML content.
	 */
	public String getNotebookDescription(String userName, String notebookName) {

		return notebookName + " created by " + userName
				+ " on 13 Jun, 2008 at 15:43:17";
	}

	/**
	 * Returns the HTML describing the aspect defined in the notebook.
	 * 
	 * @param userName
	 *            - Owner of the notebook.
	 * @param notebookName
	 *            - Notebook's name.
	 * @return String - HTML content.
	 */
	public String getNotebookAspect(String userName, String notebookName) {
		return "Aspect Information for " + notebookName + ".";
	}

	/**
	 * Returns the HTML describing the analytic defined in the norebook.
	 * 
	 * @param userName
	 *            - Owner of the notebook.
	 * @param notebookName
	 *            - Notebook's name.
	 * @return String - HTML content.
	 */
	public String getNotebookAnalytic(String userName, String notebookName) {
		return "Analytic Information for " + notebookName + ".";
	}

	/**
	 * Returns a list of scenarios.
	 * 
	 * @param userName
	 *            - Username of the owner of the notebook.
	 * @param notebookName
	 *            - Name of the notebook.for a notebook
	 * @return String - List of scenarios.
	 */
	public String getNotebookScenarios(String userName, String notebookName) {
		return "Flutter Scenario;Upper Bound Scenario";
	}

	/**
	 * Returns a list of experiment id's and names.
	 * 
	 * @param notebookName
	 * @param scenarioName
	 * @return String - List of the experiments for given scenario.
	 */
	public String getScenarioExperiment(String notebookName, String scenarioName) {
		return null;
	}

	/**
	 * Returns the HTML for a scenario's description.
	 * 
	 * @param userName
	 *            - Owner of the Notebook
	 * @param notebookName
	 *            - Notebook the Scenario resides in
	 * @param expID
	 *            - Experiment that implements this Scenario.
	 * @return String - HTML content.
	 */
	public String getScenarioDescription(String userName, String notebookName,
			int expID) {
		return null;
	}

	/**
	 * Returns a pair of dataDefID and queryDefID.
	 * 
	 * @param expID
	 *            - Id number of the experiment you want info for.
	 * @return - String containing the dataDefID and queryDefID.
	 */
	public String getExperimentDefinition(int expID) {
		return null;
	}

	/**
	 * Returns HTML for describing an experiment.
	 * 
	 * @param expID
	 *            - Id number of the experiment you want described.
	 * @return String - HTML content.
	 */
	public String getExperimentDescription(int expID) {
		return null;
	}

	/**
	 * Returns HTML analyzing an experiment.
	 * 
	 * @param expID
	 *            - Id number of the experiment you want analyzed.
	 * @return String - the HTML for the content pane.
	 */
	public String getExperimentAspect(int expID) {
		return null;
	}

	/**
	 * Returns HTML analyzing an experiment.
	 * 
	 * @param expID
	 *            - Id number of the experiment you want analyzed.
	 * @return String - the HTML for the content pane.
	 */
	public String getExperimentAnalytic(int expID) {
		return null;
	}

	/**
	 * Returns HTML Defining an experiment's data.
	 * 
	 * @param expID
	 *            - Id number of the experiment you want in on.
	 * @param dataDefID
	 *            - Id number of the data definition.
	 * @return String - HTML content.
	 */
	public String getDataDefinition(int expID, int dataDefID) {
		return null;
	}

	/**
	 * Returns HTML defining a query.
	 * 
	 * @param expID
	 *            - The experiment using the query.
	 * @param queryDefID
	 *            - Id number of the query.
	 * @return String - HTML content.
	 */
	public String getQueryDefinition(int expID, int queryDefID) {
		return null;
	}

	/**
	 * Returns a list of completed runIDs and names (start date).
	 * 
	 * @param expID
	 *            - the ID of the experiment you want runs from.
	 * @return String - the list of runs.
	 */
	public String getCompletedRuns(int expID) {
		return null;
	}

	/**
	 * Returns HTML describing all completed runs.
	 * 
	 * @return String - HTML content.
	 */
	public String getCompletedRunsDescription(int expID) {
		return null;
	}

	/**
	 * Returns HTML describing a completed run.
	 * 
	 * @param runID
	 *            - Id number of the run.
	 * @return String - HTML content.
	 */
	public String getCompletedRunDescription(int runID) {
		return null;
	}

	/**
	 * Returns HTML describing the full result for a completed run.
	 * 
	 * @param runID
	 *            - Id number of the run.
	 * @return String - HTML content.
	 */
	public String getCompletedRunFullResult(int runID) {
		return null;
	}

	/**
	 * Returns HTML analyzing a completed run.
	 * 
	 * @param runID
	 *            - Id number of the run.
	 * @return String - HTML content.
	 */
	public String getCompletedRunAnalytic(int runID) {
		return null;
	}

	/**
	 * Returns HTML describing a completed run's aspect indication.
	 * 
	 * @param runID
	 *            - Id number of the run.
	 * @return String - HTML content.
	 */
	public String getCompletedRunAspect(int runID) {
		return null;
	}

	/**
	 * Returns a list of queryIDs.
	 * 
	 * @param runID
	 *            - The id of the run you want queries from.
	 * @return String - The list of queries.
	 */
	public String getRunQueries(int runID) {
		return null;
	}

	/**
	 * Returns HTML describing a query's plan graph.
	 * 
	 * @param queryID
	 *            - Id number of the query.
	 * @return String - HTML content.
	 */
	public String getQueryPlanGraph(int queryID) {
		return null;
	}

	/**
	 * Returns HTML describing a query's aspect information.
	 * 
	 * @param queryID
	 *            - Id number of the query.
	 * @return String - HTML content.
	 */
	public String getQueryAspect(int queryID) {
		return null;
	}

	/**
	 * Returns a list of aspectID's.
	 * 
	 * @return String - contains the list of aspectID's.
	 */
	public String getAllAspectDefinitions() {
		return null;
	}

	/**
	 * Returns HTML describing all of the aspect definitions.
	 * 
	 * @return String - HTML content.
	 */
	public String getAllAspectDefinitionsDescription() {
		return "Aspect Def 1;Aspect Def 2;Aspect Def 3";
	}

	/**
	 * Returns HTML describing an aspect.
	 * 
	 * @param aspectID
	 *            - Id number of the aspect.
	 * @return String - HTML content.
	 */
	public String getAspectDescription(int aspectID) {
		return null;
	}

	/**
	 * Returns a list of analyticID's.
	 * 
	 * @return String - contains the list of analyticID's.
	 */
	public String getAllAnalyticDefinitions() {
		return "Anayltic Def 10; Analytic Def 11; Analytic Def 12; Analytic Def 13";
	}

	/**
	 * Returns HTML describing all analytic definitions.
	 * 
	 * @return String - HTML content.
	 */
	public String getAllAnalyticDefinitionsDescription() {
		return null;
	}

	/**
	 * Returns HTML describing an analytic.
	 * 
	 * @param analyticID
	 *            - Id number of the analytic
	 * @return String - HTML content.
	 */
	public String getAnalyticDescription(int analyticID) {
		return null;
	}

	/**
	 * Returns a list of pending runID's.
	 * 
	 * @return String - the list of runID's.
	 */
	public String getAllPendingRuns() {
		return "pending_run_8;pending_run_9;pending_run_10;pending_run_11";
	}

	/**
	 * Returns HTML describing all pending runs.
	 * 
	 * @return String - HTML content.
	 */
	public String getAllPendingRunsDescription() {
		return null;
	}

	/**
	 * Returns HTML describing a pending run.
	 * 
	 * @param runID
	 *            - Id number of the pending run.
	 * @return String - HTML content.
	 */
	public String getPendingRunDescription(int runID) {
		return null;
	}

	/**
	 * Returns a list of running runID's and names(start date).
	 * 
	 * @return String - the list of runID's.
	 */
	public String getAllRunningRuns() {
		return "running_run_3;running_run_5;running_run_7";
	}

	/**
	 * Returns HTML describing all running runs.
	 * 
	 * @return String - HTML content.
	 */
	public String getAllRunningRunsDescription() {
		return null;
	}

	/**
	 * Returns HTML describing a running run.
	 * 
	 * @param runID
	 *            - Id number of the run.
	 * @return String - HTML content.
	 */
	public String getRunningRunDescription(int runID) {
		return null;
	}

	/**
	 * Returns a list of paused runID's.
	 * 
	 * @return String - the list of runID's.
	 */
	public String getAllPausedRuns() {
		return "paused run 1;paused run 2";
	}

	/**
	 * Returns HTML describing all paused runs.
	 * 
	 * @return String - HTML content.
	 */
	public String getAllPausedRunsDescription() {
		return null;
	}

	/**
	 * Returns HTML describing a paused run.
	 * 
	 * @param runID
	 *            - Id number of the run.
	 * @return String - HTML content.
	 */
	public String getPausedRunDescription(int runID) {
		return null;
	}

	/**
	 * Returns a list of aborted runID's and names(start date).
	 * 
	 * @return String - the list of runID's.
	 */
	public String getAllAbortedRuns() {
		return "run 14 [ABORTED];run 19 [ABORTED];run 42 [ABORTED]";
	}

	/**
	 * Returns HTML describing all aborted runs.
	 * 
	 * @return String - HTML content.
	 */
	public String getAllAbortedRunsDescription() {
		return null;
	}

	/**
	 * Returns HTML describing an aborted run.
	 * 
	 * @param runID
	 *            - Id number of the run.
	 * @return String - HTML content.
	 */
	public String getAbortedRunDescription(int runID) {
		return null;
	}

	/**
	 * Returns a list of names of kinds of loaded plugins.
	 * 
	 * @return String - the list of kinds of plugins.
	 */
	public String getAllLoadedPluginKinds() {
		return "Experimental Subject Plugins;Aspect Plugins;Analytic Plugins;Scenario Plugins";
	}

	/**
	 * Returns HTML describing the loaded plugins.
	 * 
	 * @return String - HTML content.
	 */
	public String getLoadedPluginsDescription() {
		return "All Loaded Plugins Description Data";
	}

	/**
	 * Returns a list of plugin names of a specific kind.
	 * 
	 * @param kind
	 *            - The kind of plugin you want.
	 * @return String - contains the list of plugin names.
	 */
	public String getAllKindPlugins(String pluginKind) {

		if (pluginKind.compareTo("Experimental Subject Plugins") == 0) {
			return "PostgreSQLSubject;SQLServerSubject;OracleSubject;MySQLSubject";
		}
		if (pluginKind.compareTo("Aspect Plugins") == 0) {
			return "SQLStyle";
		}
		if (pluginKind.compareTo("Analytic Plugins") == 0) {
			return "TESTStyle";
		}
		if (pluginKind.compareTo("Scenario Plugins") == 0) {
			return "subOptimal;upper;setStatistics;setActual";
		}

		return null;
	}

	/**
	 * Returns HTML describing the kind of plugin.
	 * 
	 * @param kind
	 *            - The kind of plugin you want
	 * @return String - HTML content.
	 */
	public String getKindPluginDescription(String pluginKind) {
		return "Description for Plugin " + pluginKind;
	}

	/**
	 * Returns HTML describing a specific plugin.
	 * 
	 * @param pluginName
	 *            - The name of the plugin.
	 * @return String - HTML content.
	 */
	public String getPluginDescription(String pluginName) {
		return "Description for " + pluginName;
	}

	/**
	 * Returns a list of executor names.
	 * 
	 * @return String - the list of names of executors.
	 */
	public String getAllExecutors() {
		return "jdbc:oracle@sodb1;jdbc:sqlserver;jdbc:mysql;jdbc:oracle@aloe";
	}

	/**
	 * Returns HTML describing all executors.
	 * 
	 * @return String - HTML content.
	 */
	public String getAllExecutorsDescription() {
		return null;
	}

	/**
	 * Returns the current status of an executor.
	 * 
	 * @param executorName
	 *            - Name of the executor.
	 * @return String - Either "Running" or "Terminated".
	 */
	public String getExecutorStatus(String executorName) {
		return null;
	}

	/**
	 * Returns HTML describing a specific executor.
	 * 
	 * @param executorName
	 *            - Name of the executor.
	 * @return String - HTML content.
	 */
	public String getExecutorDescription(String executorName) {
		return null;
	}

	/* ------------------- [ alt functionality ] ------------------- */

	/**
	 * Creates a new notebook for a specific user.
	 * 
	 * @param userName
	 *            - User that gets the new notebook.
	 * @param notebookName
	 *            - Name of the new notebook.
	 */
	public String createNewNotebook(String userName, String notebookName) {
		/*
		 * if (userName.compareTo("Dave") == 0) { davesNotebooks += notebookName
		 * + ";"; return davesNotebooks; } if (userName.compareTo("Alex") == 0)
		 * { alexsNotebooks += notebookName + ";"; return alexsNotebooks; } if
		 * (userName.compareTo("Jan") == 0) { jansNotebooks += notebookName +
		 * ";"; return jansNotebooks; } if (userName.compareTo("Eric") == 0) {
		 * ericsNotebooks += notebookName + ";"; return ericsNotebooks; } else
		 * return null;
		 */
		return null;

	}

	/**
	 * Deletes a user.
	 * 
	 * @param userName
	 *            - Name of the user.
	 */
	public void deleteUser(String userName) {

	}

	/**
	 * Loads an experiment.
	 * 
	 * @return String - The experiment name.
	 */
	public String loadExperiment() {
		return null;
	}

	/**
	 * Deletes a notebook.
	 * 
	 * @param notebookName
	 *            - Name of the notebook.
	 */
	public void deleteNotebook(String notebookName) {

	}

	/**
	 * Runs an experiment and returns it's start time.
	 * 
	 * @param expID
	 *            - Id number for the experiment.
	 * @return String - contains the starting time.
	 */
	public String runExperiment(int expID) {
		return null;
	}

	/**
	 * Deletes an experiment.
	 * 
	 * @param expID
	 *            - ID number of the experiment.
	 */
	public void deleteExperiment(int expID) {

	}

	/**
	 * Opens a run and returns the ID's for the data definition and the query
	 * definition.
	 * 
	 * @param runID
	 *            - Id number of the run.
	 * @return String - contains a dataDefID and a queryDefID.
	 */
	public String openRun(int runID) {
		return null;
	}

	/**
	 * gets query ids for given run.
	 * 
	 * @return String - The query ids.
	 */
	public String getQueryIDs(int runID) {
		return null;
	}

	/**
	 * Deletes a run.
	 * 
	 * @param runID
	 *            - Id number of the run.
	 */
	public void deleteRun(int runID) {

	}

	/**
	 * Deletes a pending run.
	 * 
	 * @param runID
	 *            - Id number of the run.
	 */
	public void deletePendingRun(int runID) {

	}

	/**
	 * Pauses a running run.
	 * 
	 * @param runID
	 *            - Id number of the run.
	 */
	public void pauseRunningRun(int runID) {

	}

	/**
	 * Aborts a running run.
	 * 
	 * @param runId
	 *            - Id number of the run.
	 */
	public void abortRunningRun(int runId) {

	}

	/**
	 * Resumes a previously paused run.
	 * 
	 * @param runID
	 *            - Id number of the run.
	 */
	public void resumePausedRun(int runID) {

	}

	/**
	 * Deletes a aborted run.
	 * 
	 * @param runID
	 *            - Id number of the run.
	 */
	public void deleteAbortedRun(int runID) {

	}

	/**
	 * Returns a list of all usable lab shelf versions. This method currently
	 * just returns dummy data. It still needs to be either fully implemented or
	 * removed altogether.
	 * 
	 * @return a JSON encoded string on LS versions
	 */
	public String getLabShelfVersions() {
		return "{\"0\":\"5.1\", \"1\":\"5.2\", \"2\":\"5.3\", \"3\":\"6.0\"}";
	}

	/**
	 * Terminates an executor if it is NOT running. If the executor is running
	 * this does nothing.
	 * 
	 * @param executorName
	 *            - Name of the executor
	 */
	public void terminateExecutor(String executorName) {

	}

}
