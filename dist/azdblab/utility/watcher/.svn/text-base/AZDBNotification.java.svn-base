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
import java.util.ArrayList;

import javax.management.Notification;
/**
 * Notification class for AZDBLab that allows for individual notifications to 
 * be handled differently.  
 * 
 * If not specified the default action is to do nothing upon reciving the notification.
 * @author jendempsey
 *
 */
public class AZDBNotification extends Notification{
	private static final long serialVersionUID = 1L;

	private long timeStamp;
	private String message;
	private String processID;
	private String filename;
	public final static int DONOTHING =1;
	public final static int PRINTNOTIFICATION=2;
	public final static int EMAILNOTIFICATION=3;
	public final static int ANNOUNCENOTIFICATION=4;
	private static int how_to_handle;
	private String machineName;
	private String DBMS;
	
	/**
	 * Generic notification, Used as heartbeat notification
	 * @param type
	 * @param source
	 * @param sequenceNumber
	 */
	public AZDBNotification(String type, Object source, long sequenceNumber) {
		super(type, source, sequenceNumber);
		timeStamp=0;
		message=null;
		how_to_handle= DONOTHING;
	}
	
	public AZDBNotification(Object source, long sequenceNumber, long time, String message){
		super("AZDBNotification", source, sequenceNumber);
		this.message = message;
		timeStamp=time;
	}
	
	public AZDBNotification(Object source, long sequenceNumber, long time, String processID, String message, 
			int action) {
		super("AZDBNotification", source, sequenceNumber);
		timeStamp=time;
		this.message=message;
		how_to_handle=action;
//		System.out.println(action + " Notification type");
	}
	
	public AZDBNotification(Object source, long sequenceNumber, long time, String processID, String identifier, 
			String filename, int action) {
		super("AZDBNotification", source, sequenceNumber);
		timeStamp=time;
		this.message=identifier;
		how_to_handle=action;
		this.processID = processID;
		this.filename = filename;
		if(action==4)
			this.setInfo();
//		System.out.println(action + " Notification type");
	}
	
	public boolean equals(AZDBNotification other){
			
			return (this.toString().equals(other.toString()));
		
	}
	public String toString(){
		if(getAction() !=4){
			return  "Process ID" + getProcessID()
					+"/nType: " + super.getType()
					+"/nSource: " +super.getSource()
					+"/n SeqNumber: "+ super.getSequenceNumber()
					+"/n Time: " + getTimeStamp()
					+"/n Message" + getMessage()
					+ "/n Action" + getAction();
		}else{
			return "Process ID" + getProcessID()
					+"/nType: " + super.getType()
					+"/nSource: " +super.getSource()
					+"/n SeqNumber: "+ super.getSequenceNumber()
					+"/n Time: " + getTimeStamp()
					+"/n Identifier" + getMessage()
					+"/n Filename" + getFilename()
					+ "/n Action" + getAction();
		}
		
	}
	
	public long getTimeStamp(){
		return timeStamp;
	}
	
	public String getMessage(){
		return message;
	}

	public int getAction(){
		
		return how_to_handle;
	}
	
	public String getProcessID(){
		return this.processID;
	}
	public String getFilename(){
		return filename+message.replace(' ', '_')+source.toString()+processID+ timeStamp;
	}
	public void setInfo(){
		 String[] info = message.split("\\s+");
		 this.machineName=info[0];
		 this.DBMS=info[1];
	}
	public String getMachinName(){
		return machineName;
	}
	public String getDbms(){
		return this.DBMS;
	}
	
}
