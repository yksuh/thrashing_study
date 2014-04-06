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

import azdblab.observer.api.ResultGraphLayoutInterface;


/**
 * The graph layout listener handles laying out the graphs according to the desired type of layout listener.
 * @author Kevan Holdaway
 *
 */
public class GraphLayoutListener implements ActionListener {
	/**
	 * Creates a listener to handle graph layout events.
	 * @param result An interface that provides the functionality to do the actual graph layout. 
	 * @param style The type of layout that is desired.  This can be the moving or traditional layout.
	 */
	public GraphLayoutListener(ResultGraphLayoutInterface result, int style) {
		_result = result;
		_type = style;
	}

	/**
	 * @see java.awt.event.ActionListener#actionPerformed(java.awt.event.ActionEvent)
	 */
	public void actionPerformed(ActionEvent e) {
		switch (_type) {
			case TRADITIONAL_LAYOUT :
				{
					_result.layoutTraditional();
					break;
				}
			case MOVING_LAYOUT :
				{
					_result.layoutMoving();
					break;
				}
		}

	}
	/**
	 * Indicates that a moving layout should be used.
	 */
	public static final int MOVING_LAYOUT = 1;

	/**
	 * Indicates that the traditional flat layout should be used.
	 */
	public static final int TRADITIONAL_LAYOUT = 0;
	/**
	 * The interface that allows the actual layout to be performed.
	 */
	private ResultGraphLayoutInterface _result;

	/**
	 * The type of layout that this listener will handle.
	 */
	private int _type;

}
