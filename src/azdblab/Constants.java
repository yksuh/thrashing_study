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
package azdblab;

import java.io.File;
import java.util.Collections;
import java.util.HashMap;
import java.util.Vector;

/**
 * AZDBLAB is a class that holds constant values needed by the AZDBLAB System.
 */
public class Constants {

	public static void setLABUSERNAME(String user_name) {
		LAB_USERNAME = user_name;
	}

	public static void setLABPASSWORD(String password) {
		LAB_PASSWORD = password;
	}

	public static void setLABCONNECTSTRING(String connect_string) {
		LAB_CONNECTSTRING = connect_string;
	}

	public static void setNOTEBOOKNAME(String notebook_name) {
		LAB_NOTEBOOKNAME = notebook_name;
	}
	
	public static void setLabShelfName(String sent){
		LAB_SHELFNAME = sent;
	}

	public static String getLABUSERNAME() {
		return LAB_USERNAME;
	}

	public static String getLABMACHINENAME() {
		return LAB_MACHINENAME;
	}
	
	public static String getLABPASSWORD() {
		return LAB_PASSWORD;
	}

	public static String getLABCONNECTSTRING() {
		return LAB_CONNECTSTRING;
	}

	public static String getNOTEBOOKNAME() {
		return LAB_NOTEBOOKNAME;
	}
	
	public static String getLabShelfName(){
		return LAB_SHELFNAME;
	}

	public static final String TIMESTAMPFORMAT = "DY, MON DD YYYY HH24:MI:SS:FF";
	public static final String NEWTIMESTAMPFORMAT = "MMM dd yyyy HH:mm:ss:SSS";
	public static final String TIMEFORMAT = "EEE, MMM dd yyyy HH:mm:ss:SSS";
	public static final String NEWTIMEFORMAT = "EEE, MMM dd yyyy HH:mm:ss";
	public static final String DATEFORMAT = "DY, MON DD YYYY HH24:MI:SS";
	public static final String DTFORMAT = "MON DD YYYY";
	public static final String NEWDATEFORMAT = "EEE, MMM dd yyyy";
	public static final String DESKEYPHRASE = "sigmod08";
	// public static final String LAB_SUPERMAN = "ruizhang";
	public static final String LAB_SUPERMAN = "yksuh";
	public static final String COMMAND_PAUSE = "Pause";
	public static final String COMMAND_TERMINATE = "Terminate";
	public static final String COMMAND_RESUME = "Resume";

	public static final String WINDOWS_DUMMY_FILE = "C:\\Temp\\data64";
	public static final String LINUX_DUMMY_FILE = "/scratch/data64";
	public static final String PROC_MONITOR_NAME = "proc_monitor";
	
	public static int EXP_TIME_OUT = 1200;
	public static int EXP_TIME_OUT_MS = 1200000;
//	public static int EXP_TIME_OUT = 900;
//	public static int EXP_TIME_OUT_MS = 900000;
//	public static int EXP_TIME_OUT = 60;
//	public static int EXP_TIME_OUT_MS = 60000;
	
	public static void SetExpTimeOut(int time_out) {
		EXP_TIME_OUT = time_out;
	}

	public static String CURRENT_VERSION = null;

	public static void setCurrentVersion(String current_version) {
		CURRENT_VERSION = current_version;
	}

	public static String getCurrentVersion() {
		return CURRENT_VERSION;
	}

	/***
	 * Log file directory
	 */
	public static String AZDBLAB_LOG_DIR_NAME = "log-files";
	/***
	 * observer executable name
	 */
	public static final String AZDBLAB_OBSERVER = "Observer";
	/***
	 * executor executable name
	 */
	public static final String AZDBLAB_EXECUTOR = "Executor";
	/**
	 * Time interval between each time checking the status of the backend
	 * tables.
	 */
	public static final int UPDATE_INTERVAL = 10000; // miliseconds

	/**
	 * The directory where Plugins are stored.
	 */
	public static final String DIRECTORY_PLUGINS = "plugins/";

	public static final String DIRECTORY_IMAGE = "component/images/";

	public static final String DIRECTORY_IMAGE_LFHNODES = DIRECTORY_IMAGE
			+ "lhsnodes/";

	public static final String DIRECTORY_EXPERIMENTCOMPONENT_ = "component/";
	public static final String DIRECTORY_SCRIPTS = "script-files/";
	public static final boolean DEMO_SCREENSHOT = false;
	
	/**
	 * The default directory where XML/HTML temporary files are store. When
	 * AZDBLAB creates a temp file, it places the temp file inside this
	 * directory.
	 */
	public static final String DIRECTORY_TEMP = System
			.getProperty("java.io.tmpdir");

	/**
	 * The default directory where XSLT style sheets are stored. AZDBLAB assumes
	 * that style sheets are located in this directory.
	 */
	public static final String XML_STYLE_DIRECTORY = "component/xml_style/";

