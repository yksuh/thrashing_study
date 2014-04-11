package azdblab.utility.watcher;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
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
public class SendMail {
	public SendMail(ArrayList<String> recipients, String emailbody, String subject){
		String sender = "tauproject@sodb7.cs.arizona.edu";
		//System.out.println("IN EMAIL class");
		String host ="sodb7@cs.arizona.edu";
		
		Properties properties = System.getProperties();
		
		properties.setProperty("smtp.cs.arizona.edu", host);
		
		Session session = Session.getDefaultInstance(properties);
		
		
		try {
			MimeMessage message = new MimeMessage(session);
			message.setFrom(new InternetAddress(sender));
			for(int i = 0; i<recipients.size(); i++){
				message.addRecipient(Message.RecipientType.TO, 
						new InternetAddress(recipients.get(i)));
			}
			message.setSubject(subject);
			message.setText(emailbody);
			
			Transport.send(message);
			
			
		} catch (AddressException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}
