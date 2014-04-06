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
package azdblab.swingUI;

import java.awt.BorderLayout;

import java.awt.Color;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.GradientPaint;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ComponentEvent;
import java.awt.event.ComponentListener;
import java.awt.event.KeyEvent;
import java.io.File;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Timer;

import javax.swing.BorderFactory;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTextPane;
import javax.swing.JPanel;
import javax.swing.JTree;
import javax.swing.KeyStroke;
import javax.swing.event.TreeExpansionEvent;
import javax.swing.event.TreeExpansionListener;
import javax.swing.plaf.basic.BasicTreeUI;
import javax.swing.tree.DefaultTreeModel;
import javax.swing.tree.TreeModel;
import javax.swing.tree.TreePath;
import javax.swing.tree.TreeSelectionModel;
import salvo.jesus.graph.visual.GraphPanel;
import salvo.jesus.graph.visual.GraphScrollPane;
import salvo.jesus.graph.visual.VisualGraph;
import salvo.jesus.graph.visual.layout.ForceDirectedLayout;
import salvo.jesus.graph.visual.layout.GraphLayoutManager;
import salvo.jesus.graph.visual.layout.LayeredTreeLayout;
import java.util.Vector;
import javax.swing.JOptionPane;

import azdblab.Constants;
import azdblab.swingUI.objectNodes.*;

import java.util.TimerTask;

import azdblab.exception.sanitycheck.SanityCheckException;
import azdblab.executable.Main;
import azdblab.labShelf.creator.SpecifierFrm;
import azdblab.labShelf.creator.UserCreator;
import azdblab.labShelf.dataModel.Executor;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Run;
import azdblab.observer.api.ResultClipBoardInterface;
import azdblab.observer.api.ResultGraphLayoutInterface;
import azdblab.observer.api.ResultNavigationTreeInterface;
import azdblab.observer.controller.listeners.ExperimentTreeListener;
import azdblab.swingUI.dialogs.*;

import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;
import azdblab.swingUI.treeNodesManager.AZDBLABTreeCellRenderer;
import azdblab.swingUI.treeNodesManager.AZDBLabTreeUI;
import azdblab.utility.procdiff.LinuxProcessAnalyzer;
import azdblab.utility.procdiff.ProcessAnalyzer;
import azdblab.utility.procdiff.ProcessInfo;
import azdblab.utility.procdiff.WindowsProcessAnalyzer;

/**
 * The main GUI for azdblab observer
 * 
 */
