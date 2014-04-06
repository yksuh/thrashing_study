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

import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JTextPane;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JProgressBar;
import javax.swing.JTextField;

import javax.swing.JPanel;

import azdblab.Constants;

import azdblab.labShelf.dataModel.Comment;
import azdblab.labShelf.dataModel.Experiment;
import azdblab.labShelf.dataModel.Notebook;
import azdblab.labShelf.dataModel.Query;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;
import azdblab.labShelf.dataModel.Run.RunStatus;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.dialogs.AddCommentDlg;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;
import azdblab.swingUI.treeNodesManager.NodePanel;

/**
 * The data module for CompletedRun object. Used in creating the view for
 * CompletedRun node in the GUI
 * 
 * @author ZHANGRUI
 * 
 */
public class RunningRunNode extends RunStatusNode {

	private class ProgressPanel extends javax.swing.JPanel {
		/**
		 * 
		 */
		private static final long serialVersionUID = -291718415846632597L;

		private JLabel jLabel15;
		private JTextField txt_CurrentStatus;
		private JLabel jLabel1;
		private JProgressBar prgbar_Progress;
		private JTextField txt_Finish;

		public ProgressPanel() {
			super();
			initGUI();

		}

		private void initGUI() {
			try {
				this.setPreferredSize(new java.awt.Dimension(679, 525));
				setLayout(null);
				{
					{
						{
							jLabel15 = new JLabel();
							add(jLabel15);
							jLabel15.setText("Current Status:");
							jLabel15.setBounds(35, 28, 112, 28);
						}
						{
							txt_CurrentStatus = new JTextField();
							add(txt_CurrentStatus);
							txt_CurrentStatus.setBounds(147, 28, 497, 28);
							txt_CurrentStatus.setEditable(false);
							txt_CurrentStatus.setForeground(new java.awt.Color(
									255, 0, 0));
						}

						{
							prgbar_Progress = new JProgressBar();
							prgbar_Progress.setMaximum(100);
							prgbar_Progress.setStringPainted(true);
							this.add(prgbar_Progress);
							prgbar_Progress.setBounds(21, 147, 644, 35);
						}
						{
							jLabel1 = new JLabel();
							this.add(jLabel1);
							jLabel1.setText("Main Progress");
							jLabel1.setBounds(21, 105, 126, 28);
						}

					}

				}
				RunStatus runStat = User.getUser(strUserName).getNotebook(
						strNotebookName).getExperiment(strExperimentName)
						.getRun(strStartTime).getRunProgress();
				String currentStage = runStat.current_stage_;
				double percentage = runStat.percentage_;

				txt_CurrentStatus.setText(currentStage);
				prgbar_Progress.setValue((int) percentage);

				{
					JLabel lbl_FinishDescription = new JLabel(
							"Predicted Finish Time:");
					lbl_FinishDescription.setBounds(21, 200, 300, 35);
					this.add(lbl_FinishDescription);
				}
				{
					txt_Finish = new JTextField(
							getPredictedFinishTime(currentStage));
					txt_Finish.setEditable(false);
					txt_Finish.setBounds(221, 200, 300, 35);
					this.add(txt_Finish);

				}

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	private String getPredictedFinishTime(String currentStage) {
		if (currentStage.contains("Populating")) {
			return "Not Soon";
		} else if (currentStage.contains("Analyz")) {
			try {
				int queryNum = Integer.parseInt(currentStage.split("#")[1]
						.trim());
				SimpleDateFormat creationDateFormater = new SimpleDateFormat(
						Constants.TIMEFORMAT);
				
				Calendar old = Calendar.getInstance();
				old.setTime(creationDateFormater.parse(strStartTime));
				Calendar current = Calendar.getInstance();
				current.setTime(creationDateFormater.parse(creationDateFormater
						.format(System.currentTimeMillis())));
				long miliDif = current.getTimeInMillis()
						- old.getTimeInMillis();

				int TotalQueries = User.getUser(strUserName).getNotebook(
						strNotebookName).getExperiment(strExperimentName)
						.getRun(strStartTime).getExperimentRunQueries().size();

				long miliPerQuery = miliDif / queryNum;
				long miliRemaining = miliPerQuery * (TotalQueries - queryNum);

				long diffDays = miliRemaining / (24 * 60 * 60 * 1000);
				long diffHours = (miliRemaining / (60 * 60 * 1000)) - diffDays
						* 24;
				long diffMinutes = (miliRemaining / (60 * 1000))
						- (diffDays * 24 + diffHours) * 60;

				return "Days:" + diffDays + " Hours:" + diffHours + " Minutes:"
						+ diffMinutes;

			} catch (Exception e) {
				System.out.println(e.getMessage());
				return "Error Determining finish Time";
			}

		}
		return "Almost Certainly Not Soon";
	}

	private boolean bIsPaused;

	public RunningRunNode(String username, String notebookname, String expname,
			String scenario, String machineName, String dbms, String startTime) {

		super(username, notebookname, expname, scenario, machineName, dbms,
				startTime, 1);

		bIsPaused = false;
		willHaveChildren = false;
		if(Constants.DEMO_SCREENSHOT){
			strNodeName = "Running Run of [" + expname + "," + Constants.hiddenDBMSes.get(dbms.toLowerCase()) + ":"+ getShortMachineName() +"," 
					+ startTime + "," + username + "," + notebookname + "]";
		}else{
			strNodeName = "Running Run ("+getRunID()+") of [" + expname + "," + dbms + ":"+ getShortMachineName() +"," 
					+ startTime + "," + username + "," + notebookname + "]";	
		}
	}

	public String getDBMS() {
		return strDBMS;
	}

	public void setPaused(boolean isPaused) {
		bIsPaused = isPaused;
	}

	public boolean getIsPaused() {
		return bIsPaused;
	}

	public String getIconResource(boolean open) {
		return (Constants.DIRECTORY_IMAGE_LFHNODES + "runningrun_new.png");
	}

	private JPanel createProgressPanel() {

		return new ProgressPanel();

	}
	
	private JPanel createRunningRunPanel() {

		// Info Section
		String info = "";
		info += "<HTML><BODY><CENTER><h1>";
		info += "<p> Experiment : " + strExperimentName + "</p>";
		info += "<p> from notebook : " + strNotebookName + "</p>";
		info += "<p> of user : " + strUserName + "</p>";
		info += "<p> on database : " + strDBMS + "</p>";
		info += "<p> is currently running, started at " + strStartTime + "</p>";
		info += "</h1></CENTER> <font color='blue'>";
		info += "</font>";

		info += "</BODY></HTML>";

		JTextPane infoPane = createTextPaneFromString(info);

		JPanel panelProgress = createProgressPanel();

		NodePanel tab_Content = new NodePanel();

		tab_Content.addComponentToTab("Running Run info", infoPane);
		tab_Content.addComponentToTab("Progress info", panelProgress);
		tab_Content.addComponentToTab("Run Status",
				createTextPaneFromString(getRunLogHTML()));
		tab_Content.addComponentToTab("Comments", getCommentPane());

		return tab_Content;
	}

	private void PauseRunningRunActionPerformed(ActionEvent evt) {
		if (JOptionPane.showConfirmDialog(null,
				"Are you sure to pause this run?", "Pausing Run",
				JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {

			String userName = getUserName();
			String notebookName = getNotebookName();
			String experimentName = getExperimentName();
			String startTime = getStartTime();
			String transactionTime = new SimpleDateFormat(Constants.TIMEFORMAT)
					.format(new Date(System.currentTimeMillis()));
//			String command = "Pause";

			Run tempRun = User.getUser(userName).getNotebook(notebookName).getExperiment(
					experimentName).getRun(startTime);
			RunStatus rs = tempRun.getRunProgress();
//			tempRun.setExecutorCommand(transactionTime, command);
			
			if(!rs.current_stage_.contains("Aborted")){
//				// update run status to paused
				tempRun.insertRunLog(transactionTime, "Paused", rs.percentage_);
				tempRun.updateRunProgress(transactionTime, "Paused", rs.percentage_);				
			}
		}
	}

	private JPanel createButtonPanel() {
		JPanel buttonPanel = new JPanel();
		buttonPanel.setLayout(new FlowLayout());

		JButton button = new JButton("Pause Running Run");
		JButton button1 = new JButton("Abort Running Run");
		buttonPanel.add(button);
		buttonPanel.add(button1);
		button.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent ev) {
				PauseRunningRunActionPerformed(ev);
				AZDBLabObserver.checkRuns();
			}
		});

		button1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent ev) {
				AbortRunningRunActionPerformed(ev);
				AZDBLabObserver.checkRuns();
			}
		});

