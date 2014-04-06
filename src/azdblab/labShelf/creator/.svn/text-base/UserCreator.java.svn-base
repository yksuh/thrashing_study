//
// This whole class may not be needed any longer
//

/*
 * Copyright (c) 2012, Arizona Board of Regents
 * 
 * See LICENSE at /cs/projects/tau/azdblab/license
 * See README at /cs/projects/tau/azdblab/readme
 * AZDBLab, http://www.cs.arizona.edu/projects/focal/ergalics/azdblab.html
 * This is a Laboratory Information Management System
 * 
 * Authors:
 * Benjamin Dicken (benjamindicken.com, bddicken@gmail.com)
 * 
 * What needs to still be added to this class:
 *   -- Need to add logging of errors to the AZDBLab loggers.
 *   -- Removal of users... need to implement.
 */

package azdblab.labShelf.creator;

import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.util.List;
import java.util.Vector;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTextField;

import javax.swing.WindowConstants;
import javax.swing.border.TitledBorder;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.*;

import azdblab.Constants;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.User;

/**
 * This code was edited or generated using CloudGarden's Jigloo SWT/Swing GUI
 * Builder, which is free for non-commercial use. If Jigloo is being used
 * commercially (ie, by a corporation, company or business for any purpose
 * whatever) then you should purchase a license for each developer using Jigloo.
 * Please visit www.cloudgarden.com for details. Use of Jigloo implies
 * acceptance of these licensing terms. A COMMERCIAL LICENSE HAS NOT BEEN
 * PURCHASED FOR THIS MACHINE, SO JIGLOO OR THIS CODE CANNOT BE USED LEGALLY FOR
 * ANY CORPORATE OR COMMERCIAL PURPOSE.
 */
public class UserCreator extends javax.swing.JFrame {

	static final long serialVersionUID = System.identityHashCode("UserCreator");

	private JPanel pan_UserCreate;
	private JLabel jLabel1;
	private JLabel jLabel3;
	private JLabel jLabel4;
	private JLabel jLabel5;
	private JScrollPane scrp_view;
	private JCheckBox su_User_Check;
	private JButton btn_Quit;
	private JButton btn_Generate;
	private JTextField txt_Password;
	private JList userList;

	public UserCreator() {
		super();
		initNewGUI();
	}

