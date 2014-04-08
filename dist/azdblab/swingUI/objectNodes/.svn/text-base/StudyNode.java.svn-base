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
package azdblab.swingUI.objectNodes;

import java.awt.BorderLayout;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.lang.reflect.Constructor;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTable;
import javax.swing.JTextArea;
import javax.swing.event.CaretEvent;
import javax.swing.event.CaretListener;
import javax.swing.event.PopupMenuEvent;
import javax.swing.event.PopupMenuListener;
import javax.swing.table.AbstractTableModel;

import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.TableDefinition;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.plugins.PluginData;
import azdblab.plugins.protocol.Protocol;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.dialogs.SelectRunsDialog;
import azdblab.swingUI.treeNodesManager.NodePanel;

public class StudyNode extends ObjectNode {
	 
	private int id, item, protocolId;
	private String studyName, ComputationQuery;
	private AddedRunsTableModel selectedRuns;
	private JTable added_Runs;
	JPanel tablePanel, btnsPanel, jpl_Info, propsPanel;
	private JComboBox<PluginData> protocolVal;
	NodePanel tab_Content;
	JPanel protocolStats;

	public StudyNode(int id, String studyName) {
		strNodeName = studyName;
		this.id = id;
		this.studyName = studyName;
		willHaveChildren = false;
		protocolStats = new JPanel();
		protocolStats.setLayout(new BorderLayout());
	}
	
	public StudyNode(int id, String studyName, int item, int protocolId, String ComputationQuery) {
		this(id, studyName);
		this.studyName = studyName;
		this.item = item;
		this.protocolId = protocolId;
		this.ComputationQuery = ComputationQuery;
	}

	private JPanel initializeDataPanel() {
		NodePanel tab_Content = new NodePanel();
		tab_Content.addComponentToTab("Study Info", initializeInfo());
		tab_Content.addComponentToTab("Protocol Stats", protocolStats);
		return tab_Content;
	}

	private JPanel initializeInfo() {
		jpl_Info = new JPanel();
		jpl_Info.setLayout(new GridBagLayout());
		
		init_runstable();
		init_btnspanel();
		init_propspanel();
		
		GridBagConstraints c = new GridBagConstraints();
		c.gridx=0; c.gridy=0; c.fill = GridBagConstraints.BOTH;c.weighty=0.2;c.weightx=1; c.gridheight=1;
		jpl_Info.add(propsPanel, c);
		c.gridx=0; c.gridy=1;c.weighty=0.7;
		jpl_Info.add(tablePanel, c);
		c.gridx=0; c.gridy=2;c.weighty=0.1;
		jpl_Info.add(btnsPanel, c);
		return jpl_Info;

	}

	private void init_propspanel() {
		propsPanel = new JPanel();
		propsPanel.setLayout(new GridBagLayout());
		JLabel studyNameLbl = new JLabel("Study Name:");
		JLabel studyNameValLbl = new JLabel(studyName);
		
		JLabel protocolLbl = new JLabel("Protocol version:");
		
		Vector<PluginData> myPlugins = Main.masterManager
				.getPluginsWithSuperclass(azdblab.plugins.protocol.Protocol.class);
		
		PluginData[] protocols = new PluginData[myPlugins.size()];
		
		for (int i = 0; i < myPlugins.size(); i++) {
			try {
				protocols[i] = myPlugins.get(i);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		protocolVal = new JComboBox<PluginData>(myPlugins.toArray(new PluginData[0]));
		protocolVal.setSelectedIndex(protocolId);
		
		protocolVal.addItemListener(new ItemListener() {
			
			@Override
			public void itemStateChanged(ItemEvent e) {
				if (e.getStateChange() == ItemEvent.SELECTED) {
					LabShelfManager.getShelf().executeUpdateSQL("UPDATE " 
							+ TableDefinition.STUDY.TableName 
							+ " SET protocolId="
							+ protocolVal.getSelectedIndex());
					LabShelfManager.getShelf().commit();
				}
			}
		});
		
		JLabel itemLbl = new JLabel("Item:");
		JComboBox<String> itemVal = new JComboBox<String>(new String[] {String.format("%d", item)});
		
		JLabel compQryLbl = new JLabel("Computation Query:");
		JTextArea compQryTxt = new JTextArea(ComputationQuery);
		compQryTxt.addFocusListener(new FocusListener() {
			
			@Override
			public void focusLost(FocusEvent e) {
				//LabShelfManager.getShelf().up
				
			}
			
			@Override
			public void focusGained(FocusEvent e) {
				// TODO Auto-generated method stub
				
			}
		});
		GridBagConstraints c = new GridBagConstraints();
		c.gridx=0; c.gridy=0; c.fill=GridBagConstraints.BOTH; c.weighty=0.05; c.weightx=0.5;
		propsPanel.add(studyNameLbl, c);
		c.gridx=1; c.gridy=0;
		propsPanel.add(studyNameValLbl, c);
		c.gridx=0; c.gridy=1;
		propsPanel.add(protocolLbl, c);
		c.gridx=1; c.gridy=1;
		propsPanel.add(protocolVal, c);
		c.gridx=0; c.gridy=2;
		propsPanel.add(itemLbl, c);
		c.gridx=1; c.gridy=2;
		propsPanel.add(itemVal, c);
		c.gridx=0; c.gridy=3; c.weighty=1;
		propsPanel.add(compQryLbl, c);
		c.gridx=1; c.gridy=3; c.weighty=1;
		propsPanel.add(compQryTxt, c);
	}

	private void init_btnspanel() {
		btnsPanel = new JPanel();
		btnsPanel.setLayout(new GridLayout(1, 2));
		
		JButton btnAdd = new JButton("Add Runs");
		
		btnAdd.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				
				new SelectRunsDialog(selectedRuns);
			}
		});
		
