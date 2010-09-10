<cffunction name="provides" access="public" output="false" returntype="void" hint="Defines formats that the controller will respond with upon request. The format can be requested through a URL variable called `format`, by appending the format name to the end of a URL as an extension (when URL rewriting is enabled), or in the request header."
	examples='
		<!--- In your controller --->
		<cffunction name="init">
			<cfset provides("html,xml,json")>
		</cffunction>
	'
	categories="controller-initialization,provides" chapters="responding-with-multiple-formats" functions="onlyProvides,renderWith">
	<cfargument name="formats" required="false" default="" type="string" hint="Formats to instruct the controller to provide. Valid values are `html` (the default), `xml`, `json`, `csv`, `pdf`, and `xls`." />
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
	
<cffunction name="onlyProvides" access="public" output="false" returntype="void" hint="Use this in an individual controller action to define which formats the action will respond with. This can be used to define provides behavior in individual actions or to override a global setting set with @provides in the controller's `init()`."
	examples='
		<!--- In your controller --->
		<cffunction name="init">
			<cfset provides("html,xml,json")>
		</cffunction>
		
		<!--- This action will provide the formats defined in `init()` above --->
		<cffunction name="list">
			<cfset products = model("product").findAll()>
			<cfset renderWith(products)>
		</cffunction>
		
		<!--- This action will only provide the `html` type and will ignore what was defined in the call to `provides()` in the `init()` method above --->
		<cffunction name="new">
			<cfset onlyProvides("html")>
			<cfset model("product").new()>
		</cffunction>
	'
	categories="controller-request,provides" chapters="responding-with-multiple-formats" functions="provides,renderWith">
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
	
<cffunction name="renderWith" access="public" returntype="void" output="false" hint="Instructs the controller to render the data passed in to the format that is requested. If the format requested is `json` or `xml`, Wheels will transform the data into that format automatically. For other formats (or to override the automatic formatting), you can also create a view template in this format: `nameofaction.xml.cfm`, `nameofaction.json.cfm`, `nameofaction.pdf.cfm`, etc."
	examples='
		<!--- In your controller --->
		<cffunction name="init">
			<cfset provides("html,xml,json")>
		</cffunction>
		
		<!--- This action will provide the formats defined in `init()` above --->
		<cffunction name="list">
			<cfset products = model("product").findAll()>
			<cfset renderWith(products)>
		</cffunction>
		
		<!--- This action will only provide the `html` type and will ignore what was defined in the call to `provides()` in the `init()` method above --->
		<cffunction name="new">
			<cfset onlyProvides("html")>
			<cfset model("product").new()>
		</cffunction>
	'
	categories="controller-request,provides" chapters="responding-with-multiple-formats" functions="provides,onlyProvides">
	<cfargument name="data" required="true" type="any" hint="Data to format and render." />
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
			loc.contentType = "html";
			
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
		
		if ((ListFindNoCase(variables.$class.formats.existingTemplates, loc.template) || loc.templateFileExists) && loc.contentType != "html")
			loc.content = renderPage(argumentCollection=arguments, template=loc.template, returnAs="string", layout=false, hideDebugInformation=true);
			
		if (loc.contentType == "pdf" && application.wheels.showErrorInformation)
			$throw(type="Wheels.PdfRenderingError"
				, message="When rendering the a PDF file, don't specify the filename attribute. This will stream the PDF straight to the browser.");
		
		// throw an error if we do not have a template to render the content type that we do not have defaults for
		if (!ListFindNoCase("html,json,xml", loc.contentType) && !StructKeyExists(loc, "content") && application.wheels.showErrorInformation)
			$throw(type="Wheels.renderingError"
				, message="To render the #loc.contentType# content type, create the template `#loc.template#.cfm` for the #arguments.controller# controller.");			
				
		// set our header based on our mime type
		$header(name="content-type", value=application.wheels.formats[loc.contentType], charset="utf-8");
		
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
				if (StructKeyExists(loc, "content"))
					renderText(loc.content);
				else
					renderText(SerializeJSON(arguments.data));
				break; 
			}
			case "xml":
			{
				if (StructKeyExists(loc, "content"))
					renderText(loc.content);
				else
					renderText($toXml(arguments.data)); 
				break; 
			}
			default:
			{
				renderText(loc.content);
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
		loc.format = "html";
		
		// see if we have a format param
		if (StructKeyExists(arguments.params, "format"))
			return arguments.params.format;
		
		for (loc.item in application.wheels.formats)
			if (arguments.httpAccept == application.wheels.formats[loc.item])
				return loc.item;
	</cfscript>
	<cfreturn loc.format />
</cffunction>