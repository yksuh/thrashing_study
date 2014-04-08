package plugins;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.LinkedHashMap;
import java.util.List;

import javax.swing.BorderFactory;
import javax.swing.JLabel;
import javax.swing.JPanel;

import azdblab.Constants;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.plugins.protocol.Protocol;

public class TucsonProtocol2 extends Protocol {
	
	private JPanel stats_Pnl;
	
	// TODO: prefix with labshelf and study name
	private static final String[] TableNames = {"Analysis_Dmd_Ver1",
			"Analysis_Qmd_Ver1",
			"Analysis_Umd_Ver1",
			"Chosen_Users_Ver1",
			"Chosen_Notebooks_Ver1",
			"Chosen_LabShelf_Ver1",
			"Chosen_Runs_Ver1",
			"Analysis_S0_AQE_Ver1",
			"Analysis_RowCount_Ver1",
			"Analysis_S1_VQE_Ver1", // all executions passing sanity checks
			"Analysis_API_Ver1",
			"Analysis_ACDP_Ver1",
			"Analysis_AQProc_QatC_Ver1",
			"Analysis_AEQPI_Ver1",
			"Analysis_ANQPI_Ver1",
			"Analysis_AQPI_Ver1",
			"Analysis_AEUPI_Ver1",
			"Analysis_AEUP_Ver1",
			"Analysis_S1_QIO_Ver2",
			"Analysis_AEDep_Ver1",
			"Analysis_S1_DIO_Ver2",
			"Analysis_S1_DIO_PDE_Ver2",
			"Analysis_S1_DIOV_PDE_Ver2",
			"Analysis_S1_DIOV_Ver2",
			"Analysis_S1_OTV_Ver2",
			"Analysis_S1_OTV_PDE_Ver2",
			"Analysis_S1_IOTV_Ver2",
			"Analysis_S2_II_Ver2",
			"Analysis_ANUPI_Ver1",
			"Analysis_AUPI_Ver1",
			"Analysis_AEDPI_Ver1",
			"Analysis_ANDPI_Ver1",
			"Analysis_ADPI_Ver1",
			"Analysis_AQED_Ver1",
			"Analysis_ACTQatC_Ver1",
			"Analysis_ASPQatC_Ver1",
			"Analysis_ATSM_Ver1",
			"Analysis_ATRM_Ver1",
			"Analysis_ATRM_Ver1",
			"Analysis_S1_QEA_Ver1",
			"Analysis_S1_TQE_Ver1",
			"Analysis_S1_QatC_Ver1",
			"Analysis_S1_TQC_Ver1",
			"Analysis_S1_MQ_PDE_Ver1",
			"Analysis_S1_MQ_Ver1",
			"Analysis_S1_AF_PDE_Ver1",
			"Analysis_S1_AF_Ver1",
			"Analysis_S1_UPV_PDE_Ver1",
			"Analysis_S1_UPV_Ver1",
			"Analysis_S1_CDP_Ver1",
			"Analysis_S1_QProc_QatC_Ver1",
			"Analysis_S1_QProc_QE_Ver1",
			"Analysis_S1_EQTV_PDE_Ver1",
			"Analysis_S1_EQTV_Ver1",
			"Analysis_S1_DTV_PDE_Ver1",
			"Analysis_S1_DTV_Ver1",
			"Analysis_S1_ZQTV_PDE_Ver1",
			"Analysis_S1_ZQTV_Ver1",
			"Analysis_S1_QTV_PDE_Ver1",
			"Analysis_S1_QTV_Ver1",
			"Analysis_S1_HTV_PDE_Ver1",
			"Analysis_S1_LTV_PDE_Ver1",
			"Analysis_S1_NQPV_PDE_Ver1",
			"Analysis_S1_NQPV_Ver1",
			"Analysis_S1_OQPV_PDE_Ver1",
			"Analysis_S1_OQPV_Ver1",
			"Analysis_S1_OUPV_PDE_Ver1",
			"Analysis_S1_OUPV_Ver1",
			"Analysis_ASPQatC_Ver1",
			"Analysis_ATSM_Ver1",
			"Analysis_ATRM_Ver1",
			"Analysis_S2_I_Ver1",
			"Analysis_S2_II_Ver1",
			"Analysis_S2_III_Ver1",
			"Analysis_S2_IV_Ver1",
			"Analysis_S3_0_Ver1",
			"Analysis_CDP_Ver1",
			"Analysis_QProc_QatC_Ver1",
			"Analysis_S3_I_Ver1",
			"Analysis_S3_II_Ver1",
			"Analysis_S3_III_Ver1",
			"Analysis_PI_Ver1",
			"Analysis_QPI_Ver1",
			"Analysis_EUPI_Ver1",
			"Analysis_NUPI_Ver1",
			"Analysis_UPI_Ver1",
			"Analysis_EDPI_Ver1",
			"Analysis_NDPI_Ver1",
			"Analysis_DPI_Ver1",
			"Analysis_QED_Ver1",
			"Analysis_S4_CTQatC_Ver1",
			"Analysis_S5_I_EQTV_Ver1",
			"Analysis_SPQatC_Ver1",
			"Analysis_S5_II_TSM_Ver1",
			"Analysis_S5_II_SMVP_Ver1",
			"Analysis_S5_II_TRM_Ver1",
			"Analysis_S5_II_RMVP_Ver1",
			"Analysis_S1_FQE_Ver1",
			"Analysis_S1_Ver1",
			"Analysis_S5_I_EQTV_PDE_Ver1",
			"Analysis_S1_FQEP1_Ver1"};
	