	/**
	 * The name of the style sheet that is used to transform the XML experiment
	 * result.
	 */
	public static final String RESULT_TRANSFORM_STYLE = XML_STYLE_DIRECTORY
			+ "result.xsl";

	/**
	 * The name of the style sheet that is used to transform the XML experiment
	 * source.
	 */
	public static final String SOURCE_TRANSFORM_STYLE = XML_STYLE_DIRECTORY
			+ "source.xsl";
	public static String XACT_SOURCE_TRANSFORM_STYLE = XML_STYLE_DIRECTORY
			+ "xact_source.xsl";

	/**
	 * The default directory where XML Schemas are stored. Schemas should be
	 * placed here or AZDBLAB will not locate them.
	 */
	// public static final String XML_SCHEMA_DIRECTORY = "component/xml_schema";
	public static final String XML_SCHEMA_DIRECTORY = DIRECTORY_PLUGINS
			+ "xml_schema";

	/**
	 * The name of the schema for transaction experiment XML.
	 */
	public static final Vector<VersionTag> XACTEXPERIMENT_SCHEMA_VERS = new Vector<VersionTag>(); // _
	/**
	 * The name of the schema for experiment XML.
	 */
	public static final Vector<VersionTag> EXPERIMENT_SCHEMA_VERS = new Vector<VersionTag>(); // _
	// =
	// XML_SCHEMA_DIRECTORY + "experiment.xsd";
	/**
	 * The name of the schema for data defintion XML.
	 */
	public static final Vector<VersionTag> DATA_DEFINITION_SCHEMA_VERS = new Vector<VersionTag>(); // _
	// =
	// XML_SCHEMA_DIRECTORY + "dataDefinition.xsd";

	/**
	 * The name of the schema for test result XML.
	 */
	public static final Vector<VersionTag> TEST_RESULT_SCHEMA_VERS = new Vector<VersionTag>(); // _
	// =
	// XML_SCHEMA_DIRECTORY + "testResult.xsd";

	/**
	 * The name of the schema for query result XML.
	 */
	public static final Vector<VersionTag> QUERY_RESULT_SCHEMA_VERS = new Vector<VersionTag>(); // _
	// =
	// XML_SCHEMA_DIRECTORY + "queryResult.xsd";

	/**
	 * The name of the schema for grammar XML.
	 */
	public static final Vector<VersionTag> GRAMMAR_SCHEMA_VERS = new Vector<VersionTag>(); // _
	// =
	// XML_SCHEMA_DIRECTORY + "grammar.xsd";
	/**
	 * The name of the schema for predefined queries XML.
	 */
	public static final Vector<VersionTag> PREDEFINED_SCHEMA_VERS = new Vector<VersionTag>(); // =
	// XML_SCHEMA_DIRECTORY + "predefinedQueries.xsd";

	/**
	 * The name of the schema for tree XML.
	 */
	public static final Vector<VersionTag> TREE_SCHEMA_VERS = new Vector<VersionTag>(); // _
	// =
	// XML_SCHEMA_DIRECTORY + "tree.xsd";

	/**
	 * The name of the schema for permutable XML.
	 */
	public static final Vector<VersionTag> PERMUTABLE_SCHEMA_VERS = new Vector<VersionTag>();// =
	// XML_SCHEMA_DIRECTORY + "permutableQueries.xsd";

	public static final Vector<VersionTag> QUERYRESULTERR_TEMPLATE_VERS = new Vector<VersionTag>();
	private static final int NUMBER_OF_SCHEMA = 9;

	// XML_SCHEMA_DIRECTORY + "queryResultErrorTemplate.xml";

