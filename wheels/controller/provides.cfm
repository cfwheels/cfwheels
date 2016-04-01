<!--- PUBLIC CONTROLLER INITIALIZATION FUNCTIONS --->

<cffunction name="provides" access="public" output="false" returntype="void">
	<cfargument name="formats" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		$combineArguments(args=arguments, combine="formats,format", required=true);
		arguments.formats = $listClean(arguments.formats);
		loc.possibleFormats = StructKeyList(get("formats"));
		loc.iEnd = ListLen(arguments.formats);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.formats, loc.i);
			if (get("showErrorInformation") && !ListFindNoCase(loc.possibleFormats, loc.item))
			{
				$throw(type="Wheels.InvalidFormat", message="An invalid format of `#loc.item#` has been specified. The possible values are #loc.possibleFormats#.");
			}
		}
		variables.$class.formats.default = ListAppend(variables.$class.formats.default, arguments.formats);
	</cfscript>
</cffunction>

<!--- PUBLIC CONTROLLER REQUEST FUNCTIONS --->

<cffunction name="onlyProvides" access="public" output="false" returntype="void">
	<cfargument name="formats" type="string" required="false" default="">
	<cfargument name="action" type="string" required="false" default="#variables.params.action#">
	<cfscript>
		var loc = {};
		$combineArguments(args=arguments, combine="formats,format", required=true);
		arguments.formats = $listClean(arguments.formats);
		loc.possibleFormats = StructKeyList(get("formats"));
		loc.iEnd = ListLen(arguments.formats);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.formats, loc.i);
			if (get("showErrorInformation") && !ListFindNoCase(loc.possibleFormats, loc.item))
			{
				$throw(type="Wheels.InvalidFormat", message="An invalid format of `#loc.item#` has been specified. The possible values are #loc.possibleFormats#.");
			}
		}
		variables.$class.formats.actions[arguments.action] = arguments.formats;
	</cfscript>
</cffunction>

