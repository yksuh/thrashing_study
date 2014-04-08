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
package azdblab.model.experiment;

import java.io.InputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.xml.serialize.OutputFormat;
import org.apache.xml.serialize.XMLSerializer;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;

//import javax.xml.parsers.SAXParserFactory;
//import javax.xml.parsers.SAXParser;

//import javax.xml.XMLMetaData;
//import javax.xml.transform.stream.StreamSource;
//import javax.xml.validation.Schema;
//import javax.xml.validation.SchemaFactory;

//import org.xml.sax.SAXException;
//import org.xml.sax.SAXParseException;
//import org.xml.sax.helpers.DefaultHandler;

import azdblab.Constants;
import azdblab.executable.Main;

public class XMLHelper {

	public static Document readDocument(File xml_source) {

		try {

			ExperimentErrorHandler.hasErrors = false;
			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();

			factory.setIgnoringComments(true);
			factory.setIgnoringElementContentWhitespace(true);

			DocumentBuilder builder = factory.newDocumentBuilder();
			builder.setErrorHandler(new ExperimentErrorHandler(xml_source
					.getName()));
			Document d = builder.parse(xml_source);
			if (ExperimentErrorHandler.hasErrors) {
				writeXMLToOutputStream(System.err, d.getDocumentElement());
				System.exit(1); // okay exit since xml wrong
			}
			return d;

		} catch (IOException e) {
			Main._logger.reportError(e.getMessage());
			// e.printStackTrace();
			System.exit(1);
		} catch (ParserConfigurationException e) {
			Main._logger.reportError(e.getMessage());
			System.exit(1);
		} catch (SAXException e) {
			Main._logger.reportError(e.getMessage());
			System.exit(1);
		}
		return null;
	}

	public static Document readDocument(FileInputStream fin) {

		try {

			ExperimentErrorHandler.hasErrors = false;
			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();

			factory.setIgnoringComments(true);
			factory.setIgnoringElementContentWhitespace(true);

			DocumentBuilder builder = factory.newDocumentBuilder();
			builder.setErrorHandler(new ExperimentErrorHandler(fin.toString()));
			Document d = builder.parse(fin);
			if (ExperimentErrorHandler.hasErrors) {
				writeXMLToOutputStream(System.err, d.getDocumentElement());
				// System.exit(1); //okay exit since xml wrong
			}
			return d;

		} catch (IOException e) {
			Main._logger.reportError(e.getMessage());
			e.printStackTrace();
			// System.exit(1);
		} catch (ParserConfigurationException e) {
			Main._logger.reportError(e.getMessage());
			e.printStackTrace();
			// System.exit(1);
		} catch (SAXException e) {
			Main._logger.reportError(e.getMessage());
			e.printStackTrace();
			// System.exit(1);
		}
		return null;
	}


