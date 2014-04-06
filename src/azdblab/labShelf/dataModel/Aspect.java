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

import java.io.Reader;
import java.sql.Clob;
import java.sql.ResultSet;
import java.util.Vector;

import azdblab.Constants;
import azdblab.labShelf.TableDefinition;

public class Aspect extends TableDefinition {
	
	private String userName;
	private String notebookName;
	private String aspectName;
	private String aspectStyle;
	private String aspectDescription;
	private String aspecticSQL;
	/**
	 * @param userName
	 * @param notebookName
	 * @param aspectName
	 * @param aspectStyle
	 * @param aspectDescription
	 * @param aspecticSQL
	 */
	public Aspect(String userName, String notebookName, String aspectName,
			String aspectStyle, String aspectDescription, String aspecticSQL) {
		super();
		this.userName = userName;
		this.notebookName = notebookName;
		this.aspectName = aspectName;
		this.aspectStyle = aspectStyle;
		this.aspectDescription = aspectDescription;
		this.aspecticSQL = aspecticSQL;
	}
	/**
	 * @return the userName
	 */
	public String getUserName() {
		return userName;
	}
	/**
	 * @return the notebookName
	 */
	public String getNotebookName() {
		return notebookName;
	}
	/**
	 * @return the aspectName
	 */
	public String getAspectName() {
		return aspectName;
	}
	/**
	 * @return the aspectStyle
	 */
	public String getAspectStyle() {
		return aspectStyle;
	}
	/**
	 * @return the aspectDescription
	 */
	public String getAspectDescription() {
		return aspectDescription;
	}
	/**
	 * @return the aspecticSQL
	 */
	public String getAspecticSQL() {
		return aspecticSQL;
	}
	
	/**
	 * 
	 * @return
	 */
	public static Vector<Aspect> getAllAspects() {

		Vector<Aspect> result = new Vector<Aspect>();

		String columnName = "UserName, " + "NotebookName, " + "AspectName, "
				+ "Style, " + "Description, " + "AspectSQL";

		String[] columnNames = new String[] {};
		String[] columnValues = new String[] {};
		int[] dataTypes = new int[] {};

		try {
			// Queries the DBMS for the test results of an experiment.
			ResultSet rs = LabShelfManager.getShelf().executeSimpleQuery(
					Constants.TABLE_PREFIX + Constants.TABLE_DEFINEDASPECT,
					new String[] { columnName }, columnNames, columnValues,
					dataTypes);

			while (rs.next()) {

				String userName = rs.getString(1);
				String notebookName = rs.getString(2);
				String aspectName = rs.getString(3);
				String aspectStyle = rs.getString(4);
				String aspectDescription = rs.getString(5);
				Clob clob = rs.getClob(6);

				if (clob == null) {

				}

				char[] data = new char[1024];

				Reader reader = clob.getCharacterStream();

				StringBuffer strbuf = new StringBuffer();

				for (int len; (len = reader.read(data, 0, 1024)) > 0; strbuf
						.append(data, 0, len))
					;

				String aspectSQL = new String(strbuf);

				Aspect aspnode = new Aspect(userName, notebookName, aspectName,
						aspectStyle, aspectDescription, aspectSQL);

				result.add(aspnode);
			}

			rs.close();

			return result;

		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}

}