	private Hashtable<String, String> nameMap;

	public TucsonProtocol2() {
		stats_Pnl = new JPanel();
		stats_Pnl.setLayout(new GridBagLayout());
	}
	
	public static String getName() {
		return "Tucson Protocol";
	}
	
	@Override
	public ResultSet execute(String prefix, Hashtable<String[], Integer[]> runs) {

		stats_Pnl.removeAll();
		nameMap = new Hashtable<String, String>();
		
		for(int nameInd = 0; nameInd < TableNames.length; nameInd++)
			nameMap.put("__" + TableNames[nameInd] + "__", prefix + nameInd);
		
		
		for (String[] connect : runs.keySet()){
			LabShelfManager shelf = LabShelfManager.getShelf(connect[0], connect[1], connect[2], Constants.getLABMACHINENAME());
			nameMap.put("__username__", "\'" + connect[0] + "\'");
			nameMap.put("__password__", "\'" + connect[1] + "\'");
			nameMap.put("__connect_string__", "\'" + connect[2] + "\'");
			do_stepN(shelf, "step0.sql", prefix, runs.get(connect)); 
			do_stepN(shelf, "step1.sql", prefix, runs.get(connect));
			do_stepN(shelf, "step2-4.sql", prefix, runs.get(connect)); 
			do_stepN(shelf, "step5.sql", prefix, runs.get(connect)); 
			nameMap.remove("__username__");
			nameMap.remove("__password__");
			nameMap.remove("__connect_string__");
			collect_Results(shelf);
		}
		return null;
	}

	private void collect_Results(LabShelfManager shelf) {
		GridBagConstraints c = new GridBagConstraints();
		c.fill=GridBagConstraints.BOTH;
		c.gridx = 1; c.gridy = 0; c.fill = GridBagConstraints.BOTH;
		c.weightx = 1; c.weighty = 1;
		List<String> dbmsnames = getDbmsNames(shelf);
		
		for (String dbms: dbmsnames) {
			stats_Pnl.add(new JLabel(dbms), c);
			c.gridx++;
		}
		stats_Pnl.add(new JLabel("Total"), c);
		c.gridx = 0;
		c.gridy++;
		stats_Pnl.add(new JLabel("Query Times"), c);
		
		for (String dbms: dbmsnames) {
			c.gridx++;
			collectRunTime(shelf, c, dbms);
		}
		c.gridx=0;
		c.gridy++;
		int y = c.gridy;
		for (String dbms: dbmsnames) {
			c.gridx++;
			c.gridy = y;
			collectOverallSanityChecks(shelf, c, dbms);
		}
		
		c.gridx=0;
		c.gridy++;
		y = c.gridy;
		for (String dbms: dbmsnames) {
			c.gridx++;
			c.gridy = y;
			collectQEChecks(shelf, c, dbms);
		}
		
		//collectOverallSanityChecks(shelf, c);
		//collectQEChecks(shelf, c);
		//collectQAtCChecks(shelf, c);
		//collectStepCounts(shelf, c);
	}
	
