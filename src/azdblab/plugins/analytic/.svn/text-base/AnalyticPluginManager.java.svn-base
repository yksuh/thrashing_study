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
package azdblab.plugins.analytic;

import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.ComboBoxModel;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.JPanel;
import java.lang.reflect.Constructor;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Vector;
import azdblab.executable.Main;
import azdblab.plugins.PluginData;

public class AnalyticPluginManager {

	// *************************************** Begin of the Inner panel
	// component *******************************//
	class StyleSelectPanel extends javax.swing.JPanel {

		private static final long serialVersionUID = 4;

		private JLabel jLabel1;
		private JLabel jLabel2;
		private JLabel jLabel3;
		private JLabel jLabel4;
		private JButton btn_Next;
		private JComboBox<PluginData> cmbbox_Style;
		private JTextField txt_AnalyticName;
		private JTextField txt_NotebookName;
		private JTextField txt_UserName;

		private String strPanelUserName = null;

		private String strPanelNotebookName = null;

		private String strPanelAnalyticName = null;

		private String strPanelStyleName = null;

		private String strPanelAnalyticDescription = null;

		private String strPanelAnalyticSQL = null;

		private boolean isNew;

		private Vector<PluginData> vecMyAspects;

		public StyleSelectPanel(String user_name, String notebook_name) {
			super();

			strPanelUserName = user_name;
			strPanelNotebookName = notebook_name;

			isNew = true;

			initGUI();
		}

		public StyleSelectPanel(String user_name, String notebook_name,
				String analytic_name, String style_name,
				String analyticDescription, String analyticSQL) {
			super();

			strPanelUserName = user_name;
			strPanelNotebookName = notebook_name;
			strPanelAnalyticName = analytic_name;
			strPanelStyleName = style_name;
			strPanelAnalyticDescription = analyticDescription;
			strPanelAnalyticSQL = analyticSQL;

			isNew = false;

			initGUI();
		}

		private void initGUI() {

			try {
				setPreferredSize(new Dimension(400, 300));
				this.setLayout(null);
				{
					jLabel1 = new JLabel();
					this.add(jLabel1);
					jLabel1.setText("User");
					jLabel1.setBounds(14, 28, 56, 21);
				}
				{
					jLabel2 = new JLabel();
					this.add(jLabel2);
					jLabel2.setText("Notebook");
					jLabel2.setBounds(14, 63, 63, 21);
				}
				{
					txt_UserName = new JTextField();
					txt_UserName.setText(strPanelUserName);
					txt_UserName.setEditable(false);
					this.add(txt_UserName);
					txt_UserName.setBounds(91, 28, 287, 21);
				}
				{
					txt_NotebookName = new JTextField();
					txt_NotebookName.setText(strPanelNotebookName);
					txt_NotebookName.setEditable(false);
					this.add(txt_NotebookName);
					txt_NotebookName.setBounds(91, 63, 287, 21);
				}
				{
					jLabel3 = new JLabel();
					this.add(jLabel3);
					jLabel3.setText("Analytic");
					jLabel3.setBounds(14, 98, 63, 21);
				}
				{
					txt_AnalyticName = new JTextField();

					if (isNew) {
						txt_AnalyticName.setEditable(true);
					} else {
						txt_AnalyticName.setText(strPanelAnalyticName);
						txt_AnalyticName.setEditable(false);
					}

					this.add(txt_AnalyticName);
					txt_AnalyticName.setBounds(91, 98, 287, 21);
				}
				{
					loadPlugins();
					ComboBoxModel<PluginData> cmbbox_StyleModel = new DefaultComboBoxModel<PluginData>(
							(Vector<PluginData>) getPlugins());

					cmbbox_Style = new JComboBox<PluginData>();

					this.add(cmbbox_Style);
					cmbbox_Style.setModel(cmbbox_StyleModel);
					cmbbox_Style.setBounds(91, 168, 287, 28);

					if (isNew) {
						cmbbox_Style.setEditable(true);
					} else {
						cmbbox_Style.setEditable(false);
					}
				}
				{
					jLabel4 = new JLabel();
					this.add(jLabel4);
					jLabel4.setText("Style");
					jLabel4.setBounds(14, 168, 63, 21);
				}
				{
					btn_Next = new JButton();
					this.add(btn_Next);
					btn_Next.setText("Next");
					btn_Next.setBounds(150, 220, 80, 30);
					btn_Next.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							btn_NextActionPerformed(evt);
						}
					});
				}

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		private void btn_NextActionPerformed(ActionEvent evt) {
			// Main._logger.outputLog("btn_Next.actionPerformed, event=" + evt);
			// TODO add your code for btn_Next.actionPerformed

			// ***************************** errcheck code here
			// **************************

			strPanelAnalyticName = txt_AnalyticName.getText();

			strPanelStyleName = cmbbox_Style.getSelectedItem().toString();

			// Aspect tempaspect = new SQLStyleAspect(myDBController,
			// strPanelUserName, strPanelNotebookName, strPanelAspectName);

			Analytic tempanalytic = mapAnalytic.get(strPanelStyleName);

			tempanalytic.setAnalyticName(strPanelAnalyticName);

			JPanel panelSpec = null;

			if (isNew) {
				panelSpec = tempanalytic
						.getNewSpecificationPanel(panelStyleSelect);
			} else {
				panelSpec = tempanalytic
						.getExistingSpecificationPanel(panelStyleSelect);
			}

			panelSpec.setVisible(true);
			panelStyleSelect.setVisible(false);
			panelBase.add(panelSpec);

		}

