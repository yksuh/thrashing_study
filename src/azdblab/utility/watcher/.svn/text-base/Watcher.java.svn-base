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
import java.util.ArrayList;

import javax.management.JMX;
import javax.management.MBeanServerConnection;
import javax.management.Notification;
import javax.management.NotificationListener;
import javax.management.ObjectName;
import javax.management.remote.JMXConnector;
import javax.management.remote.JMXConnectorFactory;
import javax.management.remote.JMXServiceURL;
import javax.swing.JOptionPane;

import azdblab.utility.logger.AZDBLabLogger;

/**
 * Class responsible for watching the application and handling notifications and
 * loss of connection with the application.
 * 
 * @author jendempsey
 * 
 */
public class Watcher {
	/**
	 * Inner class that will handle the notifications. If coalesce is true only
	 * the first of a series of consecutive identical notifications will be
	 * 
	 * The Default is to print Notification info.
	 */
	public static class ClientListener implements NotificationListener {
		private LoadSettings settings = new LoadSettings();
		private AZDBNotification prev = null;
		public File file;

		public static String mName;
		public static String dbms;

		public void handleNotification(Notification notification,
				Object handback) {
			// echo("Notifications being received...");
			Watcher.setRun(true);
		
			Launcher.expectHeartbeats = true;
			// notification.getType());
			if (notification instanceof AZDBNotification) {
				AZDBNotification san = (AZDBNotification) notification;
				san = ParseNotification.formatNotification(san);
				
				// echo("Notifications type2" + san.getAction());
				try {
					// echo(""+(san.getAction()==AZDBNotification.PRINTNOTIFICATION));
					if (san.getAction() == AZDBNotification.PRINTNOTIFICATION) {
						// echo("NOTIFICATION RECEIVED" );
						if (Launcher.coalesce
								&& ((prev != null) && !(prev.equals(san)))) {
							echo("\nReceived notification:");
							echo("\tClassName: "
									+ notification.getClass().getName());
							echo("\tSource: " + notification.getSource());
							echo("\tType: " + notification.getType());
							echo("\tMessage: " + notification.getMessage());
						} else if (!Launcher.coalesce) {
							echo("\nReceived notification:");
							echo("\tClassName: "
									+ notification.getClass().getName());
							echo("\tSource: " + notification.getSource());
							echo("\tType: " + notification.getType());
							echo("\tMessage: " + notification.getMessage());
						} else {
							System.out.println("we're here!!");
						}
						System.out.println("print notification");
						// JOptionPane.showMessageDialog(null,
						// notification.getMessage());
						watcherLog.outputLog(san.toString());
					} else if (san.getAction() == AZDBNotification.DONOTHING) {
						echo("heartbeat received and handled correctly");
					}
					
					else if(san.getAction() == AZDBNotification.ANNOUNCENOTIFICATION){
						mName = san.getMachinName();
						dbms= san.getDbms();
						watcherLog.outputLog(san.toString());
					}
					
					else if (san.getAction() == AZDBNotification.EMAILNOTIFICATION) {
						echo("We're supposed to have email!");
						watcherLog.outputLog(san.toString());
						if (!(Launcher.coalesce) || ((prev != null) && !(prev.equals(san)))) {
							System.out.println("email should be sent*****1!");
							ArrayList<String> emails = new ArrayList<String>();
							emails = settings.getEmails();
							if (emails != null) {
								SendMail message = new SendMail(
										settings.getEmails(), san.getMessage()+ "\n DBMS: "+dbms+"\n machine" +
												"Name: "+mName,
										"[Watcher Notification]");
							} else {
								echo("\n Received Email Notification, no email addresses given");
							}
						} else {
							System.out.println("email should be sent****2!");
						}
					} else {
//						System.out.println("wrong place...");
					}
					prev = san;
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}

			else {
				// System.out.println("notification type3: " +
				// notification.getType());
				// echo("\nIncorrect notification received...");
				// echo("\nReceived notification:");
				// echo("\tClassName: " + notification.getClass().getName());
				// echo("\tSource: " + notification.getSource());
				// echo("\tType: " + notification.getType());
				// echo("\tMessage: " + notification.getMessage());
			}
		}
	}

