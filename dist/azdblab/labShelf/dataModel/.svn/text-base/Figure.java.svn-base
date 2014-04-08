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
package azdblab.labShelf.dataModel;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;

import com.panayotis.gnuplot.JavaPlot;
import com.panayotis.gnuplot.plot.DataSetPlot;
import com.panayotis.gnuplot.plot.Plot;
import com.panayotis.gnuplot.style.PlotStyle;
import com.panayotis.gnuplot.style.Style;

import azdblab.Constants;
import azdblab.labShelf.GeneralDBMS;
import azdblab.swingUI.AZDBLabObserver;

public class Figure {

	private int paperID;
	private int InstantiatedQueryID;
	private String FigureName;
	private String xValue;
	private String yValue;
	private String description;
	private String creationTime;
	private String cValue;
	private int numColors;
	private boolean ShowLegend;
	private String LineType;

	public Figure(int paperID, int InstantiatedQueryID, String FigureName,
			String Xval, String yVal, String description, String creationTime,
			String cVal, int cNum, String showLegend, String lineType) {
		this.paperID = paperID;
		this.InstantiatedQueryID = InstantiatedQueryID;
		this.FigureName = FigureName;
		this.xValue = Xval;
		this.yValue = yVal;
		this.description = description;
		this.creationTime = creationTime;
		this.cValue = cVal;
		this.numColors = cNum;
		this.ShowLegend = showLegend.toLowerCase().equals("true");
		this.LineType = lineType;
	}

