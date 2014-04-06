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
 * This class is used by AjaxManager to validate user logins for mobile and web 
 * applications. User logins are stored as XML files and are located at 
 * /cs/projects/tau/installations/azdblab/logins on sodb7.
 * 
 */

package azdblab;

import java.io.File;
import java.util.List;
import java.util.Vector;

import javax.swing.JOptionPane;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import azdblab.labShelf.creator.Encryptor;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.User;

public class LoginManager {

	public LoginManager() {
		// do nothing
	}

	/**
	 * Gets all the Lab Shelf versions that this user is allowed to log into
	 * 
	 * @param user
	 * @param pass
	 * @return
	 */
	public static Vector<String> getShelvesForUser(Document doc) {

		List<String> verNames = LabShelfManager.getShelf().getVersionNames();
		Vector<String> lSV = new Vector<String>();

		try {
			if (doc == null) {
				throw new NullPointerException();
			}

			// Add all valid LS versions for this user to the lSV data structure
			NodeList nList = doc.getElementsByTagName("v");
			for (String v : verNames) {
				
				for (int temp = 0; temp < nList.getLength(); temp++) {
					
					Node nNode = nList.item(temp);
					
					if (nNode.getNodeType() == Node.ELEMENT_NODE) {
						Element eElement = (Element) nNode;
						if (eElement.getChildNodes().item(0).getNodeValue().compareTo(v) == 0) {
							lSV.add(v);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

		return lSV;
	}

	/**
	 * Returns the XML document for the given user credentials. If there is no
	 * matching file for the credentials, return null;
	 * 
	 * @param username
	 * @param pass
	 * @return
	 */
	public static Document getUserLoginXML(String username, String pass) {
		try {
			File usersXML = new File(
					"/cs/projects/tau/installations/azdblab/logins/");
			File[] allUsers = usersXML.listFiles();

			for (File fXmlFile : allUsers) {
				// Check if user already has an xml file for the currently
				// running LS version
				if ((username + ".xml").compareTo(fXmlFile.getName()) == 0) {
					DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
					DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
					Document doc = dBuilder.parse(fXmlFile);
					doc.getDocumentElement().normalize();

					// Check if password is correct
					Element e = doc.getDocumentElement();
					Encryptor enc = new Encryptor(pass);
					String passHash = enc.encrypt(pass);
					passHash = enc.encrypt(pass);
					
					if (!(passHash.equals(getTagValue("password", e)))) {
						return null;
					} else {
						return doc;
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		return null;
	}
	
	/**
	 * Checks if users is a super-user
	 * 
	 * @param userConstants.AZDBLAB_VERSION
	 * @param pass
	 * @return
	 */
	public static String getSUSForUser(Document doc) {
		try {
			if (doc == null) 
				throw new NullPointerException();
			
			// Add all valid LS versions for this user to the lSV data structure
			NodeList nList = doc.getElementsByTagName("superuser");
			Node nNode = nList.item(0);
					
			if (nNode.getNodeType() == Node.ELEMENT_NODE) {
				Element eElement = (Element) nNode;
				return eElement.getChildNodes().item(0).getNodeValue();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "n";
	}

	

	/**
	 * Create a user login XML file (or modify an existing one) with the
	 * information that the user filled out inside of the Create User dialog.
	 * 
	 * @author Benjamin Dicken
	 * @return a boolean. If creation was successful return true, else false
	 */
	public static boolean createUserLogin(String userFileName, String username, String password, String su) {
		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		String up = "/cs/projects/tau/installations/azdblab/logins/"
				+ userFileName + ".xml";
		File fXmlFile = new File(up);

		// add a LH version to the user's login xml file
		if (fXmlFile.exists()) {
			try {
				DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
				Document doc2 = dBuilder.parse(fXmlFile);
				doc2.getDocumentElement().normalize();

				Element nList = doc2.getDocumentElement();

				Element rootElement = doc2.createElement("version");
				nList.appendChild(rootElement);
				Element attr = doc2.createElement("v");
				attr.appendChild(doc2.createTextNode(Constants.AZDBLAB_VERSION)); 
				rootElement.appendChild(attr);

				// write the content into xml file
				TransformerFactory transformerFactory = TransformerFactory
						.newInstance();
				Transformer transformer = transformerFactory.newTransformer();
				DOMSource source = new DOMSource(doc2);

				StreamResult result = new StreamResult(fXmlFile);
				transformer.transform(source, result);
			} catch (Exception e) {
				JOptionPane.showMessageDialog(null,
						"An error occured while adding this user.", "Error",
						JOptionPane.ERROR_MESSAGE);
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
				e1.appendChild(doc.createTextNode(username));

				// Create the password XML element
				// need to implement password encryption
				Element e2 = doc.createElement("password");
				nList.appendChild(e2);
				Encryptor enc = new Encryptor(password);
				String eP = enc.encrypt(password);
				e2.appendChild(doc.createTextNode(eP));

				// Create the super-user XML element
				Element e4 = doc.createElement("superuser");
				nList.appendChild(e4);
				//String su = (su_User_Check.isSelected() == true) ? "y" : "n";
				e4.appendChild(doc.createTextNode(su));

				// Create the version
				Element e3 = doc.createElement("version");
				nList.appendChild(e3);
				Element attr = doc.createElement("v");
				attr.appendChild(doc.createTextNode(Constants.AZDBLAB_VERSION)); 
				e3.appendChild(attr);

				// write the content into xml file
				TransformerFactory transformerFactory = TransformerFactory
						.newInstance();
				Transformer transformer = transformerFactory.newTransformer();
				DOMSource source = new DOMSource(doc);

				StreamResult result = new StreamResult(fXmlFile);
				transformer.transform(source, result);
			} catch (Exception e) {
				JOptionPane.showMessageDialog(null,
						"An error occured while adding this user.", "Error",
						JOptionPane.ERROR_MESSAGE);
				e.printStackTrace();
				return false;
			}
		}
		return true;
	}

	/**
	 * Returns a Vector<String> of all users who do not already have a login xml
	 * file for this version of AZDBLab. The login XML files are located in the
	 * directory /cs/projects/tau/installations/azdblab/logins, which may change
	 * down the road.
	 * 
	 * @param path
	 * @author Benjamin Dicken
	 * @return
	 */
	public static Vector<String> getUsers(String path) {
//		LabShelfManager shelf = LabShelfManager.getShelf("azdblab_6_1", "azdblab_6_1", "jdbc:oracle:thin:@sodb7.cs.arizona.edu:1521:notebook");
		Vector<String> users = User.getAllUserNames();
		Vector<String> usersReturn = User.getAllUserNames();

		try {
			File usersXML = new File(
					"/cs/projects/tau/installations/azdblab/logins/");
			File[] allUsers = usersXML.listFiles();

			for (File fXmlFile : allUsers) {
				// Check if user already has an xml file for the currently
				// running LS version
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

							NodeList nList = doc
									.getElementsByTagName("version");

							boolean isInLSVer = false;
							for (String v : verNames) {
								for (int temp = 0; temp < nList.getLength(); temp++) {
									Node nNode = nList.item(temp);
									if (nNode.getNodeType() == Node.ELEMENT_NODE) {
										Element eElement = (Element) nNode;
										if (getTagValue("v", eElement)
												.compareTo(v) == 0) {
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
}