	public static void LoadSchemas() throws Exception {
		File schema_dir = new File(XML_SCHEMA_DIRECTORY);
		File[] schema_files = schema_dir.listFiles();
		for (int i = 0; i < schema_files.length; ++i) {
			String[] schema_name = schema_files[i].getName().split("\\.");
			if (schema_name.length < 2) {
				continue;
			} else if (!schema_name[1].toLowerCase().equals("xsd")
					&& !schema_name[1].toLowerCase().equals("xml")) {
				continue;
			}
			String[] schema_details = schema_name[0].split("_");
			if (schema_details.length != 7) {
				continue;
			}
			if (schema_details[0].equals("dataDefinition")) {
				DATA_DEFINITION_SCHEMA_VERS
						.add(new VersionTag(schema_name[0].replaceFirst(
								"dataDefinition_", ""), "dataDefinition_"));
			} else if (schema_details[0].equals("experiment")) {
				EXPERIMENT_SCHEMA_VERS.add(new VersionTag(schema_name[0]
						.replaceFirst("experiment_", ""), "experiment_"));
			} 
			/***
			 * Young's added this for his thesis.
			 */
			else if (schema_details[0].equals("transactionExperiment")) {
				XACTEXPERIMENT_SCHEMA_VERS.add(new VersionTag(schema_name[0]
						.replaceFirst("transactionExperiment_", ""), "transactionExperiment_"));
			} 
			else if (schema_details[0].equals("grammar")) {
				GRAMMAR_SCHEMA_VERS.add(new VersionTag(schema_name[0]
						.replaceFirst("grammar_", ""), "grammar_"));
			} else if (schema_details[0].equals("predefinedQueries")) {
				PREDEFINED_SCHEMA_VERS.add(new VersionTag(schema_name[0]
						.replaceFirst("predefinedQueries_", ""),
						"predefinedQueries_"));
			} else if (schema_details[0].equals("permutableQueries")) {
				PERMUTABLE_SCHEMA_VERS.add(new VersionTag(schema_name[0]
						.replaceFirst("permutableQueries_", ""),
						"permutableQueries_"));
			} else if (schema_details[0].equals("queryResult")) {
				QUERY_RESULT_SCHEMA_VERS.add(new VersionTag(schema_name[0]
						.replaceFirst("queryResult_", ""), "queryResult_"));
			} else if (schema_details[0].equals("queryResultErrorTemplate")) {
				QUERYRESULTERR_TEMPLATE_VERS.add(new VersionTag(schema_name[0]
						.replaceFirst("queryResultErrorTemplate_", ""),
						"queryResultErrorTemplate"));
			} else if (schema_details[0].equals("testResult")) {
				TEST_RESULT_SCHEMA_VERS.add(new VersionTag(schema_name[0]
						.replaceFirst("testResult_", ""), "testResult_"));
			} else if (schema_details[0].equals("tree")) {
				TREE_SCHEMA_VERS.add(new VersionTag(schema_name[0]
						.replaceFirst("tree_", ""), "tree_"));
			}
		}
	}

	public static String CHOSEN_XACTEXPERIMENT_SCHEMA = null;
	public static String CHOSEN_EXPERIMENT_SCHEMA = null; // "component/xml_schema/experiment_02_20_2010_20_20_19.xsd";//null;
	public static String CHOSEN_DATA_DEFINITION_SCHEMA = null;
	public static String CHOSEN_TEST_RESULT_SCHEMA = null;
	public static String CHOSEN_QUERY_RESULT_SCHEMA = null;
	public static String CHOSEN_GRAMMAR_SCHEMA = null;
	public static String CHOSEN_PREDEFINED_SCHEMA = null;
	public static String CHOSEN_TREE_SCHEMA = null;
	public static String CHOSEN_PERMUTABLE_SCHEMA = null;
	public static String CHOSEN_QUERYRESULTERR_TEMPLATE = null;

