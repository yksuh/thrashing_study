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

import org.w3c.dom.Document;
import org.w3c.dom.Element;


import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.model.experiment.XMLHelper;
import azdblab.model.query.model.DefaultQuery;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import java.util.ArrayList;
import java.util.List;

import javax.swing.tree.DefaultMutableTreeNode;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;


/**
 * DOCUMENT ME!
 *
 * @author Siou Lin
 * @version %I%
 */
public class PermutableQueryWriter {
    //~ Methods 

    /**
     * DOCUMENT ME!
     *
     * @param permutableQuery DOCUMENT ME!
     * @param outFile DOCUMENT ME!
     */
    public static void write( DefaultQuery permutableQuery,
                              File         outFile ) {
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance(  );

            factory.setValidating( true );
            factory.setNamespaceAware( true );
            factory.setIgnoringComments( true );
            factory.setIgnoringElementContentWhitespace( true );
            factory.setAttribute( Constants.JAXP_SCHEMA_LANGUAGE, Constants.W3C_XML_SCHEMA );
            factory.setAttribute( Constants.JAXP_SCHEMA_SOURCE,
                                  Constants.CHOSEN_PERMUTABLE_SCHEMA );

            DocumentBuilder builder = factory.newDocumentBuilder(  );

            Document        doc = builder.newDocument(  );

            Element         root   = doc.createElement( Constants.S_GENERATOR_TYPE_PERMUTABLE );
            Element         query  = doc.createElement( "query" );
            Element         select = doc.createElement( "select" );
            Element         from   = doc.createElement( "from" );
            Element         where  = doc.createElement( "where" );

            root.setAttribute( "xmlns:xsi",
                               "http://www.w3.org/2001/XMLSchema-instance" );
            root.setAttribute( "xsi:noNamespaceSchemaLocation",
                               "../xml_schema/permutableQueries.xsd" );
            root.appendChild( query );

            // add select and from clause (where is optional)
            query.appendChild( select );
            query.appendChild( from );

            // build select node
            String[] selectAttr = permutableQuery.getSelectClause(  ).split( "," );

            for( int i = 0; i < selectAttr.length; i++ ) {
                Element column = doc.createElement( "column" );
                column.setTextContent( selectAttr[i].trim(  ) );
                select.appendChild( column );
            }

            select.setAttribute( "permutable",
                                 String.valueOf( permutableQuery
                                                 .isSelectPermutable(  ) ) );

            // build from node            
            String[] fromAttr = permutableQuery.getFromClause(  ).split( "," );

            for( int i = 0; i < fromAttr.length; i++ ) {
                Element table = doc.createElement( "table" );
                table.setTextContent( fromAttr[i].trim(  ) );
                from.appendChild( table );
            }

            from.setAttribute( "permutable",
                               String.valueOf( permutableQuery.isFromPermutable(  ) ) );

            // build where node
            List<?> whereTokens = tokenizeWhere( permutableQuery );

            if( whereTokens.size(  ) > 0 ) {
                query.appendChild( where );
                where.appendChild( getWhereNode( doc, parseWhere( whereTokens ) ) );
                where.setAttribute( "permutable",
                                    String.valueOf( permutableQuery
                                                    .isWherePermutable(  ) ) );
            }

            //TODO: write to temporary file and check if document structure is valid. alert user if invalid
            FileOutputStream out = new FileOutputStream( outFile );
            XMLHelper.writeXMLToOutputStream( out, root );
        } catch( IOException e ) {
            Main._logger.reportError( e.getMessage(  ) );
            System.exit( 1 );
        } catch( ParserConfigurationException e ) {
            Main._logger.reportError( e.getMessage(  ) );
            System.exit( 1 );
        }
    }

    /**
     * DOCUMENT ME!
     *
     * @param doc DOCUMENT ME!
     * @param node DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    private static Element getWhereNode( Document               doc,
                                         DefaultMutableTreeNode node ) {
        String item = node.getUserObject(  ).toString(  );

        if( item.equals( "AND" ) || item.equals( "OR" ) ) {
            Element conditionSet = doc.createElement( "conditionSet" );
            conditionSet.setAttribute( "operator", item );

            for( int i = 0; i < node.getChildCount(  ); i++ ) {
                conditionSet.appendChild( getWhereNode( doc,
                                                        (DefaultMutableTreeNode) node
                                                        .getChildAt( i ) ) );
            }

            return conditionSet;
        }

        Element condition = doc.createElement( "condition" );
        condition.setTextContent( item );

        return condition;
    }

    /**
     * Parses a tokenized where list and returns an operator tree. Unless
     * parentheses are specified, arguments are assumed to be left
     * associative.
     *
     * @param list - list of operator and condition tokens
     *
     * @return operator tree
     */
    private static DefaultMutableTreeNode parseWhere( List<?> list ) {
        if( list.size(  ) == 1 ) {
            return new DefaultMutableTreeNode( list.get( 0 ), false );
        }

        int    parens = 0;
        int    start = 0;
        String op    = "";

        //TODO: verify that tokens are valid
        DefaultMutableTreeNode node = null;

        for( int i = 0; i < list.size(  ); i++ ) {
            String item = list.get( i ).toString(  );

            if( item.equals( "(" ) ) {
                parens++;
            } else if( item.equals( ")" ) ) {
                parens--;
            } else if( parens == 0 ) {
                // process top level operator
                if( item.equals( "OR" ) || item.equals( "AND" ) ) {
                    if( op.equals( "" ) ) {
                        node = new DefaultMutableTreeNode( item );
                    }

                    // process left clause
                    if( list.get( start ).equals( "(" )
                        && list.get( i - 1 ).equals( ")" ) ) {
                        //NOTE: the subList function grabs items in interval [start,end)
                        node.add( parseWhere( list.subList( start + 1, i - 1 ) ) );
                    } else {
                        node.add( parseWhere( list.subList( start, i ) ) );
                    }

                    start = i + 1;

                    // process right clause
                    if( op.equals( "" ) ) {
                        op = item;
                    } else if( !op.equals( item ) ) {
                        if( list.get( i + 1 ).equals( "(" )
                            && list.get( list.size(  ) - 1 ).equals( ")" ) ) {
                            node.add( parseWhere( list.subList( i + 2,
                                                                list.size(  )
                                                                - 1 ) ) );
                        } else {
                            node.add( parseWhere( list.subList( i + 1,
                                                                list.size(  ) ) ) );
                        }

                        break;
                    }
                }
            } else if( i == ( list.size(  ) - 1 ) ) {
                return parseWhere( list.subList( 1, list.size(  ) - 1 ) );
            }
        }

        node.add( parseWhere( list.subList( start, list.size(  ) ) ) );

        return node;
    }

    /**
     * DOCUMENT ME!
     *
     * @param query DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    private static List<String> tokenizeWhere( DefaultQuery query ) {
        String whereString = query.getWhereClause(  ).trim(  );
        Main._logger.outputLog( whereString );

        List<String>         whereTokens = new ArrayList<String>(  );

        StringBuffer sb = new StringBuffer(  );

        for( int i = 0; i < whereString.length(  ); i++ ) {
            char c = whereString.charAt( i );

            if( ( c == '(' ) || ( c == ')' ) ) {
                if( sb.length(  ) > 0 ) {
                    whereTokens.add( sb.toString(  ) );
                    sb = new StringBuffer(  );
                }

                whereTokens.add( String.valueOf( c ) );
            } else if( c == ' ' ) {
                if( sb.length(  ) > 0 ) {
                    //match a condition or operator
                    if( sb.toString(  ).matches( "\\w+[.]\\w+(<||<=||=||<>||>=||>)\\w+[.]\\w+" )
                        || sb.toString(  ).equals( "OR" )
                        || sb.toString(  ).equals( "AND" ) ) {
                        whereTokens.add( sb.toString(  ) );
                        sb = new StringBuffer(  );
                    }
                }
            } else {
                sb.append( c );
            }
        }

        if( sb.length(  ) > 0 ) {
            whereTokens.add( sb.toString(  ) );
        }

        return whereTokens;
    }
}
