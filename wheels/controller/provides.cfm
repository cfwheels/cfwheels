<cffunction name="provides" access="public" output="false" returntype="void">
	<cfargument name="formats" required="false" default="" type="string" />
	<cfscript>
		var loc = {};
		$combineArguments(args=arguments, combine="formats,format", required=true);
		arguments.formats = $listClean(arguments.formats);
		loc.possibleFormats = StructKeyList(application.wheels.formats);
		
		for (loc.i = 1; loc.i lte ListLen(arguments.formats); loc.i++)
			if (application.wheels.showErrorInformation && !ListFindNoCase(loc.possibleFormats, ListGetAt(arguments.formats, loc.i)))
				$throw(type="Wheels.invalidFormat"
					, message="An invalid format of `#ListGetAt(arguments.formats, loc.i)#` has been specific. The possible values are #loc.possibleFormats#.");	
		
		variables.$class.formats.default = ListAppend(variables.$class.formats.default, $listClean(arguments.formats));
	</cfscript>
	<cfreturn />
</cffunction>
	
<cffunction name="onlyProvides" access="public" output="false" returntype="void">
	<cfargument name="formats" required="false" default="" type="string" />
	<cfargument name="action" type="string" default="#variables.params.action#" />
	<cfscript>
		var loc = {};
		$combineArguments(args=arguments, combine="formats,format", required=true);
		arguments.formats = $listClean(arguments.formats);
		loc.possibleFormats = StructKeyList(application.wheels.formats);
		
		for (loc.i = 1; loc.i lte ListLen(arguments.formats); loc.i++)
			if (application.wheels.showErrorInformation && !ListFindNoCase(loc.possibleFormats, ListGetAt(arguments.formats, loc.i)))
				$throw(type="Wheels.invalidFormat"
					, message="An invalid format of `#ListGetAt(arguments.formats, loc.i)#` has been specific. The possible values are #loc.possibleFormats#.");	
		
		variables.$class.formats.actions[arguments.action] = $listClean(arguments.formats);
	</cfscript>
	<cfreturn />
</cffunction>
	
<cffunction name="renderWith" access="public" output="false">
	<cfargument name="data" required="true" type="any" />
	<cfargument name="controller" type="string" required="false" default="#variables.params.controller#" hint="See documentation for @renderPage.">
	<cfargument name="action" type="string" required="false" default="#variables.params.action#" hint="See documentation for @renderPage.">
	<cfargument name="template" type="string" required="false" default="" hint="See documentation for @renderPage.">
	<cfargument name="layout" type="any" required="false" hint="See documentation for @renderPage.">
	<cfargument name="cache" type="any" required="false" default="" hint="See documentation for @renderPage.">
	<cfargument name="returnAs" type="string" required="false" default="" hint="See documentation for @renderPage.">
	<cfargument name="hideDebugInformation" type="boolean" required="false" default="false" hint="See documentation for @renderPage.">
	<cfargument name="$acceptableFormats" type="string" required="false" default="#variables.$class.formats.default#" />
	<cfscript>
		var loc = {};
		$args(name="renderWith", args=arguments);
		loc.templateFileExists = false;
		loc.contentType = $requestContentType();
		
		if (StructKeyExists(variables.$class.formats, arguments.action))
			arguments.$acceptableFormats = variables.$class.formats[arguments.action];
			
		if (not ListFindNoCase(arguments.$acceptableFormats, loc.contentType))
			loc.contentType = "";
			
		if (!Len(arguments.template))
			loc.template = "/" & arguments.controller & "/" & arguments.action;
		else
			loc.template = arguments.template;
			
		if (Len(loc.contentType))
			loc.template = loc.template & "." & loc.contentType;
		
		loc.templatePath = $generateIncludeTemplatePath($type="page", $name=loc.template, $template=loc.template);
		if (!ListFindNoCase(variables.$class.formats.existingTemplates, loc.template) && !ListFindNoCase(variables.$class.formats.nonExistingTemplates, loc.template))
		{
			if (FileExists(ExpandPath(loc.templatePath)))
				loc.templateFileExists = true;
			
			if (application.wheels.cacheFileChecking)
			{
				if (loc.templateFileExists)
					variables.$class.formats.existingTemplates = ListAppend(variables.$class.formats.existingTemplates, loc.template);
				else
					variables.$class.formats.nonExistingTemplates = ListAppend(variables.$class.formats.nonExistingTemplates, loc.template);
			}
		}	
		
		if (ListFindNoCase(variables.$class.formats.existingTemplates, loc.template) || loc.templateFileExists)
			loc.content = renderPage(argumentCollection=arguments, template=loc.template, returnAs="string");
			
		if (loc.contentType == "pdf" && application.wheels.showErrorInformation)
			$throw(type="Wheels.PdfRenderingError"
				, message="When rendering the a PDF file, don't specify the filename attribute. This will stream the PDF straight to the browser.");		
		
		switch (loc.contentType)
		{
			case "html":
			{ 
				StructDelete(arguments, "data", false); 
				renderPage(argumentCollection=arguments); 
				break; 
			}
			case "json":
			{ 
				$header(name="content-type", value="text/json" , charset="utf-8");
				if (StructKeyExists(loc, "content"))
					renderText(loc.content);
				else
					renderText(SerializeJSON(arguments.data));
				break; 
			}
			case "xml":
			{
				$header(name="content-type", value="text/xml" , charset="utf-8");
				if (StructKeyExists(loc, "content"))
					renderText(loc.content);
				else
					renderText($toXml(arguments.data)); 
				break; 
			}
		}
	</cfscript>
</cffunction>
	
<cffunction name="$requestContentType" access="public" output="false" returntype="string">
	<cfargument name="params" type="struct" required="false" default="#variables.params#" />
	<cfargument name="httpAccept" type="string" required="false" default="#request.cgi.http_accept#" />
	<cfscript>
		var loc = {};
		loc.format = "";
		
		// see if we have a format param
		if (StructKeyExists(arguments.params, "format"))
			return arguments.params.format;
		
		for (loc.item in application.wheels.formats)
			if (arguments.httpAccept == application.wheels.formats[loc.item])
				return loc.item;
	</cfscript>
	<cfreturn loc.format />
</cffunction>
