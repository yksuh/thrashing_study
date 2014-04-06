package azdblab.swingUI.dialogs;

import java.awt.Component;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;
import javax.swing.ListCellRenderer;

import azdblab.Constants;
import azdblab.labShelf.dataModel.Experiment;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Notebook;
import azdblab.labShelf.dataModel.User;
import azdblab.swingUI.objectNodes.StudyNode.AddedRunsTableModel;

public class SelectRunsDialog {
	private JFrame addElement;
	private JLabel lbl_username, lbl_password, lbl_connectstring;
	private JTextField txt_username, txt_connectstring;
	private JPasswordField txt_password;
	private JButton btn_getRuns, btn_Connect;
	private AddedRunsTableModel selectedRuns;
	private JComboBox<User> box_Users;
	private JComboBox<Notebook> box_Notebooks;
	private JComboBox<Experiment> box_Experiments;
	private LabShelfManager shelf;

	public SelectRunsDialog(AddedRunsTableModel selectedRuns) {
		this.selectedRuns = selectedRuns;
		addElement = new JFrame();
		addComponents();
		addElement.setVisible(true);
	}
	
	private void addComponents() {
		JPanel dlg_Panel = new JPanel();
		lbl_username = new JLabel("User Name:");
		txt_username = new JTextField(Constants.getLABUSERNAME());
		lbl_password = new JLabel("Password:");
		txt_password = new JPasswordField(Constants.getLABPASSWORD());
		lbl_connectstring = new JLabel("Connection String:");
		txt_connectstring = new JTextField(Constants.getLABCONNECTSTRING());
		
		init_ConnectBtn();
		init_UsersBox();
		init_NotebooksBox();
		init_ExperimentsBox();
		init_GetRunsBtn();
		
		dlg_Panel.setLayout(new GridLayout(8, 2));
		dlg_Panel.add(lbl_username);
		dlg_Panel.add(txt_username);
		dlg_Panel.add(lbl_password);
		dlg_Panel.add(txt_password);
		dlg_Panel.add(lbl_connectstring);
		dlg_Panel.add(txt_connectstring);
		dlg_Panel.add(btn_Connect);
		dlg_Panel.add(new JLabel());
		dlg_Panel.add(new JLabel("Users"));
		dlg_Panel.add(box_Users);
		dlg_Panel.add(new JLabel("Notebooks"));
		dlg_Panel.add(box_Notebooks);
		dlg_Panel.add(new JLabel("Experiments"));
		dlg_Panel.add(box_Experiments);
		dlg_Panel.add(btn_getRuns);
		dlg_Panel.add(new JButton("Cancel"));
		addElement.setSize(900, 300);
		addElement.add(dlg_Panel);
		
	}

	private void init_GetRunsBtn() {
		btn_getRuns = new JButton("Add runs");
		btn_getRuns.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				if (shelf == null) return;
				
				String query = String.format("select e.username, e.notebookname, e.experimentname, er.runid " +
						"from azdblab_experiment e, " +
						"azdblab_experimentrun er " +
						"where e.username='%s' " +
						"and e.notebookname='%s' " +
						"and e.experimentname='%s' " +
						"and e.experimentid = er.experimentid " +
						"and er.currentstage='Completed' " +
						"order by er.runid", 
						((User)box_Users.getSelectedItem()).getUserName(), 
						((Notebook)box_Notebooks.getSelectedItem()).getNotebookName(), 
						((Experiment)box_Experiments.getSelectedItem()).getExperimentName());
				
				ResultSet rs = shelf.executeQuerySQL(query);
				Vector<Object[]> runIds = new Vector<Object[]>();
				try {
					while (rs.next()) {
						Object[] res = new Object[4];
						res[0] = rs.getString(1);
						res[1] = rs.getString(2);
						res[2] = rs.getString(3);
						res[3] = rs.getInt(4);
						runIds.add(res);
					}
					rs.close();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
				
				for (Object[] runId: runIds)
					selectedRuns.addRow(new Object[] {txt_username.getText(), 
							String.copyValueOf(txt_password.getPassword()), 
							txt_connectstring.getText(), 
							shelf.getLabShelfVersion(), runId[0], runId[1], runId[2], runId[3]});
			}
		});
	}

	private void init_ExperimentsBox() {
		if (box_Experiments == null)
		box_Experiments = new JComboBox<Experiment>();
		box_Experiments.setEditable(false);
		box_Experiments.setRenderer(new ComboBoxExperimentRenderer());
		
	}

	private void init_NotebooksBox() {
		if (box_Notebooks == null)
			box_Notebooks = new JComboBox<Notebook>();
		box_Notebooks.setEditable(false);
		box_Notebooks.setRenderer(new ComboBoxNotebookRenderer());
		
		box_Notebooks.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				Notebook notebook = (Notebook) box_Notebooks.getSelectedItem();
				List<Experiment> experiments = new ArrayList<Experiment>();
				if (notebook != null)
					experiments = notebook.getAllExperiments();
				box_Experiments.removeAllItems();
				for(Experiment experiment:experiments) {
					box_Experiments.addItem(experiment);
				}
			}
		});
	}

	private void init_UsersBox() {
		box_Users = new JComboBox<User>();
		box_Users.setEditable(false);
		box_Users.setRenderer(new ComboBoxUserRenderer());
		
		box_Users.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				User u = (User) box_Users.getSelectedItem();
				List<Notebook> notebooks = new ArrayList<Notebook>();
				if (u != null) 
					notebooks = u.getNotebooks();
				box_Notebooks.removeAllItems();
				for(Notebook notebook:notebooks) {
					box_Notebooks.addItem(notebook);
				}
			}
		});
	}

	private void init_ConnectBtn() {
		btn_Connect = new JButton("Connect");
		btn_Connect.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				shelf = LabShelfManager.getShelf(txt_username.getText(), 
						String.copyValueOf(txt_password.getPassword()), 
						txt_connectstring.getText(), Constants.getLABMACHINENAME());
				Vector<User> users = User.getAllUsers(shelf);
				box_Users.removeAllItems();
				for (User user: users) {
					box_Users.addItem(user);
				}
			}
		});
	}
	
	private class ComboBoxUserRenderer extends JLabel implements ListCellRenderer<User> {

		/**
		 * 
		 */
		private static final long serialVersionUID = -4235425356563191465L;

		@Override
		public Component getListCellRendererComponent(
				JList<? extends User> list, User value, int index,
				boolean isSelected, boolean cellHasFocus) {
			if (value != null)
				this.setText(value.getUserName());
			return this;
		}
		
	}
	
	private class ComboBoxNotebookRenderer extends JLabel implements ListCellRenderer<Notebook> {

		/**
		 * 
		 */
		private static final long serialVersionUID = -3124502452095668674L;

		@Override
		public Component getListCellRendererComponent(
				JList<? extends Notebook> list, Notebook value, int index,
				boolean isSelected, boolean cellHasFocus) {
			if (value != null)
				this.setText(value.getNotebookName());
			return this;
		}
		
	}
	
	private class ComboBoxExperimentRenderer extends JLabel implements ListCellRenderer<Experiment> {

		/**
		 * 
		 */
		private static final long serialVersionUID = 89436260056026363L;

		@Override
		public Component getListCellRendererComponent(
				JList<? extends Experiment> list, Experiment value, int index,
				boolean isSelected, boolean cellHasFocus) {
			if (value != null)
				this.setText(value.getExperimentName());
			return this;
		}
		
	}
}