		JButton btn_AddComment = new JButton("Add Comment");
		btn_AddComment.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				AddCommentDlg dlg = new AddCommentDlg(getRunID());
				dlg.setModal(true);
				dlg.setVisible(true);

				refreshCommentList();
			}
		});
		buttonPanel.add(btn_AddComment);

		return buttonPanel;
	}

	private void AbortRunningRunActionPerformed(ActionEvent evt) {

		if (JOptionPane.showConfirmDialog(null,
				"Are you sure to abort this (paused) run?", "Aborting Run",
				JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {

			String userName = getUserName();
			String notebookName = getNotebookName();
			String experimentName = getExperimentName();

			String startTime = getStartTime();

			String transactionTime = new SimpleDateFormat(Constants.TIMEFORMAT)
					.format(new Date(System.currentTimeMillis()));

			Run temp_run = User.getUser(userName).getNotebook(notebookName)
					.getExperiment(experimentName).getRun(startTime);
			RunStatus runStat = temp_run.getRunProgress();

			temp_run.insertRunLog(transactionTime, "Aborted",
					runStat.percentage_);
			temp_run.updateRunProgress(transactionTime, "Aborted",
					runStat.percentage_);

		}
	}

	public JPanel getButtonPanel() {
		return createButtonPanel();
	}

	public JPanel getDataPanel() {

		AZDBLabObserver.putInfo("You are looking at a Running Run Node");
		return createRunningRunPanel();
	}

	@Override
	protected void loadChildNodes() {
		User t_u = User.getUser(strUserName);
		Notebook t_n = t_u.getNotebook(strNotebookName);
		Experiment t_e = t_n.getExperiment(strExperimentName);
		Run t_r = t_e.getRun(strStartTime);
		List<Query> myQueries = t_r.getExperimentRunQueries();
		//		
		// Vector<Query> myQueries = User.getUser(strUserName).getNotebook(
		// strNotebookName).getExperiment(strExperimentName).getRun(
		// strStartTime).getExperimentRunQueries();
		for (int i = 0; i < myQueries.size(); i++) {
			Query q = myQueries.get(i);
			parent.add(new AZDBLABMutableTreeNode(new QueryNode(q.iQueryID,
					q.iQueryNumber, q.getStrQuerySQL())));
		}
	}

	@Override
	public List<Comment> getComments() {
		return User.getUser(strUserName).getNotebook(strNotebookName)
				.getExperiment(strExperimentName).getRun(strStartTime)
				.getAllComments();
	}

	@Override
	protected Vector<String> getAuthors() {
		Vector<String> vecToRet = new Vector<String>();
		vecToRet.add("Rui Zhang");
		vecToRet.add("Young-Kyoon Suh");
		vecToRet.add("Matthew Johnson");
		return vecToRet;
	}

	@Override
	protected String getDescription() {
		return "This node contains information pertaining to a currently running node";
	}

}
