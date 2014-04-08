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
package azdblab.swingUI.dialogs;

import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.filechooser.FileFilter;

import com.panayotis.gnuplot.JavaPlot;
import com.panayotis.gnuplot.swing.JPlot;
import com.panayotis.gnuplot.terminal.PostscriptTerminal;

public class ShowFigureDlg {

	private JFrame myFrame;
	private JavaPlot myPlot;
	

	public ShowFigureDlg(JavaPlot sentPlot) {
		myPlot = sentPlot;

		showDialog();
	}

	private void showDialog() {
		JButton btn_close = new JButton("Close");
		btn_close.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				myFrame.dispose();
			}
		});

		JButton btn_GNUSave = new JButton("Save Figure");
		btn_GNUSave.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				myFrame.setVisible(false);
				try {
					String filename = GNUSaveButton_ActionPreformed();
					if (filename.equals("")) {
						return;
					}
					JOptionPane.showMessageDialog(null,
							"Saved figure to\nFile:" + filename);
				} catch (Exception x) {
					JOptionPane
							.showMessageDialog(null, "Failed to save Figure");
					x.printStackTrace();
				}
				myFrame.dispose();
			}
		});

		JButton btn_GNUAddFigure = new JButton("Add to Paper");
		btn_GNUAddFigure.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				// TODO
				// new AddFigureShortDlg(figProp, inst_ID);
				myFrame.dispose();
			}
		});

		JPlot plot = new JPlot();
		try {
			plot.setJavaPlot(myPlot);
		} catch (Exception e) {
			e.printStackTrace();
		}
		plot.getJavaPlot().getParameters().set("terminal", "png size 1000,800");
		plot.plot();
	
		JPanel jpl_FigButtons = new JPanel();
		jpl_FigButtons.setLayout(new GridLayout(1, 3));
		((GridLayout) jpl_FigButtons.getLayout()).setHgap(5);
		jpl_FigButtons.add(btn_close);
		jpl_FigButtons.add(btn_GNUSave);
		jpl_FigButtons.add(btn_GNUAddFigure);

		myFrame = new JFrame("Generated Figure");
		myFrame.setSize(1050, 900);
		myFrame.setLocation(50,50);
		myFrame.setLayout(new BorderLayout());
		((BorderLayout) myFrame.getLayout()).setVgap(5);
		myFrame.add(plot, BorderLayout.CENTER);
		myFrame.add(jpl_FigButtons, BorderLayout.SOUTH);
		myFrame.setVisible(true);
		myFrame.setAlwaysOnTop(true);

	}

	private String GNUSaveButton_ActionPreformed() {

		JFileChooser chooser = new JFileChooser();
		chooser.setCurrentDirectory(new java.io.File("/home"));
		chooser.setDialogTitle("Select a save Destination");
		chooser.setFileFilter(new PostScriptFilter());
		chooser.setAcceptAllFileFilterUsed(false);
		String directory = "";
		try {
			if (chooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
				directory += chooser.getSelectedFile();
				directory = directory.replace(".ps", "");
				myPlot.setTerminal(new PostscriptTerminal(directory + ".ps"));
				myPlot.plot();
				myFrame.dispose();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return directory;
	}
}

class PostScriptFilter extends FileFilter {

	// Accept all directories and all gif, jpg, tiff, or png files.
	public boolean accept(File f) {
		if (f.isDirectory()) {
			return true;
		}

		if (f.getName().contains(".ps")) {
			return true;
		}

		return false;
	}

	// The description of this filter
	public String getDescription() {
		return "Just PostScript(.ps)";
	}
}