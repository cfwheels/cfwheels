/**
 * ********************************************************************************
 * Copyright Ortus Solutions, Corp
 * www.ortussolutions.com
 * ********************************************************************************
 * I turn a query of coverage data into an XML document for import into SonarQube's Generic Code Coverage plugin.
 */
component accessors=true {

	/**
	 * If set to true, the XML document will be formatted for human readability
	 */
	property name="formatXML" default="false";

	function init(){
		// This transformation will format an XML document to be indented with line breaks for readability
		variables.xlt = "<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform"">
						<xsl:output method=""xml"" encoding=""utf-8"" indent=""yes"" xslt:indent-amount=""2"" xmlns:xslt=""http://xml.apache.org/xslt"" />
						<xsl:strip-space elements=""*""/>
						<xsl:template match=""node() | @*""><xsl:copy><xsl:apply-templates select=""node() | @*"" /></xsl:copy></xsl:template>
						</xsl:stylesheet>";

		return this;
	}

	/**
	 *
	 * @qryCoverageData A query object containing coverage data
	 * @XMLOutputPath   Full path to write XML file to
	 *
	 * @return generated XML string
	 */
	string function generateXML( required query qryCoverageData, string XMLOutputPath = "" ){
		var coverageXML                     = xmlNew();
		var rootNode                        = xmlElemNew( coverageXML, "coverage" );
		rootNode.XMLAttributes[ "version" ] = 1;

		// Loop over each file
		for ( var row in qryCoverageData ) {
			var fileNode                     = xmlElemNew( coverageXML, "file" );
			fileNode.XMLAttributes[ "path" ] = row.filePath;

			for ( var line in row.lineData ) {
				var covered                            = ( row.lineData[ line ] > 0 ? "true" : "false" );
				var lineNode                           = xmlElemNew( coverageXML, "lineToCover" );
				lineNode.XMLAttributes[ "lineNumber" ] = line;
				lineNode.XMLAttributes[ "covered" ]    = covered;
				fileNode.XMLChildren.append( lineNode );
			}
			rootNode.XMLChildren.append( fileNode );
		}

		coverageXML.xmlRoot = rootNode;
		// coverageXML.XMLChildren.append( rootNode );

		if ( getFormatXML() ) {
			// Clean up formatting on XML doc and convert to string
			coverageXML = xmlTransform( coverageXML, variables.xlt );
		}

		// Convert to string
		var coverageXMLString = toString( coverageXML );

		// If there is an output path, write it to a file
		if ( len( XMLOutputPath ) ) {
			fileWrite( arguments.XMLOutputPath, coverageXMLString );
		}

		// Return the XML string
		return coverageXMLString;
	}

}