		JButton btnDel = new JButton("Delete Runs");
		
		btnDel.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				selectedRuns.deleteRow(added_Runs.getSelectedRow());
			}
		});
		
		btnsPanel.add(btnAdd);
		btnsPanel.add(btnDel);
	}
	
	private Integer[] getHTRuns(Hashtable<String[], Integer[]> ht, String[] key) {
		try {
		for (String[] hkey : ht.keySet()) {
			for (int i = 0; i < hkey.length; i++) {
				if (!key[i].equals(hkey[i]))
					return null;
			}
			Integer[] res = ht.get(hkey);
			ht.remove(hkey);
			return res;
		}
		} catch (Exception e) {
			return null;
		}
		return null;
	}
	
	private Hashtable<String[], Integer[]> constructHT() {
		Hashtable<String[], Integer[]> res = new Hashtable<String[], Integer[]>();
		
		for (int row = 0; row < added_Runs.getRowCount(); row++) {
			String[] key = new String[] {(String) selectedRuns.getAbsValueAt(row, 0),
					(String) selectedRuns.getAbsValueAt(row, 1),
					(String) selectedRuns.getAbsValueAt(row, 2)};
			Integer[] runs = getHTRuns(res, key);
			if (runs == null) 
				runs = new Integer[0];
			Integer[] newRuns = new Integer[runs.length + 1];
			System.arraycopy(runs, 0, newRuns, 1, runs.length);
			newRuns[0] = (Integer) selectedRuns.getAbsValueAt(row, 7);
			res.put(key, newRuns);
		}
		return res;
	}

	private void init_runstable() {
		selectedRuns = new AddedRunsTableModel(id);
		added_Runs = new JTable(selectedRuns);
		tablePanel = new JPanel();
		tablePanel.setLayout(new BorderLayout());
		
		JPanel innerPnl = new JPanel(new BorderLayout());
		JButton runProtocolBtn = new JButton("Run Protocol");
		
		runProtocolBtn.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				PluginData protocol = (PluginData)protocolVal.getSelectedItem();
				try {
					Constructor<?> c = protocol.pluginClass.getConstructor(new Class[0]);
					Protocol p = (Protocol) c.newInstance((Object[])null);
					p.execute(studyName, constructHT());
					protocolStats.removeAll();
					protocolStats.add(p.getProtocolStats(), BorderLayout.CENTER);
				} catch (Exception e1) {
					e1.printStackTrace();
				}
			}
		});
		
		innerPnl.add(added_Runs.getTableHeader(), BorderLayout.NORTH);
		innerPnl.add(added_Runs, BorderLayout.CENTER);
		
		tablePanel.add(runProtocolBtn, BorderLayout.NORTH);
		tablePanel.add(innerPnl, BorderLayout.CENTER);
	}

	@Override
	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Study Node");

		return initializeDataPanel();
	}

	@Override
	public String getIconResource(boolean open) {
		return Constants.DIRECTORY_IMAGE_LFHNODES + "Analysis.png";
	}

	@Override
	public JPanel getButtonPanel() {
		JPanel btnPanel = new JPanel();
		btnPanel.setLayout(new BorderLayout());
		JButton btnDel = new JButton("Delete  Study");
		btnDel.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				String query = "DELETE FROM " + TableDefinition.STUDY.TableName + " WHERE StudyID = " + String.format("%d", id);
				try {
					LabShelfManager.getShelf().executeDeleteSQL(query);
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
				
			}
		});
		btnPanel.add(btnDel);
		return btnPanel;
	}

	@Override
	protected void loadChildNodes() {
	}

	@Override
	protected Vector<String> getAuthors() {
		Vector<String> vecToRet = new Vector<String>();
		vecToRet.add("Andrey Kvochko");
		vecToRet.add("Richard T. Snodgrass");
		vecToRet.add("Youngkyoon Suh");
		return vecToRet;
	}

	@Override
	protected String getDescription() {
		return "This node contains general information about a study.";
	}
	
	public class AddedRunsTableModel extends AbstractTableModel {
		
		/**
		 * 
		 */
		private static final long serialVersionUID = 346335199370426897L;
		
		private Object[][] data = new Object[0][];
		private String[] columnNames = {"LabShelf version", "User", "Notebook", "Experiment", "RunId"};
		
		public AddedRunsTableModel(int studyId) {
			LabShelfManager.getShelf().createTable(TableDefinition.STUDYRUN.TableName, 
					TableDefinition.STUDYRUN.columns, 
					TableDefinition.STUDYRUN.columnDataTypes, 
					TableDefinition.STUDYRUN.columnDataTypeLengths, 
					TableDefinition.STUDYRUN.primaryKey, 
					TableDefinition.STUDYRUN.foreignKey);
			ResultSet rs = LabShelfManager.getShelf().executeSimpleQuery(TableDefinition.STUDYRUN.TableName, 
					new String[] {
					"Labshelf_User",
					"Labshelf_Password",
					"ConnectString",
					"Labshelf_Name",
					"Username",
					"NotebookName",
					"ExperimentName",
					"RunID"
					}, new String[] {
					"StudyID"
					}, new String[] {
					String.format("%d", studyId)
					}, new int[] {
					GeneralDBMS.I_DATA_TYPE_NUMBER
			});
			
			try {
				while (rs.next()) {
					Object[][] newdata = new Object[data.length + 1][];
					System.arraycopy(data, 0, newdata, 0, data.length);
					newdata[data.length] = new Object[]{
							rs.getString(1),
							rs.getString(2),
							rs.getString(3),
							rs.getString(4),
							rs.getString(5),
							rs.getString(6),
							rs.getString(7),
							rs.getInt(8)
					};
					data = newdata;
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		public void deleteRow(int rowIndex) {
			
			if (rowIndex > data.length || rowIndex < 0)
				return;
			
			
			
			LabShelfManager.getShelf().deleteRows(TableDefinition.STUDYRUN.TableName, 
					new String[] {
					"LABSHELF_NAME",
					"RUNID",
					"STUDYID"
			}, new String[] {
					(String) data[rowIndex][3],
					String.format("%d", data[rowIndex][7]),
					String.format("%d", id)
			}, new int[] {
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			});
			
			LabShelfManager.getShelf().commitlabshelf();
			
			Object[][] newData = new Object[data.length - 1][columnNames.length+3];
			if (newData.length > 0)
				System.arraycopy(data, 0, newData, 0, rowIndex);
			if (data.length - 1 >= rowIndex)
				System.arraycopy(data, rowIndex+1, newData, rowIndex, data.length - rowIndex - 1);
			data = newData;
			this.fireTableRowsDeleted(rowIndex, rowIndex);
		}
		
		public void addRow(Object[] newRow) {
			
			try {
				LabShelfManager.getShelf().insertTuple(TableDefinition.STUDYRUN.TableName, 
						new String[] {
						"LABSHELF_USER",
						"LABSHELF_PASSWORD",
						"CONNECTSTRING",
						"LABSHELF_NAME",
						"USERNAME",
						"NOTEBOOKNAME",
						"EXPERIMENTNAME",
						"RUNID",
						"STUDYID"
				}, new String[] {
						(String) newRow[0],
						(String) newRow[1],
						(String) newRow[2],
						(String) newRow[3],
						(String) newRow[4],
						(String) newRow[5],
						(String) newRow[6],
						String.format("%d", newRow[7]),
						String.format("%d", id)
				}, new int[] {
						GeneralDBMS.I_DATA_TYPE_VARCHAR,
						GeneralDBMS.I_DATA_TYPE_VARCHAR,
						GeneralDBMS.I_DATA_TYPE_VARCHAR,
						GeneralDBMS.I_DATA_TYPE_VARCHAR,
						GeneralDBMS.I_DATA_TYPE_VARCHAR,
						GeneralDBMS.I_DATA_TYPE_VARCHAR,
						GeneralDBMS.I_DATA_TYPE_VARCHAR,
						GeneralDBMS.I_DATA_TYPE_NUMBER,
						GeneralDBMS.I_DATA_TYPE_NUMBER
				});
				LabShelfManager.getShelf().commit();
			} catch (SQLException e) {
				e.printStackTrace();
				return;
			}
			
			Object[][] newData = new Object[data.length + 1][columnNames.length+3];
				System.arraycopy(data, 0, newData, 0, data.length);
			newData[newData.length - 1] = newRow;
			data = newData;
			this.fireTableRowsInserted(newData.length - 1, newData.length - 1);
		}
		
		@Override
		public String getColumnName(int column) {
			return columnNames[column];
		};
		
		@Override
		public int getRowCount() {
			return data.length;
		}

		@Override
		public int getColumnCount() {
			return columnNames.length;
		}

		@Override
		public Object getValueAt(int rowIndex, int columnIndex) {
			return data[rowIndex][columnIndex+3];
		}
		
		public Object getAbsValueAt(int rowIndex, int columnIndex) {
			return data[rowIndex][columnIndex];
		}
	}

}