		public String getAnalyticName() {
			return strPanelAnalyticName;
		}

		public String getStyleName() {
			return strPanelStyleName;
		}

		public List<PluginData> getPlugins() {
			return vecMyAspects;
		}

		public void loadPlugins() {
			vecMyAspects = Main.masterManager
					.getPluginsWithSuperclass(azdblab.plugins.analytic.Analytic.class);
		
			Object arglist[] = new Object[5];
			arglist[0] = strPanelUserName;
			arglist[1] = strPanelNotebookName;
			arglist[2] = strPanelAnalyticName;
			arglist[3] = strPanelAnalyticDescription;
			arglist[4] = strPanelAnalyticSQL;

			Class<?> partypes[] = new Class[5];
			partypes[0] = String.class;
			partypes[1] = String.class;
			partypes[2] = String.class;
			partypes[3] = String.class;
			partypes[4] = String.class;

			for (int i = 0; i < vecMyAspects.size(); i++) {
				try {
					Class<?> anlClass = vecMyAspects.get(i).pluginClass;
					Constructor<?> constructor = anlClass.getConstructor(partypes);
					/**
					 * private void declarePlugin(String strStyleName, Analytic
					 * analyticPlugin) { if
					 * (!mapAnalytic.containsKey(strStyleName)) {
					 * mapAnalytic.put(strStyleName, analyticPlugin); } }
					 * */
					if (!mapAnalytic
							.containsKey(vecMyAspects.get(i).pluginClass
									.getName())) {
						mapAnalytic.put(vecMyAspects.get(i).pluginClass
								.getName(), (Analytic) constructor
								.newInstance(arglist));
					}
					// declarePlugin(vecMyAspects.get(i), (Analytic) constructor
					// .newInstance(arglist));
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		
		}
	}

	// *************************************** End of the Inner panel component
	// *******************************//

	public static final String DEFINEDANALYTICTABLENAME = "DEFINEDANALYTIC";

	/**
	 * The base panel to hold other panel GUIs.
	 */
	private JPanel panelBase;

	/**
	 * Style selection panel
	 */
	private JPanel panelStyleSelect;

	private Map<String, Analytic> mapAnalytic;

	public AnalyticPluginManager() {

		panelBase = new JPanel();

		panelStyleSelect = null;

		mapAnalytic = new HashMap<String, Analytic>();

	}


	public JPanel createAnalytic(String user_name, String notebook_name) {

		if (panelStyleSelect == null) {

			panelStyleSelect = new StyleSelectPanel(user_name, notebook_name);

			panelStyleSelect.setVisible(true);
			panelBase.add(panelStyleSelect);

		}

		return panelBase;

	}

	public JPanel createAnalytic(String user_name, String notebook_name,
			String analytic_name, String style_name,
			String analyticDescription, String analyticSQL) {

		if (panelStyleSelect == null) {

			panelStyleSelect = new StyleSelectPanel(user_name, notebook_name,
					analytic_name, style_name, analyticDescription, analyticSQL);

			panelStyleSelect.setVisible(true);
			panelBase.add(panelStyleSelect);

		}

		return panelBase;

	}

	public void exportSpecification(String user_name, String notebook_name,
			String file_name) {

	}

	public void importSpecification(String file_name) {

	}
}