	private int collectStepCounts(LabShelfManager shelf, GridBagConstraints c, String dbms) {
		LinkedHashMap<String, Integer> stepCounts = getStepCounts(shelf, dbms);
		int row = c.gridy+1;
		c.gridx = 0; c.gridy=row++; c.weighty=1; c.weightx=0;
		c.gridwidth=10;c.fill=GridBagConstraints.VERTICAL;
		stats_Pnl.add(new JLabel("The number of Query Executions(QEs) and Q@Cs remaining after each sub-step"), c);
		c.gridwidth=1;c.fill=GridBagConstraints.BOTH;
		for (String stepName: stepCounts.keySet()) {
			row++;
			c.gridx = 0; c.gridy=row; c.weighty=1; c.weightx=1;
			JLabel lbl1 = new JLabel(stepName);
			lbl1.setOpaque(true);
			lbl1.setBackground(row%2==0?Color.decode("#F3EAEA"):Color.WHITE);
			stats_Pnl.add(lbl1, c);
			c.gridx=1;
			JLabel lbl2 = new JLabel(stepCounts.get(stepName).toString());
			lbl2.setOpaque(true);
			lbl2.setBackground(row%2==0?Color.WHITE:Color.decode("#F3EAEA"));
			stats_Pnl.add(lbl2, c);
		}
		return row;
	}
	
	private int collectOverallSanityChecks(LabShelfManager shelf, GridBagConstraints c, String dbms) {
		Hashtable<String, Integer> overallSanityChecks = getOverallViolations(shelf, dbms);
		c.gridwidth=1;c.fill=GridBagConstraints.BOTH;
		GridBagConstraints c1 = (GridBagConstraints) c.clone();
		c1.gridx = 0;
		for (String ovCheck: overallSanityChecks.keySet()) {
			stats_Pnl.add(new JLabel(ovCheck), c1);
			JLabel lbl2 = new JLabel(overallSanityChecks.get(ovCheck).toString());
			lbl2.setOpaque(true);
			lbl2.setBackground(c.gridy%2==0?Color.WHITE:Color.decode("#F3EAEA"));
			stats_Pnl.add(lbl2, c);
			c.gridy++;
			c1.gridy++;
		}
		return 0;
	}
	
	private int collectQEChecks(LabShelfManager shelf, GridBagConstraints c, String dbms) {
		Hashtable<String, Double> qeChecks = getQEViolations(shelf, dbms);
		c.gridwidth=1;c.fill=GridBagConstraints.BOTH;
		GridBagConstraints c1 = (GridBagConstraints) c.clone();
		c1.gridx = 0;
		for (String qeCheck: qeChecks.keySet()) {
			stats_Pnl.add(new JLabel(qeCheck), c1);
			JLabel lbl2 = new JLabel(String.format("%1$,.2f",qeChecks.get(qeCheck))+"%");
			lbl2.setOpaque(true);
			lbl2.setBackground(c.gridy%2==0?Color.WHITE:Color.decode("#F3EAEA"));
			stats_Pnl.add(lbl2, c);
			c.gridy++;
			c1.gridy++;
		}
		return 0;
	}
	
