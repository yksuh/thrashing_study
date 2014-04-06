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
package azdblab.swingUI.objectNodes;

import java.util.Vector;

import azdblab.Constants;
import azdblab.exception.analysis.InvalidExperimentRunException;
import azdblab.exception.dbms.DBMSInvalidConnectionParameterException;
import azdblab.exception.dbms.DBMSNotSupportedException;
import azdblab.model.dataDefinition.DataDefinition;
import azdblab.swingUI.AZDBLabObserver;

import javax.swing.JPanel;
import javax.swing.JTextPane;

/**
 * The experiment module provides access to the content of the experiment XML.
 * It provides a simple API to extract the information from the XML.
 * 
 * @author
 * 
 */
public class DataDefNode extends ObjectNode {

	private DataDefinition myDataDef;

	/**
	 * Creates an experiment module.
	 * 
	 * @param exp_source
	 *            The XML source of the experiment module.
	 * @throws InvalidExperimentRunException
	 *             If there is a test that has a problem.
	 * @throws DBMSNotSupportedException
	 *             If the DBMS for a test in the experiment has an invalid DBMS
	 * @throws DBMSInvalidConnectionParameterException
	 *             When the experiment cannot connect to the DBMS.
	 */
	public DataDefNode(DataDefinition data_def) {
		willHaveChildren = false;
		myDataDef = data_def;

		strNodeName = "Data Definition";
	}

	public String getIconResource(boolean open) {
		return (Constants.DIRECTORY_IMAGE_LFHNODES + "datadef_new.png");
	}

	private JPanel createDataDefPanel() {

		JTextPane infoPane = createTextPaneFromXML(myDataDef.getRoot(),
				Constants.SOURCE_TRANSFORM_STYLE);

		// Install All the sections into tabs
		JPanel dataDefPanel = new JPanel();
		dataDefPanel.add("Data Definition", infoPane);

		// return new JComponentWrapper(qryResPanel, ("Query # " + iQueryNum +
		// ""), JComponentWrapper.PANEL_TYPE_PANE);

		return dataDefPanel;

	}

	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Data Definition Node");

		return createDataDefPanel();
	}

	public JPanel getButtonPanel() {
		return null;
	}

	@Override
	protected void loadChildNodes() {
	}

	@Override
	protected Vector<String> getAuthors() {
		Vector<String> vecToRet = new Vector<String>();
		vecToRet.add("Rui Zhang");
		vecToRet.add("Young-Kyoon Suh");
		vecToRet.add("Matthew Johnson");
		return vecToRet;
	}

	@Override
	protected String getDescription() {
		return "This information contains data pertaining to an table definition for a particular experiment";
	}

}
