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
import java.io.IOException;
import java.net.ServerSocket;
import java.util.ArrayList;
import java.util.Date;

import javax.management.InstanceAlreadyExistsException;
import javax.management.MBeanRegistrationException;
import javax.management.MalformedObjectNameException;
import javax.management.NotCompliantMBeanException;

import azdblab.executable.Main;

public class Launcher {
	//default of coalesce is ture, so duplicate messages aren't printed
	public static boolean coalesce = true;
	public LoadSettings settings;
	public static String machineName;
	public static String dbmsName;
	public static boolean executorRunning =false;
	public static boolean expectHeartbeats = false;

	public Launcher(String expUserName, String expPassword, String machineName,
			String dbmsName, String current_version)
			throws MalformedObjectNameException, NullPointerException,
			InstanceAlreadyExistsException, MBeanRegistrationException,
			NotCompliantMBeanException, InterruptedException {
		this.machineName = machineName;
		this.dbmsName= dbmsName;
		final String LAB_USERNAME;
		final String LAB_PASSWORD;
		final String LAB_CONNECTSTRING;
		Date startDate = new Date();
		settings = new LoadSettings();
		setCoalesce();

		LAB_USERNAME = Main.getLABUSERNAME();
		LAB_PASSWORD = Main.getLABPASSWORD();
		LAB_CONNECTSTRING = Main.getLABCONNECTSTRING();
		//SendMail x = new SendMail(settings.getEmails(), "Test", "email test");
		//  find an available port to establish a
		// connection between watcher and the application.
		String port = "";
		try {
			ServerSocket s = new ServerSocket(0);
			port = s.getLocalPort() + "";
			s.close();
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		// mbeanname indicates the type of MBean that will be created 
		// should be set through the settings file.  
		String mbeanname = "src:type=Executor";
		if (settings.get("-mbeanname") != null)
			mbeanname = settings.get("-mbeanname");

		
		ArrayList<String> appArgs = new ArrayList<String>();
		appArgs.add("java");
		//Arguments needed to allow for a connection with jmxserver
		appArgs.add("-Dcom.sun.management.jmxremote.port=" + port);
		appArgs.add("-Dcom.sun.management.jmxremote.authenticate=false");
		appArgs.add("-Dcom.sun.management.jmxremote.ssl=false");
		appArgs.add("-cp");
		appArgs.add("azdblab.jar");
		appArgs.add("azdblab.utility.watcher.RegisterMBean");
		//arguments needed to initialize executor
		appArgs.add("-mbeanname");
		appArgs.add(mbeanname);
		appArgs.add("-expUserName");
		appArgs.add(expUserName);
		appArgs.add("-expPassword");
		appArgs.add(expPassword);
		appArgs.add("-machineName");
		appArgs.add(this.machineName);
		appArgs.add("-dbmsName");
		appArgs.add(this.dbmsName);
		appArgs.add("-LABUSERNAME");
		appArgs.add(LAB_USERNAME);
		appArgs.add("-LABPASSWORD");
		appArgs.add(LAB_PASSWORD);
		appArgs.add("-LABCONNECT");
		appArgs.add(LAB_CONNECTSTRING);
		appArgs.add("-current_version");
		appArgs.add(current_version);
		final ProcessBuilder application = new ProcessBuilder(appArgs);
		application.redirectErrorStream(true);

		ArrayList<String> appArgs2 = new ArrayList<String>();
		appArgs2.add("java");
		appArgs2.add("-cp");
		appArgs2.add("azdblab.jar");
		appArgs2.add("azdblab.utility.watcher.Watcher");
		// -onclose indicates what watcher should do in case the connection
		//between the application and the server is closed.
		appArgs2.add("-onclose");
		appArgs2.add(settings.get("-onclose"));
		appArgs2.add("-mbeanname");
		appArgs2.add(mbeanname);
		appArgs2.add("-port");
		appArgs2.add(port);
		appArgs.add("-machineName");
		appArgs.add(this.machineName);
		appArgs.add("-dbmsName");
		appArgs.add(this.dbmsName);
		appArgs.add("-startDate");
		appArgs.add(startDate.toString().replace(' ', '_'));
		final ProcessBuilder watcher = new ProcessBuilder(appArgs2);
		watcher.redirectErrorStream(true);

		try {
			Thread thread1 = new Thread() {
				//proc1 = runs executor, proc2 =watcher
				public void run() {
					Process proc1;
					try {
						proc1 = application.start();
						StreamHandler appGobbler = new StreamHandler(
								proc1.getInputStream(), "application");
						appGobbler.setMode(settings.get("-outstream"));
						appGobbler.run();
					} catch (IOException e) {
						e.printStackTrace();
					}

				}
			};
			Thread thread2 = new Thread() {
				public void run() {
					Process proc2;
					try {
						proc2 = watcher.start();
						StreamHandler watchGobbler = new StreamHandler(
								proc2.getInputStream(), "watcher");
						watchGobbler.setMode(settings.get("-outstream"));
						watchGobbler.run();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}

				}
			};
			thread1.start();
			Thread.sleep(15000);

			thread2.start();

		} catch (Exception ex) {
			ex.printStackTrace();
		}

	}

	private void setCoalesce() {
//		String bool = settings.get("-onclose");
//		coalesce = Boolean.parseBoolean(bool);
		coalesce = true;
	}

}