	public static boolean ChooseProperSchema(String current_version) {
		VersionTag current_ver_tag = new VersionTag(current_version, "");
		int chosen_schema = 0;
		Collections.sort(XACTEXPERIMENT_SCHEMA_VERS, new VersionTagComparor());
		for (int i = 0; i < XACTEXPERIMENT_SCHEMA_VERS.size(); ++i) {
			VersionTag temp_schema = XACTEXPERIMENT_SCHEMA_VERS.get(i);
			if (VersionTag.CompareVersions(temp_schema, current_ver_tag) <= 0) {
				CHOSEN_XACTEXPERIMENT_SCHEMA = XML_SCHEMA_DIRECTORY
						+ "/transactionExperiment_" + temp_schema.toString() + ".xsd";
				++chosen_schema;
				break;
			}
		}
		Collections.sort(EXPERIMENT_SCHEMA_VERS, new VersionTagComparor());
		for (int i = 0; i < EXPERIMENT_SCHEMA_VERS.size(); ++i) {
			VersionTag temp_schema = EXPERIMENT_SCHEMA_VERS.get(i);
			if (VersionTag.CompareVersions(temp_schema, current_ver_tag) <= 0) {
				CHOSEN_EXPERIMENT_SCHEMA = XML_SCHEMA_DIRECTORY
						+ "/experiment_" + temp_schema.toString() + ".xsd";
				++chosen_schema;
				break;
			}
		}
		Collections.sort(DATA_DEFINITION_SCHEMA_VERS, new VersionTagComparor());
		for (int i = 0; i < DATA_DEFINITION_SCHEMA_VERS.size(); ++i) {
			VersionTag temp_schema = DATA_DEFINITION_SCHEMA_VERS.get(i);
			if (VersionTag.CompareVersions(temp_schema, current_ver_tag) <= 0) {
				CHOSEN_DATA_DEFINITION_SCHEMA = XML_SCHEMA_DIRECTORY
						+ "/dataDefinition_" + temp_schema.toString() + ".xsd";
				++chosen_schema;
				break;
			}
		}
		Collections.sort(TEST_RESULT_SCHEMA_VERS, new VersionTagComparor());
		for (int i = 0; i < TEST_RESULT_SCHEMA_VERS.size(); ++i) {
			VersionTag temp_schema = TEST_RESULT_SCHEMA_VERS.get(i);
			if (VersionTag.CompareVersions(temp_schema, current_ver_tag) <= 0) {
				CHOSEN_TEST_RESULT_SCHEMA = XML_SCHEMA_DIRECTORY
						+ "/testResult_" + temp_schema.toString() + ".xsd";
				++chosen_schema;
				break;
			}
		}
		Collections.sort(QUERY_RESULT_SCHEMA_VERS, new VersionTagComparor());
		for (int i = 0; i < QUERY_RESULT_SCHEMA_VERS.size(); ++i) {
			VersionTag temp_schema = QUERY_RESULT_SCHEMA_VERS.get(i);
			if (VersionTag.CompareVersions(temp_schema, current_ver_tag) <= 0) {
				CHOSEN_QUERY_RESULT_SCHEMA = XML_SCHEMA_DIRECTORY
						+ "/queryResult_" + temp_schema.toString() + ".xsd";
				++chosen_schema;
				break;
			}
		}
		Collections.sort(GRAMMAR_SCHEMA_VERS, new VersionTagComparor());
		for (int i = 0; i < GRAMMAR_SCHEMA_VERS.size(); ++i) {
			VersionTag temp_schema = GRAMMAR_SCHEMA_VERS.get(i);
			if (VersionTag.CompareVersions(temp_schema, current_ver_tag) <= 0) {
				CHOSEN_GRAMMAR_SCHEMA = XML_SCHEMA_DIRECTORY + "/grammar_"
						+ temp_schema.toString() + ".xsd";
				++chosen_schema;
				break;
			}
		}
		Collections.sort(PREDEFINED_SCHEMA_VERS, new VersionTagComparor());
		for (int i = 0; i < PREDEFINED_SCHEMA_VERS.size(); ++i) {
			VersionTag temp_schema = PREDEFINED_SCHEMA_VERS.get(i);
			if (VersionTag.CompareVersions(temp_schema, current_ver_tag) <= 0) {
				CHOSEN_PREDEFINED_SCHEMA = XML_SCHEMA_DIRECTORY
						+ "/predefinedQueries_" + temp_schema.toString()
						+ ".xsd";
				++chosen_schema;
				break;
			}
		}
		Collections.sort(TREE_SCHEMA_VERS, new VersionTagComparor());
		for (int i = 0; i < TREE_SCHEMA_VERS.size(); ++i) {
			VersionTag temp_schema = TREE_SCHEMA_VERS.get(i);
			if (VersionTag.CompareVersions(temp_schema, current_ver_tag) <= 0) {
				CHOSEN_TREE_SCHEMA = XML_SCHEMA_DIRECTORY + "/tree_"
						+ temp_schema.toString() + ".xsd";
				++chosen_schema;
				break;
			}
		}
		// for (int i = 0; i < PERMUTABLE_SCHEMAS.size(); ++i) {
		// String current_schema = PERMUTABLE_SCHEMAS.get(i);
		// if (current_schema.endsWith(current_version + ".xsd")) {
		// CHOSEN_PERMUTABLE_SCHEMA = current_schema;
		// ++chosen_schema;
		// break;
		// }
		// }
		Collections
				.sort(QUERYRESULTERR_TEMPLATE_VERS, new VersionTagComparor());
		for (int i = 0; i < QUERYRESULTERR_TEMPLATE_VERS.size(); ++i) {
			VersionTag temp_schema = QUERYRESULTERR_TEMPLATE_VERS.get(i);
			if (VersionTag.CompareVersions(temp_schema, current_ver_tag) <= 0) {
				CHOSEN_QUERYRESULTERR_TEMPLATE = XML_SCHEMA_DIRECTORY
						+ "/queryResultErrorTemplate_" + temp_schema.toString()
						+ ".xml";
				++chosen_schema;
				break;
			}
		}
		if (chosen_schema == NUMBER_OF_SCHEMA) {
			return true;
		}
		return false;
	}

	/**
	 * The XML name space for JAXP.
	 */
	public static final String JAXP_SCHEMA_LANGUAGE = "http://java.sun.com/xml/jaxp/properties/schemaLanguage";

	/**
	 * The XML schema source location for JAXP.
	 */
	public static final String JAXP_SCHEMA_SOURCE = "http://java.sun.com/xml/jaxp/properties/schemaSource";

	/**
	 * The schema definition.
	 */
	public static final String W3C_XML_SCHEMA = "http://www.w3.org/2001/XMLSchema";

	/**
	 * A constant that defines the query generator type as predefined queries.
	 */
	public static final int GENERATOR_TYPE_PREDEFINED = 1;
	/**
	 * A constant that defines the query generator type as grammar.
	 */

	public static final int GENERATOR_TYPE_GRAMMAR = 2;
	/**
	 * A constant that defines the query generator type as tree.
	 */
	public static final int GENERATOR_TYPE_TREE = 3;

	/**
	 * A constant that defines the query generator type as permutable.
	 */
	public static final int GENERATOR_TYPE_PERMUTABLE = 4;

