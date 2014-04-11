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
package azdblab.model.queryGenerator;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import azdblab.Constants;
import azdblab.exception.analysis.QueryGeneratorValidationException;
import azdblab.executable.Main;
import azdblab.labShelf.dataModel.Query;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;
import azdblab.model.experiment.XMLHelper;

//import azdblab.analysis.api.QueryGenerator;

/**
 * The predefined query generator simply extracts queries from the XML. No
 * queries are generated.
 */
public class PredefinedQueryGenerator extends QueryGenerator {
	/**
	 * Creates a predefined query generator.
	 * 
	 * @param root
	 *            The DOM root element for the query generator.
	 * @param dataDef
	 *            The data definition that this query generator will use.
	 * @param number_queries
	 *            The number of queries to be generated.
	 * @param controller
	 *            A handle to allow the query generator to communicate with
	 *            AZDBLab's internal tables.
	 * @param exp_name
	 *            The name of the experiment.
	 * @param test_num
	 *            The test number this experiment is associated.
	 * @throws QueryGeneratorValidationException
	 *             Thrown if the query generator XML has a validation error.
	 * @throws IOException
	 *             thrown if there is a problem writing a file.
	 */
	public PredefinedQueryGenerator(Element root,
			int number_queries,
			String user_name,
			String notebook_name, 
			String exp_name ) throws QueryGeneratorValidationException, IOException {
		
		super(user_name, notebook_name, exp_name);
		
		myRoot 			= root;
		
		_numberQueries = number_queries;

		myXMLFile = File.createTempFile("predefineQueries", ".xml", new File(
				Constants.DIRECTORY_TEMP));
		myXMLFile.deleteOnExit();

		FileOutputStream out = new FileOutputStream(myXMLFile);
		XMLHelper.writeXMLToOutputStream(out, root);
		out.close();
		init();

	}
	

	/**
	 * Creates a predefined query generator.
	 * 
	 * @param href
	 *            The file that holds the XML source for the query generator.
	 * @param dataDef
	 *            The data definition that this query generator will use.
	 * @param number_queries
	 *            The number of queries to be generated.
	 * @param controller
	 *            A handle to allow the query generator to communicate with
	 *            AZDBLab's internal tables.
	 * @param exp_name
	 *            The name of the experiment.
	 * @param test_num
	 *            The test number this experiment is associated.
	 * @throws QueryGeneratorValidationException
	 *             Thrown if the query generator XML has a validation error.
	 * 
	public PredefinedQueryGenerator(String href, int number_queries,
			// LabShelf labShelf,
			InternalDatabaseController dbcontroller, 
			String user_name,
			String notebook_name, String exp_name, int test_num)
			throws QueryGeneratorValidationException {

		myXMLFile = new File(AZDBLAB.XML_SOURCE_DIRECTORY + href);
//		myDataDef = dataDef;
		_testNumber = test_num;
		strUserName = user_name;
		strNotebookName = notebook_name;
		_experimentName = exp_name;
		// _labshelf = labshelf;
		_internaldbcontroller = dbcontroller;
		
//		_internaldbcontroller = new InternalDatabaseController(	AZDBLAB.LABstrUserName,
//				AZDBLAB.LAB_PASSWORD,
//				AZDBLAB.LAB_CONNECTSTRING
//				);

//		_internaldbcontroller.open();

		_numberQueries = number_queries;

		init();
	}
	*/
	
	
	public String getQueryDefName() {
		return myRoot.getAttribute("name");
	}
	
	
	/**
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	public boolean equals( Object o ) {
		if (!( o instanceof PredefinedQueryGenerator ))
			return false;
		PredefinedQueryGenerator other = (PredefinedQueryGenerator) o;
		NodeList otherQueries = other.getRoot().getElementsByTagName("query");
		NodeList thisQueries = this.getRoot().getElementsByTagName("query");
		if (otherQueries.getLength() != thisQueries.getLength())
			return false;
		// compares the queries to make sure they are all the same.
		for (int i = 0; i < otherQueries.getLength(); i++) {
			String sqlOther = ( (Element) otherQueries.item(i) )
					.getAttribute("sql");
			String sqlThis = ( (Element) thisQueries.item(i) )
					.getAttribute("sql");
			if (!sqlOther.equals(sqlThis))
				return false;
		}
		return true;
	}

	/**
	 * @see azdblab.analysis.api.QueryGenerator#generateQueries()
	 */
	public int generateQueries(String startTime) {
		List<Query> testQueries = null;
		//Date date = new Date(System.currentTimeMillis());
		System.out.println(strUserName+" "+strNotebookName+" "+strExperimentName+" "+startTime);
		Run exp_run = User.getUser(strUserName).getNotebook(strNotebookName)
		    .getExperiment(strExperimentName).getRun(startTime);
		
		if(exp_run == null){
			System.out.println("the experiment run is null");
			System.exit(0);
		}
                // testQueries = _labshelf.getTestQueries(_experimentName,
                // _testNumber);
		while (testQueries == null) {
                testQueries = exp_run.getExperimentRunQueries();
		}
        if (testQueries.size() != _numberQueries) {
                // something got killed during query generation (not analysis)
        	exp_run.deleteExperimentRunQueries();

                // generating queries anew
                for (int i = 0; i < _numberQueries; i++) {
                        String query = myQueries[i];
                        if (Main.verbose)
                                Main._logger.outputLog("Generated Query: " + query);
                        exp_run.insertQuery(strUserName, strNotebookName, strExperimentName, startTime, i, query);
                }
        } else {
                // pulling queries from the DBMS.
                for (int i = 0; i < testQueries.size(); i++) {
                        Query testQuery = (Query) testQueries.get(i);
                        if (!exp_run.queryExist(strUserName, strNotebookName, strExperimentName, startTime, testQuery.iQueryNumber)) {
                                // query result does not exist
                        	exp_run.deleteQuery(testQuery.iQueryNumber);
                        	exp_run.insertQuery(strUserName, strNotebookName, strExperimentName, startTime, testQuery.iQueryNumber, testQuery.strQuerySQL);
                        }
                        if (Main.verbose)
                                Main._logger.outputLog("Query Retrieved from DBMS: "
                                                + testQuery.strQuerySQL);

                }
        }
      return _numberQueries;
	}

