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
package azdblab.model.experiment;

import java.io.IOException;
import java.io.File;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import azdblab.Constants;
import azdblab.labShelf.dataModel.Experiment;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.User;
//import azdblab.analysis.api.OptimizerAnalyzer;
//import azdblab.labNotebook.InternalDatabaseController;
import azdblab.model.dataDefinition.DataDefinition;
import azdblab.model.queryGenerator.DefaultGrammarSpecificGenerator;
import azdblab.model.queryGenerator.PredefinedQueryGenerator;
import azdblab.model.queryGenerator.QueryGenerator;
import azdblab.model.transactionGenerator.TransactionGenerator;
import azdblab.plugins.experimentSubject.ExperimentSubject;
import azdblab.plugins.scenario.*;
import azdblab.analysis.api.QueryModifier; //import azdblab.analysis.queryGenerator.DefaultQueryModifier;
//import azdblab.analysis.queryGenerator.PermutableGenerator;
//import azdblab.analysis.queryGenerator.QueryGenerator;
//import azdblab.analysis.api.QueryGenerator;
import azdblab.exception.analysis.InvalidExperimentRunException;
import azdblab.exception.analysis.NameResolutionException;
import azdblab.exception.analysis.QueryGeneratorValidationException; //import azdblab.exception.analysis.UnsupportedAnalyzerType;
import azdblab.exception.analysis.UnsupportedQueryGeneratorTypeException;

//import AZDBLab.dbms.api.LabShelf;

/**
 * Provides access methods to the information that is stored in the Test XML for
 * an experiment.
 * 
 */
public class ExperimentRun {
	/**
	 * Creates a test with the characteristics specified by the parameters.
	 * 
	 * @param exp_name
	 *            The name of the experiment that this test belongs to.
	 * @param test_num
	 *            The test number for this test.
	 * @param test
	 *            The DOM XML test element for this test
	 * @throws InvalidExperimentRunException
	 *             If there is a problem with the test.
	 */

	private File filedataDef;
	private Experiment myExperiment;

	private long iMinCard;
	private long iMaxCard;

	// private File filepreQuery;

	private LabShelfManager _controller;

	public long getVarTableMinCardinality() {
		return _granularity;
	}

	public long getVarTableMaxCardinality() {
		return iMaxCard;
	}

	public File getdataDefFile() {
		return this.filedataDef;
	}

	/*
	 * public File getpreQueryFiles() {
	 * 
	 * Element queryElement = (Element) myRoot.getElementsByTagName(
	 * "queryDefinitionReference").item(0);
	 * 
	 * if (queryElement == null) { return null; }
	 * 
	 * String strfname = queryElement.getAttribute("href");
	 * 
	 * this.filepreQuery = new File(AZDBLAB.XML_SOURCE_DIRECTORY + "/" +
	 * strfname); return this.filepreQuery; }
	 */

