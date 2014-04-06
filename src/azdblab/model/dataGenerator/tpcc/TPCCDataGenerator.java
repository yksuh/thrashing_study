package azdblab.model.dataGenerator.tpcc;

import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.sql.SQLException;

public class TPCCDataGenerator {
	
//	static int loadWhse(int whseKount) {
//		try {
//			Warehouse warehouse = new Warehouse();
//			for (int i = 1; i <= whseKount; i++) {
//
//				warehouse.w_id = i;
//				warehouse.w_ytd = 300000;
//
//				// random within [0.0000 .. 0.2000]
//				warehouse.w_tax = (float) ((TPCCUtil.randomNumber(0, 2000, gen)) / 10000.0);
//
//				warehouse.w_name = TPCCUtil.randomStr(TPCCUtil.randomNumber(6,
//						10, gen));
//				warehouse.w_street_1 = TPCCUtil.randomStr(TPCCUtil
//						.randomNumber(10, 20, gen));
//				warehouse.w_street_2 = TPCCUtil.randomStr(TPCCUtil
//						.randomNumber(10, 20, gen));
//				warehouse.w_city = TPCCUtil.randomStr(TPCCUtil.randomNumber(10,
//						20, gen));
//				warehouse.w_state = TPCCUtil.randomStr(3).toUpperCase();
//				warehouse.w_zip = "123456789";
//
//				if (outputFiles == false) {
//					whsePrepStmt.setLong(1, warehouse.w_id);
//					whsePrepStmt.setDouble(2, warehouse.w_ytd);
//					whsePrepStmt.setDouble(3, warehouse.w_tax);
//					whsePrepStmt.setString(4, warehouse.w_name);
//					whsePrepStmt.setString(5, warehouse.w_street_1);
//					whsePrepStmt.setString(6, warehouse.w_street_2);
//					whsePrepStmt.setString(7, warehouse.w_city);
//					whsePrepStmt.setString(8, warehouse.w_state);
//					whsePrepStmt.setString(9, warehouse.w_zip);
//					whsePrepStmt.executeUpdate();
//				} else {
//					String str = "";
//					str = str + warehouse.w_id + ",";
//					str = str + warehouse.w_ytd + ",";
//					str = str + warehouse.w_tax + ",";
//					str = str + warehouse.w_name + ",";
//					str = str + warehouse.w_street_1 + ",";
//					str = str + warehouse.w_street_2 + ",";
//					str = str + warehouse.w_city + ",";
//					str = str + warehouse.w_state + ",";
//					str = str + warehouse.w_zip;
//					out.println(str);
//				}
//
//			} // end for
//		} catch (SQLException se) {
//			LOG.debug(se.getMessage());
//			transRollback();
//		} catch (Exception e) {
//			e.printStackTrace();
//			transRollback();
//		}
//		return (whseKount);
//
//	} // end loadWhse()
}
