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

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import azdblab.observer.api.ResultCloseInterface;


/**
 * The close action listener handles all close actions or all events where the user wishes to close
 * an experiment that is being displayed by the result browser.
 * @author Kevan Holdaway
 *
 */
public class CloseActionListener implements ActionListener {
	/**
	 * Creates a CloseActionListener for the result browser.  There are two types of listeners.  
	 * The listener can either close a single experiment or it can close all experiments.
	 * @param result The ResultCloseInterface for this listener provides the actual functionality to
	 * close an experiment.
	 * @param type Determines whether this listener will close one or all experiments.
	 */
	public CloseActionListener(ResultCloseInterface result, int type) {
		_result = result;
		_type = type;
	}

	/**
	 * @see java.awt.event.ActionListener#actionPerformed(java.awt.event.ActionEvent)
	 */
	public void actionPerformed(ActionEvent e) {
		switch (_type) {
			case CLOSE_SINGLE :
				{
					_result.close();
					break;
				}
			case CLOSE_ALL :
				{
					_result.closeAll();
					break;
				}
		}
	}
	/**
	 * Specifies that this listener will close all experiments when an event is fired.
	 */
	public static final int CLOSE_ALL = 1;

	/**
	 * Specifies that this listener will close a single experiment when an event is fired.
	 */
	public static final int CLOSE_SINGLE = 0;

	/**
	 * Used to perform the actual close actions.
	 */
	private ResultCloseInterface _result;
	/**
	 * Determines whether this listener will close all experiments or a single experiment.
	 */
	private int _type;
}
