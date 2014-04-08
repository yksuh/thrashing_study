package azdblab.model.transactionGenerator;

import java.io.File;

import org.w3c.dom.Element;

import azdblab.labShelf.dataModel.LabShelfManager;

public abstract class TransactionGenerator {

	protected String strUserName;

	protected String strNotebookName;

	protected String strExperimentName;
	
	protected String strStartTime;
	
	protected LabShelfManager shelf = LabShelfManager.getShelf();
	
	
	public TransactionGenerator(String userName, String notebookName, String experimentName) {
		strUserName			= userName;
		strNotebookName		= notebookName;
		strExperimentName	= experimentName;
	}
	
	/**
	 * Determines if two queries generator's XML are the same.
	 * @param o The other query generator
	 * @return true - if they query generators are the same class and have the same
	 * XML<BR>false - if the query generators are not the same class or have
	 * different XML.
	 */
	public abstract boolean equals(Object o);

	
	/**
	 * Invoking this will cause the query generator to generate
	 * its queries.
	 */
	public abstract int generateTransaction(String startTime);
	/**
	 * Returns the XML Document DOM root.
	 * @return The XML documents root element.
	 */
	public abstract Element getRoot();
	
	
	public abstract String getDescription(boolean hasResult);
	
	
	public void setTestTime(String testTime) {
		strStartTime		= testTime;
	}
	
	public abstract String getTransactionDefName();
	
	
	public abstract File getTransactionDefFile();
	
//	public abstract boolean checkSuccess();
	
}

