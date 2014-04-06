package plugins;

import java.awt.BorderLayout;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;

import javax.swing.JLabel;
import javax.swing.JPanel;

import azdblab.Constants;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.plugins.protocol.Protocol;

public class TucsonProtocol extends Protocol {
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
			"Analysis_S5_I_EQTV_PDE_Ver1"};

	public TucsonProtocol() {
		
	}
	
	public static String getName() {
		return "Tucson Protocol";
	}
	
	@Override
	public ResultSet execute(String prefix, Hashtable<String[], Integer[]> runs) {
		Hashtable<String, String> nameMap = new Hashtable<String, String>();
		
		for(int nameInd = 0; nameInd < TableNames.length; nameInd++)
			nameMap.put("__" + TableNames[nameInd] + "__", prefix + nameInd);
		
		
		for (String[] connect : runs.keySet()){
			LabShelfManager shelf = LabShelfManager.getShelf(connect[0], connect[1], connect[2], Constants.getLABMACHINENAME());
			nameMap.put("__username__", "\'" + connect[0] + "\'");
			nameMap.put("__password__", "\'" + connect[1] + "\'");
			nameMap.put("__connect_string__", "\'" + connect[2] + "\'");
			do_stepN(shelf, "step0.sql", prefix, runs.get(connect), nameMap);
			do_stepN(shelf, "step1.sql", prefix, runs.get(connect), nameMap);
			do_stepN(shelf, "step2-4.sql", prefix, runs.get(connect), nameMap);
			do_stepN(shelf, "step5.sql", prefix, runs.get(connect), nameMap); 
			nameMap.remove("__username__");
			nameMap.remove("__password__");
			nameMap.remove("__connect_string__");
		}
		collect_Results(prefix, runs);
		return null;
	}

	private void collect_Results(String prefix, Hashtable<String[], Integer[]> runs) {
		
	}

	private void do_stepN(LabShelfManager shelf, String filename, String prefix, Integer[] runs, Hashtable<String, String> nameMap) {
		File f = new File("plugins/tucson_protocol/queries/" + filename);
	
		FileInputStream s = null;
		try {
			s = new FileInputStream(f);
		} catch (FileNotFoundException e1) {
			// TODO Auto-generated catch block
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
				if (!q.trim().isEmpty())
					shelf.executeUpdateQuery(q);
			} catch (SQLException e) {
				System.out.println(q);
				e.printStackTrace(); 
			} 
		}
	}

	@Override
	public JPanel getProtocolStats() {
		JPanel stats_Pnl = new JPanel();
		stats_Pnl.setLayout(new BorderLayout());
		JLabel lbl_Default = new JLabel("Please execute the protocol first.");
		stats_Pnl.add(lbl_Default);
		return stats_Pnl;
	}

}
