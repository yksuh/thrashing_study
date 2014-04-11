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
package azdblab.geturls;

import java.io.*;

import azdblab.swingUI.objectNodes.*;
import azdblab.Constants;

public class GetURLs {
	
	/**
	 * Get the URL (temporary html web page) for the description of the user
	 * @param userName
	 * @return
	 */
	public File getUserDescription(String userName) {
			UserNode userNode = new UserNode(userName);
			
			try {
				File tempURL = File.createTempFile("userDescription", ".html", new File(Constants.DIRECTORY_TEMP));
				tempURL.deleteOnExit();
				FileWriter frout = new FileWriter(tempURL);
				frout.write(userNode.createDescription());
				frout.close();
				return tempURL;
				
			} catch (IOException ioex) {
				ioex.printStackTrace();
			}
			
			return null;
			
	}
	
	/**
	 * Get the URL (temporary html web page) for the analytic description of the user
	 * @param userName
	 * @return
	 */
	public File getUserAnalytic(String userName) {
		
		UserNode userNode = new UserNode(userName);
		
		try {
			File tempURL = File.createTempFile("userAnalytic", ".html", new File(Constants.DIRECTORY_TEMP));
			tempURL.deleteOnExit();
			FileWriter frout = new FileWriter(tempURL);
			frout.write(userNode.createUserAnalytic());
			frout.close();
			return tempURL;
			
		} catch (IOException ioex) {
			ioex.printStackTrace();
		}
		
		return null;
		
	}

}