	private int collectQAtCChecks(LabShelfManager shelf, GridBagConstraints c, String dbms) {
		Hashtable<String, Integer> qAtCChecks = getQAtCViolations(shelf, dbms);
		int row = c.gridy+1;
		c.gridx = 0; c.gridy=row++; c.weighty=1; c.weightx=0;
		c.gridwidth=10;c.fill=GridBagConstraints.VERTICAL;
		stats_Pnl.add(new JLabel("Q@C Sanity Checks"), c);
		c.fill=GridBagConstraints.BOTH;
		c.gridwidth=1;
		for (String checkName: qAtCChecks.keySet()) {
			row++;
			c.gridx = 0; c.gridy=row; c.weighty=1; c.weightx=1;
			JLabel lbl1 = new JLabel(checkName);
			lbl1.setOpaque(true);
			lbl1.setBackground(row%2==0?Color.decode("#F3EAEA"):Color.WHITE);
			stats_Pnl.add(lbl1, c);
			c.gridx=1;
			JLabel lbl2 = new JLabel(qAtCChecks.get(checkName).toString());
			lbl2.setOpaque(true);
			lbl2.setBackground(row%2==0?Color.WHITE:Color.decode("#F3EAEA"));
			stats_Pnl.add(lbl2, c);
		}
		return row;
	}


	private int collectRunTime(LabShelfManager shelf, GridBagConstraints c, String dbms) {
		Double runTime = getQueriesRunTime(shelf, dbms);
		JLabel lbl2 = new JLabel(String.format("%1$,.2f",runTime));
		lbl2.setOpaque(true);
		lbl2.setBackground(c.gridy%2==0?Color.WHITE:Color.decode("#F3EAEA"));
		stats_Pnl.add(lbl2, c);
		return 0;
	}

