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

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

import com.panayotis.gnuplot.JavaPlot;
import com.panayotis.gnuplot.swing.JPlot;

import azdblab.labShelf.InternalTable;
import azdblab.labShelf.TableDefinition;
import azdblab.labShelf.dataModel.Figure;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.plugins.evaluation.Evaluation;
import azdblab.swingUI.objectNodes.ObjectNode;
import azdblab.swingUI.objectNodes.QueryNode;

public class DiscontinuityEvaluation extends Evaluation {
	public static String MYNAME = "DiscontinuityAspect";
	private int myQueryID;
	private JFrame newFrame;

	public DiscontinuityEvaluation(ObjectNode sent) {
		super(sent);

		if (sent instanceof QueryNode) {
			myQueryID = ((QueryNode) sent).getQueryID();
		}
	}

	@Override
	public Vector<JButton> getButtons() {

		JButton btn_Visualize = new JButton("Visualize Discontinuity");
		btn_Visualize.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				visualize();
			}
		});

		Vector<JButton> vecMyButtons = new Vector<JButton>();
		vecMyButtons.add(btn_Visualize);
		return vecMyButtons;
	}

	@Override
	public Evaluation getInstance(ObjectNode sent) {
		return new DiscontinuityEvaluation(sent);
	}

	@Override
	public String getName() {
		return MYNAME;
	}

	@Override
	public Vector<String> getSupportedClasses() {
		Vector<String> vecMyUsers = new Vector<String>();
		vecMyUsers.add("QueryNode");
		return vecMyUsers;
	}

	@Override
	public Vector<InternalTable> getTables() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public JPanel getTabs() {
		// TODO Auto-generated method stub
		return null;
	}

	/*
	 * 
	 * 
	 * Beginning GUI section
	 */
	private void visualize() {
		newFrame = new JFrame("Discontinuity Visualization of Query:"
				+ myQueryID);
		newFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		newFrame.setSize(new Dimension(1000, 880));
		newFrame.setLocation(100, 100);
		newFrame.getContentPane().setLayout(new BorderLayout());

		JLabel lbl_figInfo = new JLabel(
				"This is a visualition of all the Plan Operators in the Query");
		newFrame.getContentPane().add(lbl_figInfo, BorderLayout.NORTH);

		JPlot myPlot = new JPlot();
		myPlot.setJavaPlot(getPlanOperatorFigure());
		myPlot.getJavaPlot().getParameters().set("terminal",
				"png size 1000,800");
		myPlot.plot();
		newFrame.getContentPane().add(myPlot, BorderLayout.CENTER);

		JButton btn_Close = new JButton("Close");
		btn_Close.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				newFrame.dispose();
			}
		});
		JButton btn_SaveFig = new JButton("Save");
		btn_SaveFig.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				// TODO save the currentFigure;
			}
		});

		JPanel jpl_Buttons = new JPanel(new GridLayout(1, 2));
		((GridLayout) jpl_Buttons.getLayout()).setHgap(5);
		jpl_Buttons.add(btn_SaveFig);
		jpl_Buttons.add(btn_Close);

		newFrame.getContentPane().add(jpl_Buttons, BorderLayout.SOUTH);

		newFrame.setVisible(true);
	}

	private JavaPlot getPlanOperatorFigure() {
		/*
		 * 
		 * 		String sql = "select  qe.cardinality, hs.value, hs.planoperatorid from azdblab_plan pl, azdblab_queryexecution qe, AZDBLAB_QUERYEXECUTIONHASPLAN hp, AZDBLAB_QUERYEXECUTIONHASSTAT hs, AZDBLAB_PLANOPERATOR po    where qe.queryid  = "
				+ myQueryID
				+ " and hp.queryexecutionid = qe.queryexecutionid and      hs.queryexecutionid = qe.queryexecutionid and      hp.planid = pl.planid and      po.planid = pl.planid and      po.planoperatorid = hs.planoperatorid and      po.operatorname = 'HASH JOIN' and hs.name='ORA_COST' order by qe.queryid, hs.planoperatorid, qe.cardinality asc";

		 */
		String qDbms = "select dbmsname from " + TableDefinition.EXPERIMENTRUN.TableName + " er, " + TableDefinition.QUERY + " q" +
		 " WHERE q.runid = er.runid and q.queryid = " + myQueryID;
		
		ResultSet r = LabShelfManager.getShelf().executeQuerySQL(qDbms);
		String dbms = "";
		try {
			if (r.next())
			dbms = r.getString("dbmsname");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		Hashtable<String, String> costNames = new Hashtable<String, String> ();
		costNames.put("pgsql", "PG_TOTAL_COST");
		costNames.put("db2", "DB2_TOTAL_COST");
		costNames.put("oracle", "ORA_COST");
		costNames.put("mysql", "MY_ROWS");
		
		String sql = "select  qe.cardinality, hs.value, hs.planoperatorid from azdblab_plan pl, azdblab_queryexecution qe, AZDBLAB_QUERYEXECUTIONHASPLAN hp, AZDBLAB_QUERYEXECUTIONHASSTAT hs, AZDBLAB_PLANOPERATOR po    where qe.queryid  = "
				+ myQueryID
				+ " and hp.queryexecutionid = qe.queryexecutionid and      hs.queryexecutionid = qe.queryexecutionid and      hp.planid = pl.planid and      po.planid = pl.planid and      po.planoperatorid = hs.planoperatorid and    hs.name='"
					+ costNames.get(dbms) + "' order by qe.queryid, hs.planoperatorid, qe.cardinality asc";
		System.out.println(sql);
		return Figure.getJavaPlot(sql, 0, 1, 2, false, false, 1, false,
				"Points", true);

	}
	
	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
}
