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

import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import azdblab.executable.Main;
import azdblab.swingUI.AZDBLabObserver;


/**
 * This is basically the entry point for the ResultBrowser. Calling the show
 * method will launch the result browser. The GUI listeners will then be the
 * main interaction for the user as the result browser handles events generated
 * by the GUI.
 * 
 */
public class ObserverGUI extends Thread {

	/**
	 * Commands the result browser to show itself so that the user can begin
	 * interacting with it.
	 */
	public void show() {
/*
	@mjseo
		In order to solve this problem, I tried to make test code to see the dialog working, and I was able to know different user interfaces between two dialogs, one of which is AZDBLab's observer dialog and the other is general java swing dialog. In the former dialog, I cannot use keyboard to find file fast, but in the latter dialog, I can do that. AZDBLab's observer has been using manual look-and-feel modification. The following source code can explain that.
		file: src/azdblab.swingUI/ObserverGUI.java

		part of source code:

		 public void show() {
		   try {
		     UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());

		Since we are using GNOME environment, this method call automatically set look-and-feel as GTK style. When applying this look-and-feel, keyboard doesn't work. One of possibility is bug of JDK.
		The method call, UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()), can makes AZDBLab's Observer GUI looks like native program. However, JfileChooser dialog doesn't work as general dialog. The problem is that we cannot use accessible key to find file fast.
		There might be three solutions.
		First, it is to make custom file chooser dialog class that can work at every platform such as Gtk, QT, and Windows, which is not simple solution. However, good thing of this method is that the user interface can be maintained by same interface.
		The second solution is not to use look-and-feel anymore. Also, The GTK related warning message we can see in console may have been occurred due to that manual look-and-feel adjustment.
		Third, we can use third party file chooser for JfileChooser for GTK File Chooser, gtkjfilechooser(http://code.google.com/p/gtkjfilechooser/ [^]).
		Please check this issue after commenting try-catch block in show() method of rc/azdblab.swingUI/ObserverGUI.java
*/
		try {
			UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
			UIManager.put("FileChooserUI", javax.swing.plaf.metal.MetalFileChooserUI.class.getName() );
	} catch (ClassNotFoundException e) {
			Main._logger.reportError("Couldn't use system look and feel.");
		} catch (InstantiationException e) {
			Main._logger.reportError("Couldn't use system look and feel.");
		} catch (IllegalAccessException e) {
			Main._logger.reportError("Couldn't use system look and feel.");
		} catch (UnsupportedLookAndFeelException e) {
			Main._logger.reportError("Couldn't use system look and feel.");
		}
		AZDBLabObserver browser = new AZDBLabObserver();
		browser.setVisible(true);
	}
}