	final static int DONOTHING = 1;
	final static int PRINT = 2;
	final static int EMAIL = 3;
	public static ArrayList<String> emailAddress;
	private static String handleOnClose = "PRINT";
	private static boolean run;
	public static AZDBLabLogger watcherLog;
	public static void main(String[] args) {
		String mbname = "";
		String port = "";
		String machineName ="";
		String dbmsName ="";
		String startDate ="";
		LoadSettings settings = new LoadSettings();
		emailAddress = settings.getEmails();
		for (int i = 0; i < args.length; ++i) {
			if (args[i].equals("-onclose")) {
				i++;
				handleOnClose = (args[i]);
				handleOnClose = handleOnClose.trim();
			} else if (args[i].equals("-mbeanname")) {
				i++;
				mbname = args[i];
			} else if (args[i].equals("-port")) {
				i++;
				port = args[i];
			}else if (args[i].equals("-machineName")) {
				i++;
				machineName = args[i];
			}else if (args[i].equals("-dbmsName")) {
				i++;
				dbmsName = args[i];
			}else if (args[i].equals("-startDate")) {
				i++;
				startDate = args[i];
			}
				
		}
		
		String logfilename= "azdb_"+machineName+"_"+dbmsName+"_"+startDate;
		watcherLog = new AZDBLabLogger("watcher");
		try {
			watcherLog.setAZDBLabAppender("",System.currentTimeMillis()+"","watcher",logfilename);
		} catch (IOException e) {
			// e.printStackTrace();
			System.err.println("Appender cannot be created due to permission.");
					System.err.println("Please retry again.");
		}
		watcherLog.setAZDBLabLoggerName(logfilename);
		
		echo("handleOnClose = " + handleOnClose);
		JMXConnector jmxc = null;
		boolean isConnected = false;
		// watcher will attempt to connect with the executor 10 times,
		// when it is first initializing before handling the inability to
		// connect
		int numOfTries = 0;
		while (!isConnected) {
			try {
				// echo("watcher started");
				// Establish connection with JMX server and register to recieve
				// notifications
				JMXServiceURL url = new JMXServiceURL(
						"service:jmx:rmi:///jndi/rmi://:" + port + "/jmxrmi");
				jmxc = JMXConnectorFactory.connect(url, null);

				ClientListener listener = new ClientListener();

				MBeanServerConnection mbsc = jmxc.getMBeanServerConnection();

				ObjectName mbeanName = new ObjectName(mbname);

//				ExecutorMBean mbeanProxy = JMX.newMBeanProxy(mbsc, mbeanName,
//						ExecutorMBean.class, true);

				mbsc.addNotificationListener(mbeanName, listener, null, null);

				// wait set amount of time for notification. if none is
				// Received then send email to list, or print
				// echo("CONNECTED");
				isConnected = true;
				numOfTries = 11;
				setRun(true);
				// sleep(30000);
				int i = 0;
				// watcher will continue running if it receives a heartbeat
				// notification
				// or if the executor has not yet been started.

				while (getRun()) {
					setRun(false);
					sleep(5002);
					// echo("before if heartbeats: " + getRun() + " / " +
					// Launcher.expectHeartbeats);
					if (!Launcher.expectHeartbeats)
						setRun(true);
					// echo("after if heartbeats: " + getRun() + " / " +
					// Launcher.expectHeartbeats);
				}
				// echo("Out of getRun()....");
				// If this point is reached, DBMS could have hung or shut down
				// and should be
				// checked
				watcherLog.outputLog("Watcher is no longer receiving heartbeats.");
				if (handleOnClose.equals("PRINT")) {

					echo("No more heartbeats are being sent");

				} else if (handleOnClose.equals("DONOTHING")) {

				} else if (handleOnClose.equals("EMAIL")) {
					if (emailAddress.isEmpty())
						echo("No email reciepents given");
					else {
						echo("Email will be sent...");
						SendMail message = new SendMail(
								emailAddress,
								"The executor on "
										+  ClientListener.mName+  " (" + ClientListener.dbms
										+ ") is no longer sending heartbeats.  Watcher has"
										+ "closed and the DBMS should be checked.",
								"[Watcher Notification]");
						echo("Done ...");
					}
				}
				jmxc.close();
				System.exit(0);
			}

			catch (Exception ex) {
				

				if (numOfTries <= 10) {
					watcherLog.outputLog("Watcher is attempting to reconnect.");
					sleep(3000);
					numOfTries++;
				} else {
					watcherLog.outputLog("Exception thrown in watcher" + ex.getStackTrace());
					isConnected = true;

					if (handleOnClose.equals("PRINT")) {
						echo("You have been disconnected.");
						// JOptionPane.showMessageDialog(null,
						// "Executor has stopped",
						// "Error", JOptionPane.ERROR_MESSAGE);
					} else if (handleOnClose.equals("DONOTHING")) {

					} else if (handleOnClose.equals("EMAIL")) {
						if (emailAddress.isEmpty())
							echo("No email reciepents given");
						else {
							echo("Email will be sent...");
							SendMail message = new SendMail(
									emailAddress,
									"The connection between "
											+ "watcher and the executor on "
											+  ClientListener.mName +  " (" + ClientListener.dbms
											+ ") has failed.  Watcher is no" +
											"longer running.", "[Watcher Notification]");
							echo("Done ...");
						}
					}
				}

				try {
					// if any attempt to connect throws any exception ensure
					// that
					// the connection is closed
					jmxc.close();
					echo("\nClose the connection to the server");

				} catch (IOException e) {
					echo("Connection Closed");
				}
			}
		//	System.out.println("Out of loop....");

		}
	}

	private static void echo(String msg) {
		System.out.println(msg);
	}

	private static void setRun(boolean bool) {
		run = bool;
	}

	private static boolean getRun() {
		return run;
	}

	private static void sleep(int millis) {
		try {
			Thread.sleep(millis);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

}
