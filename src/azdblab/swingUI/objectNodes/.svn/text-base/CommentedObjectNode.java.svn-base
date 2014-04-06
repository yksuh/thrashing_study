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

import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.util.List;

import javax.swing.DefaultListModel;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.ListSelectionModel;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

import azdblab.labShelf.dataModel.Comment;

public abstract class CommentedObjectNode extends ObjectNode {

	public abstract List<Comment> getComments();

	protected JTextArea txt_CommentArea;
	protected JList lst_CommentTimes;

	private boolean noImplement = true;

	protected JPanel getCommentPane() {

		if (noImplement) {
			JPanel jpl_tmp = new JPanel(new BorderLayout());
			jpl_tmp.add(new JLabel("Not available in azdblab 5.0"));
		}

		lst_CommentTimes = new JList();
		lst_CommentTimes.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		lst_CommentTimes.setSelectedIndex(-1);
		lst_CommentTimes.addListSelectionListener(new ListSelectionListener() {
			@Override
			public void valueChanged(ListSelectionEvent e) {
				if (lst_CommentTimes.getSelectedIndex() == -1) {
					return;
				}

				txt_CommentArea.setText(((Comment) lst_CommentTimes
						.getSelectedValue()).getComment());
			}
		});
		refreshCommentList();

		JScrollPane scrp_top = new JScrollPane();
		scrp_top.setViewportView(lst_CommentTimes);

		JPanel jpl_top = new JPanel(new BorderLayout());
		jpl_top.add(new JLabel("Please select a comment to view"),
				BorderLayout.NORTH);
		jpl_top.add(scrp_top, BorderLayout.CENTER);

		txt_CommentArea = new JTextArea();
		txt_CommentArea.setLineWrap(true);
		txt_CommentArea.setEditable(false);

		JScrollPane scrp_Bottom = new JScrollPane();
		scrp_Bottom.setViewportView(txt_CommentArea);

		JPanel jpl_Bottom = new JPanel(new BorderLayout());
		jpl_Bottom.add(new JLabel("Comment:"), BorderLayout.NORTH);
		jpl_Bottom.add(scrp_Bottom, BorderLayout.CENTER);

		JPanel jpl_toRet = new JPanel(new GridLayout(2, 1));
		((GridLayout) jpl_toRet.getLayout()).setHgap(5);

		jpl_toRet.add(jpl_top);
		jpl_toRet.add(jpl_Bottom);
		return jpl_toRet;
	}

	public void refreshCommentList() {
		if (noImplement) {
			return;
		}
		DefaultListModel lmodel = new DefaultListModel();
		try {
			List<Comment> vecComments = getComments();
			for (int i = 0; i < vecComments.size(); i++) {
				lmodel.addElement(vecComments.get(i));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		lst_CommentTimes.setModel(lmodel);
	}

}