public class AZDBLabObserver extends javax.swing.JFrame implements
		ResultNavigationTreeInterface, ResultClipBoardInterface,
		ResultGraphLayoutInterface {

	public static boolean timerOn = true;

	static final long serialVersionUID = System
			.identityHashCode("AZDBLabObserver");
	
//	public static MasterPluginManager masterManager;

	private class CheckingPendingAndRunning extends TimerTask {
		public void run() {
			if (timerOn) {
				checkRuns();
			}
		}
	}

	private class CheckingRunningAndPausedExecutors extends TimerTask {
		public void run() {
			if (timerOn) {
				checkExecutors();
			}
		}
	}
	
	private static JLabel lbl_StatusBar;
	
	private CheckingPendingAndRunning checkPnR;
	private CheckingRunningAndPausedExecutors checkPnRExe;

	private Timer timer;

	public static String currentUser;

	//public static ExecutionAspectPluginManager myAspectPluginManager;
	//public static HashMap<Class, PluginManager> masterManager;
	/**
	 * Creates a result browser frame.
	 */
	public AZDBLabObserver() {

		super();

		currentUser = System.getProperty("user.name");

		LabShelfConnectorDlg dcDlg = new LabShelfConnectorDlg(this);

		dcDlg.setModal(true);

		dcDlg.setVisible(true);

		if (Constants.getLABUSERNAME() == null
				|| Constants.getLABPASSWORD() == null
				|| Constants.getLABCONNECTSTRING() == null) {
			// if user closes dcDlg without hitting ok or cancel, exit
			System.exit(0);
		}

		 //System.out.println("User:"+Constants.getLABUSERNAME());
		 //System.out.println("Pass:"+Constants.getLABPASSWORD());
		 //System.out.println("Connect:"+Constants.getLABCONNECTSTRING());
		LabShelfManager.getShelf(Constants.getLABUSERNAME(), Constants
				.getLABPASSWORD(), Constants.getLABCONNECTSTRING(), Constants.getLABMACHINENAME());

		checkVersion();

		checkPnR = new CheckingPendingAndRunning();
		checkPnRExe = new CheckingRunningAndPausedExecutors();
		
		timer = new Timer();

		lbl_StatusBar = new JLabel("Ready...");
		
        // Check to make sure upper left corner icon directory is valid
//        File file = new File("src/" + Constants.DIRECTORY_IMAGE);
//        if (!file.isDirectory())
//                Main._logger
//                .reportError("the directory for \"left_icon.gif\" is incorrect in AZDBLabObserver.java");

        // Set the corner image on the window frame (Maybe change Icon)?
//        String cornerImageString = "src/" + Constants.DIRECTORY_IMAGE + "left_icon.gif";
//        ImageIcon cornerImg = new ImageIcon(cornerImageString);
//        this.setIconImage(cornerImg.getImage());


		// Check to make sure upper left corner icon directory is valid
		// Set the corner image on the window frame (Maybe change Icon)?
		String cornerImageString = Constants.DIRECTORY_IMAGE + "left_icon.gif";
		ImageIcon cornerImg = new ImageIcon(cornerImageString);
		this.setIconImage(cornerImg.getImage());
		
		init();

	}
	
	/**
	 * This method updates the status bar at the bottom of the Observer with the
	 * given Method
	 * 
	 * @param info
	 */
	public static void putInfo(String info) {
		lbl_StatusBar.setText(info);
	}

	private void checkVersion() {
		try {
			String tmpVersion = Constants.AZDBLAB_VERSION.replace(".", "TOKEN")
					.split("TOKEN")[0];
			String sql = "select * from azdblab_version where versionname Like '"
					+ tmpVersion + ".%'";

			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			if (!rs.next()) {
				Main._logger
						.reportError("Executor version does not exist in AZDBLAB: ");
				Main._logger.reportError("Observer version: "
						+ Constants.AZDBLAB_VERSION);
				System.exit(-1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void updateTree() {
		myTree.updateUI();
	}

	private void loadPlugin() {		
		
		// Experiment Subject plugin Node
		ExperimentSubjectPluginNode expSubNode = new ExperimentSubjectPluginNode();
		AZDBLABMutableTreeNode expSubTreeNode = new AZDBLABMutableTreeNode(
				expSubNode);

		treeNodePluginCollected.add(expSubTreeNode);

		// Aspect plugin Node
//		AspectPluginNode aspNode = new AspectPluginNode();
//		AZDBLABMutableTreeNode aspTreeNode = new AZDBLABMutableTreeNode(aspNode);

//		treeNodePluginCollected.add(aspTreeNode);
//
//		// Analytic plugin Node
//		AnalyticPluginNode anlNode = new AnalyticPluginNode();
//		AZDBLABMutableTreeNode anlTreeNode = new AZDBLABMutableTreeNode(anlNode);

//		treeNodePluginCollected.add(anlTreeNode);
		// Scenario plugin Node
		ScenarioPluginNode scenNode = new ScenarioPluginNode();
		AZDBLABMutableTreeNode scenTreeNode = new AZDBLABMutableTreeNode(
				scenNode);

		treeNodePluginCollected.add(scenTreeNode);
		
		// Evaluation plugin node
		EvaluationPluginNode EANode = new EvaluationPluginNode();
		AZDBLABMutableTreeNode EATreeNode = new AZDBLABMutableTreeNode(
				EANode);
		treeNodePluginCollected.add(EATreeNode);
		
		// Protocol plugin node
		ProtocolPluginNode PNode = new ProtocolPluginNode();
		AZDBLABMutableTreeNode PTreeNode = new AZDBLABMutableTreeNode(
				PNode);

		treeNodePluginCollected.add(PTreeNode);
		
	}

	private void loadExecutor() {
		// Experiment Subject plugin Node
		Vector<Executor> executors = Executor.getAllExecutors();
		Vector<ExecutorNode> vecExeNode = new Vector<ExecutorNode>();
		Vector<PausedExecutorNode> vecPausedExeNode = new Vector<PausedExecutorNode>();
		for (Executor e : executors) {
			String status = (e.getExecutorState(e.getMachineName(), e.getDBMS()).strCurrentStatus);
			if(status.toLowerCase().contains("pause")){
				PausedExecutorNode en = new PausedExecutorNode(
						e.getMachineName(),
						e.getDBMS(),
						status,
						e.getExecutorState(e.getMachineName(), e.getDBMS()).strCommand);
				vecPausedExeNode.add(en);
			}else{
				ExecutorNode en = new ExecutorNode(
						e.getMachineName(),
						e.getDBMS(),
						status,
						e.getExecutorState(e.getMachineName(), e.getDBMS()).strCommand);
				vecExeNode.add(en);
			}
		}
		treeNodeExecutorCollected.removeAllChildren();
		for (int i = 0; i < vecExeNode.size(); i++) {
			ExecutorNode exeNode = vecExeNode.get(i);
			AZDBLABMutableTreeNode exeTreeNode = new AZDBLABMutableTreeNode(
					exeNode);

			treeNodeExecutorCollected.add(exeTreeNode);
		}
		treeNodePausedExecutorCollected.removeAllChildren();
		for (int i = 0; i < vecPausedExeNode.size(); i++) {
			PausedExecutorNode exeNode = vecPausedExeNode.get(i);
			AZDBLABMutableTreeNode exeTreeNode = new AZDBLABMutableTreeNode(
					exeNode);

			treeNodePausedExecutorCollected.add(exeTreeNode);
		}
	}
	
	public static void checkExecutors() {

		if (myTree.getSelectionPath() != null) {
			Object[] path = myTree.getSelectionPath().getPath();

			if (path.length > 0) {
				ObjectNode userObj = (ObjectNode) ((AZDBLABMutableTreeNode) path[path.length - 1])
						.getUserObject();
				if (userObj instanceof ExecutorNode
				 || userObj instanceof PausedExecutorNode) {
					return;
				} else if (userObj instanceof QueryNode) {
					ObjectNode tmpObj = (ObjectNode) ((AZDBLABMutableTreeNode) path[path.length - 2])
							.getUserObject();
					if (tmpObj instanceof ExecutorNode) {
						return;
					}
				} else if (userObj instanceof PlanDetailNode) {
					ObjectNode tmpObj = (ObjectNode) ((AZDBLABMutableTreeNode) path[path.length - 3])
							.getUserObject();
					if (tmpObj instanceof ExecutorNode) {
						return;
					}
				}

			}
		}
		List<ExecutorNode> vecExecutors = LabShelfManager.getShelf().getAllExecutors();
		// insert the running run and pending run node
		if ((vecExecutors != null) && (vecExecutors.size() != 0)) {

			TreePath newTPRunning = new TreePath(treeNodeExecutorCollected.getPath());
			boolean runningExecutorExpand = myTree.isExpanded(newTPRunning);

			if (!myTree.isCollapsed(newTPRunning)) {
				myTree.collapsePath(newTPRunning);
			}
			treeNodeExecutorCollected.removeAllChildren();

			TreePath newTPPaused = new TreePath(treeNodePausedExecutorCollected
					.getPath());
			boolean pausedExecutorExpand = myTree.isExpanded(newTPPaused);

			if (!myTree.isCollapsed(newTPPaused)) {
				myTree.collapsePath(newTPPaused);
			}
			treeNodePausedExecutorCollected.removeAllChildren();
			
			for (int i = 0; i < vecExecutors.size(); i++) {
				ExecutorNode exeNode = vecExecutors.get(i);

				if (exeNode.getType() == Run.TYPE_PAUSED) {
					treeNodePausedExecutorCollected.add(new AZDBLABMutableTreeNode(
							exeNode));
				} else {
					treeNodeExecutorCollected.add(new AZDBLABMutableTreeNode(
							exeNode));
				}
			}

			if (newTPRunning != null) {
				if (runningExecutorExpand) {
					myTree.expandPath(newTPRunning);
				}
			}

			if (newTPPaused != null) {
				if (pausedExecutorExpand) {
					myTree.expandPath(newTPPaused);
				}
			}

		} else {

		}

		myTree.repaint();

	}
	
	public static void checkRuns() {

		if (myTree.getSelectionPath() != null) {
			Object[] path = myTree.getSelectionPath().getPath();

			if (path.length > 0) {
				ObjectNode userObj = (ObjectNode) ((AZDBLABMutableTreeNode) path[path.length - 1])
						.getUserObject();
				if (userObj instanceof RunningRunNode
						|| userObj instanceof PausedRunNode
						|| userObj instanceof AbortedRunNode
						|| userObj instanceof PendingRunNode) {
					return;
				} else if (userObj instanceof QueryNode) {
					ObjectNode tmpObj = (ObjectNode) ((AZDBLABMutableTreeNode) path[path.length - 2])
							.getUserObject();
					if (tmpObj instanceof RunningRunNode) {
						return;
					}
				} else if (userObj instanceof PlanDetailNode) {
					ObjectNode tmpObj = (ObjectNode) ((AZDBLABMutableTreeNode) path[path.length - 3])
							.getUserObject();
					if (tmpObj instanceof RunningRunNode) {
						return;
					}
				}

			}
		}
		List<RunStatusNode> vecRuns = LabShelfManager.getShelf().getAllRuns();
		// insert the running run and pending run node
		if ((vecRuns != null) && (vecRuns.size() != 0)) {

			TreePath newTPRunning = new TreePath(treeNodeRunningRunCollected
					.getPath());
			boolean runningRunExpand = myTree.isExpanded(newTPRunning);

			if (!myTree.isCollapsed(newTPRunning)) {
				myTree.collapsePath(newTPRunning);
			}
			treeNodeRunningRunCollected.removeAllChildren();

			TreePath newTPPending = new TreePath(treeNodePendingRunCollected
					.getPath());
			boolean pendingRunExpand = myTree.isExpanded(newTPPending);

			if (!myTree.isCollapsed(newTPPending)) {
				myTree.collapsePath(newTPPending);
			}
			treeNodePendingRunCollected.removeAllChildren();

			TreePath newTPPaused = new TreePath(treeNodePausedRunCollected
					.getPath());
			boolean pausedRunExpand = myTree.isExpanded(newTPPaused);

			if (!myTree.isCollapsed(newTPPaused)) {
				myTree.collapsePath(newTPPaused);
			}
			treeNodePausedRunCollected.removeAllChildren();

			TreePath newTPAborted = new TreePath(treeNodeAbortedRunCollected
					.getPath());
			boolean abortedRunExpand = myTree.isExpanded(newTPAborted);

			if (!myTree.isCollapsed(newTPAborted)) {
				myTree.collapsePath(newTPAborted);
			}
			treeNodeAbortedRunCollected.removeAllChildren();
		//	System.out.println("--------------------");
			
			for (int i = 0; i < vecRuns.size(); i++) {
				RunStatusNode rsNode = vecRuns.get(i);

				if (rsNode.getType() == Run.TYPE_RUNNING) {
					treeNodeRunningRunCollected.add(new AZDBLABMutableTreeNode(
							rsNode));
				} else if (rsNode.getType() == Run.TYPE_PENDING) {
					treeNodePendingRunCollected.add(new AZDBLABMutableTreeNode(
							rsNode));
				//	System.out.println(rsNode.getDBMS() + " :: " +rsNode.getExperimentName());
				} else if (rsNode.getType() == Run.TYPE_PAUSED) {
					treeNodePausedRunCollected.add(new AZDBLABMutableTreeNode(
							rsNode));
				} else if (rsNode.getType() == Run.TYPE_ABORTED) {
					treeNodeAbortedRunCollected.add(new AZDBLABMutableTreeNode(
							rsNode));
				}
			}

			if (newTPRunning != null) {
				if (runningRunExpand) {
					myTree.expandPath(newTPRunning);
				}
			}

			if (newTPPending != null) {
				if (pendingRunExpand) {
					myTree.expandPath(newTPPending);
				}
			}

			if (newTPPaused != null) {
				if (pausedRunExpand) {
					myTree.expandPath(newTPPaused);
				}
			}

			if (newTPAborted != null) {
				if (abortedRunExpand) {
					myTree.expandPath(newTPAborted);
				}
			}

		} else {

		}

		myTree.repaint();

	}

	/**
	 * @see azdblab.observer.api.ResultNavigationTreeInterface#clearRightComponent()
	 */
	public void clearRightComponent() {
		setRightSideAsEditor(new JTextPane());
	}

	/**
	 * @see azdblab.observer.api.ResultClipBoardInterface#copy()
	 */
	public void copy() {
		if (_rightTextPane != null)
			_rightTextPane.copy();

	}

	/**
	 * @see azdblab.observer.api.ResultClipBoardInterface#cut()
	 */
	public void cut() {
		if (_rightTextPane != null)
			_rightTextPane.cut();
	}

	/**
	 * @see azdblab.observer.api.ResultNavigationTreeInterface#getCurrentSelectionPath()
	 */
	public TreePath getCurrentSelectionPath() {

		return _currentSelectedExperimentPath;
	}

	/**
	 * Creates the MenuBar for the JFrame.
	 * 
	 * @return A JMenuBar for this JFrame.
	 */
	private JMenuBar getNewMenuBar() {

		JMenuBar j = new JMenuBar();

		// Creating the File Menu
		JMenu file = new JMenu("File");
		file.setMnemonic('F');

		JMenu help = new JMenu("Help");
		help.setMnemonic('H');

		// Toolkit kit = Toolkit.getDefaultToolkit();

		// Creating the "lab shelf creator" Menu Item
		JMenuItem openManager = new JMenuItem("Open AZDBLab manager");
		openManager.addActionListener(new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent arg0) {
				SpecifierFrm sfrm = new SpecifierFrm();
				sfrm.setVisible(true);
			}
		});
		
		// Creating the "exit" menu option
		JMenuItem exit = new JMenuItem("Exit");
		exit.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F4,
				ActionEvent.ALT_MASK));
		exit.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				checkPnR.cancel();
				checkPnRExe.cancel();
				System.exit(0);
			}
		});
		
		file.add(openManager);
		file.addSeparator();
		file.add(exit);

		help.add(getMnuitm_Schema());
		help.add(getMnuitm_About());

		// Adding the menus to the main menu bar
		j.add(file);
		j.add(help);

		return j;
	}

	/**
	 * Creates the navigation tree on the left.
	 * 
	 * @return The Navigation tree that will be used. This appears on the left
	 *         side of the GUI.
	 */
	private JTree createLHSTree() {
		// Creating the tree.
		JTree tree = new JTree();
		tree.setEditable(false);
		tree.setCellRenderer(new AZDBLABTreeCellRenderer());

		// Setting the root element for the tree.
		myTreeRoot = new AZDBLABMutableTreeNode("Root");

		// Root Level Node for USER
		CollectedUserNode cuNode = new CollectedUserNode();

		treeNodeUser = new AZDBLABMutableTreeNode(cuNode);

		// Root Level Node for ASPECTS
		CollectedAspectNode caNode = new CollectedAspectNode();
		treeNodeAspectCollected = new AZDBLABMutableTreeNode(caNode);

		// Root Level Node for ANALYTICS
		CollectedAnalyticNode canlNode = new CollectedAnalyticNode();
		treeNodeAnalyticCollected = new AZDBLABMutableTreeNode(canlNode);

		// Root Level Node for PENDING RUNS
		CollectedPendingRunNode prcNode = new CollectedPendingRunNode();
		treeNodePendingRunCollected = new AZDBLABMutableTreeNode(prcNode);

		// Root Level Node for RUNNING RUNS
		CollectedRunningRunNode rrcNode = new CollectedRunningRunNode();
		treeNodeRunningRunCollected = new AZDBLABMutableTreeNode(rrcNode);

		// Root Level Node for PAUSED RUNS
		CollectedPausedRunNode psdNode = new CollectedPausedRunNode();
		treeNodePausedRunCollected = new AZDBLABMutableTreeNode(psdNode);

		// Root Level Node for ABORTED RUNS
		CollectedAbortedRunNode abrNode = new CollectedAbortedRunNode();
		treeNodeAbortedRunCollected = new AZDBLABMutableTreeNode(abrNode);

		// Root Level Node for PLUGINS
		CollectedPluginNode plgNode = new CollectedPluginNode();
		treeNodePluginCollected = new AZDBLABMutableTreeNode(plgNode);

		CollectedExecutorNode exeNode = new CollectedExecutorNode();
		treeNodeExecutorCollected = new AZDBLABMutableTreeNode(exeNode);

		CollectedPausedExecutorNode pausedExecNode = new CollectedPausedExecutorNode();
		treeNodePausedExecutorCollected = new AZDBLABMutableTreeNode(pausedExecNode);
		
		myTreeRoot.add(treeNodeUser);
		myTreeRoot.add(treeNodeAspectCollected);
		myTreeRoot.add(treeNodeAnalyticCollected);

		myTreeRoot.add(treeNodePendingRunCollected);
		myTreeRoot.add(treeNodeRunningRunCollected);
		myTreeRoot.add(treeNodePausedRunCollected);
		myTreeRoot.add(treeNodeAbortedRunCollected);

		myTreeRoot.add(treeNodePluginCollected);

		myTreeRoot.add(treeNodeExecutorCollected);
		
		myTreeRoot.add(treeNodePausedExecutorCollected);

		// Setting the model for the tree.
		TreeModel model = new DefaultTreeModel(myTreeRoot);

		// Setting the selection mode on the selection model.
		TreeSelectionModel select = tree.getSelectionModel();
		select.setSelectionMode(TreeSelectionModel.SINGLE_TREE_SELECTION);
		tree.setModel(model);

		tree.addTreeExpansionListener(new TreeExpansionListener() {

			@Override
			public void treeCollapsed(TreeExpansionEvent event) {
			}

			@Override
			public void treeExpanded(TreeExpansionEvent event) {
				AZDBLABMutableTreeNode mtn = (AZDBLABMutableTreeNode) event
						.getPath().getLastPathComponent();
				if (((ObjectNode) mtn.getUserObject()).loadChildren()) {
					((DefaultTreeModel) ((JTree) event.getSource()).getModel())
							.nodeStructureChanged(mtn);
				}
			}

		});

		// Adding a selection listener to handle selection events on the tree.
		tree.addTreeSelectionListener(new ExperimentTreeListener(this));

		// cuNode.AssignTreeNodeUser(tree, treeNodeUser);
		return tree;
	}

	/**
	 * Called by the constructor to setup the GUI in its initial state with no
	 * open experiments.
	 */
	private void init() {

		// Tells the Java VM to exit when the JFrame is closed.
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		// Setting the initial size and location of the window.
		Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
		Dimension frameSize = new Dimension(screenSize.width - 80,
				screenSize.height - 80);

		this.setSize(frameSize);
		this.setLocation(
				(int) (screenSize.getWidth() - frameSize.getWidth()) / 2,
				(int) (screenSize.getHeight() - frameSize.getHeight()) / 2);
		this.setTitle(strAZDBLABTitle);

		this.addComponentListener(new ComponentListener() {
			
			@Override
			public void componentHidden(ComponentEvent arg0) {
			}

			@Override
			public void componentMoved(ComponentEvent arg0) {
			}

			@Override
			public void componentResized(ComponentEvent arg0) {
				// System.out.println("resizing");
				// TODO write the resize listener
				mySplitPane.setDividerLocation(.2);

				myRightSplitPane.setDividerLocation(myRightSplitPane
						.getHeight() - 60); // this shouldn't be proportional,
												// it should be fixed at
												// frameSize/height -130

			}

			@Override
			public void componentShown(ComponentEvent arg0) {
			}
		});
		// Setting the MenuBar
		JMenuBar myMenuBar = getNewMenuBar();
		this.setJMenuBar(myMenuBar);

		myContentPane = this.getContentPane();

		BorderLayout myLayout = new BorderLayout();
		myLayout.setHgap(5);

		myContentPane.setLayout(myLayout);

		// Creating the tree on the left that is used to navigate through the
		// experiments.
		myTree = createLHSTree();
		myTree.setRootVisible(true);

		JScrollPane treePane = new JScrollPane(myTree);
		treePane
				.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
		treePane
				.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
		treePane.setBorder(BorderFactory.createLineBorder(Color.black));

		mySplitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, false);
		mySplitPane.setLeftComponent(treePane);

		mySplitPane.setBorder(BorderFactory.createLineBorder(Color.black));

		mapOpenedExperiments = new HashMap<String, String>();

		myRightGraphPane = new GraphScrollPane();
		myRightGraphPane
				.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
		myRightGraphPane
				.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
		myRightGraphPane.setBorder(BorderFactory.createLineBorder(Color.black));
		myGraphPanel = (GraphPanel) myRightGraphPane.getViewport().getView();
		myRightGraphPane.setPreferredSize(new Dimension(frameSize.width / 4,
				825));
		myRightGraphButtonPanel = new GraphScrollPane();
		myRightGraphButtonPanel
				.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
		myRightGraphButtonPanel
				.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_NEVER);

		myRightGraphButtonPanel.setBorder(BorderFactory
				.createLineBorder(Color.black));
		myRightSplitPane = new JSplitPane(JSplitPane.VERTICAL_SPLIT, false);

		myRightSplitPane.setTopComponent(myRightGraphPane);
		myRightSplitPane.setBottomComponent(myRightGraphButtonPanel);

		myRightSplitPane.setDividerLocation(frameSize.height - 110);
		mySplitPane.setRightComponent(myRightSplitPane);
		myTree.setRootVisible(false);

		mySplitPane.setDividerLocation(Math.min(frameSize.width / 4, 400));
		myContentPane.add(mySplitPane, BorderLayout.CENTER);

		lbl_StatusBar.setBorder(BorderFactory.createLoweredBevelBorder());

		loadPlugin();
		loadExecutor();
		if(!Constants.DEMO_SCREENSHOT){
			timer.scheduleAtFixedRate(checkPnR, 2000, Constants.UPDATE_INTERVAL);
			timer.scheduleAtFixedRate(checkPnRExe, 2000, Constants.UPDATE_INTERVAL);
		}else{
			checkRuns();
			checkExecutors();
		}
		
	}

	/**
	 * @see azdblab.observer.api.ResultGraphLayoutInterface#layoutMoving()
	 */
	public void layoutMoving() {
		myRightGraphPane.getVisualGraph().setGraphLayoutManager(
				myForcedGraphLayout);
		myRightGraphPane.getVisualGraph().layout();
	}

	/**
	 * @see azdblab.observer.api.ResultGraphLayoutInterface#layoutTraditional()
	 */
	public void layoutTraditional() {
		myRightGraphPane.getVisualGraph().setGraphLayoutManager(
				myLayeredGraphLayout);
		myRightGraphPane.getVisualGraph().layout();
	}

	/**
	 * @see azdblab.observer.api.ResultClipBoardInterface#paste()
	 */
	public void paste() {
		if (_rightTextPane != null)
			_rightTextPane.paste();
	}

	/**
	 * @see azdblab.observer.api.ResultNavigationTreeInterface#setCurrentSelectionPath(javax.swing.tree.TreePath)
	 */
	public void setCurrentSelectionPath(TreePath curr) {
		_currentSelectedExperimentPath = curr;
	}

	/**
	 * @see azdblab.observer.api.ResultNavigationTreeInterface#setLayouts(salvo.jesus.graph.visual.layout.LayeredTreeLayout,
	 *      salvo.jesus.graph.visual.layout.ForceDirectedLayout)
	 */
	public void setLayouts(LayeredTreeLayout lay1, ForceDirectedLayout lay2) {
		myLayeredGraphLayout = lay1;
		myForcedGraphLayout = new ForceDirectedLayout(myRightGraphPane
				.getVisualGraph());
	}

	/**
	 * @see azdblab.observer.api.ResultNavigationTreeInterface#setPreviousSelectionPath(javax.swing.tree.TreePath)
	 */
	public void setPreviousSelectionPath(TreePath old) {

		if (old != null
				&& old.getPathCount() > 1
				&& mapOpenedExperiments.get(((AZDBLABMutableTreeNode) old
						.getPathComponent(1)).getUserObject().toString()) == null) {

		}
	}

	/**
	 * @see azdblab.observer.api.ResultNavigationTreeInterface#setRightSideAsEditor(javax.swing.JTextPane)
	 */
	public void setRightSideAsEditor(JTextPane right) {
		// Sets the right side of the pane to be a JTextPane. Enables
		// appropriate buttons and actions.

		_rightTextPane = right;
		myRightGraphPane.setViewportView(right);

		Dimension rightSize = right.getPreferredScrollableViewportSize();

		rightSize.width++;
		myRightGraphPane.getViewport().setViewSize(rightSize);
		rightSize.width--;
		myRightGraphPane.getViewport().setViewSize(rightSize);
	}

	/**
	 * @see azdblab.observer.api.ResultNavigationTreeInterface#setRightSideAsGraph(salvo.jesus.graph.visual.VisualGraph)
	 */
	public void setRightSideAsGraph(VisualGraph right) {
		// Sets the right pane as a VisualGraph. Enables the appropriate buttons
		// for a visual graph and disables buttons that
		// are not meaningful for this context.

		myGraphPanel.setVisualGraph(right, myRightGraphPane);
		myRightGraphPane.setViewportView(myGraphPanel);
		Dimension rightSize = myGraphPanel.getPreferredSize();

		rightSize.width++;
		myRightGraphPane.getViewport().setViewSize(rightSize);
		rightSize.width--;
		myRightGraphPane.getViewport().setViewSize(rightSize);

	}

	public void setRightSideAsPanel(JPanel tmpPanel) {
		myRightGraphPane.setViewportView(tmpPanel);
	}

	public void setRightSideAsPanel1(JPanel bottomPanel) {
		if (bottomPanel != null) {
			myRightGraphButtonPanel.setViewportView(bottomPanel);
		} else {
			myRightGraphButtonPanel.setViewportView(new JPanel());
		}
	}

	private TreePath _currentSelectedExperimentPath;
	/**
	 * The stores a list of all currently opened experiments.
	 */
	private HashMap<String, String> mapOpenedExperiments;

	/**
	 * This stores the previously selected experiment. If the current experiment
	 * is closed this experiment will be selected again.
	 */

	/*
	 * This is the right pane of the GUI. The content of the selected item in
	 * the tree is stored here.
	 */
	private JTextPane _rightTextPane;

	/**
	 * setRightSideAsPanel The Container that holds all objects for this GUI.
	 */
	private Container myContentPane = null;
	/**
	 * The layout manager that performs the moving graph layout.
	 */
	private GraphLayoutManager myForcedGraphLayout;
	/**
	 * The JPanel that holds the query plan graph being displayed.
	 */
	private GraphPanel myGraphPanel;
	/**
	 * The layout manager that performs the traditional tree layout.
	 */
	private GraphLayoutManager myLayeredGraphLayout;

	/**
	 * The right graph scroll pane is the scroll pane used to display the
	 * contents that are selected in the left navigation tree.
	 */
	private GraphScrollPane myRightGraphPane, myRightGraphButtonPanel;
	/**
	 * The split pane has a verticle split, with a left and right
	 * setRightSideAsPanelside. The left side holds the navigation tree and the
	 * right side holds the contents of the selected item in the navigation
	 * tree.
	 */
	private JSplitPane mySplitPane;
	private JSplitPane myRightSplitPane;
	/**
	 * The title of the result browser window.
	 */
	private String strAZDBLABTitle = "AZDBLab Observer";

	/**
	 * The navigation tree found on the left.
	 */
	private static JTree myTree;

	/**
	 * The root node of the tree.
	 */
	private AZDBLABMutableTreeNode myTreeRoot;

	private AZDBLABMutableTreeNode treeNodeUser;

	private AZDBLABMutableTreeNode treeNodeAnalyticCollected;

	private AZDBLABMutableTreeNode treeNodeAspectCollected;

	private static AZDBLABMutableTreeNode treeNodePendingRunCollected;

	private static AZDBLABMutableTreeNode treeNodeRunningRunCollected;

	private static AZDBLABMutableTreeNode treeNodePausedRunCollected;

	private static AZDBLABMutableTreeNode treeNodeAbortedRunCollected;

	private AZDBLABMutableTreeNode treeNodePluginCollected;

	private static AZDBLABMutableTreeNode treeNodeExecutorCollected;

	private static AZDBLABMutableTreeNode treeNodePausedExecutorCollected;

	/************* Menu Section ************/

	private JMenuItem mnuitm_session = null;

	/************* Menu Section ************/
	private JMenuItem getMnuitm_About() {
		if (mnuitm_session == null) {
			mnuitm_session = new JMenuItem();
			mnuitm_session.setText("Session Information");

			mnuitm_session.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent evt) {
					mnuitm_sessionActionPerformed(evt);
				}
			});
		}
		return mnuitm_session;
	}

	private JMenuItem mnuitm_schema = null;

	private JMenuItem getMnuitm_Schema() {
		if (mnuitm_schema == null) {
			mnuitm_schema = new JMenuItem();
			mnuitm_schema.setText("View Table Schema");

			mnuitm_schema.addActionListener(new ActionListener() {
				@Override
				public void actionPerformed(ActionEvent e) {
					mnuitm_schemaActionPreformed(e);
				}
			});
		}
		return mnuitm_schema;
	}

	private void mnuitm_sessionActionPerformed(ActionEvent evt) {
		String str_About = "You are logged in to LabShelf:"
				+ Constants.getNOTEBOOKNAME() + "\n";
		str_About += "As user:" + Constants.getLABUSERNAME() + "\n";
		str_About += "On AZDBLab Version:" + Constants.AZDBLAB_VERSION + "\n";

		JOptionPane.showMessageDialog(null, str_About, "About AZDBLab",
				JOptionPane.INFORMATION_MESSAGE, new ImageIcon("./src/"
						+ Constants.DIRECTORY_IMAGE + "azdblab.png"));
	}

	private void mnuitm_schemaActionPreformed(ActionEvent evt) {
		ViewTableSchemaDlg viewDlg = new ViewTableSchemaDlg(this);
		viewDlg.setVisible(true);
	}

	/**
	 * The purpose of this method is to allow object nodes to add elements to
	 * the tree<br>
	 * the UI will be updated accordingly.
	 * 
	 * @param parent
	 * @param child
	 */
	public static void addElementToTree(AZDBLABMutableTreeNode parent,
			AZDBLABMutableTreeNode child) {
		((DefaultTreeModel) myTree.getModel()).insertNodeInto(child, parent,
				parent.getChildCount());
		if(!Constants.DEMO_SCREENSHOT){
			myTree.updateUI();	
		}
	}

	public static void updateUI() {
		myTree.updateUI();
	}

	/**
	 * The purpose of this method is to allow objectNodes to remove nodes from
	 * the tree, the UI will be updated accordingly
	 * 
	 * @param toRemove
	 */
	public static void removeElement(AZDBLABMutableTreeNode toRemove) {
		((DefaultTreeModel) myTree.getModel()).removeNodeFromParent(toRemove);
		if(!Constants.DEMO_SCREENSHOT){
			myTree.updateUI();	
		}
	}

	public static String getCurrentUser() {
		return currentUser;
	}

}
