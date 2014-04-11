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

package azdblab.model.query.mediator;

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


import azdblab.Constants;
import azdblab.model.query.model.DefaultQuery;


/**
 * DOCUMENT ME!
 *
 * @author $author$
 * @version %I%
 */
public class PermutableQueryReader {
    //~ Methods 

    /**
     * DOCUMENT ME!
     *
     * @param root DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    public static DefaultQuery[] read( Element root ) {
        DefaultQuery query = new DefaultQuery(  );

        // get query
        Element queryElement = (Element) root.getElementsByTagName( "query" )
                               .item( 0 );

        // read select attributes
        NodeList     columns = queryElement.getElementsByTagName( "column" );

        StringBuffer selectStr = new StringBuffer( columns.item( 0 )
                                                   .getTextContent(  ) );

        for( int i = 1; i < columns.getLength(  ); i++ ) {
            selectStr.append( ", " + columns.item( i ).getTextContent(  ) );
        }

        query.setSelectClause( selectStr.toString(  ) );

        // read from attributes
        NodeList     tables = queryElement.getElementsByTagName( "table" );

        StringBuffer fromStr = new StringBuffer( tables.item( 0 )
                                                 .getTextContent(  ) );

        for( int i = 1; i < tables.getLength(  ); i++ ) {
            fromStr.append( ", " + tables.item( i ).getTextContent(  ) );
        }

        query.setFromClause( fromStr.toString(  ) );

        // read where attributes
        query.setWhereClause( getWhereString( (Element) queryElement.getElementsByTagName( "conditionSet" )
                                              .item( 0 ) ) );

        // read permutation specifications
        Element select = (Element) queryElement.getElementsByTagName( "select" )
                         .item( 0 );
        Element from = (Element) queryElement.getElementsByTagName( "from" )
                       .item( 0 );
        Element where = (Element) queryElement.getElementsByTagName( "where" )
                        .item( 0 );

        query.setSelectPermutable( select.getAttribute( "permutable" ).equals( "true" ) );
        query.setFromPermutable( from.getAttribute( "permutable" ).equals( "true" ) );
        query.setWherePermutable( where.getAttribute( "permutable" ).equals( "true" ) );
        query.setType( Constants.GENERATOR_TYPE_PERMUTABLE );

        DefaultQuery[] queries = new DefaultQuery[1];
        queries[0] = query;

        return queries;
    }

    /**
     * DOCUMENT ME!
     *
     * @param node DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    private static String getWhereString( Element node ) {
        String whereString = getWhereStringR( node );

        return whereString.substring( 1, whereString.length(  ) - 1 );
    }

    /**
     * DOCUMENT ME!
     *
     * @param node DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    private static String getWhereStringR( Element node ) {
        // condition node
        if( node.getNodeName(  ).equals( "condition" ) ) {
            return node.getTextContent(  );
        }

        // operator node
        String       operator    = node.getAttribute( "operator" );
        StringBuffer whereString = new StringBuffer( "(" );

        NodeList     children       = node.getChildNodes(  );
        boolean      firstCondition = true;

        for( int i = 0; i < children.getLength(  ); i++ ) {
            Node child = children.item( i );

            if( child.getNodeType(  ) == Node.ELEMENT_NODE ) {
                if( firstCondition ) {
                    firstCondition = false;
                } else {
                    whereString.append( " " + operator + " " );
                }

                whereString.append( getWhereStringR( (Element) children.item( i ) ) );
            }
        }

        whereString.append( ")" );

        return whereString.toString(  );
    }
}
