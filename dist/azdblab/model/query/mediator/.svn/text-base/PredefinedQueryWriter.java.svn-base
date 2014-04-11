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

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;


/**
 * DOCUMENT ME!
 *
 * @author $author$
 * @version %I%
 */
public class PredefinedQueryWriter {
    //~ Methods 

    /**
     * DOCUMENT ME!
     *
     * @param defaultQuery DOCUMENT ME!
     * @param outFile DOCUMENT ME!
     */
    public static void write( DefaultQuery defaultQuery,
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

            Element         root  = doc.createElement( Constants.S_GENERATOR_TYPE_PREDEFINED );
            Element         query = doc.createElement( "query" );

            root.setAttribute( "xmlns:xsi",
                               "http://www.w3.org/2001/XMLSchema-instance" );
            root.setAttribute( "xsi:noNamespaceSchemaLocation",
                               "../xml_schema/predefinedQueries.xsd" );
            root.appendChild( query );

            String queryString = "SELECT " + defaultQuery.getSelectClause(  )
                                 + " FROM " + defaultQuery.getFromClause(  );

            if( defaultQuery.getWhereClause(  ).length(  ) > 0 ) {
                queryString += ( " WHERE " + defaultQuery.getWhereClause(  ) );
            }

            query.setAttribute( "sql", queryString );

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
}
