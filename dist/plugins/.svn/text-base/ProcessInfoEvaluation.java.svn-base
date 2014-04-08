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
package plugins;

import java.awt.event.ActionEvent;

import java.awt.event.ActionListener;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;
import java.util.Map.Entry;

import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JOptionPane;

import azdblab.Constants;
import azdblab.labShelf.InternalTable;
import azdblab.labShelf.dataModel.Experiment;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;
import azdblab.plugins.evaluation.Evaluation;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.objectNodes.CompletedRunNode;
import azdblab.swingUI.objectNodes.NotebookNode;
import azdblab.swingUI.objectNodes.ObjectNode;
import azdblab.swingUI.treeNodesManager.NodePanel;
@SuppressWarnings("unchecked")
public class ProcessInfoEvaluation extends Evaluation {

	public ProcessInfoEvaluation(ObjectNode sent) {
		super(sent);
	}

	@Override
	public Vector<JButton> getButtons() {
		if (myObjectNode instanceof NotebookNode) {
			return getNotebookLevelButtons();
		} else if (myObjectNode instanceof CompletedRunNode) {
			return getCompletedRunLevelButtons();
		} else {
			System.err
					.println("Error in ProcessInfoAspect.getButtons(), unexpected type of object Node");
		}
		return null;
	}

	private Vector<JButton> getNotebookLevelButtons() {
		JButton btn_ExportDBMSProcess = new JButton("Export DBMS Processes");
		btn_ExportDBMSProcess.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				try {
					AZDBLabObserver.timerOn = false;
					exportDBMSProcesses();
					JOptionPane.showMessageDialog(null,
							"Successfully Exported Information");
				} catch (Exception x) {
					JOptionPane.showMessageDialog(null,
							"Failed to export Information");
					x.printStackTrace();
				}
				AZDBLabObserver.timerOn = true;
			}
		});

		Vector<JButton> toRet = new Vector<JButton>();
		toRet.add(btn_ExportDBMSProcess);
		return toRet;

	}

	private Vector<JButton> getCompletedRunLevelButtons() {
		JButton btn_ComputeProcessInformation = new JButton(
				"Get Process Information for Run");
		btn_ComputeProcessInformation.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				JFileChooser chooser = new JFileChooser();
				chooser.setCurrentDirectory(new java.io.File("/home"));
				chooser.setDialogTitle("Select a save Destination");
				chooser.setAcceptAllFileFilterUsed(false);
				String directory = "";
				if (chooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
					directory += chooser.getSelectedFile();
				} else {
					System.out
							.println("No location selected, aborting operation");
					return;
				}
				try {
					User.getUser(
							((CompletedRunNode) myObjectNode).getUserName())
							.getNotebook(
									((CompletedRunNode) myObjectNode)
											.getNotebookName()).getExperiment(
									((CompletedRunNode) myObjectNode)
											.getExperimentName()).getRun(
									((CompletedRunNode) myObjectNode)
											.getStartTime())
							.saveProcessInformation(directory);
					JOptionPane.showMessageDialog(null, "Success!");
				} catch (Exception x) {
					x.printStackTrace();
					JOptionPane.showMessageDialog(null,
							"Failed to save process information");
				}

				AZDBLabObserver.timerOn = true;
			}
		});

		Vector<JButton> toRet = new Vector<JButton>();
		toRet.add(btn_ComputeProcessInformation);
		return toRet;
	}

	private void exportDBMSProcesses() throws Exception {

		JFileChooser chooser = new JFileChooser();
		chooser.setCurrentDirectory(new java.io.File("/home"));
		chooser.setDialogTitle("Where would you like the Process Maps saved");
		chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
		chooser.setAcceptAllFileFilterUsed(false);
		String directory = "";
		if (chooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
			directory += chooser.getSelectedFile();
		} else {
			throw new Exception();
		}

		List<Experiment> vecExperiments = User.getUser(
				((NotebookNode) myObjectNode).getUserName()).getNotebook(
				((NotebookNode) myObjectNode).getNotebookName())
				.getAllExperiments();
		Vector<Run> vecRuns = new Vector<Run>();

		for (int i = 0; i < vecExperiments.size(); i++) {
			vecRuns.addAll(vecExperiments.get(i).getCompletedRuns());
		}
		System.out.println("Looking at " + vecRuns.size() + " runs");

		String[] dbmsNames = Constants.DBMSs;
		for (int i = 0; i < dbmsNames.length; i++) {

			TreeMap<String, Integer> processMap = new TreeMap<String, Integer>();
			for (int j = 0; j < vecRuns.size(); j++) {
				if (vecRuns.get(j).getDBMS().equalsIgnoreCase(dbmsNames[i])) {
					TreeMap<String, Integer> tempMap = vecRuns.get(j)
							.getProcessInformation();
					mergeMaps(processMap, tempMap);
				}
			}
			TreeMap<String, Integer> sorted_map = new TreeMap<String, Integer>(
					new ValueComparator(processMap));

			sorted_map.putAll(processMap);

			saveMap(sorted_map, directory + "/" + dbmsNames[i] + "ProcessMap");
			System.out.println("Finished computing process information for "
					+ dbmsNames[i]);
		}
	}

	/**
	 * Merges two maps, the second argument is merged in to the first argument
	 * 
	 * @param MainMap
	 * @param toMerge
	 */
	private void mergeMaps(TreeMap<String, Integer> MainMap,
			TreeMap<String, Integer> toMerge) {

		Iterator<Entry<String, Integer>> it = toMerge.entrySet().iterator();
		while (it.hasNext()) {
			Entry<String, Integer> ent = (Entry<String, Integer>) it.next();
			if (!ent.getKey().equals("")) {
				if (MainMap.containsKey(ent.getKey())) {
					Integer oldNum = MainMap.get(ent.getKey());
					MainMap.put(ent.getKey(), oldNum + ent.getValue());
				} else {
					MainMap.put(ent.getKey(), ent.getValue());
				}
			}
			it.remove();
		}
	}

	private void saveMap(TreeMap<String, Integer> toSave, String fileName)
			throws Exception {
		Iterator<Entry<String, Integer>> it = toSave.entrySet().iterator();

		BufferedWriter out = new BufferedWriter(new FileWriter(fileName));
		while (it.hasNext()) {
			Entry<String, Integer> ent = (Entry<String, Integer>) it.next();
			if (!ent.getKey().equals("")) {
				out.write(ent.getKey() + ":" + ent.getValue() + "\n");
			}
			it.remove();
		}
		out.close();
	}

	@Override
	public String getName() {
		return "Process Info Aspect";
	}

	@Override
	public NodePanel getTabs() {
		return null;
	}

	@Override
	public Vector<InternalTable> getTables() {
		return null;
	}
	
	private class ValueComparator implements Comparator {

		Map base;

		public ValueComparator(Map base) {
			this.base = base;
		}

		public int compare(Object a, Object b) {

			if ((Integer) base.get(a) < (Integer) base.get(b)) {
				return 1;
			} else if ((Integer) base.get(a) == (Integer) base.get(b)) {
				return 0;
			} else {
				return -1;
			}
		}
	}

	@Override
	public Evaluation getInstance(ObjectNode sent) {
		return new ProcessInfoEvaluation(sent);
	}

	@Override
	public Vector<String> getSupportedClasses() {
		Vector<String> toRet = new Vector<String>();
		toRet.add("NotebookNode");
		toRet.add("CompletedRunNode");
		return toRet;
	}
	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
}