	/**
	 * A string representation for the predefined queries type query generator.
	 */
	public static final String S_GENERATOR_TYPE_PREDEFINED = "predefinedQueries";

	/**
	 * A string representation for the grammar type query generator.
	 */
	public static final String S_GENERATOR_TYPE_GRAMMAR = "grammar";

	/**
	 * A string representation for the tree type query generator.
	 */
	public static final String S_GENERATOR_TYPE_TREE = "tree";

	/**
	 * A string representation for the permutable type query generator.
	 */
	public static final String S_GENERATOR_TYPE_PERMUTABLE = "permutableQueries";

	/**
	 * A constant indicating that the analyzer expects only 1 variable table.
	 */
	public static final int SINGLE_VARIABLE_TABLE_TYPE = 1;

	/**
	 * The prefix given to all internal tables. Thus table X would really be
	 * stored as AZDBLAB_X in the DBMS
	 */
	public static final String TABLE_PREFIX = "AZDBLAB_";

	public static final String TABLE_CARDINALITY = "CARDINALITY";

	public static final String TABLE_EXPERIMENTSPEC = "EXPERIMENTSPEC";

	/**
	 * The name of the user internal table.
	 */
	public static final String TABLE_USER = "USER";

	/**
	 * The name of the labshelf internal table.
	 */
	public static final String TABLE_NOTEBOOK = "NOTEBOOK";

	/**
	 * The name of the experiment internal table
	 */
	public static final String TABLE_EXPERIMENT = "EXPERIMENT";

	public static final String TABLE_EXPERIMENTRUN = "EXPERIMENTRUN";

	public static final String TABLE_PREDEFINED_QUERY = "PREDEFINEDQUERY";

	public static final String TABLE_INSTANTIATED_QUERY = "INSTANTIATED_QUERY";

	public static final String TABLE_INSTANTIATED_QUERYDATE = "INSTANTIATED_QUERYDATE";

	public static final String TABLE_PAPER = "PAPER";

	public static final String TABLE_FIGURE = "FIGURE";

	public static final String TABLE_TABLE = "TABLE";

	public static final String TABLE_ANALYSIS = "ANALYSIS";

	public static final String TABLE_ANALYSIS_QUERY = "ANALYSISQUERY";

	public static final String TABLE_ANALYSIS_SCRIPT = "ANALYSISSCRIPT";

	public static final String TABLE_ANALYSIS_RUN = "ANALYSISRUN";

	public static final String TABLE_ANALYSIS_RESULT = "ANALYSISRESULT";

	public static final String TABLE_RUNLOG = "RUNLOG";

	public static final String TABLE_REFERSEXPERIMENTSPEC = "REFERSEXPERIMENTSPEC";

	/**
	 * The name of the query result internal table.
	 */
	public static final String TABLE_QUERY = "QUERY";

	public static final String TABLE_QUERYRESULT = "QUERYRESULT";

	public static final String TABLE_QUERYHASPARAMETER = "QUERYHASPARAMETER";

	/**
	 * The name of the plan node internal table.
	 */
	public static final String TABLE_PLAN_NODE = "PLANNODE";

	public static final String TABLE_PLAN = "PLAN";

	// public static final String TABLE_QRHASPLAN = "QRHASPLAN";
	public static final String TABLE_QUERYEXECUTIONHASPLAN = "QUERYEXECUTIONHASPLAN";

	public static final String TABLE_PLANOPERATOR = "PLANOPERATOR";

	/**
	 * The name of the change point internal table.
	 */
	public static final String TABLE_QUERYEXECUTION = "QUERYEXECUTION";

	public static final String TABLE_QUERYEXECUTIONSTAT = "QUERYEXECUTIONSTAT";

	public static final String TABLE_QUERYEXECUTIONHASSTAT = "QUERYEXECUTIONHASSTAT";

	public static final String TABLE_QUERYSTATEVALUATION = "QUERYSTATEVALUATION";

	/**
	 * The name of the completed task table
	 */
	public static final String TABLE_COMPLETED_TASK = "COMPLETEDTASK";

	/**
	 * The name of the change point table internal table.
	 */
	public static final String TABLE_EXECUTOR = "EXECUTOR";

	public static final String TABLE_EXECUTORLOG = "EXECUTORLOG";

	public static final String TABLE_VERSION = "VERSION";

	/**
	 * The name of the Aspect internal table.
	 */
	public static final String TABLE_DEFINEDASPECT = "DEFINEDASPECT";

	/**
	 * The name of the Aspect Values internal table.
	 */
	public static final String TABLE_SATISFIESASPECT = "SATISFIESASPECT";

	/**
	 * The name of the Analytics internal table.
	 */
	public static final String TABLE_DEFINEDANALYTIC = "DEFINEDANALYTIC";

	/**
	 * The name of the Aspect Values internal table.
	 */
	public static final String TABLE_ANALYTICVALUEOF = "ANALYTICVALUEOF";

