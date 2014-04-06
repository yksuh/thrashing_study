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
import java.lang.management.ManagementFactory;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Vector;

import javax.management.InstanceAlreadyExistsException;
import javax.management.MBeanRegistrationException;
import javax.management.MBeanServer;
import javax.management.MalformedObjectNameException;
import javax.management.NotCompliantMBeanException;
import javax.management.ObjectName;

import azdblab.Constants;
import azdblab.executable.Executor;
import azdblab.executable.Main;
import azdblab.plugins.MasterPluginManager;
import azdblab.plugins.PluginData;

/**
 * Registers the application with the JMX server and 
 * re-initializes necessary variables. 
 * @author jendempsey
 *
 */
public class RegisterMBean {
	public static Executor executor;
	 public static void main(String[] args)   throws InstanceAlreadyExistsException, MBeanRegistrationException, NotCompliantMBeanException, MalformedObjectNameException, NullPointerException, InterruptedException{
		 String mbname ="";
		 String expUserName = null;
		 String expPassword= null;
		 String connectString = null;
		String dbmsName =null;		 
		 String LAB_USERNAME=null;
	     String LAB_PASSWORD=null;
		 String LAB_CONNECTSTRING=null;
		 String  current_version=null;
		 for (int i = 0; i < args.length; ++i) {
			 if (args[i].equals("-mbeanname")){
				 i++; 
				 mbname= args[i];
			 }else if (args[i].equals("-expUserName")){
				 i++; 
				 expUserName= args[i];
			 }
			 else if (args[i].equals("-expPassword")){
				 i++; 
				 expPassword= args[i];
			 }else if (args[i].equals("-machineName")){
				 i++; 
				 connectString = args[i];
			 }else if (args[i].equals("-dbmsName")){
				 i++; 
				 dbmsName= args[i];
			 }else if (args[i].equals("-LABUSERNAME")){
				 i++; 
				 LAB_USERNAME= args[i];
			 }else if (args[i].equals("-LABPASSWORD")){
				 i++; 
				 LAB_PASSWORD= args[i];
			 }else if (args[i].equals("-LABCONNECT")){
				 i++; 
				 LAB_CONNECTSTRING= args[i];
			 }else if (args[i].equals("-current_version")){
				 i++; 
				 current_version= args[i];
			 }
			
		 }
		 
		 File tempDir = new File(Constants.DIRECTORY_TEMP);
			if (!tempDir.exists()) {
				tempDir.mkdir();
			}
			
			try {
				Constants.LoadSchemas();
			} catch (Exception ex) {
				ex.printStackTrace();
				System.exit(3);
			}
			Main.masterManager = new MasterPluginManager();
			Main.populateDBMSListing();
		 Main.setAZDBLabLogger(Constants.AZDBLAB_EXECUTOR);
		 Main.setLABCONNECTSTRING(LAB_CONNECTSTRING);
		 Main.setLABPASSWORD(LAB_PASSWORD);
		 Main.setLABUSERNAME(LAB_USERNAME);
		 Constants.setCurrentVersion(current_version);
		 Constants.ChooseProperSchema(current_version);
			
		 MBeanServer mbs = ManagementFactory.getPlatformMBeanServer();
		 ObjectName mbeanName = new ObjectName(mbname);
		 String machineName = "";
		try {
			machineName = InetAddress.getLocalHost().getHostName();
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		 //creates a new instance of the application. This line must be 
		 //altered when implementing watcher.
		executor = new Executor(expUserName, expPassword,
				machineName, connectString, dbmsName);
		 mbs.registerMBean(executor, mbeanName);
		 //System.out.println("REGISTERED EXECUTOR (registerMBean)");
		 //starts the application, and must be changed accordingly when
		 //watcher is implemented for other applications.
//		 Launcher.expectHeartbeats=true;
		 executor.execute();
		 
		 /***
		  * Young: Why do we want to have this?
		  */
		 try {
			Thread.sleep(Long.MAX_VALUE);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
}
