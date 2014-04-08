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
package azdblab.plugins.aspect;

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
import java.lang.reflect.Method;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Vector;
import azdblab.Constants;
import azdblab.VersionTag;
import azdblab.VersionedPlugin;
import azdblab.executable.Main;
import azdblab.plugins.PluginData;

public class AspectPluginManager {

	// *************************************** Begin of the Inner panel
	// component *******************************//
	class StyleSelectPanel extends javax.swing.JPanel {

		private static final long serialVersionUID = 4;

		private JLabel jLabel1;
		private JLabel jLabel2;
		private JLabel jLabel3;
		private JLabel jLabel4;
		private JLabel jLabel5;
		private JButton btn_Next;
		// private JButton btn_Delete;
		private JComboBox cmbbox_Style;
		private JTextField txt_AspectValue;
		private JTextField txt_AspectName;
		private JTextField txt_NotebookName;
		private JTextField txt_UserName;

		private String strPanelUserName = null;

		private String strPanelNotebookName = null;

		private String strPanelAspectName = null;

		private String strPanelAspectValue = null;

		private String strPanelStyleName = null;

		private String strPanelAspectDescription = null;

		private String strPanelAspectSQL = null;

		private boolean bIsNew;

		Vector<String> myAspects;

		public StyleSelectPanel(String user_name, String notebook_name) {
			super();

			strPanelUserName = user_name;
			strPanelNotebookName = notebook_name;

			bIsNew = true;

			initGUI();
		}

		public StyleSelectPanel(String user_name, String notebook_name,
				String aspect_name, String style_name,
				String aspectDescription, String aspectSQL) {
			super();

			strPanelUserName = user_name;
			strPanelNotebookName = notebook_name;
			strPanelAspectName = aspect_name;
			strPanelStyleName = style_name;
			strPanelAspectDescription = aspectDescription;
			strPanelAspectSQL = aspectSQL;

			bIsNew = false;

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
					jLabel3.setText("Define an Aspect Name");
					jLabel3.setBounds(10, 98, 150, 21);
				}
				{
					jLabel5 = new JLabel();
					this.add(jLabel5);
					jLabel5.setText("Define an Aspect Value");
					jLabel5.setBounds(10, 130, 150, 21);
				}
				{
					txt_AspectName = new JTextField();

					if (bIsNew) {
						txt_AspectName.setEditable(true);
					} else {
						txt_AspectName.setText(strPanelAspectName);
						txt_AspectName.setEditable(false);
					}

					this.add(txt_AspectName);
					txt_AspectName.setBounds(170, 98, 200, 21);
				}

				{
					txt_AspectValue = new JTextField();
					if (bIsNew) {
						txt_AspectValue.setEditable(true);
					} else {
						txt_AspectValue.setText(strPanelAspectValue);
						txt_AspectValue.setEditable(false);
					}
					this.add(txt_AspectValue);
					txt_AspectValue.setBounds(170, 130, 200, 21);
				}