	private void initNewGUI() {
		try {
			setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
			getContentPane().setLayout(null);
			this.setTitle("User Creator");

			JTabbedPane tabbedPane = new JTabbedPane();
			tabbedPane.setBounds(0, 0, 470, 525);

			pan_UserCreate = new JPanel();
			pan_UserCreate.setBounds(14, 14, 470, 525);
			pan_UserCreate.setBorder(BorderFactory.createTitledBorder(null, null,
					TitledBorder.LEADING, TitledBorder.TOP));
			pan_UserCreate.setLayout(null);
			{
				pan_UserCreate = new JPanel();
				getContentPane().add(pan_UserCreate);
				pan_UserCreate.setBounds(14, 14, 427, 429);
				pan_UserCreate.setBorder(BorderFactory.createTitledBorder(null,
						"Create user", TitledBorder.LEADING, TitledBorder.TOP));
				pan_UserCreate.setLayout(null);
				{
					jLabel4 = new JLabel();
					jLabel4.setText("");
					jLabel4.setForeground(Color.red);
					pan_UserCreate.add(jLabel4);
					jLabel4.setBounds(14, 270, 300, 28);
				}
				{
					jLabel1 = new JLabel();
					pan_UserCreate.add(jLabel1);
					jLabel1.setText("Select User to create login for:");
					jLabel1.setBounds(14, 59, 250, 22);
				}
				{
					Vector<String> u = this.getUsers("");
					if (u.size() == 0)
						jLabel4.setText("all users already have logins!");
					userList = new JList(u);
					scrp_view = new JScrollPane(userList);
					pan_UserCreate.add(scrp_view);
					scrp_view.setBounds(14, 85, 200, 100);
				}
				{
					jLabel3 = new JLabel();
					pan_UserCreate.add(jLabel3);
					jLabel3.setText("Choose a password");
					jLabel3.setBounds(14, 190, 300, 28);
				}
				{
					txt_Password = new JTextField();
					pan_UserCreate.add(txt_Password);
					txt_Password.setBounds(15, 225, 399, 26);
				}
				{
					jLabel5 = new JLabel();
					pan_UserCreate.add(jLabel5);
					jLabel5.setText("<html> <p> If a user already has an account in a different Lab Shelf, their previous password will be kept.</p> </html>");
					jLabel5.setBounds(14, 290, 400, 80);
				}
				{
					su_User_Check = new JCheckBox();
					pan_UserCreate.add(su_User_Check);
					su_User_Check.setText("Super User?");
					su_User_Check.setBounds(14, 29, 154, 24);
					su_User_Check.setSelected(false);
					su_User_Check.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							boolean isSel = (su_User_Check.isSelected());
							su_User_Check.setSelected(isSel);
						}
					});
				}
			}
			{
				btn_Generate = new JButton();
				pan_UserCreate.add(btn_Generate);
				btn_Generate.setText("Submit");
				btn_Generate.setBounds(73, 449, 133, 28);
				btn_Generate.addActionListener(new ActionListener() {
					public void actionPerformed(ActionEvent evt) {
						createUserLogin((String)userList.getSelectedValue());
					}
				});
			}
			{
				btn_Quit = new JButton();
				pan_UserCreate.add(btn_Quit);
				btn_Quit.setText("Quit");
				btn_Quit.setBounds(245, 449, 133, 28);
				btn_Quit.addActionListener(new ActionListener() {
					public void actionPerformed(ActionEvent evt) {
						btn_QuitActionPerformed(evt);
					}
				});
			}
			tabbedPane.addTab("User Creator", pan_UserCreate);
			tabbedPane.setTabLayoutPolicy(JTabbedPane.SCROLL_TAB_LAYOUT);

			pack();
			getContentPane().add(tabbedPane);
			this.setSize(500, 570);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Create a user login XML file (or modify an existing one) with the
	 * information that the user filled out inside of the Create User dialog.
	 * 
	 * @author Benjamin Dicken
	 * @return a boolean. If creation was successful return true, else false
	 */
	private boolean createUserLogin(String userFileName)
	{
		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		String up = "/cs/projects/tau/installations/azdblab/logins/" + userFileName + ".xml";
		File fXmlFile = new File(up);
		
		// Check if all the fields of the form are filled out
		boolean fieldsNotFilledOut = false;
		if(txt_Password.getText().equals("") ||
		   userList.getSelectedValue() == null) {
			fieldsNotFilledOut = true;
		}
		if(fieldsNotFilledOut) {
			JOptionPane.showMessageDialog(null, "Please fill out all fields.", "Empty Fields", JOptionPane.ERROR_MESSAGE);
			return false;
		}
		
		// add a LH version to the user's login xml file
		if(fXmlFile.exists()) 
		{
			try 
			{
				DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
				Document doc2 = dBuilder.parse(fXmlFile);
				doc2.getDocumentElement().normalize();
				
				Element nList = doc2.getDocumentElement();
				
				Element rootElement = doc2.createElement("version");
				nList.appendChild(rootElement);
				Element attr = doc2.createElement("v");
				attr.appendChild(doc2.createTextNode(Constants.AZDBLAB_VERSION));  // GET THE CURRENT VERSION DYNAMICALLY
				rootElement.appendChild(attr);
				
				// write the content into xml file
				TransformerFactory transformerFactory = TransformerFactory
						.newInstance();
				Transformer transformer = transformerFactory.newTransformer();
				DOMSource source = new DOMSource(doc2);
	
				StreamResult result = new StreamResult(fXmlFile);
				transformer.transform(source, result);
			} catch (Exception e) {
				JOptionPane.showMessageDialog(null, "An error occured while adding this user.", "Error", JOptionPane.ERROR_MESSAGE);
				e.printStackTrace();
				return false;
			}
		}
		
		// Create new XML file for the selected user
		else {
			try {
				DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
				Document doc = dBuilder.newDocument();
				
				Element nList = doc.createElement("user");
				doc.appendChild(nList);
				
				// Create the user name XML element
				Element e1 = doc.createElement("username");
				nList.appendChild(e1);
				Encryptor enc = new Encryptor((String)userList.getSelectedValue());
				String eU = enc.encrypt((String)userList.getSelectedValue());          /// USER NOW ENCRYPTED, MUST ALSO CHANGE UserManajer.java
				e1.appendChild(doc.createTextNode(eU));
				
				// Create the password XML element
				// need to implement password encryption
				Element e2 = doc.createElement("password");
				nList.appendChild(e2);
				enc = new Encryptor(txt_Password.getText());
				String eP = enc.encrypt(txt_Password.getText());
				e2.appendChild(doc.createTextNode(eP));
				
				// Create the super-user XML element
				Element e4 = doc.createElement("superuser");
				nList.appendChild(e4);
				String su = (su_User_Check.isSelected() == true)? "y" : "n";
				e4.appendChild(doc.createTextNode(su));
				
				// Create the version
				Element e3 = doc.createElement("version");
				nList.appendChild(e3);
				Element attr = doc.createElement("v");
				attr.appendChild(doc.createTextNode(Constants.AZDBLAB_VERSION));  // GET THE CURRENT VERSION DYNAMICALLY
				e3.appendChild(attr);
				
				// write the content into xml file
				TransformerFactory transformerFactory = TransformerFactory
						.newInstance();
				Transformer transformer = transformerFactory.newTransformer();
				DOMSource source = new DOMSource(doc);
	
				StreamResult result = new StreamResult(fXmlFile);
				transformer.transform(source, result);
			} catch(Exception e) {
				JOptionPane.showMessageDialog(null, "An error occured while adding this user.", "Error", JOptionPane.ERROR_MESSAGE);
				e.printStackTrace();
				return false;
			}
		}
		
		JOptionPane.showMessageDialog(null, "User \""+ (String)userList.getSelectedValue() + "\" was added successfully!", "User Created", JOptionPane.PLAIN_MESSAGE);

		this.updateCreateUI();
		
		return true;
	}

	/**
	 * Returns a Vector<String> of all users who do not already have a login xml
	 * file for this version of AZDBLab.  The login XML files are located in the
	 * directory /cs/projects/tau/installations/azdblab/logins, which may change
	 * down the road.
	 * 
	 * @param path
	 * @author Benjamin Dicken
	 * @return
	 */
	private Vector<String> getUsers(String path) {

		Vector<String> users = User.getAllUserNames();
		Vector<String> usersReturn = User.getAllUserNames();

		try {
			File usersXML = new File("/cs/projects/tau/installations/azdblab/logins/");
			File[] allUsers = usersXML.listFiles();

			for (File fXmlFile : allUsers) {
				// Check if user already has an xml file for the currently running LS version
				for (String u : users) {
					if ((u + ".xml").compareTo(fXmlFile.getName()) == 0) {

						List<String> verNames = LabShelfManager.getShelf()
								.getVersionNames();

						// Make sure to not read hidden files
						if (fXmlFile.getName().charAt(0) != '.') {
							DocumentBuilderFactory dbFactory = DocumentBuilderFactory
									.newInstance();
							DocumentBuilder dBuilder = dbFactory
									.newDocumentBuilder();
							Document doc = dBuilder.parse(fXmlFile);
							doc.getDocumentElement().normalize();

							NodeList nList = doc.getElementsByTagName("version");

							boolean isInLSVer = false;
							for (String v : verNames) {
								for (int temp = 0; temp < nList.getLength(); temp++) {
									Node nNode = nList.item(temp);
									if (nNode.getNodeType() == Node.ELEMENT_NODE) {
										Element eElement = (Element) nNode;
										if (getTagValue("v", eElement).compareTo(v) == 0) {
											isInLSVer = true;
										}
									}
								}
							}
							if (isInLSVer == true)
								usersReturn.remove(u);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return usersReturn;
	}

	private static String getTagValue(String sTag, Element eElement) {
		NodeList nlList = eElement.getElementsByTagName(sTag).item(0)
				.getChildNodes();
		Node nValue = (Node) nlList.item(0);
		return nValue.getNodeValue();
	}

	private void btn_QuitActionPerformed(ActionEvent evt) {
		this.dispose();
	}
	
	/**
	 * Updates all of the dynamic portions of the user creation dialog box.
	 * 
	 * @author Benjamin Dicken
	 * @return void
	 */
	private void updateCreateUI() {	
		
		// Refresh the users list
		scrp_view.remove(userList);
		pan_UserCreate.remove(scrp_view);
		Vector<String> u = this.getUsers("");
		userList = new JList(u);
		txt_Password.setText("");
		scrp_view = new JScrollPane(userList);	
		pan_UserCreate.add(scrp_view);
		scrp_view.setBounds(14, 85, 200, 100);scrp_view.setBounds(14, 85, 200, 100);
		
		u = this.getUsers("");
		if (u.size() == 0) {
			jLabel4.setText("all users already have logins!");
		}
		
		pan_UserCreate.validate();
	}
	
}
