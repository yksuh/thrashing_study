package azdblab.swingUI.objectNodes;

import java.util.Vector;

import javax.swing.JPanel;

import azdblab.swingUI.treeNodesManager.NodePanel;

public class CollectedPausedExecutorNode extends ObjectNode {
	
	public CollectedPausedExecutorNode() {
		strNodeName = "Paused Executors";
	}
	
	public String getIconResource(boolean open) {
		return null;
	}

	private JPanel createCollectedPausedExecutorNodePanel() {

		String exeinfo = "";
		exeinfo += "<HTML><BODY><CENTER><h1>";
		exeinfo += "All the paused Executors are here!";
		exeinfo += "</h1></CENTER> <font color='blue'>";
		exeinfo += "</font></BODY></HTML>";


		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("All Paused Executors", createTextPaneFromString(exeinfo));
		return npl_toRet;
	}

	@Override
	public JPanel getDataPanel() {
		return createCollectedPausedExecutorNodePanel();
	}

	public JPanel getButtonPanel() {
		return null;
	}

	@Override
	protected void loadChildNodes() {
	}

	@Override
	protected Vector<String> getAuthors() {
		Vector<String> vecToRet = new Vector<String>();
		vecToRet.add("Young-Kyoon Suh");
		return vecToRet;
	}

	@Override
	protected String getDescription() {
		return "This node is the parent to all paused executors that this labshelf has been run on";
	}

}
