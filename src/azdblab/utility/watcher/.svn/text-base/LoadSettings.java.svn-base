package azdblab.utility.watcher;

/*
* Copyright (c) 2012, Arizona Board of Regents
* 
* See LICENSE at /cs/projects/tau/azdblab/license
* See README at /cs/projects/tau/azdblab/readme
* AZDBLab, http://www.cs.arizona.edu/projects/focal/ergalics/azdblab.html
* This is a Laboratory Information Management System
* 
* Authors:
*  Jennifer Dempsey
*/
import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;


/**
 * Loads the settings from the settings file and places
 * them into a HashMap.
 * 
 * @author jendempsey
 *
 */
public class LoadSettings {
	private static HashMap<String, String> settings;
	
	public LoadSettings(){
		String key; 
		settings = new HashMap<String, String>();
		try {
			Scanner scan = new Scanner(new File(
					"watcher_settings"));
			while(scan.hasNextLine()){
				key = scan.nextLine();
				String[] entry = key.split("\\s+");
				settings.put(entry[0], entry[1]);
			}
			scan.close();	// young edited
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	/**
	 * Separte getEmails method splits the list of email
	 * recipients into individual strings in an Array. 
	 * @return ArrayList containing email recipients
	 */
	public ArrayList<String> getEmails(){
		String[] emailList = this.get("-email").split("\\s+");
		ArrayList<String> result = new ArrayList<String>();
		for(int i =0; i< emailList.length; i++){
			result.add(emailList[i]);
		}
		return result;
	}
	
	public String get(String key){
		return settings.get(key);
	}
	
}
