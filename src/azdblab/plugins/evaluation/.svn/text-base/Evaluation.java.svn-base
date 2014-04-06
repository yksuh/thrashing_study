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
package azdblab.plugins.evaluation;

import java.util.List;
import javax.swing.JButton;
import javax.swing.JPanel;

import azdblab.labShelf.InternalTable;
import azdblab.labShelf.TableDefinition;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.plugins.Plugin;
import azdblab.swingUI.objectNodes.ObjectNode;

/**
 * This is the base interface for Plugins
 * 
 * It is not in any way related to Aspect.java
 * 
 * @author mwj
 * 
 */
public abstract class Evaluation extends Plugin {
	protected ObjectNode myObjectNode;

	public Evaluation(ObjectNode sent) {
		myObjectNode = sent;
	}

	/**
	 * Returns the name of the Plugin
	 */
	public abstract String getName();

	/**
	 * Returns all buttons needed by the aspect
	 * 
	 * @return A vector of buttons, or null if no buttons
	 */
	public abstract List<JButton> getButtons();

	/**
	 * Returns all tabs needed by the aspect
	 * 
	 * @return A JPanel containing all the tabs, or null if no tabs
	 */
	public abstract JPanel getTabs();

	/**
	 * Gets all internal tables used by the aspects
	 * 
	 * @return a vector of tables, or null if no tables needed
	 */
	public abstract List<InternalTable> getTables();

	/**
	 * Returns a vector of all supported classes
	 * 
	 * @return
	 */
	public abstract List<String> getSupportedClasses();

	public abstract Evaluation getInstance(ObjectNode sent);

	/**
	 * This method installs all relevent aspect tables if they are needed
	 */
	public void installIfNeeded() {
//		List<InternalTable> lstInternalTables = getTables();
//		if (lstInternalTables == null) {
//			return;
//		}
//		TableDefinition.vecPluginTables.addAll(lstInternalTables);
//		for (int i = 0; i < lstInternalTables.size(); i++) {
//			InternalTable tmp = lstInternalTables.get(i);
//			if (!LabShelfManager.getShelf().tableExists(tmp.TableName)) {
//				LabShelfManager.getShelf().createTable(tmp.TableName,
//						tmp.columns, tmp.columnDataTypes,
//						tmp.columnDataTypeLengths, tmp.primaryKey,
//						tmp.foreignKey);
////				if(tmp.TableName.equalsIgnoreCase(QueryParamEvaluation.PKQUERYPARAM.TableName)){
////					String alterTblSQL = "alter table " + QueryParamEvaluation.PKQUERYPARAM + " MODIFY value NUMBER(10, 3)";
////					LabShelfManager.getShelf().executeUpdateSQL(alterTblSQL);
////				}
//			}
//		}
	}

}
