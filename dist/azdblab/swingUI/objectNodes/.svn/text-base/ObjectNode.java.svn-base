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

import java.awt.Dimension;

import java.awt.Insets;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import javax.swing.JButton;
import javax.swing.JTextPane;
import javax.swing.JPanel;
import javax.swing.event.HyperlinkEvent;
import javax.swing.event.HyperlinkListener;

import javax.swing.text.html.HTMLDocument;
import javax.swing.text.html.HTMLFrameHyperlinkEvent;
import azdblab.Constants;
import azdblab.model.experiment.XMLHelper;
import azdblab.plugins.evaluation.Evaluation;
import azdblab.plugins.evaluation.EvaluationPluginManager;
import azdblab.swingUI.treeNodesManager.AZDBLABHtmlEditorKit;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;
import azdblab.swingUI.treeNodesManager.NodePanel;

public abstract class ObjectNode {

	protected String strNodeName;

	protected boolean bIsSpecial = false;
	private boolean _loaded = false;
	private List<Evaluation> myAspects;
	private boolean checkedAspects = false;
	protected boolean willHaveChildren = true;
	
	private static EvaluationPluginManager myExecutionAspectPluginManager;

	public JPanel getModifiedDataPanel() {
		checkAspects();
		JPanel initPane = getDataPanel();
		NodePanel npl_new;
		if (initPane instanceof NodePanel) {
			npl_new = (NodePanel) initPane;

		} else {
			npl_new = new NodePanel();
			npl_new.addComponentToTab(strNodeName, initPane);
		}

		for (int i = 0; i < myAspects.size(); i++) {
			JPanel jpl_tmp = myAspects.get(i).getTabs();
			if (jpl_tmp != null) {
				npl_new.addComponentToTab(myAspects.get(i).getName(), jpl_tmp);
			}
		}
		npl_new.addComponentToTab("About", getAboutPanel());
		return npl_new;

	}

	private JTextPane getAboutPanel() {
		String html = "<html><body><center>";
		html += "<h1>About</h1>";
		html += "<p>" + getDescription() + "</p>";
		List<String> vecAuthors = getAuthors();
		html += "<h2> Authors</h2>";
		html += "<dl>";
		for (int i = 0; i < vecAuthors.size(); i++) {
			html += "<dt>" + vecAuthors.get(i) + "</dt>";
		}
		html += "</dl>";
		html += "</center></body></html>";

		return createTextPaneFromString(html);
	}

	protected abstract String getDescription();

	protected abstract List<String> getAuthors();

	public JPanel getModifiedButtonPanel() {
		checkAspects();
		if (myAspects != null) {
			JPanel myButtons = getButtonPanel();
			for (int i = 0; i < myAspects.size(); i++) {
				List<JButton> tmp = myAspects.get(i).getButtons();
				if (tmp != null) {
					if (myButtons == null) {
						myButtons = new JPanel();
					}
					for (int j = 0; j < tmp.size(); j++) {
						myButtons.add(tmp.get(j));
					}
				}
			}
			return myButtons;
		} else {
			return getButtonPanel();
		}
	}

	protected abstract JPanel getDataPanel();

	protected abstract JPanel getButtonPanel();

	public void checkAspects() {
		if (!checkedAspects) {
			checkedAspects = true;
			if(myExecutionAspectPluginManager == null){
				myExecutionAspectPluginManager = new EvaluationPluginManager();
			}
			myAspects = myExecutionAspectPluginManager.getPlugins(this);
		}
	}

	protected AZDBLABMutableTreeNode parent;

	public abstract String getIconResource(boolean open);

	/**
	 * returns the name of the node, used by AZDBLABMutableTreeNode
	 */
	public String toString() {
		return strNodeName;
	}

	/**
	 * sets the boolean value isSpecial
	 * 
	 * @param isSpecial
	 */
	public void setIsSpecial(boolean isSpecial) {
		bIsSpecial = isSpecial;
	}

