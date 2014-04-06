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

package azdblab.model.query.model;

import azdblab.analysis.api.Query;

import java.util.Observable;


/**
 * DOCUMENT ME!
 *
 * @author $author$
 * @version %I%
 */
public class DefaultQuery extends Observable implements Query {
    //~ Constructors 

    /**
     * Creates a new DefaultQuery object.
     */
    public DefaultQuery(  ) {
        super(  );
        selectClause = new String(  );
        fromClause   = new String(  );
        whereClause  = new String(  );
    }

    //~ Methods 

    /**
     * @see azdblab.analysis.api.Query#setFromClause(String)
     */
    public void setFromClause( String fromClause ) {
        this.fromClause = fromClause;
        setChanged(  );
        notifyObservers( FROM );
    }

    /**
     * @see azdblab.analysis.api.Query#getFromClause()
     */
    public String getFromClause(  ) {
        return fromClause;
    }

    /**
     * @see azdblab.analysis.api.Query#setFromPermutable(boolean)
     */
    public void setFromPermutable( boolean fromPermutable ) {
        this.fromPermutable = fromPermutable;
        setChanged(  );
        notifyObservers( FROM_PERMUTABLE );
    }

    /**
     * @see azdblab.analysis.api.Query#isFromPermutable()
     */
    public boolean isFromPermutable(  ) {
        return fromPermutable;
    }

    /**
     * DOCUMENT ME!
     *
     * @param selectClause DOCUMENT ME!
     *
     * @see azdblab.analysis.api.Query#setSelectClause(String)
     */
    public void setSelectClause( String selectClause ) {
        this.selectClause = selectClause;
        setChanged(  );
        notifyObservers( SELECT );
    }

    /**
     * @see azdblab.analysis.api.Query#getSelectClause()
     */
    public String getSelectClause(  ) {
        return selectClause;
    }

    /**
     * @see azdblab.analysis.api.Query#setSelectPermutable(boolean)
     */
    public void setSelectPermutable( boolean selectPermutable ) {
        this.selectPermutable = selectPermutable;
        setChanged(  );
        notifyObservers( SELECT_PERMUTABLE );
    }

    /**
     * @see azdblab.analysis.api.Query#isSelectPermutable()
     */
    public boolean isSelectPermutable(  ) {
        return selectPermutable;
    }

    /**
     * @see azdblab.analysis.api.Query#setType(int)
     */
    public void setType( int type ) {
        this.type = type;
        setChanged(  );
        notifyObservers( TYPE );
    }

    /**
     * @see azdblab.analysis.api.Query#getType()
     */
    public int getType(  ) {
        return type;
    }

    /**
     * @see azdblab.analysis.api.Query#setWhereClause(String)
     */
    public void setWhereClause( String whereClause ) {
        this.whereClause = whereClause;
        setChanged(  );
        notifyObservers( WHERE );
    }

    /**
     * @see azdblab.analysis.api.Query#getWhereClause()
     */
    public String getWhereClause(  ) {
        return whereClause;
    }

    /**
     * @see azdblab.analysis.api.Query#setWherePermutable(boolean)
     */
    public void setWherePermutable( boolean wherePermutable ) {
        this.wherePermutable = wherePermutable;
        setChanged(  );
        notifyObservers( WHERE_PERMUTABLE );
    }

    /**
     * @see azdblab.analysis.api.Query#isWherePermutable()
     */
    public boolean isWherePermutable(  ) {
        return wherePermutable;
    }

    //~ Instance fields 

    /** DOCUMENT ME! */
    private String fromClause;

    /** DOCUMENT ME! */
    private String selectClause;

    /** DOCUMENT ME! */
    private String whereClause;

    /** DOCUMENT ME! */
    private boolean fromPermutable;

    /** DOCUMENT ME! */
    private boolean selectPermutable;

    /** DOCUMENT ME! */
    private boolean wherePermutable;

    /** DOCUMENT ME! */
    private int type;
}