<cffunction name="renderWith" access="public" returntype="any" output="false">
	<cfargument name="data" type="any" required="true">
	<cfargument name="controller" type="string" required="false" default="#variables.params.controller#">
	<cfargument name="action" type="string" required="false" default="#variables.params.action#">
	<cfargument name="template" type="string" required="false" default="">
	<cfargument name="layout" type="any" required="false">
	<cfargument name="cache" type="any" required="false" default="">
	<cfargument name="returnAs" type="string" required="false" default="">
	<cfargument name="hideDebugInformation" type="boolean" required="false" default="false">
	<cfargument name="status" type="any" required="false" default="200">
	<cfscript>
		var loc = {};
		$args(name="renderWith", args=arguments);
		loc.contentType = $requestContentType();
		loc.acceptableFormats = $acceptableFormats(action=arguments.action);

		// default to html if the content type found is not acceptable
		if (!ListFindNoCase(loc.acceptableFormats, loc.contentType))
		{
			loc.contentType = "html";
		}

		// call render page if we are just rendering html
		if (loc.contentType == "html")
		{
			StructDelete(arguments, "data");
			loc.rv = renderPage(argumentCollection=arguments);
		}
		else
		{
			loc.templateName = $generateRenderWithTemplatePath(argumentCollection=arguments, contentType=loc.contentType);
			loc.templatePathExists = $formatTemplatePathExists($name=loc.templateName);
			if (loc.templatePathExists)
			{
				loc.content = renderPage(argumentCollection=arguments, template=loc.templateName, returnAs="string", layout=false, hideDebugInformation=true);
			}

			// throw an error if we rendered a pdf template and we got here, the cfdocument call should have stopped processing
			if (loc.contentType == "pdf" && get("showErrorInformation") && loc.templatePathExists)
			{
				$throw(type="Wheels.PdfRenderingError", message="When rendering the a PDF file, don't specify the filename attribute. This will stream the PDF straight to the browser.");
			}

			// throw an error if we do not have a template to render the content type that we do not have defaults for
			if (!ListFindNoCase("json,xml", loc.contentType) && !StructKeyExists(loc, "content") && get("showErrorInformation"))
			{
				$throw(type="Wheels.RenderingError", message="To render the #loc.contentType# content type, create the template `#loc.templateName#.cfm` for the #arguments.controller# controller.");
			}

			// set our header based on our mime type
			loc.formats = get("formats");
			loc.value = loc.formats[loc.contentType] & "; charset=utf-8";
			$header(name="content-type", value=loc.value, charset="utf-8");

			// If custom statuscode passed in, then set appropriate header
			// status may be a numeric value such as 404, or a text value such as 'Forbidden';
			if(structKeyExists(arguments, "status")){
				loc.status=arguments.status;
				if(isNumeric(loc.status)){
					loc.statusCode=loc.status;
					loc.statusText=$returnStatusText(loc.status); 
				} else { 
					// Try for statuscode;
					loc.statusCode=$returnStatusCode(loc.status);
					loc.statusText=loc.status;
				}
				$header(statusCode=loc.statusCode, statusText=loc.statusText); 
			}

			// if we do not have the loc.content variable and we are not rendering html then try to create it
			if (!StructKeyExists(loc, "content"))
			{
				switch (loc.contentType)
				{
					case "json":
						loc.namedArgs = {};
						if (StructCount(arguments) > 8)
						{
							loc.namedArgs = $namedArguments(argumentCollection=arguments, $defined="data,controller,action,template,layout,cache,returnAs,hideDebugInformation");
						}
						for (loc.key in loc.namedArgs)
						{
							if (loc.namedArgs[loc.key] == "string")
							{
								if (IsArray(arguments.data))
								{
									loc.iEnd = ArrayLen(arguments.data);
									for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
									{
										// force to string by wrapping in non printable character (that we later remove again)
										arguments.data[loc.i][loc.key] = Chr(7) & arguments.data[loc.i][loc.key] & Chr(7);
									}
								}
							}
						}
						loc.content = SerializeJSON(arguments.data);
						if (Find(Chr(7), loc.content))
						{
							loc.content = Replace(loc.content, Chr(7), "", "all");
						}
						for (loc.key in loc.namedArgs)
						{
							if (loc.namedArgs[loc.key] == "integer")
							{
								// force to integer by removing the .0 part of the number
								loc.content = REReplaceNoCase(loc.content, '([{|,]"' & loc.key & '":[0-9]*)\.0([}|,"])', "\1\2", "all");
							}
						}
						break;
					case "xml":
						loc.content = $toXml(arguments.data);
						break;
				}
			}

			// if the developer passed in returnAs="string" then return the generated content to them
			if (arguments.returnAs == "string")
			{
				loc.rv = loc.content;
			}
			else
			{
				renderText(loc.content);
			}
		}
	</cfscript>
	<cfif StructKeyExists(loc, "rv")>
		<cfreturn loc.rv>
	</cfif>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$acceptableFormats" access="public" output="false" returntype="string">
	<cfargument name="action" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = variables.$class.formats.default;
		if (StructKeyExists(variables.$class.formats, arguments.action))
		{
			loc.rv = variables.$class.formats[arguments.action];
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$generateRenderWithTemplatePath" access="public" output="false" returntype="string">
	<cfargument name="controller" type="string" required="true">
	<cfargument name="action" type="string" required="true">
	<cfargument name="template" type="string" required="true">
	<cfargument name="contentType" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = "";
		if (!Len(arguments.template))
		{
			loc.rv = "/" & arguments.controller & "/" & arguments.action;
		}
		else
		{
			loc.rv = arguments.template;
		}
		if (Len(arguments.contentType))
		{
			loc.rv &= "." & arguments.contentType;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$formatTemplatePathExists" access="public" output="false" returntype="boolean">
	<cfargument name="$name" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.templatePath = $generateIncludeTemplatePath($type="page", $name=arguments.$name, $template=arguments.$name);
		loc.rv = false;
		if (!ListFindNoCase(variables.$class.formats.existingTemplates, arguments.$name) && !ListFindNoCase(variables.$class.formats.nonExistingTemplates, arguments.$name))
		{
			if (FileExists(ExpandPath(loc.templatePath)))
			{
				loc.rv = true;
			}
			if (get("cacheFileChecking"))
			{
				if (loc.rv)
				{
					variables.$class.formats.existingTemplates = ListAppend(variables.$class.formats.existingTemplates, arguments.$name);
				}
				else
				{
					variables.$class.formats.nonExistingTemplates = ListAppend(variables.$class.formats.nonExistingTemplates, arguments.$name);
				}
			}
		}
		if (!loc.rv && ListFindNoCase(variables.$class.formats.existingTemplates, arguments.$name))
		{
			loc.rv = true;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$requestContentType" access="public" output="false" returntype="string">
	<cfargument name="params" type="struct" required="false" default="#variables.params#">
	<cfargument name="httpAccept" type="string" required="false" default="#request.cgi.http_accept#">
	<cfscript>
		var loc = {};
		loc.rv = "html";
		if (StructKeyExists(arguments.params, "format"))
		{
			loc.rv = arguments.params.format;
		}
		else
		{
			loc.formats = get("formats");
			for (loc.item in loc.formats)
			{
				if (FindNoCase(loc.formats[loc.item], arguments.httpAccept))
				{
					loc.rv = loc.item;
					break;
				}
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>
<cffunction name="$returnStatusText" access="public" output="false" returntype="string">
	<cfargument name="status" type="numeric" required="false" default="OK">
	<cfscript>
		var loc={};
		loc.status      = arguments.status;
		loc.statusCodes = $getStatusCodes();
		loc.rv          =  "";		 
		if(structKeyExists(loc.statuscodes, loc.status)){
			loc.rv = loc.statuscodes[loc.status];
		} else {
			$throw(type="Wheels.RenderingError", message="An invalid http response code #loc.status# was passed in.");
		} 
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$returnStatusCode" access="public" output="false" returntype="string">
	<cfargument name="status" required="false" default="200" hint="Can be either a numeric value or text">
	<cfscript>
		var loc={};
		loc.status      = arguments.status;
		loc.statusCodes = $getStatusCodes();
		loc.rv          =  "";	 
		loc.lookup=StructFindValue(loc.statuscodes, loc.status);
		if(arrayLen(loc.lookup)){
      		loc.rv = loc.lookup[1]["key"];
      	} else {
			$throw(type="Wheels.RenderingError", message="An invalid http response text #loc.status# was passed in.");
		} 
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$getStatusCodes" access="public" output="false" returntype="struct">
	<cfscript>
	var loc={};
		loc.statuscodes={
			100 = 'Continue',
			101 = 'Switching Protocols',
			102 = 'Processing',
			200 = 'OK',
			201 = 'Created',
			202 = 'Accepted',
			203 = 'Non-Authoritative Information',
			204 = 'No Content',
			205 = 'Reset Content',
			206 = 'Partial Content',
			207 = 'Multi-Status',
			208 = 'Already Reported',
			226 = 'IM Used',
			300 = 'Multiple Choices',
			301 = 'Moved Permanently',
			302 = 'Found',
			303 = 'See Other',
			304 = 'Not Modified',
			305 = 'Use Proxy',
			306 = 'Reserved',
			307 = 'Temporary Redirect',
			308 = 'Permanent Redirect',
			400 = 'Bad Request',
			401 = 'Unauthorized',
			402 = 'Payment Required',
			403 = 'Forbidden',
			404 = 'Not Found',
			405 = 'Method Not Allowed',
			406 = 'Not Acceptable',
			407 = 'Proxy Authentication Required',
			408 = 'Request Timeout',
			409 = 'Conflict',
			410 = 'Gone',
			411 = 'Length Required',
			412 = 'Precondition Failed',
			413 = 'Request Entity Too Large',
			414 = 'Request-URI Too Long',
			415 = 'Unsupported Media Type',
			416 = 'Requested Range Not Satisfiable',
			417 = 'Expectation Failed',
			422 = 'Unprocessable Entity',
			423 = 'Locked',
			424 = 'Failed Dependency',
			425 = 'Reserved for WebDAV advanced collections expired proposal',
			426 = 'Upgrade Required',
			427 = 'Unassigned',
			428 = 'Precondition Required',
			429 = 'Too Many Requests',
			430 = 'Unassigned',
			431 = 'Request Header Fields Too Large',
			500 = 'Internal Server Error',
			501 = 'Not Implemented',
			502 = 'Bad Gateway',
			503 = 'Service Unavailable',
			504 = 'Gateway Timeout',
			505 = 'HTTP Version Not Supported',
			506 = 'Variant Also Negotiates (Experimental)',
			507 = 'Insufficient Storage',
			508 = 'Loop Detected',
			509 = 'Unassigned',
			510 = 'Not Extended',
			511 = 'Network Authentication Required'
		};
	</cfscript>
	<cfreturn loc.statuscodes>
</cffunction>