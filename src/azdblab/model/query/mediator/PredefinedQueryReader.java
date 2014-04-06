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

import azdblab.Constants;
import azdblab.model.query.model.DefaultQuery;


/**
 * DOCUMENT ME!
 *
 * @author Siou Lin
 * @version %I%
 */
public class PredefinedQueryReader {
    //~ Methods 

    //    /**
    //     * DOCUMENT ME!
    //     *
    //     * @param args DOCUMENT ME!
    //     */
    //    public static void main( String[] args ) {
    //        Main._logger.outputLog( "Main" );
    //
    //        Element root = XMLHelper.validate( new File( AZDBLab.PREDEFINED_SCHEMA ),
    //                                           new File( "./xml_source/JL1M3new.xml" ) )
    //                       .getDocumentElement(  );
    //
    //        read( root );
    //    }

    /**
     * DOCUMENT ME!
     *
     * @param root DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    public static DefaultQuery[] read( Element root ) {
        int numQueries = root.getElementsByTagName( "query" ).getLength(  );

        DefaultQuery[] queries = new DefaultQuery[numQueries];

        for( int i = 0; i < numQueries; i++ ) {
            // get query
            Element queryElement = (Element) root.getElementsByTagName( "query" )
                                   .item( i );

            //TODO: allow predefined queries for other databases
            String query = queryElement.getAttribute( "sql" );

            // tokenize clauses
            String[] clauses = tokenizeClauses( query );

            queries[i] = new DefaultQuery(  );
            queries[i].setSelectClause( clauses[0] );
            queries[i].setFromClause( clauses[1] );
            queries[i].setWhereClause( clauses[2] );
            queries[i].setType( Constants.GENERATOR_TYPE_PREDEFINED );
        }

        return queries;
    }

    /**
     * DOCUMENT ME!
     *
     * @param query DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    private static String[] tokenizeClauses( String query ) {
        int      startSelect = 0;
        int      startFrom  = query.indexOf( "FROM" );
        int      startWhere = query.indexOf( "WHERE" );

        String[] clauses = new String[3];
        clauses[0] = query.substring( startSelect, startFrom );

        clauses[1] = ( startWhere > 0 )
                     ? query.substring( startFrom, startWhere )
                     : query.substring( startFrom, query.length(  ) );

        clauses[2] = ( startWhere > 0 )
                     ? query.substring( startWhere, query.length(  ) ) : "";

        clauses[0] = clauses[0].replaceAll( "SELECT", "" );
        clauses[1] = clauses[1].replaceAll( "FROM", "" );
        clauses[2] = clauses[2].replaceAll( "WHERE", "" );

        clauses[0] = clauses[0].trim(  );
        clauses[1] = clauses[1].trim(  );
        clauses[2] = clauses[2].trim(  );

        return clauses;
    }
}
