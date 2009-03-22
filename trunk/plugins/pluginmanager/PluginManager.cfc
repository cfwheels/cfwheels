<cfcomponent output="false">

	<cffunction name="init">
		<cfset this.version = "0.9.1">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="install">
		<cfargument name="pluginURL" type="string" required="true" />
		
		<cfset loc = {}>
		
		<cfset loc.pluginFile = $downloadPlugin(arguments.pluginURL)>
		<cfset loc.pluginFileName = REMatch("plugins/(.*?).zip", arguments.pluginURL)>
		<cfset loc.pluginFileName = Replace(loc.pluginFileName[1], "plugins/", "")>
		<cfset loc.pluginDirectory = "plugins/">
		
		<cffile action="write" file="#ExpandPath(loc.pluginDirectory)&loc.pluginFileName#" output="#loc.pluginFile#" mode="777" />
		
		<cfset $reloadApp()>
		
	</cffunction>
	
	<cffunction name="$getPluginListing" returnType="query">
		<cfset var loc = {}>
		
		<cfhttp url="http://www.wikitorio.com/plugins.xml" result="loc.xmlData" />
				
		<!--- Parse the data into a query --->
		<cfset loc.pluginQuery = XmlToQuery(XmlParse(loc.xmlData.fileContent))>

		<cfreturn loc.pluginQuery>
	</cffunction>
	
	<cffunction name="$downloadPlugin" returnType="any">
		<cfargument name="fileURL" type="string" required="true" />
		
		<cfset var loc = {}>
		
		<cfhttp url="#arguments.fileURL#" result="loc.fileData" method="GET" getAsBinary="yes" />
		
		<cfset loc.fileData = loc.fileData.FileContent>
		
		<cfreturn loc.fileData>
	</cffunction>
	
	<cffunction name="$reloadApp">
		<cflocation url="?reload=true" addToken="no" />
	</cffunction>
	
	<cffunction name="XmlToQuery" access="public" output="no" hint="Converts a XML document object or a XML file to query.">
		<cfargument name="xmlObj" required="no" type="any" hint="Parsed XML document object. Required if argument file is not set.">
		<cfargument name="file" required="no" type="string" hint="Pathname or URL of the XML file to read. Required if argument xmlObj is not set.">
		<cfargument name="charset" required="no" type="string" default="UTF-8" hint="The character encoding in which the XML file contents is encoded.">

		<cfscript>

			/* Default variables */
			var i = 0;
			var n = 0;
			var childCurrent = "";
			var childLast    = "";

			if(NOT IsDefined("arguments.xmlData"))
			{
				query = QueryNew("");

				if(IsDefined("arguments.file"))
					xmlObj = XmlParseFile(arguments.file, arguments.charset);

				if(StructKeyExists(xmlObj, "xmlRoot"))
					XmlToQuery(xmlData=xmlObj.xmlRoot);
				else
					XmlToQuery(xmlData=xmlObj);
			}

			else
			{
				for(i=1; i LTE ArrayLen(arguments.xmlData.xmlChildren); i=i+1)
				{
					/* Create a struct with the Children and Attributes data */
					data = StructNew();
					data[arguments.xmlData.xmlChildren[i].xmlName] = arguments.xmlData.xmlChildren[i].xmlText;
					StructAppend(data, arguments.xmlData.xmlChildren[i].xmlAttributes);

					/* Append previous data to current data struct */
					if(IsDefined("arguments.prevData"))
						StructAppend(data, arguments.prevData);

					/* Create a array with the elements names */
					names = StructKeyArray(data);

					/* Set the current children name */
					childCurrent = arguments.xmlData.xmlChildren[i].xmlName;

					/* Create a new row if the query is empty or the current children name is the same as the last children name */
					if(query.recordcount EQ 0 OR childCurrent EQ childLast)
						QueryAddRow(query);

					/* Set the last children name */
					childLast = arguments.xmlData.xmlChildren[i].xmlName;

					/* Loop over the element names */
					for(n=1; n LTE ArrayLen(names); n=n+1)
					{
						colName = REReplace(names[n], "[^[:alpha:]]", "_", "ALL");
						colData = Trim(data[names[n]]);

						if(colData NEQ "")
						{
							// Create column
							if(ListFindNoCase(query.ColumnList, colName) EQ 0)
								QueryAddColumn(query, colName, ArrayNew(1));

							// Set data
							QuerySetCell(query, colName, colData, query.recordcount);
						}
					}

					/* Get recursive data */
					if(ArrayLen(arguments.xmlData.xmlChildren[i].xmlChildren) GT 0)
						XmlToQuery(xmlData=arguments.xmlData.xmlChildren[i], prevData=data);
				}
			}

			/* Return query */
			if(NOT IsDefined("arguments.xmlData"))
				return query;

		</cfscript>

	</cffunction>

	
</cfcomponent>