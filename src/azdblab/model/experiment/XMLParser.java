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

// Youngkyoon Suh (11/17/10): added to run transaction experiments in AZDBLAB; 
// some code taken from Ricardo's code  

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Vector;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;

public class XMLParser {

	private DocumentBuilderFactory factory;
	
	private String			strExpName; 			
	
	/*
	 * Table properties
	 */
	private String 			strExperimentTableName;
	private String 			strCardinality;
	private int 			iExperimentNumCols;	
	private String[] 		strExperimentColNames;
	private int[] 			iExperimentColTypes;
	private int[]			iExperimentColTypeLengths;
	
	private String 			strResultTableName;
	private int 			iResultNumCols;	
	private String[] 		strResultColNames;
	private int[] 			iResultColTypes;
	private int[]			iResultColTypeLengths;
	
	private String 			strNumXact;
	private String 			strConnString;
	private String 			strSeedSG;
	private String 			strSeedTG;

	private String 			strXactID;
	private String 			strUsername;
	private String 			strPassword;
	private Vector<Integer>	vecNumRead;
	private Vector<Integer>	vecNumWrite;
	
	private Vector<Integer>	vecBoolSingleRow;
	private Vector<Integer>	vecTuples;
	
	public XMLParser() {
		
		factory 		= DocumentBuilderFactory.newInstance();		
		factory.setNamespaceAware(true);
		factory.setIgnoringComments(true);
		factory.setIgnoringElementContentWhitespace(true);
		factory.setXIncludeAware(false);
		
		strExperimentTableName 	= "";
		strCardinality 	= "";
		iExperimentNumCols		= 0;
		
		strResultTableName		= "";
		iResultNumCols			= 0;
		
		strUsername				= "";
		strPassword				= "";
		strConnString			= "";
		
		strNumXact				= "";
		strSeedSG				= "";
		strSeedTG				= "";
		strXactID				= "";
		
		vecNumRead				= new Vector<Integer>();
		vecNumWrite				= new Vector<Integer>();
		vecBoolSingleRow		= new Vector<Integer>();
		vecTuples				= new Vector<Integer>();

	}
	
	public void ReadTableData(File tableSource) {

		String[] strExperimentColTypes, strResultColTypes;

		try {
			DocumentBuilder builder 		= factory.newDocumentBuilder();
	
			Document 		d 				= builder.parse(tableSource);
			
			NodeList 		configureData 	= d.getElementsByTagName("configure");
			
			for (int i = 0; i < configureData.getLength(); i++) {
				Element	configureElem 	= (Element) configureData.item(i);
				
				strUsername				= configureElem.getAttribute("username");
				strPassword				= configureElem.getAttribute("password");
				strConnString			= configureElem.getAttribute("connectstring");
			}
			
			NodeList 		tableExperimentData 		= d.getElementsByTagName("tableExperiment");

			for (int i = 0; i < tableExperimentData.getLength(); i++) {
			
				Element		tmpelm	= (Element) tableExperimentData.item(i);
				
				strExperimentTableName		= tmpelm.getAttribute("tableName");
				strCardinality				= tmpelm.getAttribute("cardinality");
				iExperimentNumCols			= Integer.parseInt(tmpelm.getAttribute("numCol"));
				
				strExperimentColNames 		= new String[iExperimentNumCols];
				strExperimentColTypes 		= new String[iExperimentNumCols];
				iExperimentColTypes			= new int[iExperimentNumCols];
				iExperimentColTypeLengths	= new int[iExperimentNumCols];
				
				NodeList childData = tmpelm.getElementsByTagName("col");
				
				for (int j = 0; j < childData.getLength(); j++) {
					Element childElm 	= (Element) childData.item(j);
				
					strExperimentColNames[j] 		= childElm.getAttribute("name");
					strExperimentColTypes[j] 		= childElm.getAttribute("dataType");					
					
					if (strExperimentColTypes[j].compareTo("clob") == 0)
						iExperimentColTypes[j] = GeneralDBMS.I_DATA_TYPE_CLOB;
					else if (strExperimentColTypes[j].compareTo("date") == 0)
						iExperimentColTypes[j] = GeneralDBMS.I_DATA_TYPE_DATE;
					else if (strExperimentColTypes[j].compareTo("number") == 0)
						iExperimentColTypes[j] = GeneralDBMS.I_DATA_TYPE_NUMBER;
					else if (strExperimentColTypes[j].compareTo("varchar2") == 0)
						iExperimentColTypes[j] = GeneralDBMS.I_DATA_TYPE_VARCHAR;
					else
						iExperimentColTypes[j] = GeneralDBMS.I_DATA_TYPE_SEQUENCE;
					
					iExperimentColTypeLengths[j] = Integer.parseInt(childElm.getAttribute("dataLength"));
				}				
			}
					
			NodeList 		tableResultData 		= d.getElementsByTagName("tableResult");

			for (int i = 0; i < tableResultData.getLength(); i++) {
			
				Element		tmpelm	= (Element) tableResultData.item(i);
				
				strResultTableName		= tmpelm.getAttribute("tableName");
				iResultNumCols			= Integer.parseInt(tmpelm.getAttribute("numCol"));
				
				strResultColNames 		= new String[iResultNumCols];
				strResultColTypes 		= new String[iResultNumCols];
				iResultColTypes			= new int[iResultNumCols];
				iResultColTypeLengths	= new int[iResultNumCols];
				
				NodeList childData = tmpelm.getElementsByTagName("col");
				
				for (int j = 0; j < childData.getLength(); j++) {
					Element childElm 	= (Element) childData.item(j);
				
					strResultColNames[j] 		= childElm.getAttribute("name");
					strResultColTypes[j] 		= childElm.getAttribute("type");					
					
					if (strResultColTypes[j].compareTo("number") == 0)
						iResultColTypes[j] = GeneralDBMS.I_DATA_TYPE_NUMBER;
					else if (strResultColTypes[j].compareTo("date") == 0)
						iResultColTypes[j] = GeneralDBMS.I_DATA_TYPE_DATE;
					else if (strResultColTypes[j].compareTo("clob") == 0)
						iResultColTypes[j] = GeneralDBMS.I_DATA_TYPE_CLOB;
					else if (strResultColTypes[j].compareTo("varchar2") == 0)
						iResultColTypes[j] = GeneralDBMS.I_DATA_TYPE_VARCHAR;
					else
						iResultColTypes[j] = GeneralDBMS.I_DATA_TYPE_SEQUENCE;
					
					iResultColTypeLengths[j] = Integer.parseInt(childElm.getAttribute("dataLength"));
				}				
			}
			
		} catch (IOException e) {
			e.printStackTrace();
			Main._logger.reportError(e.getMessage());
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
			Main._logger.reportError(e.getMessage());
		} catch (SAXException e) {
			e.printStackTrace();
			Main._logger.reportError(e.getMessage());
		}		
	}
	
