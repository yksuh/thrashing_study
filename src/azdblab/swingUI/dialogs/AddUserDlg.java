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
package azdblab.swingUI.dialogs;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.border.TitledBorder;


/**
* This code was edited or generated using CloudGarden's Jigloo
* SWT/Swing GUI Builder, which is free for non-commercial
* use. If Jigloo is being used commercially (ie, by a corporation,
* company or business for any purpose whatever) then you
* should purchase a license for each developer using Jigloo.
* Please visit www.cloudgarden.com for details.
* Use of Jigloo implies acceptance of these licensing terms.
* A COMMERCIAL LICENSE HAS NOT BEEN PURCHASED FOR
* THIS MACHINE, SO JIGLOO OR THIS CODE CANNOT BE USED
* LEGALLY FOR ANY CORPORATE OR COMMERCIAL PURPOSE.
*/
public class AddUserDlg extends javax.swing.JDialog {
	
	public static final long	serialVersionUID	= System.identityHashCode("AddUserDlg");
	
	private JButton 		btn_add;
	private JTextField 		txt_username;
	private JLabel 			jLabel1;
	private JButton 		btn_cancel;
	
	
	private	String			strUserName;
	
	
	public AddUserDlg() {
		super();
		initVAR();
		initGUI();
	}
	
	private void initGUI() {
		try {
			{
				this.setDefaultCloseOperation(DISPOSE_ON_CLOSE);
				getContentPane().setLayout(null);
				this.setTitle("Add a new user");
				{
					btn_add = new JButton();
					getContentPane().add(btn_add);
					btn_add.setText("Add");
					btn_add.setBounds(84, 168, 112, 28);
					btn_add.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							btn_addActionPerformed(evt);
						}
					});
				}
				{
					btn_cancel = new JButton();
					getContentPane().add(btn_cancel);
					btn_cancel.setText("Cancel");
					btn_cancel.setBounds(259, 168, 105, 28);
					btn_cancel.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							btn_cancelActionPerformed(evt);
						}
					});
				}
				{
					jLabel1 = new JLabel();
					getContentPane().add(jLabel1);
					jLabel1.setBounds(14, 28, 420, 196);
					jLabel1.setBorder(BorderFactory.createTitledBorder(null, "Specify User Name", TitledBorder.LEADING, TitledBorder.TOP));
				}
				{
					txt_username = new JTextField();
					getContentPane().add(txt_username);
					txt_username.setText(strUserName);
					txt_username.setBounds(42, 63, 364, 28);
				}
			}
			//this.setIconImage(new ImageIcon(AZDBLAB.DIRECTORY_IMAGE + "/" + "azdblab.png").getImage());
			this.setSize(465, 274);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private void initVAR() {
		strUserName	= System.getProperty("user.name");
	}
	
	private void btn_addActionPerformed(ActionEvent evt) {
		strUserName	= txt_username.getText();
		dispose();
	}
	
	private void btn_cancelActionPerformed(ActionEvent evt) {
		strUserName	= null;
		dispose();
	}

	public String getUserName() {
		return strUserName;
	}
}
