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

import java.io.*;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.labShelf.DBMSConnectParam;
import azdblab.labShelf.dataModel.LabShelfManager;

public class LabShelfConnector {
	
	private String		strUserName;
	private String		strPassword;
	private String		strConnectString;
	private String 		current_version_;
	
	
	//private LabShelf		dbController_;
	
	private Vector<DBMSConnectParam>		vecDBMSConParam;
	
	
	public LabShelfConnector() {
		vecDBMSConParam		= new Vector<DBMSConnectParam>();
	}
	
	public String getCurrentVersion() {
      return current_version_;
	}

	
	private void loadLabShelfConnections() {
		
		File		pluginDir			= new File(Constants.DIRECTORY_PLUGINS);
		
		if (!pluginDir.exists()) {
			return;
		}
		
		File[]		dbmsConParams		= (pluginDir).listFiles();
		
		try {

			Map<String, DBMSConnectParam>	mapTmpDBCon	= new TreeMap<String, DBMSConnectParam>();
			
	        Decryptor	decryptor 	= new Decryptor(Constants.DESKEYPHRASE);
			
			for ( int i = 0; i < dbmsConParams.length; i++ ) {
				
				if (dbmsConParams[i].getName().contains(".xml")) {
					Document			doc					= XMLHelper.readDocument(dbmsConParams[i]);
					Element				root				= doc.getDocumentElement();
					
					if (root.getAttribute("TYPE").equals("labShelf")) {
					
						DBMSConnectParam	newDBMSConParam		= new DBMSConnectParam(	root.getAttribute("TITLE"), 
																						decryptor.decrypt(root.getAttribute("LAB_USERNAME")), 
																						decryptor.decrypt(root.getAttribute("LAB_PASSWORD")), 
																						decryptor.decrypt(root.getAttribute("LAB_CONNECTSTRING")),
																						root.getAttribute("CREATE_TIME"),
																						root.getAttribute("CREATOR_NAME"),
																						root.getAttribute("COMMENTS"));
						
						mapTmpDBCon.put(newDBMSConParam.strNotebookName, newDBMSConParam);
						
					}
										
				}
							
			}
			
			vecDBMSConParam.addAll(mapTmpDBCon.values());
			
			if (vecDBMSConParam.size() > 0) {
				
				DBMSConnectParam	tmpDBConParam	= vecDBMSConParam.get(0);
				
				strUserName			= tmpDBConParam.strJDBCUserName;
				strPassword			= tmpDBConParam.strJDBCPassword;
				strConnectString	= tmpDBConParam.strJDBCConnectString;
                current_version_ = tmpDBConParam.create_date_;				
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
				
	}
	
	
	public void initialize() {
		loadLabShelfConnections();
		execute();
	}
	
	
	private void execute() {
		
		BufferedReader stdin	= new BufferedReader(new InputStreamReader(System.in));

		try {
		
			while (true) {
				
				displayOptions();
				
				String		option		= stdin.readLine();
				
				if (!option.equals("")) {
					
					if (option.equals("Q")) {
						Main._logger.outputLog("Terminate Executor.");
						System.exit(0);
					}
									
					int		id			= Integer.parseInt(option);
					
					if (id <= vecDBMSConParam.size() && id >= 1) {
						DBMSConnectParam	tmpConParam		= vecDBMSConParam.get(id - 1);
						
						strUserName							= tmpConParam.strJDBCUserName;
						strPassword							= tmpConParam.strJDBCPassword;
						strConnectString					= tmpConParam.strJDBCConnectString;
						current_version_ = tmpConParam.create_date_;
						
						//return;
						
					} else if (id == 0) {
						Main._logger.outputLog("Please Specify JDBC User Name: ");
						strUserName							= stdin.readLine();
						
						Main._logger.outputLog("Please Specify JDBC Password: ");
						strPassword							= stdin.readLine();
						
						Main._logger.outputLog("Please Specify JDBC Connect String: ");
						strConnectString					= stdin.readLine();
						
						//return;
					}
					
				} else if (vecDBMSConParam.size() > 0){
					
					DBMSConnectParam	tmpConParam		= vecDBMSConParam.get(0);
					
					strUserName							= tmpConParam.strJDBCUserName;
					strPassword							= tmpConParam.strJDBCPassword;
					strConnectString					= tmpConParam.strJDBCConnectString;
					
					//return;
					
				} else if (vecDBMSConParam.size() == 0) {
					
					Main._logger.outputLog("Please Specify JDBC User Name: ");
					strUserName							= stdin.readLine();
					
					Main._logger.outputLog("Please Specify JDBC Password: ");
					strPassword							= stdin.readLine();
					
					Main._logger.outputLog("Please Specify JDBC Connect String: ");
					strConnectString					= stdin.readLine();
					
				}
				
				if (login() == 0) {
					return;
				}
				
			}
			
		} catch (IOException ioex) {
			ioex.printStackTrace();
		}
		
	}
	
	private void displayOptions() {
		
		for ( int i = 0; i < vecDBMSConParam.size(); i++ ) {
			DBMSConnectParam	tmpDBMSCP	= vecDBMSConParam.get(i);
			if(Main._logger == null){
				System.out.println("error!");
			}
			Main._logger.outputLog((i + 1) + ": " + tmpDBMSCP.strNotebookName);
		}
		
		Main._logger.outputLog("0: User Specify Connecting Parameters");
		
		Main._logger.outputLog("Q: Quit");
		
		if (vecDBMSConParam.size() == 0) {
			Main._logger.outputLog("Please Select an Option: [0]");
		} else {
			Main._logger.outputLog("Please Select an Option: [1]");
		}
		
	}
	
	
	private int login() {
		
		if (strUserName.equals("") || strPassword.equals("") || strConnectString.equals("")) {
			Main._logger.outputLog("Please Use a Valid Connection.");
			return -1;
		}
		
	
		Main.setLABUSERNAME(strUserName);
		Main.setLABPASSWORD(strPassword);
		Main.setLABCONNECTSTRING(strConnectString);
		
		LabShelfManager.getShelf(Main.getLABUSERNAME(),
				Main.getLABPASSWORD(),
				Main.getLABCONNECTSTRING(),
				"sodb7.cs.arizona.edu");
		
		//dbController.OpenLabShelf();
		
		return 0;
		
	}
	
	
	public LabShelfManager getLabShelf() {
		return LabShelfManager.getShelf();
	}

}
