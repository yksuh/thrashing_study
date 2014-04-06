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

import java.text.SimpleDateFormat;
import java.util.Date;

import azdblab.Constants;
import azdblab.labShelf.GeneralDBMS;

public class Comment {
	private int runID;
	private String strDateAdded;
	private String strComment;

	public Comment(int runID, String comment, String dateAdded) {
		this.runID = runID;
		strComment = comment;
		strDateAdded = dateAdded;
	}

	public int getRunID() {
		return runID;
	}

	public String getDateAdded() {
		return strDateAdded;
	}

	public String getComment() {
		return strComment;
	}

	public static void addComment(int runID, String comment) {
		LabShelfManager.getShelf()
				.putDocument(
						Constants.TABLE_PREFIX + Constants.TABLE_COMMENT,
						"Comments",
						new String[] { "RunID", "DateAdded" },
						new String[] {
								String.valueOf(runID),
								new SimpleDateFormat(Constants.TIMEFORMAT)
										.format(new Date(System
												.currentTimeMillis())) },
						new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
								GeneralDBMS.I_DATA_TYPE_VARCHAR, }, comment);
		LabShelfManager.getShelf().commit();
		LabShelfManager.getShelf().commitlabshelf();
	}

	@Override
	public String toString() {
		return strDateAdded;
	}
}