	/**
	 * The name of the running run internal table.
	 */
	public static final String TABLE_RUNNINGRUN = "RUNNINGRUN";

	/**
	 * The name of the pending run internal table.
	 */
	public static final String TABLE_PENDINGRUN = "PENDINGRUN";

	/**
	 * The name of the run progress internal table.
	 */
	public static final String TABLE_RUNPROGRESS = "RUNPROGRESS";

	/**
	 * The name of the batch internal table.
	 */
//	public static final String TABLE_BATCH = "BATCH";

	/**
	 * The name of the batch result internal table.
	 */
	public static final String TABLE_BATCHRESULT = "BATCHRESULT";

	/**
	 * The name of the transaction internal table.
	 */
//	public static final String TABLE_TRANSACTION = "TRANSACTION";

	/**
	 * The name of the statement internal table.
	 */
//	public static final String TABLE_STATEMENT = "STATEMENT";

	/**
	 * The name of the batchhasparameter internal table.
	 */
//	public static final String TABLE_BATCHHASPARAMETER = "BATCHHASPARAMETER";

	/**
	 * The name of the batchsatisfiesaspect internal table.
	 */
//	public static final String TABLE_BATCHSATISFIESASPECT = "BATCHSATISFIESASPECT";
	/**
	 * The name of the ScenarioVersion table
	 */
	public static final String TABLE_SCENARIOVERSION = "SCENARIOVERSION";
	public static final String TABLE_RUNHASASPECT = "RUNHASASPECT";
	public static final String TABLE_SANITYCHECKASPECT = "SANITYCHECKASPECT";
	public static final String TABLE_COMMENT = "COMMENT";
	public static final String TABLE_QUERYEXECUTIONPROCS = "QUERYEXECUTIONPROCS";
	public static final String TABLE_PKQUERYPARAM = "PKQUERYPARAM";
	public static final String TABLE_STUDYRUN = "STUDYRUN";
	public static final String TABLE_STUDY = "STUDY";
	
	public static final String SEQUENCE_ANALYSIS = "SEQ_ANALYSISID";
	public static final String SEQUENCE_PAPER = "SEQ_PAPERID";
	public static final String SEQUENCE_PREDEFINED_QUERY = "SEQ_PREDEFINEDQUERYID";
	public static final String SEQUENCE_ANALYSISRUN = "SEQ_ANALYSISRUNID";
	public static final String SEQUENCE_INSTIATED_QUERY = "SEQ_INSTANTIATEDQUERYID";
	public static final String SEQUENCE_SENSITIVITY_ANALYSIS = "SEQ_SENSITIVITY_ANALYSIS";
	public static final String SEQUENCE_EXPERIMENT = "SEQ_EXPERIMENTID";
	public static final String SEQUENCE_EXPERIMENTSPEC = "SEQ_EXPERIMENTSPECID";
	public static final String SEQUENCE_STUDY = "SEQ_STUDYID";
	
	/**
	 * Tables for thrashing study
	 */
	public static final String TABLE_BATCHSET = "BATCHSET";
	public static final String TABLE_BATCHSETHASPARAMETER = "BATCHSETHASPARAMETER";
	public static final String TABLE_BSSATISFIESASPECT = "BSSATISFIESASPECT";	// batchsetsatisifiesaspect
	public static final String TABLE_BATCH = "BATCH";
	public static final String TABLE_BATCHHASRESULT = "BATCHHASRESULT";
	public static final String TABLE_CLIENT = "CLIENT";
	public static final String TABLE_CLIENTHASRESULT = "CLIENTHASRESULT";
	public static final String TABLE_TRANSACTION = "TRANSACTION";
	public static final String TABLE_TRANSACTIONHASRESULT = "TRANSACTIONHASRESULT";
	public static final String TABLE_STATEMENT = "STATEMENT";
	public static final String TABLE_STATEMENTHASRESULT = "STATEMENTHASRESULT";
	public static final String TABLE_COMPLETEDFGTASK = "COMPLETEDFGTASK"; // fine-grained task
	
	/***
	 * Sequence for thrashing study 
	 */
	public static final String SEQUENCE_BATCHSET = "SEQ_BATCHSET";
	public static final String SEQUENCE_BATCH = "SEQ_BATCH";
	public static final String SEQUENCE_CLIENT = "SEQ_CLIENT";
	public static final String SEQUENCE_TRANSACTION = "SEQ_TRANSACTION";
	public static final String SEQUENCE_STATEMENT = "SEQ_STATEMENT";
	public static final String SEQUENCE_CLIENTHASRESULT = "CLIENTRESULT";
	public static final String SEQUENCE_TRANSACTIONHASRESULT = "SEQ_XACTRESULT";	
	
	/**
	 * The data generation type for a column that indicates randomly generated
	 * values.
	 */
	public static final int I_GEN_TYPE_RANDOM = 0;