				{
					loadPlugins();
					ComboBoxModel cmbbox_StyleModel = new DefaultComboBoxModel(
							(Vector<String>) getPlugins());

					cmbbox_Style = new JComboBox();
					this.add(cmbbox_Style);
					cmbbox_Style.setModel(cmbbox_StyleModel);
					cmbbox_Style.setBounds(91, 168, 287, 28);

					if (bIsNew) {
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

				/*
				 * { btn_Delete = new JButton(); this.add(btn_Delete);
				 * btn_Delete.setText("Delete"); btn_Delete.setBounds(240, 220,
				 * 80, 30); btn_Delete.addActionListener(new ActionListener() {
				 * public void actionPerformed(ActionEvent evt) {
				 * btn_DeleteActionPerformed(evt); } });
				 * 
				 * if (isNew) { btn_Delete.setVisible(false); } else {
				 * btn_Delete.setVisible(true); }
				 * 
				 * }
				 */

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		private void btn_NextActionPerformed(ActionEvent evt) {
			// Main._logger.outputLog("btn_Next.actionPerformed, event=" + evt);
			// ***************************** errcheck code here
			// **************************

			strPanelAspectName = txt_AspectName.getText();
			strPanelAspectValue = txt_AspectValue.getText();

			strPanelStyleName = cmbbox_Style.getSelectedItem().toString();

			// Aspect tempaspect = new SQLStyleAspect(myDBController,
			// strPanelUserName, strPanelNotebookName, strPanelAspectName);

			Aspect tempaspect = mapAspect.get(strPanelStyleName);

			tempaspect.setAspectName(strPanelAspectName);
			// tempaspect.setAspectValue(strPanelAspectValue);

			JPanel panelSpec = null;

			if (bIsNew) {
				panelSpec = tempaspect
						.getNewSpecificationPanel(panelStyleSelect);
			} else {
				panelSpec = tempaspect
						.getExistingSpecificationPanel(panelStyleSelect);
			}

			panelStyleSelect.setVisible(false);
			panelSpec.setVisible(true);
			panelBase.add(panelSpec);

		}

		public String getAspectName() {
			return strPanelAspectName;
		}

		public String getStyleName() {
			return strPanelStyleName;
		}

		public List<String> getPlugins() {
			return myAspects;
		}

		public void installPlugins() {
			// no instillation is needed here
		}

		public void loadPlugins() {
			Vector<String> vecStyleNames = new Vector<String>();
			Vector<VersionedPlugin> versioned_plugins = new Vector<VersionedPlugin>();
			Vector<PluginData> myPlugins = Main.masterManager
					.getPluginsWithSuperclass(azdblab.plugins.aspect.Aspect.class);

			for (int i = 0; i < myPlugins.size(); i++) {
				Method method = null;

				try {
					Class<?>[] params = new Class[0];
					method = myPlugins.get(i).pluginClass.getDeclaredMethod(
							"getAspectStyleName", params);

					Object[] paramobj = new Object[0];
					String styleName = method.invoke(null, paramobj).toString();

					// vecStyleNames.add(styleName);

					Class<?> partypes[] = new Class[5];
					partypes[0] = String.class;
					partypes[1] = String.class;
					partypes[2] = String.class;
					partypes[3] = String.class;
					partypes[4] = String.class;

					Constructor<?> constructor = myPlugins.get(i).pluginClass
							.getConstructor(partypes);

					Object arglist[] = new Object[5];

					arglist[0] = strPanelUserName;
					arglist[1] = strPanelNotebookName;
					arglist[2] = strPanelAspectName;
					arglist[3] = strPanelAspectDescription;
					arglist[4] = strPanelAspectSQL;
					String version_tag = myPlugins.get(i).pluginFileName
							.substring(myPlugins.get(i).pluginFileName
									.indexOf("_") + 1,
									myPlugins.get(i).pluginFileName
											.indexOf("."));

					VersionedPlugin tmp_vp = new VersionedPlugin(
							new VersionTag(version_tag, styleName),
							(Object) (Aspect) constructor.newInstance(arglist));
					versioned_plugins.add(tmp_vp);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			VersionTag current_ver_tag = new VersionTag(Constants
					.getCurrentVersion(), "");
			Collections.sort(versioned_plugins,
					(new VersionedPlugin()).new VersionedPluginComparor());
			for (int i = 0; i < versioned_plugins.size(); ++i) {
				VersionedPlugin tmp_vp = versioned_plugins.get(i);
				if (VersionTag.CompareVersions(tmp_vp.version_tag_,
						current_ver_tag) <= 0) {
					declarePlugin(tmp_vp.version_tag_.prefix_,
							(Aspect) tmp_vp.class_object_);
					vecStyleNames.add(tmp_vp.version_tag_.prefix_);
				}
			}
			myAspects = new Vector<String>();
			if (!bIsNew) {
				myAspects.add(strPanelStyleName);
				return;
			}

			myAspects = vecStyleNames;

			// /ASDAFSDAFSAD
			//			
			//			
			//			
			//			
			// try {
			//
			// String strDirPlugin = Constants.DIRECTORY_PLUGINS.replace("/",
			// ".");
			//
			// File[] plugins = (new File(Constants.DIRECTORY_PLUGINS))
			// .listFiles();
			//
			// Vector<String> vecStyleNames = new Vector<String>();
			// Vector<VersionedPlugin> versioned_plugins = new
			// Vector<VersionedPlugin>();
			// for (int i = 0; i < plugins.length; i++) {
			// String plugin_file_name = plugins[i].getName();
			// if (plugin_file_name.contains(".jar")) {
			// String[] name_detail = plugin_file_name.replace(".jar",
			// "").split("_");
			// if (name_detail.length != 7) {
			// Main._logger.reportError(plugin_file_name
			// + " is not a valid plugin file.");
			// continue;
			// }
			// String plugin_class_name = plugin_file_name.substring(
			// 0, plugin_file_name.indexOf("_"));
			// String version_tag = plugin_file_name.substring(
			// plugin_file_name.indexOf("_") + 1,
			// plugin_file_name.indexOf("."));
			// ClassLoader classLoader = new URLClassLoader(
			// new URL[] { new URL("file:"
			// + plugins[i].getAbsolutePath()) });
			// Class aspClass = classLoader.loadClass(strDirPlugin
			// + plugin_class_name);
			// /*
			// * for (int i = 0; i < plugins.length; i++) { if
			// * (plugins[i].getName().contains(".jar")) { ClassLoader
			// * classLoader = new URLClassLoader(new URL[]{new
			// * URL("file:" + plugins[i].getAbsolutePath())}); Class
			// * aspClass = classLoader.loadClass(strDirPlugin +
			// * plugins[i].getName().replace(".jar", ""));
			// */
			//
			// if (!(aspClass.getSuperclass().equals(Aspect.class))) {
			// // Main._logger.outputLog(plugins[i].getName());
			// continue;
			// }
			//						
			// Method method = null;
			//
			// try {
			// Class[] params = new Class[0];
			// method = aspClass.getDeclaredMethod(
			// "getAspectStyleName", params);
			// } catch (NoSuchMethodException nsmexp) {
			// nsmexp.printStackTrace();
			// }
			//
			// Object[] paramobj = new Object[0];
			// String styleName = method.invoke(null, paramobj)
			// .toString();
			//
			// // vecStyleNames.add(styleName);
			//
			// Class partypes[] = new Class[5];
			// partypes[0] = String.class;
			// partypes[1] = String.class;
			// partypes[2] = String.class;
			// partypes[3] = String.class;
			// partypes[4] = String.class;
			//
			// Constructor constructor = aspClass
			// .getConstructor(partypes);
			//
			// Object arglist[] = new Object[5];
			//
			// arglist[0] = strPanelUserName;
			// arglist[1] = strPanelNotebookName;
			// arglist[2] = strPanelAspectName;
			// arglist[3] = strPanelAspectDescription;
			// arglist[4] = strPanelAspectSQL;
			//
			// VersionedPlugin tmp_vp = new VersionedPlugin(
			// new VersionTag(version_tag, styleName),
			// (Object) (Aspect) constructor
			// .newInstance(arglist));
			// versioned_plugins.add(tmp_vp);
			// // declarePlugin(styleName,
			// // (Aspect)constructor.newInstance(arglist));
			//
			// }
			//
			// }
			// VersionTag current_ver_tag = new VersionTag(Constants
			// .getCurrentVersion(), "");
			// Collections.sort(versioned_plugins,
			// (new VersionedPlugin()).new VersionedPluginComparor());
			// for (int i = 0; i < versioned_plugins.size(); ++i) {
			// VersionedPlugin tmp_vp = versioned_plugins.get(i);
			// if (VersionTag.CompareVersions(tmp_vp.version_tag_,
			// current_ver_tag) <= 0) {
			// declarePlugin(tmp_vp.version_tag_.prefix_,
			// (Aspect) tmp_vp.class_object_);
			// vecStyleNames.add(tmp_vp.version_tag_.prefix_);
			// }
			// }
			// myAspects = new Vector<String>();
			// if (!bIsNew) {
			// myAspects.add(strPanelStyleName);
			// return;
			// // myAspects = new String[] { strPanelStyleName };
			// }
			//
			// // String[] styleNames = new String[vecStyleNames.size()];
			// //
			// // for (int i = 0; i < vecStyleNames.size(); i++) {
			// //
			// // styleNames[i] = vecStyleNames.get(i);
			// // }
			//
			// myAspects = vecStyleNames;
			// // myAspects = styleNames;
			//
			// } catch (ClassNotFoundException cnfexp) {
			// cnfexp.printStackTrace();
			// } catch (IllegalAccessException iaexp) {
			// iaexp.printStackTrace();
			// } catch (InstantiationException instexp) {
			// instexp.printStackTrace();
			// } catch (NoSuchMethodException nsmexp) {
			// nsmexp.printStackTrace();
			// } catch (InvocationTargetException itexp) {
			// itexp.printStackTrace();
			// } catch (MalformedURLException muexp) {
			// muexp.printStackTrace();
			// }
			 }

		}

		// *************************************** End of the Inner panel
		// component
		// *******************************//

		public static final String DEFINEDASPECTTABLENAME = "DEFINEDASPECT";

		/**
		 * The base panel to hold other panel GUIs.
		 */
		private JPanel panelBase;

		/**
		 * Style selection panel
		 */
		private JPanel panelStyleSelect;

		private Map<String, Aspect> mapAspect;

		// private LabShelf myDBController;

		public AspectPluginManager() {

			panelBase = new JPanel();

			panelStyleSelect = null;

			// myDBController = dbController;

			mapAspect = new HashMap<String, Aspect>();

		}

		private void declarePlugin(String strStyleName, Aspect aspectPlugin) {
			if (!mapAspect.containsKey(strStyleName)) {
				mapAspect.put(strStyleName, aspectPlugin);
			}
		}

		public JPanel createAspect(String user_name, String notebook_name) {

			if (panelStyleSelect == null) {

				panelStyleSelect = new StyleSelectPanel(user_name,
						notebook_name);

				panelStyleSelect.setVisible(true);
				panelBase.add(panelStyleSelect);

			}

			return panelBase;

		}

		public JPanel createAspect(String user_name, String notebook_name,
				String aspect_name, String style_name,
				String aspectDescription, String aspectSQL) {

			if (panelStyleSelect == null) {

				panelStyleSelect = new StyleSelectPanel(user_name,
						notebook_name, aspect_name, style_name,
						aspectDescription, aspectSQL);

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

