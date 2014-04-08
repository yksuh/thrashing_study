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
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/*
 * Class to handle the error and output streams from the ProcessBuilders in
 * the launcher where the default method in handling these streams is to 
 * print them to the console.
 * If coalesce is set to true then only the first occurrence of a group of  
 * duplicate messages will be printed. 
 * 
 * Default is to dispose of these streams. 
 */
public class StreamHandler extends Thread {
	private InputStream is;
	private String type;
	private String mode;

	public StreamHandler(InputStream is, String type) {
		this.is = is;
		this.type = type;
		mode = "DISPOSESTREAM";
	}

	public StreamHandler(InputStream is, String type, String mode) {
		this.is = is;
		this.type = type;
		this.mode = mode;
	}

	public void setMode(String mode) {
		this.mode = mode;
	}

	public void run() {
		try {
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader br = new BufferedReader(isr);
			if (mode.equals("PRINTSTREAM")) {
				if (Launcher.coalesce) {
					String prev = null;
					String current = null;
					while ((current = br.readLine()) != null) {
						if (!current.equals(prev)) {
							System.out.println(type + ">" + current);
							prev = current;
						}
					}
				} else {
					String line = null;
					while ((line = br.readLine()) != null) {
						System.out.println(type + ">" + line);
					}
				}
			}
			if (mode.equals("DISPOSESTREAM")) {

			}
			br.close();
			isr.close();
		} catch (IOException ex) {
			ex.printStackTrace();
		}
	}
}