	private void do_stepN(LabShelfManager shelf, String filename, String prefix, Integer[] runs) {
		File f = new File("plugins/tucson_protocol/v2/queries/" + filename);
	
		FileInputStream s = null;
		try {
			s = new FileInputStream(f);
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		}
		int buf;
		String query = "";
		try {
			while ((buf = s.read()) > 0) {
				query += (char)buf;
			}
			s.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		for (String key: nameMap.keySet())
			query = query.replaceAll(key, nameMap.get(key));
		
		String runList = "";
		
		for (Integer runId: runs)
			runList += runId.toString() + ", ";
		
		if (runList.length() > 0)
			runList = runList.substring(0, runList.length() - 2);
		
		query = query.replaceAll("__runidlist__", runList);
		
		String[] qs = query.split(";");
		
		for (String q : qs) {
			try {
				if (!q.trim().isEmpty()) { 
					shelf.executeUpdateQuery(q.trim());
					shelf.commitlabshelf();
				}
			} catch (SQLException e) {
				System.out.println(q);
				e.printStackTrace(); 
			} 
		}
	}

	@Override
	public JPanel getProtocolStats() {
		return stats_Pnl;
	}
	
	private Double getQueriesRunTime(LabShelfManager shelf, String dbms) {
		Double result=-1d;
		String sql = "SELECT SUM(measured_time)/3600000 " +
				"FROM __Analysis_S0_AQE_Ver1__ " +
				"WHERE dbms='" + dbms + "' ";
		for (String key: nameMap.keySet())
			sql = sql.replaceAll(key, nameMap.get(key));
		ResultSet rs = shelf.executeQuerySQL(sql);
		try {
			while (rs.next()) {
				result = rs.getDouble(1);
			}
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	private Hashtable<String, Integer> getOverallViolations(LabShelfManager shelf, String dbms) {
		Hashtable<String, Integer> result = new Hashtable<String, Integer>();
		String sql = "SELECT nummissingqueries, numUniquePlanViolations FROM __Analysis_S1_MQ_PDE_Ver1__ mq, " +
				"__Analysis_S1_UPV_PDE_Ver1__ upv " +
				"WHERE upv.runid = mq.runid " +
				"AND upv.dbms = mq.dbms " +
				"AND upv.dbms = '" + dbms + "'";
		for (String key: nameMap.keySet())
			sql = sql.replaceAll(key, nameMap.get(key));
		ResultSet rs = shelf.executeQuerySQL(sql);
		try {
			if (rs.next()) {
				result.put("Number of Missing Queries", rs.getInt(1));
				result.put("Number of Unique Plan Violations", rs.getInt(2));
			} else {
				result.put("Number of Missing Queries", 0);
				result.put("Number of Unique Plan Violations", 0);
			}
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	private Hashtable<String, Double> getQEViolations(LabShelfManager shelf, String dbms) {
		Hashtable<String, Double> result = new Hashtable<String, Double>();
		String sql = "SELECT * FROM (SELECT * FROM (SELECT dbms, SUM(numDBMSTimeViolations) numDBMSTimeViolations FROM __Analysis_S1_DTV_PDE_Ver1__ GROUP BY dbms) dtv " +
				"NATURAL FULL OUTER JOIN (SELECT dbms, SUM(numZeroQueryTimes) numZeroQueryTimes FROM __Analysis_S1_ZQTV_PDE_Ver1__ GROUP BY dbms) zqtv " +
				"NATURAL FULL OUTER JOIN (SELECT dbms, SUM(numQueryTimeViolations) numQueryTimeViolations FROM __Analysis_S1_QTV_PDE_Ver1__  GROUP BY dbms) qtv " +
				"NATURAL FULL OUTER JOIN (SELECT dbms, SUM(numQEsWithoutQProcs) numQEsWithoutQProcs FROM __Analysis_S1_NQPV_PDE_Ver1__  GROUP BY dbms) nqpv " +
				"NATURAL FULL OUTER JOIN (SELECT dbms, SUM(numQEsWithOtherQProcs) numQEsWithOtherQProcs FROM __Analysis_S1_OQPV_PDE_Ver1__  GROUP BY dbms) oqpv " +
				"NATURAL FULL OUTER JOIN (SELECT dbms, SUM(numQEsWithOtherUProcs) numQEsWithOtherUProcs FROM __Analysis_S1_OUPV_PDE_Ver1__  GROUP BY dbms) oupv " +
				"NATURAL FULL OUTER JOIN (SELECT dbms, SUM(numDIOWaitViolations) numDIOWaitViolations FROM __Analysis_S1_DIOV_PDE_Ver2__  GROUP BY dbms) diov " +
				"NATURAL FULL OUTER JOIN (SELECT dbms, COUNT(qeid) numOTViolations FROM __Analysis_S1_OTV_PDE_Ver2__   GROUP BY dbms) otv " +
				"NATURAL FULL OUTER JOIN (SELECT dbms, COUNT(*) totalQEs FROM __Analysis_S0_AQE_Ver1__   GROUP BY dbms) tqe) " +
				"WHERE dbms='" + dbms + "'";
		for (String key: nameMap.keySet())
			sql = sql.replaceAll(key, nameMap.get(key));
		ResultSet rs = shelf.executeQuerySQL(sql);
		try {
			rs.next();
			result.put("Percentage of DBMS Time Violations", 100*rs.getDouble(rs.findColumn("numDBMSTimeViolations"))/rs.getDouble(rs.findColumn("totalQEs")));
			result.put("Percentage of Zero Query Time Violations", 100*rs.getDouble(rs.findColumn("numZeroQueryTimes"))/rs.getDouble(rs.findColumn("totalQEs")));
			result.put("Percentage of Query Time Violations", 100*rs.getDouble(rs.findColumn("numQueryTimeViolations"))/rs.getDouble(rs.findColumn("totalQEs")));
			result.put("Percentage of No Query Process Violations", 100*rs.getDouble(rs.findColumn("numQEsWithoutQProcs"))/rs.getDouble(rs.findColumn("totalQEs")));
			result.put("Percentage of Other Query Process Violations", 100*rs.getDouble(rs.findColumn("numQEsWithOtherQProcs"))/rs.getDouble(rs.findColumn("totalQEs")));
			result.put("Percentage of Other Utility Process Violations", 100*rs.getDouble(rs.findColumn("numQEsWithOtherUProcs"))/rs.getDouble(rs.findColumn("totalQEs")));
			result.put("Percentage of Daemon IOWait Violations", 100*rs.getDouble(rs.findColumn("numDIOWaitViolations"))/rs.getDouble(rs.findColumn("totalQEs")));
			result.put("Percentage of Overall Time Violations", 100*rs.getDouble(rs.findColumn("numOTViolations"))/rs.getDouble(rs.findColumn("totalQEs")));
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	private Hashtable<String, Integer> getQAtCViolations(LabShelfManager shelf, String dbms) {
		Hashtable<String, Integer> result = new Hashtable<String, Integer>();
		String sql = "SELECT EXCVARQATCS "
				+ "FROM __Analysis_S1_Ver1__";
		for (String key: nameMap.keySet())
			sql = sql.replaceAll(key, nameMap.get(key));
		ResultSet rs = shelf.executeQuerySQL(sql);
		try {
			rs.next();
			result.put("Number of Excessive Variance Violations", rs.getInt(1));
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		sql = "SELECT SUM(STEPRESULTSIZE) "
				+ "FROM __Analysis_RowCount_Ver1__ WHERE STEPNAME='Analysis_ATSM_Ver1'";
		for (String key: nameMap.keySet())
			sql = sql.replaceAll(key, nameMap.get(key));
		rs = shelf.executeQuerySQL(sql);
		try {
			rs.next();
			result.put("Number of Strict Monotonicity Violations", rs.getInt(1));
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		sql = "SELECT SUM(STEPRESULTSIZE) "
				+ "FROM __Analysis_RowCount_Ver1__ WHERE STEPNAME='Analysis_ATRM_Ver1'";
		for (String key: nameMap.keySet())
			sql = sql.replaceAll(key, nameMap.get(key));
		rs = shelf.executeQuerySQL(sql);
		try {
			rs.next();
			result.put("Number of Relaxed Monotonicity Violations", rs.getInt(1));
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	private List<String> getDbmsNames(LabShelfManager shelf) {
		ArrayList<String> result = new ArrayList<String>();
		
		String sql = "SELECT DISTINCT DBMSNAME FROM __Analysis_RowCount_Ver1__";
		for (String key: nameMap.keySet())
			sql = sql.replaceAll(key, nameMap.get(key));
		ResultSet rs = shelf.executeQuerySQL(sql);
		try {
			while (rs.next()){
				result.add(rs.getString(1));
			}
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	private LinkedHashMap<String, Integer> getStepCounts(LabShelfManager shelf, String dbms) {
		LinkedHashMap<String, Integer> result = new LinkedHashMap<String, Integer>();
		String sql = "SELECT * FROM (SELECT 1 as id, " +
				"'QEs At Start of Step 2' as stepLabel, " + 
				"SUM(STEPRESULTSIZE), " +
				"dbmsname " + 
				"FROM __Analysis_RowCount_Ver1__ " + 
				"WHERE STEPNAME='Analysis_S0_AQE_Ver1'" +
				"GROUP BY dbmsname " +
				"UNION " +
				"SELECT 0 as id, " +
				"'Q@Cs At Start of Step 2' as stepLabel, " + 
				"SUM(STEPRESULTSIZE), " +
				"dbmsname " + 
				"FROM __Analysis_RowCount_Ver1__ " + 
				"WHERE STEPNAME='Analysis_ACTQatC_Ver1' " +
				"GROUP BY dbmsname " +
				"UNION " +
				"SELECT 2 as id, " +
				"'After Step 2-(i)' as stepLabel, " + 
				"SUM(STEPRESULTSIZE), " +
				"dbmsname " + 
				"FROM __Analysis_RowCount_Ver1__ " + 
				"WHERE STEPNAME='Analysis_S2_I_Ver1' " +
				"GROUP BY dbmsname " +
				"UNION " +
				"SELECT 3 as id, " + 
				"'After Step 2-(ii)' as stepLabel, " + 
				"SUM(STEPRESULTSIZE), " +
				"dbmsname " + 
				"FROM __Analysis_RowCount_Ver1__ " + 
				"WHERE STEPNAME='Analysis_S2_II_Ver2' " +
				"GROUP BY dbmsname) " +
				"ORDER BY id ASC";
		for (String key: nameMap.keySet())
			sql = sql.replaceAll(key, nameMap.get(key));
		ResultSet rs = shelf.executeQuerySQL(sql);
		try {
			while (rs.next()){
				result.put(rs.getString(2), rs.getInt(3));
			}
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}

}