	/**
	 * @see azdblab.analysis.api.QueryGenerator#getRoot()
	 */
	public Element getRoot() {
		return myRoot;
	}
	
	
	public File getQueryDefFile() {
		return myXMLFile;
	}
	

	/**
	 * Called by the constructor to extract the queries from the XML.
	 * @throws FileNotFoundException 
	 */
	private void init() throws QueryGeneratorValidationException, FileNotFoundException {
		myRoot = XMLHelper.validate(
				(InputStream)new FileInputStream(new File(Constants.CHOSEN_PREDEFINED_SCHEMA)),
                new FileInputStream(myXMLFile)).getDocumentElement();
		NodeList queries = myRoot.getElementsByTagName("query");
		if (queries.getLength() != _numberQueries)
			Main._logger.reportError("The number of queries specified in the XML numberQueries field does not match the actual number of queries found in the predefinedQueries XML.  This will prevent AZDBLab from storing query results until the entire test has completed successfully.");
		myQueries = new String[queries.getLength()];
		for (int i = 0; i < queries.getLength(); i++)
			myQueries[i] = ( (Element) queries.item(i) ).getAttribute("sql");
	}

	
	public String getDescription(boolean hasResult) {
		
			String		strDescription	= "";
			
			if (hasResult) {
				List<Query>	queries	= User.getUser(strUserName)
				.getNotebook(strNotebookName).getExperiment(
						strExperimentName).getRun(strStartTime)
				.getExperimentRunQueries();
				
				for (int i = 0; i < queries.size(); i++) {
					Query	query	= queries.get(i);
					strDescription	+= "<pre>" + query.iQueryNumber + "\t" + query.strQuerySQL + "\n" + "</pre>";
				}
				
			} else  {
				return "Predefined Queries";
			}
			
			return strDescription;
			
	}
	
	/**
	 * The data definition for this query generator.
	 */
	//private DataDefinition		myDataDef;
	
	
//	private String			strQueryDefName;

	/**
	 * The queries that were generated by this query generator.
	 */
	public String[] myQueries;

	/**
	 * The DOM element for this query generator.
	 */
	private Element myRoot;

	/**
	 * The XML source of this experiment.
	 */
	private File myXMLFile;

	/**
	 * The test number of this query generator
	 */
	//private int _testNumber;
	
	
	//private String _testTime;


	/**
	 * The number of queries to be generated.
	 */
	private int _numberQueries;
	
}