	/**
	 * The data generation type for a column that indicates sequentially
	 * generated values.
	 */
	public static final int I_GEN_TYPE_SEQUENTIAL = 1;
	/**
	 * The string representation of the timestamp data type. 
	 */
	public static final String S_DATA_TYPE_TIMESTAMP = "timestamp";
	/**
	 * The string representation of the character data type. This value would
	 * appear in the XML.
	 */
	public static final String S_DATA_TYPE_CHAR = "char";
	/**
	 * The string representation of the character data type. This value would
	 * appear in the XML.
	 */
	public static final String S_DATA_TYPE_VARCHAR2 = "varchar2";
	/**
	 * The string represenation of the numberic data type. This value would
	 * appear in the XML.
	 */
	public static final String S_DATA_TYPE_NUMBER = "number";

	/**
	 * The string representation of the random data generation type. This value
	 * would appear in the XML.
	 */
	public static final String S_GEN_TYPE_RANDOM = "random";
	/**
	 * The string representation of the sequential data generation type. This
	 * value would appear in the XML.
	 */
	public static final String S_GEN_TYPE_SEQUENTIAL = "sequential";

	/**
	 * The empty string value
	 */
	public static final String EMPTY_STRING = "";

	/**
	 * This indicates that the actual value should be used. In the context of
	 * cardinality it would mean that the actual cardinality of the table should
	 * be used as the numeric value of this attribute.
	 */
	public static final String ACTUAL_CARDINALITY = "actual";

	/**
	 * The change point number that is assigned to the optimal plan. Since it is
	 * not really a change point, we give this a value of -1.
	 */
	public static final int OPTIMAL_CHANGE_POINT_NUMBER = -1;

	/**
	 * The Current Version of AZDBLAB
	 */
	public static final String AZDBLAB_VERSION = "7.1";
	private static String LAB_USERNAME;
	private static String LAB_PASSWORD;
	private static String LAB_CONNECTSTRING;
	private static String LAB_MACHINENAME = "sodb7.cs.arizona.edu";
	private static String LAB_NOTEBOOKNAME;
	private static String LAB_SHELFNAME;
	// public static String PLUGIN_VERSION_NAME = "1.0";

	/*
	 * This section deals with versioning scenarios
	 */

	public static final String NAME_ADJACENT_SCENARIO = "ADJACENT";
	public static final String VERSION_ADJACENT_SCENARIO = AZDBLAB_VERSION;

	public static final String NAME_BOUNCING_SCENARIO = "BOUNCING";
	public static final String VERSION_BOUNCING_SCENARIO = AZDBLAB_VERSION;

	public static final String NAME_CLONE_ONEM_SCENARIO = "CLONE_ONEM";
	public static final String VERSION_CLONE_ONEM_SCENARIO = AZDBLAB_VERSION;

	public static final String NAME_DOUBLE_TRIPLE_SCENARIO = "DOUBLE_TRIPPLE";
	public static final String VERSION_DOUBLE_TRIPLE_SCENARIO = AZDBLAB_VERSION;

	public static final String NAME_EXHAUSTIVE_SCENARIO = "EXHAUSTIVE";
	public static final String VERSION_EXHAUSTIVE_SCENARIO = AZDBLAB_VERSION;

	public static final String NAME_FIXED_SCENARIO = "FIXED";
	public static final String VERSION_FIXED_SCENARIO = AZDBLAB_VERSION;

	public static final String NAME_ONE_PASS_SCENARIO = "ONE_PASS";
	public static final String VERSION_ONE_PASS_SCENARIO = AZDBLAB_VERSION;

	// public static final String NAME_NEW_ONE_PASS_SCENARIO = "NEW_ONE_PASS";
	// public static final String VERSION_NEW_ONE_PASS_SCENARIO = "6.0";

	public static final String NAME_SET_ACTUAL_SCENARIO = "SETACTUAL";
	public static final String VERSION_SET_ACTUAL_SCENARIO = AZDBLAB_VERSION;

	public static final String NAME_SET_STATISTICS_SCENARIO = "SETSTATISTICS";
	public static final String VERSION_SET_STATISTICS_SCENARIO = AZDBLAB_VERSION;

	public static final String NAME_SUB_OPTIMAL_SCENARIO = "SUBOPTIMAL";
	public static final String VERSION_SUB_OPTIMAL_SCENARIO = AZDBLAB_VERSION;

	public static final String NAME_UNIQUE_PLAN_SCENARIO = "UNIQUE_PLAN";
	public static final String VERSION_UNIQUE_PLAN_SCENARIO = AZDBLAB_VERSION;

	public static final String NAME_UPPER_BOUNCING_SCENARIO = "UPPER_BOUNCING";
	public static final String VERSION_UPPER_BOUNCING_SCENARIO = AZDBLAB_VERSION;

	public static final String NAME_UPPER_SCENARIO = "UPPER";
	public static final String VERSION_UPPER_SCENARIO = AZDBLAB_VERSION;
	