	public ExperimentRun(Experiment experiment, Element element)
			throws InvalidExperimentRunException {
		myUserName = experiment.getUserName();
		myNotebookName = experiment.getNotebookName();
		myExperimentName = experiment.getExperimentName();
		strScenarioName = experiment.getScenario();
		myExperiment = experiment;
		myRoot = element;
		_controller = LabShelfManager.getShelf();

		// Creating the DataDefinitionModule Object
		// Also validates, does name resolution
		NodeList dataDefinitionList = myRoot
				.getElementsByTagName("dataDefinition");
		if (dataDefinitionList.getLength() == 0) {
			dataDefinitionList = myRoot
					.getElementsByTagName("dataDefinitionReference");
			// String href = ((Element) dataDefinitionList.item(0))
			// .getAttribute("href");
			try {
				Element dataDef = experiment.getExperimentSpec("D");
				myDataDef = new DataDefinition(dataDef);
				// myDataDef = new DataDefinition(AZDBLAB.XML_SOURCE_DIRECTORY
				// + href);

			} catch (Exception e) {
				throw new InvalidExperimentRunException(e);
			}
		} else {
			Element dataDef = (Element) dataDefinitionList.item(0);
			try {
				myDataDef = new DataDefinition(dataDef);
			} catch (Exception e) {
				throw new InvalidExperimentRunException(e);
			}
		}

		/** ****************************** THE FILE DESCRIPTOR *************** */
		this.filedataDef = myDataDef.getXMLFile();
		/** ****************************** THE FILE DESCRIPTOR *************** */

		if(myExperimentName.contains("tps")){
			// extracting the fixed tables and their attributes.
			Element fixed_tables = (Element) myRoot.getElementsByTagName(
					"tableSet").item(0);
			NodeList tables = fixed_tables.getElementsByTagName("table");
			for (int i = 0; i < tables.getLength(); i++) {
				String table_name = ((Element) tables.item(i))
						.getAttribute("name");
				if (!myDataDef.tableIsValid(table_name)) {
					try {
						throw new NameResolutionException(
								"'"
										+ table_name
										+ "' is not a valid table name according to data definition.");
					} catch (NameResolutionException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
			return;
		}
		// extracting the variable tables and their attributes
		Element variable_tables = (Element) myRoot.getElementsByTagName(
				"variableTableSet").item(0);

		String searchGranularity;
		try {
			searchGranularity = variable_tables
					.getAttribute("searchGranularity");
		} catch (Exception e) {
			searchGranularity = "0";
		}
		_granularity = Long.parseLong(searchGranularity);

		strSearchMethod = variable_tables.getAttribute("searchMethod");

		NodeList tables = variable_tables.getElementsByTagName("table");
		try {
			for (int i = 0; i < tables.getLength(); i++) {
				Element curr_table = (Element) tables.item(i);
				Element card = (Element) curr_table.getElementsByTagName(
						"cardinality").item(0);
				String table_name = curr_table.getAttribute("name");
				String min = card.getAttribute("hypotheticalMinimum");
				String max = card.getAttribute("hypotheticalMaximum");

				iMinCard = 0;
				iMaxCard = 0;

				if (min.equals(Constants.ACTUAL_CARDINALITY)) {
					iMinCard = myDataDef.getTableCardinality(table_name);
				} else {
					iMinCard = Long.parseLong(min);
				}
				if (max.equals(Constants.ACTUAL_CARDINALITY)) {
					iMaxCard = myDataDef.getTableCardinality(table_name);
				} else {
					iMaxCard = Long.parseLong(max);
				}
				if (iMinCard > iMaxCard)
					throw new InvalidExperimentRunException(
							"hypotheticalMinimum cardinality cannot be greater than hypotheticalMaximum cardinality");
				if (!myDataDef.tableIsValid(table_name)) {
					throw new NameResolutionException(
							"'"
									+ table_name
									+ "' is not a valid table name according to data definition.");
				}

			}

			// extracting the fixed tables and their attributes.
			Element fixed_tables = (Element) myRoot.getElementsByTagName(
					"fixedTableSet").item(0);
			tables = fixed_tables.getElementsByTagName("table");
			for (int i = 0; i < tables.getLength(); i++) {
				String table_name = ((Element) tables.item(0))
						.getAttribute("name");
				if (!myDataDef.tableIsValid(table_name)) {
					throw new NameResolutionException(
							"'"
									+ table_name
									+ "' is not a valid table name according to data definition.");
				}

			}
		} catch (NameResolutionException e) {
			throw new InvalidExperimentRunException(e);
		}
		try {
			// get the number of queries the query generator will produce.
			int numberQueries = getQueryGeneratorNumberQueries();

			switch (getQueryGeneratorType()) {
			case Constants.GENERATOR_TYPE_PREDEFINED: {
				// predefined query generator
				if (generatorHasRef()) {
					// myQueryGenerator = new PredefinedQueryGenerator(
					// getQueryGeneratorHRef(), //myDataDef,
					// numberQueries,
					// _controller,
					// user_name, notebook_name,
					// myExperimentName, myTestNumber);

					Element queryGenElement = User
							.getUser(myUserName).getNotebook(myNotebookName)
							.getExperiment(myExperimentName).getExperimentSpec(
									"Q");

					myQueryGenerator = new PredefinedQueryGenerator(
							queryGenElement, // myDataDef,
							numberQueries, myUserName, myNotebookName,
							myExperimentName);

				} else {

					myQueryGenerator = new PredefinedQueryGenerator(
							getQueryGeneratorElement(), // myDataDef,
							numberQueries, myUserName, myNotebookName,
							myExperimentName);
				}

				break;
			}

			case Constants.GENERATOR_TYPE_GRAMMAR: {
				// RAHIGH make this dynamically load things for the grammar
				// query generator
				// String className = getQueryGeneratorClassName();
				String generatorSchema = getQueryGeneratorSchema();

				if (generatorHasRef()) {
					// myQueryGenerator = new DefaultGrammarSpecificGenerator(
					// getQueryGeneratorHRef(), myDataDef,
					// generatorSchema, numberQueries,
					// // _labshelf,
					// //_controller,
					// getVariableTables(), getFixedTables(),
					// myExperimentName, myTestNumber);

					Element queryGenElement = User
							.getUser(myUserName).getNotebook(myNotebookName)
							.getExperiment(myExperimentName).getExperimentSpec(
									"Q");

					myQueryGenerator = new DefaultGrammarSpecificGenerator(
							queryGenElement, myDataDef, generatorSchema,
							numberQueries,
							// _labshelf,
							_controller, getVariableTables(), getFixedTables(),
							myUserName, myNotebookName, myExperimentName);

				} else {
					myQueryGenerator = new DefaultGrammarSpecificGenerator(
							getQueryGeneratorElement(), myDataDef,
							generatorSchema, numberQueries,
							// _labshelf,
							_controller, getVariableTables(), getFixedTables(),
							myUserName, myNotebookName, myExperimentName);
				}

				break;
			}

				/*
				 * case AZDBLab.GENERATOR_TYPE_PERMUTABLE: { // permutable query
				 * generator if (generatorHasRef()) myQueryGenerator = new
				 * PermutableGenerator( getQueryGeneratorHRef(), myDataDef,
				 * numberQueries, _controller, user_name, notebook_name,
				 * myExperimentName, myTestNumber); else myQueryGenerator = new
				 * PermutableGenerator( getQueryGeneratorElement(), myDataDef,
				 * numberQueries, _controller, user_name, notebook_name,
				 * myExperimentName, myTestNumber); break; }
				 */
			default: {
				throw new UnsupportedQueryGeneratorTypeException(
						getQueryGeneratorType() + " TYPE NOT SUPPORTED");
			}
			}
		} catch (UnsupportedQueryGeneratorTypeException e) {
			throw new InvalidExperimentRunException(e);
		} catch (QueryGeneratorValidationException e) {
			throw new InvalidExperimentRunException(e);
		} catch (IOException e) {
			e.printStackTrace();
			throw new InvalidExperimentRunException(e);
		} catch (NameResolutionException e) {
			throw new InvalidExperimentRunException(e);
		}

		// TODO:
		// myQueryModifier = new DefaultQueryModifier();

	}

	/*
	 * public TestResults getTestResult() { try {
	 * _controller.getTestResult(myUserName, myNotebookName, myExperimentName,
	 * this.); } catch (SQLException sqlex) { sqlex.printStackTrace(); } }
	 */

	public void prepareExperimentRun(ExperimentSubject exp_subject,
			String dbms_name, String start_time) {
		experimentSubject = exp_subject;
		dbmsName = dbms_name;
		startTime = start_time;
	}

	/**
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	public boolean equals(Object o) {
		if (!(o instanceof ExperimentRun))
			return false;
		ExperimentRun other = (ExperimentRun) o;
		if (!other.getDataDefinition().equals(myDataDef))
			return false;
		if (!other.myQueryGenerator.equals(myQueryGenerator))
			return false;

		// this assumes that the xml parser presevers ordering of elements from
		// the file
		Table[] otherTables;
		try {
			otherTables = other.getFixedTables();
			Table[] thisTables = this.getFixedTables();
			if (otherTables.length != thisTables.length)
				return false;
			for (int i = 0; i < otherTables.length; i++) {
				if (!otherTables[i].equals(thisTables[i]))
					return false;
			}
			otherTables = other.getVariableTables();
			thisTables = this.getVariableTables();
			if (otherTables.length != thisTables.length)
				return false;
			for (int i = 0; i < otherTables.length; i++) {
				if (!otherTables[i].equals(thisTables[i]))
					return false;
			}
		} catch (NameResolutionException e) {
			e.printStackTrace();
			return false;
		}

		if (other.getQueryGeneratorNumberQueries() != this
				.getQueryGeneratorNumberQueries())
			return false;
		return true;
	}

	/**
	 * Indicates whether the generator uses a reference to the XML file or
	 * whether the XML is embedded inside of the test.
	 * 
	 * @return true - if the generator uses a queryDefinitionReference instead
	 *         of a queryDefinition tag.<BR>
	 *         false - otherwise.
	 */
	private boolean generatorHasRef() {
		return (myRoot.getElementsByTagName("queryDefinition").getLength() == 0);
	}

	/**
	 * Returns the optimizer analyzer for this test.
	 * 
	 * @return The OptimizerAnalyzer that can be used to analyze this test.
	 * @throws InvalidExperimentRunException
	 *             Never. See code for details. It will be thrown some day.
	 * 
	 *             public OptimizerAnalyzer getAnalyzer() throws
	 *             InvalidExperimentRunException { // RANORMAL determine what
	 *             kind of optimizer if (AZDBLAB.SINGLE_VARIABLE_TABLE_TYPE !=
	 *             AZDBLAB.SINGLE_VARIABLE_TABLE_TYPE) { try { throw new
	 *             UnsupportedAnalyzerType(
	 *             "AZDBLAB: only supports one variable table for experiments");
	 *             } catch (UnsupportedAnalyzerType e) { throw new
	 *             InvalidExperimentRunException(e); } }
	 * 
	 *             return new OneDimensionalExhaustiveAnalyzer(this, myDataDef);
	 *             }
	 */

	public Scenario getScenarioInstance() throws InvalidExperimentRunException {
		// RANORMAL determine what kind of optimizer
		/*
		 * if (MetaData.SINGLE_VARIABLE_TABLE_TYPE !=
		 * MetaData.SINGLE_VARIABLE_TABLE_TYPE) { try { throw new
		 * UnsupportedAnalyzerType(
		 * "AZDBLAB: only supports one variable table for experiments"); } catch
		 * (UnsupportedAnalyzerType e) { throw new
		 * InvalidExperimentRunException(e); } }
		 */
		ScenarioPluginManager scenPluginMan = new ScenarioPluginManager();
		return scenPluginMan.getScenarioInstance(strScenarioName, this);
	}

	/**
	 * Returns the data definition for this test.
	 * 
	 * @return The data defintion for this test.
	 */
	public DataDefinition getDataDefinition() {
		return myDataDef;
	}

	/**
	 * Returns the name of the experiment this test belongs to.
	 * 
	 * @return The name of the experiment this test belongs to
	 */
	public String getExperimentName() {
		return myExperimentName;
	}

	public String getUserName() {
		return myUserName;
	}

	public String getNotebookName() {
		return myNotebookName;
	}

	public Experiment getMyExperiment() {
		return myExperiment;
	}


	/**
	 * Returns a list of transaction tables for this test.
	 * 
	 * @return A list of transaction tables for this test.
	 * @throws NameResolutionException
	 */
	public Table[] getXactTables() throws NameResolutionException {
		if (myXactTables != null)
			return myXactTables;
		Element set_tables = (Element) myRoot.getElementsByTagName(
				"tableSet").item(0);
		NodeList tables = set_tables.getElementsByTagName("table");

		myXactTables = new Table[tables.getLength()];

		// Table(String name, String raw_name,long aCard, long minCard, long
		// maxCard, long avg_rlen, long nblock)
		for (int i = 0; i < tables.getLength(); i++) {
			String tname = null;
			long aCard = 0, minCard = 0, maxCard = 0;
			// long avg_rlen = 0;
			// long nblock = 0;
			Element curr_table = (Element) tables.item(i);
			Element card = (Element) curr_table.getElementsByTagName("cardinality").item(0);

			tname = curr_table.getAttribute("name");
			if (!myDataDef.tableIsValid(tname))
				throw new NameResolutionException("Table '" + tname
						+ "' is defined in Test but not in data definition.");

			long seed = Long.parseLong(curr_table.getAttribute("seed"));

			aCard = myDataDef.getTableCardinality(tname);
			String min = card.getAttribute("hypothetical");
			// detemines whether the cardinality was an integer or the actual
			// cardinality denoted by 'actual'
			if (min.equals(Constants.ACTUAL_CARDINALITY)) {
				minCard = myDataDef.getTableCardinality(tname);
			} else {
				minCard = Long.parseLong(min);
			}
			maxCard = minCard;

			// The columns are then taken from the data definition
			String[] col_names = myDataDef.getTableColumns(tname);
			Column[] columns = new Column[col_names.length];
			for (int j = 0; j < col_names.length; j++) {
				String cname = col_names[j];
				columns[j] = new Column(cname);
			}

			// myFixedTables[i] = new Table(tname, myDataDef.getDataDefName() +
			// "_"
			// + tname, aCard, minCard, maxCard, seed, columns);
			myXactTables[i] = new Table(tname, myDataDef.getDataDefName()
					+ "_", aCard, minCard, maxCard, seed, columns);
		}

		return myXactTables;
	}

	
	/**
	 * Returns a list of fixed tables for this test.
	 * 
	 * @return A list of fixed tables for this test.
	 * @throws NameResolutionException
	 */
	public Table[] getFixedTables() throws NameResolutionException {
		if (myFixedTables != null)
			return myFixedTables;
		Element set_tables = (Element) myRoot.getElementsByTagName(
				"fixedTableSet").item(0);
		NodeList tables = set_tables.getElementsByTagName("table");

		myFixedTables = new Table[tables.getLength()];

		// Table(String name, String raw_name,long aCard, long minCard, long
		// maxCard, long avg_rlen, long nblock)
		for (int i = 0; i < tables.getLength(); i++) {
			String tname = null;
			long aCard = 0, minCard = 0, maxCard = 0;
			// long avg_rlen = 0;
			// long nblock = 0;
			Element curr_table = (Element) tables.item(i);
			Element card = (Element) curr_table.getElementsByTagName(
					"cardinality").item(0);

			tname = curr_table.getAttribute("name");
			if (!myDataDef.tableIsValid(tname))
				throw new NameResolutionException("Table '" + tname
						+ "' is defined in Test but not in data definition.");

			long seed = Long.parseLong(curr_table.getAttribute("seed"));

			aCard = myDataDef.getTableCardinality(tname);
			String min = card.getAttribute("hypothetical");
			// detemines whether the cardinality was an integer or the actual
			// cardinality denoted by 'actual'
			if (min.equals(Constants.ACTUAL_CARDINALITY)) {
				minCard = myDataDef.getTableCardinality(tname);
			} else {
				minCard = Long.parseLong(min);
			}
			maxCard = minCard;

			// The columns are then taken from the data definition
			String[] col_names = myDataDef.getTableColumns(tname);
			Column[] columns = new Column[col_names.length];
			for (int j = 0; j < col_names.length; j++) {
				String cname = col_names[j];
				columns[j] = new Column(cname);
			}

			// myFixedTables[i] = new Table(tname, myDataDef.getDataDefName() +
			// "_"
			// + tname, aCard, minCard, maxCard, seed, columns);
			myFixedTables[i] = new Table(tname, myDataDef.getDataDefName()
					+ "_", aCard, minCard, maxCard, seed, columns);
		}

		return myFixedTables;
	}

	/**
	 * Returns the query generator for this test.
	 * 
	 * @return The query generator for this test.
	 */
	public QueryGenerator getMyQueryGenerator() {
		return myQueryGenerator;
	}

	/**
	 * Returns the query modifier for this test.
	 * 
	 * @return The query generator for this test.
	 */
	public QueryModifier getMyQueryModifier() {
		return myQueryModifier;
	}

	/**
	 * The query generator class name for this test.
	 * 
	 * @return The query generator class name for this test.
	 */
	/*
	 * private String getQueryGeneratorClassName() { NodeList tempList = myRoot
	 * .getElementsByTagName("queryDefinitionReference"); String result = null;
	 * if (tempList.getLength() > 0) { Element temp = (Element)
	 * tempList.item(0); result = temp.getAttribute("javaClass"); } else {
	 * tempList = myRoot.getElementsByTagName("queryDefinition"); Element temp =
	 * (Element) tempList.item(0); result = temp.getAttribute("javaClass"); }
	 * return result; }
	 */

	/**
	 * The DOM element that corresponds to this query generator.
	 * 
	 * @return The DOM element that contains the specification for the query
	 *         generator.
	 */
	private Element getQueryGeneratorElement() {
		switch (getQueryGeneratorType()) {
		case Constants.GENERATOR_TYPE_PREDEFINED: {
			return (Element) myRoot.getElementsByTagName("predefinedQueries")
					.item(0);
		}
		case Constants.GENERATOR_TYPE_GRAMMAR: {
			return (Element) myRoot.getElementsByTagName("grammar").item(0);
		}
		default: {
			return null;
		}
		}
	}

	/**
	 * Get the query generator file location
	 * 
	 * @return A reference to the query generator's file. This can be used to
	 *         open up the source code for the query generator.
	 */
	/*
	 * private String getQueryGeneratorHRef() { return ((Element)
	 * myRoot.getElementsByTagName(
	 * "queryDefinitionReference").item(0)).getAttribute("href"); }
	 */

	/**
	 * Returns the number of queries that the query generator should create.
	 * 
	 * @return The number of queries that the query generator will generate.
	 */
	private int getQueryGeneratorNumberQueries() {
		NodeList tempList = myRoot
				.getElementsByTagName("queryDefinitionReference");
		int result = 0;
		if (tempList.getLength() > 0) {
			Element temp = (Element) tempList.item(0);
			String number = temp.getAttribute("numberQueries");
			result = Integer.parseInt(number);
		} else {
			tempList = myRoot.getElementsByTagName("queryDefinition");
			Element temp = (Element) tempList.item(0);
			String number = temp.getAttribute("numberQueries");
			result = Integer.parseInt(number);
		}
		return result;
	}

	/**
	 * Returns the path to the query generator schema.
	 * 
	 * @return The path to the query generator schema.
	 */
	private String getQueryGeneratorSchema() {
		NodeList tempList = myRoot
				.getElementsByTagName("queryDefinitionReference");
		String result = null;
		if (tempList.getLength() > 0) {
			Element temp = (Element) tempList.item(0);
			result = temp.getAttribute("schemaFileName");
		} else {
			tempList = myRoot.getElementsByTagName("queryDefinition");
			Element temp = (Element) tempList.item(0);
			result = temp.getAttribute("schemaFileName");
		}
		return result;
	}

	/**
	 * Returns AZDBLabs integer representation of the query generator type.
	 * 
	 * @return AZDBLabs integer representation of the query generator type.
	 * @see Constants
	 */
	private int getQueryGeneratorType() {
		// TODO: added permutable type
		NodeList tempList = myRoot
				.getElementsByTagName("queryDefinitionReference");
		if (tempList.getLength() > 0) {
			Element temp = (Element) tempList.item(0);
			String type = temp.getAttribute("type");
			if (type.equals(Constants.S_GENERATOR_TYPE_PREDEFINED)) {
				return Constants.GENERATOR_TYPE_PREDEFINED;
			} else if (type.equals(Constants.S_GENERATOR_TYPE_GRAMMAR)) {
				return Constants.GENERATOR_TYPE_GRAMMAR;
			} else if (type.equals(Constants.S_GENERATOR_TYPE_TREE)) {
				return Constants.GENERATOR_TYPE_TREE;
			} else if (type.equals(Constants.S_GENERATOR_TYPE_PERMUTABLE)) {
				return Constants.GENERATOR_TYPE_PERMUTABLE;
			}
		} else if (myRoot.getElementsByTagName(
				Constants.S_GENERATOR_TYPE_PREDEFINED).getLength() > 0) {
			return Constants.GENERATOR_TYPE_PREDEFINED;
		} else if (myRoot.getElementsByTagName(
				Constants.S_GENERATOR_TYPE_GRAMMAR).getLength() > 0) {
			return Constants.GENERATOR_TYPE_GRAMMAR;
		} else if (myRoot.getElementsByTagName(Constants.S_GENERATOR_TYPE_TREE)
				.getLength() > 0) {
			return Constants.GENERATOR_TYPE_TREE;
		} else if (myRoot.getElementsByTagName(
				Constants.S_GENERATOR_TYPE_PERMUTABLE).getLength() > 0) {
			return Constants.GENERATOR_TYPE_PERMUTABLE;
		}
		return -1;
	}

	public ExperimentSubject getExperimentSubject() {
		return experimentSubject;
	}

	public String getDBMSName() {
		return dbmsName;
	}

	public String getStartTime() {
		return startTime;
	}

	/**
	 * Returns the root DOM element for the Test.
	 * 
	 * @return The root DOM element for the test.
	 */
	public Element getRoot() {
		return myRoot;
	}

	/**
	 * The granularity of the search. This specifies the increment for a linear
	 * search.
	 * 
	 * @return The granularity for the search.
	 */
	public long getSearchGranularity() {
		return _granularity;
	}

	public String getSearchMethod() {
		return strSearchMethod;
	}

	/**
	 * This test number for this test.
	 * 
	 * @return The test number for thist test.
	 */
	// public int getTestNumber() {
	// return myTestNumber;
	// }

	/**
	 * Returns a list of the variable tables. These are the tables that have a
	 * variable cardinality.
	 * 
	 * @return A list of the variable tables.
	 * @throws NameResolutionException
	 */
	public Table[] getVariableTables() throws NameResolutionException {
		if (myVariableTables != null)
			return myVariableTables;
		Element variable_tables = (Element) myRoot.getElementsByTagName(
				"variableTableSet").item(0);
		NodeList tables = variable_tables.getElementsByTagName("table");

		myVariableTables = new Table[tables.getLength()];

		for (int i = 0; i < tables.getLength(); i++) {
			String tname = null;
			long aCard = 0, minCard = 0, maxCard = 0;
			// long avg_rlen = 0, nblock = 0;

			Element curr_table = (Element) tables.item(i);
			Element card = (Element) curr_table.getElementsByTagName(
					"cardinality").item(0);

			tname = curr_table.getAttribute("name");
			if (!myDataDef.tableIsValid(tname))
				throw new NameResolutionException("Table '" + tname
						+ "' is defined in Test but not in data definition.");

			long seed = Long.parseLong(curr_table.getAttribute("seed"));

			// finding the max and min values for the search
			aCard = myDataDef.getTableCardinality(tname);
			String min = card.getAttribute("hypotheticalMinimum");
			if (min.equals(Constants.ACTUAL_CARDINALITY)) {
				minCard = myDataDef.getTableCardinality(tname);
			} else {
				minCard = Long.parseLong(min);
			}
			String max = card.getAttribute("hypotheticalMaximum");
			if (max.equals(Constants.ACTUAL_CARDINALITY)) {
				maxCard = myDataDef.getTableCardinality(tname);
			} else {
				maxCard = Long.parseLong(max);
			}

			String[] col_names = myDataDef.getTableColumns(tname);
			Column[] columns = new Column[col_names.length];
			for (int j = 0; j < col_names.length; j++) {
				String cname = col_names[j];
				columns[j] = new Column(cname);
			}

			// myVariableTables[i] = new Table(tname, myDataDef.getDataDefName()
			// + "_"
			// + tname, aCard, minCard, maxCard, seed, columns);
			myVariableTables[i] = new Table(tname, myDataDef.getDataDefName()
					+ "_", aCard, minCard, maxCard, seed, columns);
		}
		return myVariableTables;
	}

	/**
	 * The granularity or increment for the search.
	 */
	private long _granularity;

	private String strSearchMethod;

	/**
	 * The data definition that this test uses.
	 */
	private DataDefinition myDataDef;

	/**
	 * The experiment name that this test belongs to.
	 */
	private String myExperimentName;

	private String myUserName;

	private String myNotebookName;

	private String strScenarioName;

	/**
	 * The fixed tables for this experiment. These tables have their cardinality
	 * fixed.
	 */
	private Table[] myFixedTables = null;
	/**
	 * The tables for this experiment.
	 */
	protected Table[] myXactTables = null;
	/**
	 * The query generator for this test.
	 */
	private QueryGenerator myQueryGenerator;

	/**
	 * The query generator for this test.
	 */
	private QueryModifier myQueryModifier;

	/**
	 * The DOM Element for this test.
	 */
	private Element myRoot;

	/**
	 * The test number for this test.
	 */
	// private int myTestNumber;

	/**
	 * The variable tables for this test. These tables have variable
	 * cardinalites.
	 */
	private Table[] myVariableTables = null;

	/**
	 * A communication path to AZDBLab's internal tables. This can be used to
	 * read/write to these tables.
	 */

	private ExperimentSubject experimentSubject;

	private String dbmsName;

	private String startTime;

	/****
	 * Young added
	 * @return
	 */
	/**
	 * The query generator for this test.
	 */
	private TransactionGenerator myTransactionGenerator;
	public TransactionGenerator getMyTransactionGenerator() {
		// TODO Auto-generated method stub
		return myTransactionGenerator;
	}

}