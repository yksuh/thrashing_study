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

import azdblab.observer.api.ResultClipBoardInterface;


/**
 * The ClipBoardActionListener is a listener that waits for commands issued by the GUI to cut, paste, and copy
 * data to the Windows clipboard.  This handles this action.
 * @author Kevan Holdaway
 *
 */
public class ClipBoardActionListener implements ActionListener {

	/**
	 * Creates a listener for these actions.  The user must specify the type and pass a
	 * handle to the Frame.
	 * @param result An interface that performs the action.
	 * @param type The type of action that is being performed.
	 */
	public ClipBoardActionListener(ResultClipBoardInterface result, int type) {
		_result = result;
		_type = type;
	}
	/**
	 * @see java.awt.event.ActionListener#actionPerformed(java.awt.event.ActionEvent)
	 */
	public void actionPerformed(ActionEvent e) {
		switch (_type) {
			case COPY :
				{
					_result.copy();
					break;
				}
			case CUT :
				{
					_result.cut();
					break;
				}
			case PASTE :
				{
					_result.paste();
					break;
				}
		}
	}
	/**
	 * This type of action represents a Copy action.  This will copy data to the clipboard.
	 */
	public static final int COPY = 0;
	/**
	 * This type of action represents a Cut action.  This will cut data from the source and paste it on the
	 * clipboard.
	 */
	public static final int CUT = 1;
	/**
	 * This type of action represents a Paste action.  This will transfer data from the clipboard to 
	 * the destination object.
	 */
	public static final int PASTE = 2;

	/**
	 * A reference to the ResultClibBoardInterface.
	 */
	private ResultClipBoardInterface _result;
	/**
	 * The type of action that will be performed by this listener.
	 */
	private int _type;
}
