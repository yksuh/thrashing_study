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
//package AZDBLab.browser.large;

package azdblab.swingUI;

import java.io.File;
import javax.swing.JFileChooser;
import javax.swing.filechooser.FileFilter;

/**
 * <p>
 * When deciding which result browser to use, the user must determine what their needs are. This result browser
 * designed to provide a solution for viewing a large number of queries.  To do this, the user will not receive
 * as much information about the results of each query.  The user cannot use this browser to see the query plans
 * drawn as graphs.  The user simple sees tables summarizing the change points/query plans.
 * <p>
 * <p>
 * This result browser allows the user to view experiments with a large number or queries and change points.
 * The other result browser will not be able to handle a large number of queries.  This result browser simply
 * transforms the result into HTML and launches the user's default browser to view the results.  One window 
 * is launched to display the source HTML for the experiment and one window is launched to show the result HTML
 * for the experiment.
 * <p>
 * 
 * @author Kevan Holdaway
 *
 */
public class OptimizedResultsBrowser {
	
	/**
	 *  Prompts the user to select a file with a file choose.  It then opens a browser window with the source of 
	 * the experiment and a browser window with the result of the experiment.
	 */
	public void view() {
		//creating a file chooser for the xml source default directory
		JFileChooser chooser = new JFileChooser();

		//creating a filter so that only XML files are displayed
		XMLFileFilter filter = new XMLFileFilter();
		chooser.setFileFilter(filter);
		chooser.setAcceptAllFileFilterUsed(false);
		
		//Only allow one file to be selected at a time.
		chooser.setMultiSelectionEnabled(false);
		int returnVal = chooser.showOpenDialog(null);

		//If the user chooses to open the file, then performed the open action.
		if (returnVal == JFileChooser.APPROVE_OPTION) {
			//File selectedFile = chooser.getSelectedFile();
			//open(selectedFile.getAbsolutePath());
		}

	}

	/**
	 * This is the real meat of the view function.  This opens the file, communicates with AZDBLab, and extracts
	 * the result.  It then launches the user's default browser.
	 * @param experiment The name of the file that contains the experiment that the user wishes to analyze with the 
	 * result browser.
	 *
	private void open(String experiment) {
		ExperimentModule exp = null;
		try {
			if (XMLHelper
				.isValid(
					new FileInputStream(new File(AZDBLab.EXPERIMENT_SCHEMA)),
					new FileInputStream(new File(experiment)))) {
				
				//creating a temp file to store the result of the transform for the source.
				File expSourceHTML = File.createTempFile("source", ".html", new File (AZDBLab.XML_TEMP_DIRECTORY));
				
				//Transforming the source XML to HTML for viewing.
				XMLHelper.transform(experiment,AZDBLab.SOURCE_TRANSFORM_STYLE,expSourceHTML.getAbsolutePath());
				
				//Creating an experiment module object to retrieve the results.
				exp = new ExperimentModule(null, null, experiment);
				
				//Used to extract information from the DBMS internal tables.
				InternalDatabaseControllerAPI dbController =
					new InternalDatabaseController(
						exp.getMyDBMS(),
						exp.getMyUsername(),
						exp.getMyPassword(),
						exp.getMyConnectString());
				dbController.open();
				
				
				DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
				factory.setIgnoringElementContentWhitespace(true);
				DocumentBuilder builder = factory.newDocumentBuilder();
				builder.setErrorHandler(new ExperimentErrorHandler());
				Document expResult = builder.newDocument();
				
				//Creating a DOM for the Experiment Result
				Element expElement = expResult.createElement("experimentResult");
				expResult.appendChild(expElement);
				
				//Retreiving the results for each test in this experiment.
				Vector testResults = dbController.getTestResults(exp.getMyExperimentName());
				int myNumberTestResults = testResults.size();
				for (int i = 0; i < myNumberTestResults; i++) {
					//Appending the Test Results to the Experiment Result DOM
					TestResult testResult = (TestResult)testResults.get(i);
					Document testDoc =
						XMLHelper.validate(new File(AZDBLab.TEST_RESULT_SCHEMA), testResult._resultXML);
					Element testElement = testDoc.getDocumentElement();
					expElement.appendChild(expResult.importNode(testElement, true));
					testResult._resultXML.close();
				}
				
				dbController.close();

				//Creating a temp file to hold the results of HTML result for the experiment. 
				File expResultFile = File.createTempFile("result", ".xml", new File(AZDBLab.XML_TEMP_DIRECTORY));
				expResultFile.deleteOnExit();
				File expResultHTML = File.createTempFile("result",".html", new File(AZDBLab.XML_TEMP_DIRECTORY));
				
				OutputStream out = new FileOutputStream(expResultFile);
				XMLHelper.writeXMLToOutputStream(out,expElement);
				out.close();
				
				//Transforming the result XML to HTML
				XMLHelper.transform(expResultFile.getAbsolutePath(), AZDBLab.RESULT_TRANSFORM_STYLE, expResultHTML.getAbsolutePath());

				//Launching the browser to display the source and the result.
				Runtime.getRuntime().exec("rundll32 url.dll,FileProtocolHandler " + "file:///" + expSourceHTML.getAbsolutePath());
				Runtime.getRuntime().exec("rundll32 url.dll,FileProtocolHandler " + "file:///" + expResultHTML.getAbsolutePath());
			}
		} catch (Exception e) {
			_logger.reportError("Failed to open file '" + experiment + "' because ");
			e.printStackTrace();
		}
	}
	*/

	/**
	 * This class is used with a JFileChooser.  It filters out files to determine which files will be displayed
	 * by the JFileChooser.  This implementation is designed to display only XML files and directories.
	 * @author Kevan Holdaway
	 *
	 */
	private class XMLFileFilter extends FileFilter {

		/**
		 * @see javax.swing.filechooser.FileFilter#accept(java.io.File)
		 */
		public boolean accept(File f) {
			return f.getName().endsWith(".xml") || f.isDirectory();
		}

		/**
		 * @see javax.swing.filechooser.FileFilter#getDescription()
		 */
		public String getDescription() {
			return "AZDBLab Experiments (*.xml)";
		}

	}

}
