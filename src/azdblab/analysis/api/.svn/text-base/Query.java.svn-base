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

package azdblab.analysis.api;

/**
 * DOCUMENT ME!
 *
 * @author Siou Lin
 * @version %I%
 */
public interface Query {
    //~ Static fields/initializers ���������������������������������������������

    /** DOCUMENT ME! */
    public static final String SELECT = "select";

    /** DOCUMENT ME! */
    public static final String FROM = "from";

    /** DOCUMENT ME! */
    public static final String WHERE = "where";

    /** DOCUMENT ME! */
    public static final String TYPE = "type";

    /** DOCUMENT ME! */
    public static final String SELECT_PERMUTABLE = "selectPermutable";

    /** DOCUMENT ME! */
    public static final String FROM_PERMUTABLE = "fromPermutable";

    /** DOCUMENT ME! */
    public static final String WHERE_PERMUTABLE = "wherePermutable";

    //~ Methods ����������������������������������������������������������������

    /**
     * DOCUMENT ME!
     *
     * @param fromArgument DOCUMENT ME!
     */
    public void setFromClause( String fromClause );

    /**
     * DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    public String getFromClause(  );

    /**
     * DOCUMENT ME!
     *
     * @param fromPermutable DOCUMENT ME!
     */
    public void setFromPermutable( boolean fromPermutable );

    /**
     * DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    public boolean isFromPermutable(  );

    /**
     * DOCUMENT ME!
     *
     * @param selectArgument DOCUMENT ME!
     */
    public void setSelectClause( String selectCaluse );

    /**
     * DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    public String getSelectClause(  );

    /**
     * DOCUMENT ME!
     *
     * @param selectPermutable DOCUMENT ME!
     */
    public void setSelectPermutable( boolean selectPermutable );

    /**
     * DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    public boolean isSelectPermutable(  );

    /**
     * DOCUMENT ME!
     *
     * @param type DOCUMENT ME!
     */
    public void setType( int type );

    /**
     * DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    public int getType(  );

    /**
     * DOCUMENT ME!
     *
     * @param whereCondition DOCUMENT ME!
     */
    public void setWhereClause( String whereClause );

    /**
     * DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    public String getWhereClause(  );

    /**
     * DOCUMENT ME!
     *
     * @param wherePermutable DOCUMENT ME!
     */
    public void setWherePermutable( boolean wherePermutable );

    /**
     * DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    public boolean isWherePermutable(  );
}
