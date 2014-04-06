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

package azdblab.model.dataGenerator;

import java.io.IOException;

import azdblab.exception.analysis.ColumnAttributeException;
import azdblab.exception.analysis.DataDefinitionValidationException;
import azdblab.exception.analysis.NameResolutionException;


/**
 * Multiple data generators can be created for AZDBLab.  This interface provides
 * AZDBLab with a common way to the data generator.
 * @author Kevan Holdaway
 *
 */
public abstract class DataGenerator {
	/**
	 * This instructs the data generator to remove tables for the current
	 * data definition.
	 */
	public abstract void deleteTables();
//	public abstract String[] getTables();
	/**
	 * Performs error checking on the XML for this data generator.
	 * @throws ColumnAttributeException if an invalid column attribute is found.
	 */
	public abstract void errorCheck() throws ColumnAttributeException;
	
	/**
	 * Instructs the data generator to populate the DBMS with both tables and tuples
	 * for this data definition.
	 * @throws ColumnAttributeException If population fails because of a column attribute.
	 * @throws IOException If there is trouble reading the data definition.
	 * @throws DataDefinitionValidationException If the data definition has an XML validation problem.
	 * @throws NameResolutionException If the data defnition has a name resolution problem.  This could occur if a foreign key
	 * in a table references a key that does not exist.
	 */
	public abstract void createTables()
		throws ColumnAttributeException, IOException, DataDefinitionValidationException, NameResolutionException;
}