	public static final String NAME_HELLO_WORLD_QUERY_SCENARIO = "HELLO_WORLD_QUERY";
	public static final String VERSION_HELLO_WORLD_QUERY_SCENARIO = AZDBLAB_VERSION;

	public static final String NAME_HELLO_WORLD_CARD_SCENARIO = "HELLO_WORLD_CARD";
	public static final String VERSION_HELLO_WORLD_CARD_SCENARIO = AZDBLAB_VERSION;

	/***
	 * Young've added these for his thesis.
	 */
	public static final String NAME_TPS_SCENARIO = "TPS";
	public static final String VERSION_TPS_SCENARIO = AZDBLAB_VERSION;
	public static String NAME_XACT_THRASHING_SCENARIO = "XACTTHRASHING";
	public static String VERSION_XACT_THRASHING_SCENARIO = AZDBLAB_VERSION;

	
	//public static final String[] DBMSs = { "DB2", "MySQL", "MySQL2", "Oracle", "Pgsql", "Pgsql2", "SqlServer", "Teradata" };
//	public static final String[] DBMSs = { "DB2", "MySQL", "Oracle", "Pgsql", "Pgsql2", "SqlServer" };
	public static String[] DBMSs;
//	public static String[] hDBMSes = {"A", "B", "C", "D", "E", "F", "G"};
	public static String[] hDBMSes = {"V", "W", "T", "S", "E", "F", "G", "H"};
	
	public static void setDBMS(Vector<String> sent){
		DBMSs = new String[sent.size()];
		for(int i = 0; i < sent.size(); i++){
			DBMSs[i] = sent.get(i);
			if((DBMSs[i]).toLowerCase().contains("db2")){
				hiddenDBMSes.put((DBMSs[i]).toLowerCase(), "X");
			}else if(DBMSs[i].toLowerCase().contains("pgsql")){
				hiddenDBMSes.put((DBMSs[i]).toLowerCase(), "Y");
			}else if(DBMSs[i].toLowerCase().contains("mysql")){
				hiddenDBMSes.put((DBMSs[i]).toLowerCase(), "Z");
			}else
				hiddenDBMSes.put((DBMSs[i]).toLowerCase(), hDBMSes[i]);
		}
	}
	
	public static HashMap<String, String> hiddenDBMSes = new HashMap<String, String>();
	public static int MAX_ITERS = 3;
	public static long THINK_TIME = 60000;
	public static double BASE_SELECTIVITY = 0.01;
	public static int NumIDs    = 5;
	public static int NumValues = 2;
	
	public static final String TABLE_TPSRESULT_NAME = "AZDBLAB_XACTRUNSTAT";
	public static final long MAX_EXECUTIONTIME = 9999999;
	public static final String FIGURE_DIR = "work_docs/";
	public static final int TRY_COUNTS = 10;
	public static final int WAIT_TIME = 1000;
	public static final int SCENARIO_BASED_ON_QUERY = 0;
	public static final int SCENARIO_BASED_ON_CARDINALITY = 1;
	
	public static final String AZDBLAB_LABSHELF_SERVER = "jdbc:oracle:thin:@sodb7.cs.arizona.edu:1521:notebook";
	
	public static final String[][] SCENARIOVERSIONS = new String[][] {
			new String[] { NAME_ADJACENT_SCENARIO, VERSION_ADJACENT_SCENARIO },
			new String[] { NAME_BOUNCING_SCENARIO, VERSION_BOUNCING_SCENARIO },
			new String[] { NAME_CLONE_ONEM_SCENARIO,
					VERSION_CLONE_ONEM_SCENARIO },
			new String[] { NAME_DOUBLE_TRIPLE_SCENARIO,
					VERSION_DOUBLE_TRIPLE_SCENARIO },
			new String[] { NAME_EXHAUSTIVE_SCENARIO,
					VERSION_EXHAUSTIVE_SCENARIO },
			new String[] { NAME_FIXED_SCENARIO, VERSION_FIXED_SCENARIO },
			new String[] { NAME_ONE_PASS_SCENARIO, VERSION_ONE_PASS_SCENARIO },
			new String[] { NAME_SET_ACTUAL_SCENARIO,
					VERSION_SET_ACTUAL_SCENARIO },
			new String[] { NAME_SET_STATISTICS_SCENARIO,
					VERSION_SET_STATISTICS_SCENARIO },
			new String[] { NAME_SUB_OPTIMAL_SCENARIO,
					VERSION_SUB_OPTIMAL_SCENARIO },
			new String[] { NAME_UNIQUE_PLAN_SCENARIO,
					VERSION_UNIQUE_PLAN_SCENARIO },
			new String[] { NAME_UPPER_BOUNCING_SCENARIO,
					VERSION_UPPER_BOUNCING_SCENARIO },
			new String[] { NAME_XACT_THRASHING_SCENARIO,
					VERSION_XACT_THRASHING_SCENARIO },
			new String[] { NAME_UPPER_SCENARIO, VERSION_UPPER_SCENARIO } };
	
}