	public void ReadTransactionData(File transactionSource) {

		try {
			DocumentBuilder builder 		= factory.newDocumentBuilder();
	
			Document 		d 				= builder.parse(transactionSource);
			
			NodeList 		rootNode		= d.getElementsByTagName("transactionData");
			strExpName						= ((Element)rootNode.item(0)).getAttribute("expname");
			
			NodeList 		xactProperty 	= d.getElementsByTagName("xactProperty");
			
			for (int i =0; i < xactProperty.getLength(); i++) {
				Element		xactElm	= (Element) xactProperty.item(i);
				
				strNumXact			= xactElm.getAttribute("numXact");
				strSeedSG			= xactElm.getAttribute("seedSG");	
				strSeedTG			= xactElm.getAttribute("seedTG");
			}
			
						
			NodeList 		transactionData	= d.getElementsByTagName("transaction");

			for (int i = 0; i < transactionData.getLength(); i++) {			
				Element		tmpelm	= (Element) transactionData.item(i);

				strXactID			= tmpelm.getAttribute("xactID");
				vecNumRead.add(Integer.valueOf(tmpelm.getAttribute("numRead")));
				vecNumWrite.add(Integer.valueOf(tmpelm.getAttribute("numWrite")));	
				vecBoolSingleRow.add(Integer.valueOf(tmpelm.getAttribute("singleRow")));
				vecTuples.add(Integer.valueOf(tmpelm.getAttribute("tuple")));
			}
					
		} catch (IOException e) {
			e.printStackTrace();
			Main._logger.reportError(e.getMessage());
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
			Main._logger.reportError(e.getMessage());
		} catch (SAXException e) {
			e.printStackTrace();
			Main._logger.reportError(e.getMessage());
		}		
	}	
	
	public String getUsername () {
		return strUsername;
	}
	
	public String getPassword () {
		return strPassword;
	}
	
	public String getConnString () {
		return strConnString;
	}
	
	public String getExperimentTableName () {
		return strExperimentTableName;
	}
	
	public String getTableCardinality () {
		return strCardinality;
	}
	
	public String[] getExperimentColNames () {
		return strExperimentColNames;
	}
	
	public int[] getExperimentColTypes () {
		return iExperimentColTypes;
	}
	
	public int[] getExperimentColTypeLengths() {
		return iExperimentColTypeLengths;
	}

	public String getResultTableName () {
		return strResultTableName;
	}
	
	
	public String[] getResultColNames () {
		return strResultColNames;
	}
	
	public int[] getResultColTypes () {
		return iResultColTypes;
	}
	
	public int[] getResultColTypeLengths() {
		return iResultColTypeLengths;
	}
	
	public int getNumXact () {
		return Integer.parseInt(strNumXact);
	}
	
	public int getSeedSG () {
		return Integer.parseInt(strSeedSG);
	}
	
	public int getSeedTG () {
		return Integer.parseInt(strSeedTG);
	}
	
	public String getXactID () {
		return strXactID;
	}
	
	public List<Integer> getNumRead () {
		//return Integer.parseInt(strNumRead);
		return vecNumRead;
	}
	
	public List<Integer> getNumWrite () {
		//return Integer.parseInt(strNumWrite);
		return vecNumWrite;
	}
	
	public int getNumOps(int i) {
		return vecNumRead.get(i) + vecNumWrite.get(i) + 1; // additional operation counted is the commit operation
	}
	
	public List<Integer> getBoolSingleRow () {
		//return Integer.parseInt(strNumWrite);
		return vecBoolSingleRow;
	}
		
	public List<Integer> getTuples () {
		//return Integer.parseInt(strNumWrite);
		return vecTuples;
	}
	
	public String getExpName() {
		return strExpName;
	}
	
}