	public static Figure getFigure(int paperID, String figureName) {
		String sql = "Select InstantiatedQueryID, X_VAL, Y_VAL, Description, CreationTime, C_VAL, C_NUM, ShowLegend, LineType from "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_FIGURE
				+ " where paperID = "
				+ paperID
				+ " and figureName = '"
				+ figureName + "'";
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			if (rs.next()) {
				return new Figure(paperID, rs.getInt(1), figureName, rs
						.getString(2), rs.getString(3), rs.getString(4), 
						new SimpleDateFormat(Constants.TIMEFORMAT).format(rs.getTimestamp(5)), rs.getString(6), rs.getInt(7), rs
						.getString(8), rs.getString(9));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public static void addFigure(int paperID, int InstantiatedQueryID,
			String Description, String FigureName, String xValue,
			String yValue, String cValue, int numColors, String showLegend,
			String lineType) {
		SimpleDateFormat creationDateFormater = new SimpleDateFormat(
				Constants.NEWTIMEFORMAT);
		String currentTime = creationDateFormater.format(new Date(System
				.currentTimeMillis()));

		try {
			LabShelfManager.getShelf().insertTupleToNotebook(
					Constants.TABLE_PREFIX + Constants.TABLE_FIGURE,
					new String[] { "PaperID", "InstantiatedQueryID",
							"FigureName", "X_VAL", "Y_VAL", "Description",
							"CreationTime", "C_VAL", "C_NUM", "ShowLegend",
							"LineType" },
					new String[] { String.valueOf(paperID),
							String.valueOf(InstantiatedQueryID), FigureName,
							xValue, yValue, Description + " ", currentTime,
							cValue, String.valueOf(numColors), showLegend,
							lineType },
					new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_TIMESTAMP,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_VARCHAR });
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public JavaPlot getJavaPlot() {
		String instQuery = InstantiatedQuery.getInstantiatedQuery(
				InstantiatedQueryID).getInstantiatedSQL();
		return getJavaPlot(instQuery, getColumn(xValue.split("::")[0],
				instQuery), getColumn(yValue.split("::")[0], instQuery),
				getColumn(cValue, instQuery), xValue.split("::")[1]
						.equals("Logarithmic"), yValue.split("::")[1]
						.equals("Logarithmic"), numColors, ShowLegend,
				LineType, false);
	}

	public static JavaPlot getJavaPlot(String sql, int X_COL, int Y_COL,
			int C_COL, boolean X_LOG, boolean Y_LOG, int numColors,
			boolean showLegend, String pointType, boolean primaryKeyMode) {
		AZDBLabObserver.timerOn = false;
		try {
			JavaPlot data = new JavaPlot();
			if (showLegend) {
				data.setKey(JavaPlot.Key.TOP_LEFT);
			} else {
				data.setKey(JavaPlot.Key.OFF);
			}

			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			ResultSetMetaData rsmd = rs.getMetaData();
			ArrayList<GNUData> dataList = new ArrayList<GNUData>();

			data.getAxis("x").setLabel(rsmd.getColumnName(X_COL + 1));
			data.getAxis("y").setLabel(rsmd.getColumnName(Y_COL + 1));
			String colAxisName = rsmd.getColumnName(C_COL + 1);
			while (rs.next()) {
				dataList.add(new GNUData(new double[] {
						rs.getDouble(X_COL + 1), rs.getDouble(Y_COL + 1) }, rs
						.getDouble(C_COL + 1)));
			}
			rs.close();
			Collections.sort(dataList);
			int startVal = 0;
			if (primaryKeyMode) {
				double curVal = dataList.get(0).colorVal;
				for (int i = 0; i < dataList.size(); i++) {
					if (dataList.get(i).colorVal == curVal) {
						dataList.get(i).colorVal = startVal;
					} else {
						startVal++;
						curVal = dataList.get(i).colorVal;
						dataList.get(i).colorVal = startVal;
					}
				}
			}
			double intervals = (dataList.get(dataList.size() - 1).colorVal - dataList
					.get(0).colorVal)
					/ numColors;
			if (primaryKeyMode) {
				intervals = 1;
			}
			if (X_LOG) {
				data.getAxis("x").setLogScale(true);
			}
			if (Y_LOG) {
				data.getAxis("y").setLogScale(true);
			}

			double GNUdata[][];
			if (!primaryKeyMode) {
				if (numColors != 1) {
					for (double c = dataList.get(0).colorVal; c < dataList
							.get(dataList.size() - 1).colorVal; c = c
							+ intervals) {
						int first = -1;
						int last = -1;
						for (int i = 0; i < dataList.size(); i++) {
							if (first == -1 && dataList.get(i).colorVal >= c) {
								first = i;
							}
							if (last == -1
									&& dataList.get(i).colorVal > c + intervals) {
								last = i - 1;
							}
						}
						if (last == -1) {
							last = dataList.size() - 1;
						}
						if (last - first + 1 == 0) {
							continue;
						}
						GNUdata = new double[last - first + 1][2];
						for (int i = first; i <= last; i++) {
							GNUdata[i - first] = dataList.get(i).dataPoint;
						}
						data.addPlot(GNUdata);
					}
				} else {
					GNUdata = new double[dataList.size()][2];
					for (int i = 0; i < dataList.size(); i++) {
						GNUdata[i] = dataList.get(i).dataPoint;
					}
					data.addPlot(GNUdata);
				}
			} else {
				for (int i = 0; i <= startVal; i++) {
					int startPoint = -1;
					int endPoint = -1;
					for (int k = 0; k < dataList.size(); k++) {
						if (startPoint == -1 && dataList.get(k).colorVal == i) {
							startPoint = k;
						}
						if (dataList.get(k).colorVal == i) {
							endPoint = k;
						}
					}
					GNUdata = new double[endPoint - startPoint + 1][2];
					for (int k = startPoint; k <= endPoint; k++) {
						GNUdata[k - startPoint] = dataList.get(k).dataPoint;
					}
					data.addPlot(GNUdata);

				}
			}
			ArrayList<Plot> p = data.getPlots();
			for (int i = 0; i < p.size(); i++) {
				((DataSetPlot) p.get(i)).setTitle(colAxisName + ":" + intervals
						* i + "->" + intervals * (i + 1));

				PlotStyle pst = new PlotStyle();
				// pst.setLineType(colors[i % colors.length]);
				if (pointType.equals("Lines")) {
					pst.setStyle(Style.LINES);
					((DataSetPlot) p.get(i)).setPlotStyle(pst);
				} else if (pointType.equals("Bars")) {
					pst.setStyle(Style.BOXES);
					((DataSetPlot) p.get(i)).setPlotStyle(pst);

				}

			}
			AZDBLabObserver.timerOn = true;
			return data;
		} catch (Exception e) {
			e.printStackTrace();
		}
		AZDBLabObserver.timerOn = true;
		return null;
	}

	public static int getColumn(String colName, String query) {
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(query);
			ResultSetMetaData rsmd = rs.getMetaData();
			for (int i = 0; i < rsmd.getColumnCount(); i++) {
				if (colName.equals(rsmd.getColumnName(i + 1))) {
					return i;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public int getPaperID() {
		return paperID;
	}

	public int getInstantiatedQueryID() {
		return InstantiatedQueryID;
	}

	public String getFigureName() {
		return FigureName;
	}

	public String getxValue() {
		return xValue;
	}

	public String getyValue() {
		return yValue;
	}

	public String getDescription() {
		return description;
	}

	public String getCreationTime() {
		return creationTime;
	}

	public String getcValue() {
		return cValue;
	}

	public int getNumColors() {
		return numColors;
	}

	public boolean getShowLegend() {
		return ShowLegend;
	}

	public String getLineType() {
		return LineType;
	}

	@Override
	public String toString() {
		return FigureName;
	}

	// private static final NamedPlotColor colors[] = new NamedPlotColor[] {
	// NamedPlotColor.DARK_RED, NamedPlotColor.LIGHT_RED,
	// NamedPlotColor.ORANGE, NamedPlotColor.YELLOW,
	// NamedPlotColor.MAGENTA, NamedPlotColor.GREEN,
	// NamedPlotColor.DARK_BLUE, NamedPlotColor.BLUE,
	// NamedPlotColor.TURQUOISE, NamedPlotColor.PURPLE,
	// NamedPlotColor.AQUAMARINE, NamedPlotColor.BEIGE,
	// NamedPlotColor.BLACK, NamedPlotColor.BROWN, NamedPlotColor.CORAL,
	// NamedPlotColor.CYAN, NamedPlotColor.GOLD, NamedPlotColor.GOLDENROD };
}

class GNUData implements Comparable<GNUData> {
	public double dataPoint[];
	public double colorVal;

	public GNUData(double[] sent, double col) {
		dataPoint = sent;
		colorVal = col;
	}

	public int compareTo(GNUData o) {
		if (colorVal > o.colorVal) {
			return 1;
		} else if (colorVal < o.colorVal) {
			return -1;
		}
		return 0;
	}
}