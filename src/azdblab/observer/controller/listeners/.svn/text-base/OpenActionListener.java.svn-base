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
package azdblab.observer.controller.listeners;

import java.awt.Component;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import javax.swing.JFileChooser;
import javax.swing.filechooser.FileFilter;
import azdblab.observer.api.ResultOpenInterface;


/**
 * This ActionListener handles the open action events to open experiments.  
 * @author Kevan Holdaway
 *
 */
public class OpenActionListener implements ActionListener {

	/**
	 * This implementation of FileFilter is used to ensure that the JFileChooser only displays XML files or
	 * directories.
	 * @author Kevan Holdaway
	 *
	 */
	private class XMLFileFilter extends FileFilter {

		/**
		 * @see javax.swing.filechooser.FileFilter#accept(java.io.File)
		 */
		public boolean accept(File f) {
			return f.getName().endsWith(".xml") || f.isDirectory();
		}

		/**
		 * @see javax.swing.filechooser.FileFilter#getDescription()
		 */
		public String getDescription() {
			return "Experiments (*.xml)";
		}

	}
	/**
	 * Creates an OpenActionListener.
	 * @param parent The parent window of this the JFileChooser that will be opened.  This is only used to 
	 * determine the location of the JFileChooser on the users monitor.
	 * @param result Used to actually performed the open action of the Frame.
	 */
	public OpenActionListener(Component parent, ResultOpenInterface result) {
		_parent = parent;
		_result = result;
	}

	/**
	 * @see java.awt.event.ActionListener#actionPerformed(java.awt.event.ActionEvent)
	 */
	public void actionPerformed(ActionEvent e) {
		
		//Creating the JFileChooser, setting the default directory to the default XML source directory.
		//JFileChooser chooser = new JFileChooser(new File(AZDBLAB.XML_SOURCE_DIRECTORY));
		JFileChooser chooser = new JFileChooser(new File(System.getProperty("user.dir")));
		XMLFileFilter filter = new XMLFileFilter();
		chooser.setFileFilter(filter);
		chooser.setAcceptAllFileFilterUsed(false);
		
		//Allows multiple selections
		chooser.setMultiSelectionEnabled(true);
		int returnVal = chooser.showOpenDialog(_parent );
		if (returnVal == JFileChooser.APPROVE_OPTION) {
			
			//For each file selected perform the open action.
			File[] selectedFiles = chooser.getSelectedFiles();
			for (int i = 0; i < selectedFiles.length; i++)
				_result.loadExperiment(selectedFiles[i].getAbsolutePath());
		}

	}

	/**
	 * The parent Component for the JFileChooser.
	 */
	private Component _parent;
	/**
	 * The ResultOpenInterface actually performs the open action.
	 */
	private ResultOpenInterface _result;
}