	/**
	 * Tests to see if the xml source file is valid according to the XML schema
	 * file that was passed in.
	 * 
	 * @param xml_schema
	 *            The schema used in validation.
	 * @param xml_source
	 *            The source file that is being validated.
	 * @return true - if the file is valid and has no errors.<BR>
	 *         false - if the file has one or more errors.
	 */
	public static boolean isValid(InputStream xml_schema, InputStream xml_source) {
		try {
			ExperimentErrorHandler.hasErrors = false;
			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			factory.setValidating(true);
			factory.setNamespaceAware(true);
			factory.setIgnoringComments(true);
			factory.setIgnoringElementContentWhitespace(true);
			factory.setAttribute(Constants.JAXP_SCHEMA_LANGUAGE,
					Constants.W3C_XML_SCHEMA);
			factory.setAttribute(Constants.JAXP_SCHEMA_SOURCE, xml_schema);

			DocumentBuilder builder = factory.newDocumentBuilder();
			builder.setErrorHandler(new ExperimentErrorHandler());
			builder.parse(xml_source);
			if (ExperimentErrorHandler.hasErrors) {
				System.err.println("has errors");
				return false;
			}
			return true;
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
			return false;
		} catch (SAXException e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * Validates and returns the DOM document for this xml source.
	 * 
	 * @param xml_schema
	 *            The XML schema used in validation.
	 * @param xml_source
	 *            The XML source of this experiment.
	 * @return The DOM document for this XML source file.
	 */
	public static Document validate(InputStream xml_schema,
			InputStream xml_source) {
		try {

			ExperimentErrorHandler.hasErrors = false;
			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();

			factory.setValidating(true);
			factory.setNamespaceAware(true);
			factory.setIgnoringComments(true);
			factory.setIgnoringElementContentWhitespace(true);
			factory.setAttribute(Constants.JAXP_SCHEMA_LANGUAGE,
					Constants.W3C_XML_SCHEMA);
			factory.setAttribute(Constants.JAXP_SCHEMA_SOURCE, xml_schema);

			DocumentBuilder builder = factory.newDocumentBuilder();
			// builder.setErrorHandler(new
			// ExperimentErrorHandler(xml_source.getName()));
			Document d = builder.parse(xml_source);
			if (ExperimentErrorHandler.hasErrors) {
				writeXMLToOutputStream(System.err, d.getDocumentElement());
				System.exit(1); // okay exit since xml wrong
			}
			// else{
			// writeXMLToOutputStream(System.out, d.getDocumentElement());
			// }
			return d;

		} catch (IOException e) {
			Main._logger.reportError(e.getMessage());
			// e.printStackTrace();
			System.exit(1);
		} catch (ParserConfigurationException e) {
			Main._logger.reportError(e.getMessage());
			System.exit(1);
		} catch (SAXException e) {
			Main._logger.reportError(e.getMessage());
			System.exit(1);
		}
		return null;
	}

	/**
	 * Given an XML source and an XSLT style sheet transform the XML source. The
	 * result is placed inside of result.
	 * 
	 * @param source
	 *            The XML source that will be transformed.
	 * @param inStream
	 *            The XSLT style sheet used to transform the source.
	 * @param result
	 *            The file that will hold the transformed result.
	 */
	public static void transform(String source, InputStream inStream,
			String result) {

		try {
			TransformerFactory tFactory = TransformerFactory.newInstance();
			Transformer transformer;
			transformer = tFactory.newTransformer(new StreamSource(inStream));
			transformer.transform(new StreamSource(source), new StreamResult(
					new FileOutputStream(result)));
		} catch (TransformerConfigurationException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (TransformerException e) {
			e.printStackTrace();
		}

	}

	/**
	 * Validates and returns the DOM document for this xml source.
	 * 
	 * @param xml_schema
	 *            The XML schema used in validation.
	 * @param xml_source
	 *            The XML source of this experiment.
	 * @return The DOM document for this XML source file.
	 */
	public static Document validate(InputStream xml_schema,
			FileInputStream xml_source) {

		try {
			ExperimentErrorHandler.hasErrors = false;
			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			factory.setValidating(true);
			factory.setNamespaceAware(true);
			factory.setIgnoringComments(true);
			factory.setIgnoringElementContentWhitespace(true);
			factory.setAttribute(Constants.JAXP_SCHEMA_LANGUAGE,
					Constants.W3C_XML_SCHEMA);
			factory.setAttribute(Constants.JAXP_SCHEMA_SOURCE, xml_schema);

			DocumentBuilder builder = factory.newDocumentBuilder();
			builder.setErrorHandler(new ExperimentErrorHandler());
			Document d = builder.parse(xml_source);
			if (ExperimentErrorHandler.hasErrors) {
				Main._logger.reportError("xml has error");
				System.exit(1);
			}
			// okay exit since xml wrong
			return d;
		} catch (IOException e) {
			Main._logger.reportError(e.getMessage());
			System.exit(1);
		} catch (ParserConfigurationException e) {
			Main._logger.reportError(e.getMessage());
			System.exit(1);
		} catch (SAXException e) {
			Main._logger.reportError(e.getMessage());
			System.exit(1);
			return null;
		}
		return null;
	}

	/**
	 * Validates and returns the DOM document for this xml source.
	 * 
	 * @param xml_schema
	 *            The XML schema used in validation.
	 * @param xml_source
	 *            The XML source of this experiment.
	 * @return The DOM document for this XML source file.
	 */
	// public static Document validate(String xml_schema, String xml_source) {
	// return validate(new File(xml_schema), new File(xml_source));
	// }

	/**
	 * Writes an XML DOM to an output stream
	 * 
	 * @param out
	 *            The output stream that will hold the XML output
	 * @param e
	 *            The DOM element that will be written to the output stream.
	 * @throws IOException
	 *             If there is a problem writing to the output stream.
	 */
	// Used to output XML from a DOM to an OutputStream
	public static void writeXMLToOutputStream(OutputStream out, Element e)
			throws IOException {
		OutputFormat format = new OutputFormat();
		format.setLineWidth(85);
		format.setIndenting(true);
		format.setIndent(4);
		format.setPreserveSpace(false);
		XMLSerializer serializer = new XMLSerializer(out, format);
		serializer.serialize(e);
	}

}
