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
package plugins.unit_testing;

import java.util.ArrayList;

class DataStructureUtil {
	public static String arrayListToString(ArrayList<String> al) {
		StringBuffer sb = new StringBuffer();
		sb.append("List of ArrayList\n");
		for (int i = 0, size = al.size(); i < size; i++) {
			sb.append(String.format("[%d]-\"%s\"\n", i, al.get(i).toString()));
		}
		return sb.toString();
	}
}
public class TeradataResultXML { // public static final String FILENAME =
	// "./plugins/plugins/unit_testing/result2.xml";
	public static final String FILENAME = "/home/mjseo/result2.xml";

	public static void main(String[] args) {

	
	}

}