	/**
	 * returns the boolean value isSpecla
	 * 
	 * @return isSpecial
	 */
	public boolean getIsSpecial() {
		return bIsSpecial;
	}

	/**
	 * 
	 * @param node
	 * @param style_sheet
	 * @return
	 */
	protected JTextPane createTextPaneFromXML(org.w3c.dom.Element node,
			String style_sheet) {
		try {
			// System.out.println(style_sheet);
			File temp = File.createTempFile("editor", ".xml", new File(
					Constants.DIRECTORY_TEMP));
			temp.deleteOnExit();

			File transformedFile = File.createTempFile("result", ".htm",
					new File(Constants.DIRECTORY_TEMP));
			transformedFile.deleteOnExit();

			FileOutputStream out = new FileOutputStream(temp);
			XMLHelper.writeXMLToOutputStream(out, node);
			out.close();

			// Transforming the XML to HTML
			XMLHelper.transform(temp.getAbsolutePath(), getClass()
					.getClassLoader().getResourceAsStream(style_sheet),
					transformedFile.getAbsolutePath());

			// Creating the text pane. You must set editable to false or the
			// links
			// won't work.
			JTextPane edit = new JTextPane();
			edit.setEditable(false);
			edit.setPage("file:///" + transformedFile.getAbsolutePath());

			// Creating a listener to handle the hyperlink click events. This is
			// needed to make the links work
			// In the TextPane.
			edit.addHyperlinkListener(new HyperlinkListener() {
				public void hyperlinkUpdate(HyperlinkEvent e) {
					if (e.getEventType() == HyperlinkEvent.EventType.ACTIVATED) {
						JTextPane pane = (JTextPane) e.getSource();

						if (e instanceof HTMLFrameHyperlinkEvent) {
							HTMLFrameHyperlinkEvent evt = (HTMLFrameHyperlinkEvent) e;
							HTMLDocument doc = (HTMLDocument) pane
									.getDocument();
							doc.processHTMLFrameHyperlinkEvent(evt);
						} else {
							try {
								pane.setPage(e.getURL());
							} catch (Throwable t) {
								t.printStackTrace();
							}
						}
					}
				}
			});
			// System.out.println(edit.getContentType());
			// JColorTextPane textPane = new JColorTextPane(transformedFile);
			return edit;

		} catch (IOException ioex) {
			ioex.printStackTrace();
			return null;
		}
	}

	/**
	 * This method returns a TextPane formated in text/html with content
	 * specified by by the parameter
	 * 
	 * @param content
	 *            the html to be put into the textPane
	 * @return a TextPane with the html specified in the paramater
	 */
	protected JTextPane createTextPaneFromString(String content) {

		JTextPane edit = new JTextPane();
		edit.setEditorKit(new AZDBLABHtmlEditorKit());
	//	StyleSheet ss = ((AZDBLABHtmlEditorKit)edit.getEditorKit()).getStyleSheet();
	//	ss.addRule("p {font-size: 10 } h1 {background-color:#000;}");

		edit.setContentType("text/html");
		edit.setEditable(false);
		edit.setMinimumSize(new Dimension(0, 0));
		edit.setText(content);
		edit.setMargin(new Insets(15, 15, 15, 15));

		edit.setSelectionStart(0);
		edit.setCaretPosition(0);
		return edit;
	}

	// True if loadChildNodes was called
	// False if they already were loaded
	public boolean loadChildren() {
		if (!_loaded) {
			loadChildNodes();
			for (int i = 0; i < parent.getChildCount(); i++) {
				if (parent.getChildAt(i) instanceof DummyNode) {
					parent.remove(i);
					break;
				}
			}
			_loaded = true;
			return true;
		}
		return false;
	}

	public AZDBLABMutableTreeNode getParent() {
		return parent;
	}

	protected abstract void loadChildNodes();

	public void setParent(AZDBLABMutableTreeNode par) {
		parent = par;
		if (willHaveChildren) {
			par.add(new AZDBLABMutableTreeNode(new DummyNode()));
		}
	}

}
