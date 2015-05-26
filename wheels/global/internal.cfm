<cffunction name="$initializeRequestScope" returntype="void" access="public" output="false">
	<cfscript>
		if (!StructKeyExists(request, "wheels"))
		{
			request.wheels = {};
			request.wheels.params = {};
			request.wheels.cache = {};
			request.wheels.tickCountId = GetTickCount();

			// create a structure to track the transaction status for all adapters
			request.wheels.transactions = {};
		}
	</cfscript>
</cffunction>

<cffunction name="$toXml" returntype="xml" access="public" output="false">
	<cfargument name="data" type="any" required="true">
	<cfscript>
		// only instantiate the toXml object once per request
		if (!StructKeyExists(request.wheels, "toXml"))
		{
			request.wheels.toXml = $createObjectFromRoot(path="#application.wheels.wheelsComponentPath#.vendor.toXml", fileName="toXML", method="init");
		}
	</cfscript>
	<cfreturn request.wheels.toXml.toXml(arguments.data)>
</cffunction>

<cffunction name="$convertToString" returntype="string" access="public" output="false">
	<cfargument name="value" type="Any" required="true">
	<cfargument name="type" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		if (!Len(arguments.type))
		{
			if (IsArray(arguments.value))
			{
				arguments.type = "array";
			}
			else if (IsStruct(arguments.value))
			{
				arguments.type = "struct";
			}
			else if (IsBinary(arguments.value))
			{
				arguments.type = "binary";
			}
			else if (IsNumeric(arguments.value))
			{
				arguments.type = "integer";
			}
			else if (IsDate(arguments.value))
			{
				arguments.type = "datetime";
			}
		}
		switch (arguments.type)
		{
			case "array":
				arguments.value = ArrayToList(arguments.value);
				break;
			case "struct":
				loc.str = "";
				loc.keyList = ListSort(StructKeyList(arguments.value), "textnocase", "asc");
				loc.iEnd = ListLen(loc.keyList);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.key = ListGetAt(loc.keyList, loc.i);
					loc.str = ListAppend(loc.str, loc.key & "=" & arguments.value[loc.key]);
				}
				arguments.value = loc.str;
				break;
			case "binary":
				arguments.value = ToString(arguments.value);
				break;
			case "float": case "integer":
				if (!Len(arguments.value))
				{
					return "";
				}
				if (arguments.value == "true")
				{
					return 1;
				}
				arguments.value = Val(arguments.value);
				break;
			case "boolean":
				if (Len(arguments.value))
				{
					arguments.value = (arguments.value IS true);
				}
				break;
			case "datetime":
				// createdatetime will throw an error
				if (IsDate(arguments.value))
				{
					arguments.value = CreateDateTime(Year(arguments.value), Month(arguments.value), Day(arguments.value), Hour(arguments.value), Minute(arguments.value), Second(arguments.value));
				}
				break;
		}
	</cfscript>
	<cfreturn arguments.value>
</cffunction>

<cffunction name="$listClean" returntype="any" access="public" output="false" hint="removes whitespace between list elements. optional argument to return the list as an array.">
	<cfargument name="list" type="string" required="true">
	<cfargument name="delim" type="string" required="false" default=",">
	<cfargument name="returnAs" type="string" required="false" default="string">
	<cfscript>
		var loc = {};
		loc.rv = ListToArray(arguments.list, arguments.delim);
		loc.iEnd = ArrayLen(loc.rv);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.rv[loc.i] = Trim(loc.rv[loc.i]);
		}
		if (arguments.returnAs != "array")
		{
			loc.rv = ArrayToList(loc.rv, arguments.delim);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$hashedKey" returntype="string" access="public" output="false" hint="Creates a unique string based on any arguments passed in (used as a key for caching mostly).">
	<cfscript>
		var loc = {};
		loc.rv = "";

		// make all cache keys domain specific (do not use request scope below since it may not always be initialized)
		StructInsert(arguments, ListLen(StructKeyList(arguments)) + 1, cgi.http_host, true);

		// we need to make sure we are looping through the passed in arguments in the same order everytime
		loc.values = [];
		loc.keyList = ListSort(StructKeyList(arguments), "textnocase", "asc");
		loc.iEnd = ListLen(loc.keyList);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			ArrayAppend(loc.values, arguments[ListGetAt(loc.keyList, loc.i)]);
		}

		if (!ArrayIsEmpty(loc.values))
		{
			// this might fail if a query contains binary data so in those rare cases we fall back on using cfwddx (which is a little bit slower which is why we don't use it all the time)
			try
			{
				loc.rv = SerializeJSON(loc.values);

				// remove the characters that indicate array or struct so that we can sort it as a list below
				loc.rv = ReplaceList(loc.rv, "{,},[,]", ",,,");
				loc.rv = ListSort(loc.rv, "text");
			}
			catch (any e)
			{
				loc.rv = $wddx(input=loc.values);
			}
		}
		loc.rv = Hash(loc.rv);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$timeSpanForCache" returntype="any" access="public" output="false">
	<cfargument name="cache" type="any" required="true">
	<cfargument name="defaultCacheTime" type="numeric" required="false" default="#application.wheels.defaultCacheTime#">
	<cfargument name="cacheDatePart" type="string" required="false" default="#application.wheels.cacheDatePart#">
	<cfscript>
		var loc = {};
		loc.cache = arguments.defaultCacheTime;
		if (IsNumeric(arguments.cache))
		{
			loc.cache = arguments.cache;
		}
		loc.list = "0,0,0,0";
		loc.dateParts = "d,h,n,s";
		loc.iEnd = ListLen(loc.dateParts);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			if (arguments.cacheDatePart == ListGetAt(loc.dateParts, loc.i))
			{
				loc.list = ListSetAt(loc.list, loc.i, loc.cache);
			}
		}
		loc.rv = CreateTimeSpan(ListGetAt(loc.list, 1), ListGetAt(loc.list, 2), ListGetAt(loc.list, 3), ListGetAt(loc.list, 4));
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$combineArguments" returntype="void" access="public" output="false">
	<cfargument name="args" type="struct" required="true">
	<cfargument name="combine" type="string" required="true">
	<cfargument name="required" type="boolean" required="false" default="false">
	<cfargument name="extendedInfo" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.first = ListGetAt(arguments.combine, 1);
		loc.second = ListGetAt(arguments.combine, 2);
		if (StructKeyExists(arguments.args, loc.second))
		{
			arguments.args[loc.first] = arguments.args[loc.second];
			StructDelete(arguments.args, loc.second);
		}
		if (arguments.required && application.wheels.showErrorInformation)
		{
			if (!StructKeyExists(arguments.args, loc.first) || !Len(arguments.args[loc.first]))
			{
				$throw(type="Wheels.IncorrectArguments", message="The `#loc.second#` or `#loc.first#` argument is required but was not passed in.", extendedInfo="#arguments.extendedInfo#");
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$structKeysExist" returntype="boolean" access="public" output="false" hint="Check to see if all keys in the list exist for the structure and have length.">
	<cfargument name="struct" type="struct" required="true">
	<cfargument name="keys" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.rv = true;
		loc.iEnd = ListLen(arguments.keys);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			if (!StructKeyExists(arguments.struct, ListGetAt(arguments.keys, loc.i)) || (IsSimpleValue(arguments.struct[ListGetAt(arguments.keys, loc.i)]) && !Len(arguments.struct[ListGetAt(arguments.keys, loc.i)])))
			{
				loc.rv = false;
				break;
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$cgiScope" returntype="struct" access="public" output="false" hint="This copies all the variables CFWheels needs from the CGI scope to the request scope.">
	<cfargument name="keys" type="string" required="false" default="request_method,http_x_requested_with,http_referer,server_name,path_info,script_name,query_string,remote_addr,server_port,server_port_secure,server_protocol,http_host,http_accept,content_type,http_x_rewrite_url,http_x_original_url,request_uri,redirect_url">
	<cfargument name="scope" type="struct" required="false" default="#cgi#">
	<cfscript>
		var loc = {};
		loc.rv = {};
		loc.iEnd = ListLen(arguments.keys);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.keys, loc.i);
			loc.rv[loc.item] = "";
			if (StructKeyExists(arguments.scope, loc.item))
			{
				loc.rv[loc.item] = arguments.scope[loc.item];
			}
		}

		// fix path_info if it contains any characters that are not ascii (see issue 138)
		if (StructKeyExists(arguments.scope, "unencoded_url") && Len(arguments.scope.unencoded_url))
		{
			loc.requestUrl = URLDecode(arguments.scope.unencoded_url);
		}
		else if (IsSimpleValue(getPageContext().getRequest().getRequestURL()))
		{
			// remove protocol, domain, port etc from the url
			loc.requestUrl = "/" & ListDeleteAt(ListDeleteAt(URLDecode(getPageContext().getRequest().getRequestURL()), 1, "/"), 1, "/");
		}
		if (StructKeyExists(loc, "requestUrl") && REFind("[^\0-\x80]", loc.requestUrl))
		{
			// strip out the script_name and query_string leaving us with only the part of the string that should go in path_info
			loc.rv.path_info = Replace(Replace(loc.requestUrl, arguments.scope.script_name, ""), "?" & URLDecode(arguments.scope.query_string), "");
		}

		// fixes IIS issue that returns a blank cgi.path_info
		if (!Len(loc.rv.path_info) && Right(loc.rv.script_name, 12) == "/rewrite.cfm")
		{
			if (Len(loc.rv.http_x_rewrite_url))
			{
				// IIS6 1/ IIRF (Ionics Isapi Rewrite Filter)
				loc.rv.path_info = ListFirst(loc.rv.http_x_rewrite_url, "?");
			}
			else if (Len(loc.rv.http_x_original_url))
			{
				// IIS7 rewrite default
				loc.rv.path_info = ListFirst(loc.rv.http_x_original_url, "?");
			}
			else if (Len(loc.rv.request_uri))
			{
				// Apache default
				loc.rv.path_info = ListFirst(loc.rv.request_uri, "?");
			}
			else if (Len(loc.rv.redirect_url))
			{
				// Apache fallback
				loc.rv.path_info = ListFirst(loc.rv.redirect_url, "?");
			}

			// finally lets remove the index.cfm because some of the custom cgi variables don't bring it back
			// like this it means at the root we are working with / instead of /index.cfm
			if (Len(loc.rv.path_info) >= 10 && Right(loc.rv.path_info, 10) == "/index.cfm")
			{
				// this will remove the index.cfm and the trailing slash
				loc.rv.path_info = Replace(loc.rv.path_info, "/index.cfm", "");
				if (!Len(loc.rv.path_info))
				{
					// add back the forward slash if path_info was "/index.cfm"
					loc.rv.path_info = "/";
				}
			}
		}

		// some web servers incorrectly place rewrite.cfm in the path_info but since that should never be there we can safely remove it
		if (Find("rewrite.cfm/", loc.rv.path_info))
		{
			Replace(loc.rv.path_info, "rewrite.cfm/", "");
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$namedArguments" returntype="struct" access="public" output="false" hint="Creates a struct of the named arguments passed in to a function (i.e. the ones not explicitly defined in the arguments list).">
	<cfargument name="$defined" type="string" required="true" hint="List of already defined arguments that should not be added.">
	<cfscript>
		var loc = {};
		loc.rv = {};
		for (loc.key in arguments)
		{
			if (!ListFindNoCase(arguments.$defined, loc.key) && Left(loc.key, 1) != "$")
			{
				loc.rv[loc.key] = arguments[loc.key];
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$dollarify" returntype="struct" access="public" output="false">
	<cfargument name="input" type="struct" required="true">
	<cfargument name="on" type="string" required="true">
	<cfscript>
		var loc = {};
		for (loc.key in arguments.input)
		{
			if (ListFindNoCase(arguments.on, loc.key))
			{
				arguments.input["$" & loc.key] = arguments.input[loc.key];
				StructDelete(arguments.input, loc.key);
			}
		}
	</cfscript>
	<cfreturn arguments.input>
</cffunction>

<cffunction name="$abortInvalidRequest" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.applicationPath = Replace(GetCurrentTemplatePath(), "\", "/", "all");
		loc.callingPath = Replace(GetBaseTemplatePath(), "\", "/", "all");
		if (ListLen(loc.callingPath, "/") > ListLen(loc.applicationPath, "/") || GetFileFromPath(loc.callingPath) == "root.cfm")
		{
			if (StructKeyExists(application, "wheels"))
			{
				if (StructKeyExists(application.wheels, "showErrorInformation") && !application.wheels.showErrorInformation)
				{
					$header(statusCode=404, statustext="Not Found");
				}
				if (StructKeyExists(application.wheels, "eventPath"))
				{
					$includeAndOutput(template="#application.wheels.eventPath#/onmissingtemplate.cfm");
				}
			}
			$abort();
		}
	</cfscript>
</cffunction>

<cffunction name="$URLEncode" returntype="string" access="public" output="false">
	<cfargument name="param" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.rv = URLEncodedFormat(arguments.param);

		// these characters are safe so set them back to their original values
		loc.rv = ReplaceList(loc.rv, "%24,%2D,%5F,%2E,%2B,%21,%2A,%27,%28,%29", "$,-,_,.,+,!,*,',(,)");
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$routeVariables" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.route = $findRoute(argumentCollection=arguments);
		loc.rv = loc.route.variables;
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$findRoute" returntype="struct" access="public" output="false">
	<cfscript>
		var loc = {};

		// throw an error if a route with this name has not been set by developer in the config/routes.cfm file
		if (application.wheels.showErrorInformation && !StructKeyExists(application.wheels.namedRoutePositions, arguments.route))
		{
			$throw(type="Wheels.RouteNotFound", message="Could not find the `#arguments.route#` route.", extendedInfo="Create a new route in `config/routes.cfm` with the name `#arguments.route#`.");
		}

		loc.routePos = application.wheels.namedRoutePositions[arguments.route];
		if (Find(",", loc.routePos))
		{
			// there are several routes with this name so we need to figure out which one to use by checking the passed in arguments
			loc.iEnd = ListLen(loc.routePos);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.rv = application.wheels.routes[ListGetAt(loc.routePos, loc.i)];
				loc.foundRoute = true;
				loc.jEnd = ListLen(loc.rv.variables);
				for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
				{
					loc.variable = ListGetAt(loc.rv.variables, loc.j);
					if (!StructKeyExists(arguments, loc.variable) || !Len(arguments[loc.variable]))
					{
						loc.foundRoute = false;
					}
				}
				if (loc.foundRoute)
				{
					break;
				}
			}
		}
		else
		{
			loc.rv = application.wheels.routes[loc.routePos];
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$cachedModelClassExists" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = false;
		if (StructKeyExists(application.wheels.models, arguments.name))
		{
			loc.rv = application.wheels.models[arguments.name];
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$constructParams" returntype="string" access="public" output="false">
	<cfargument name="params" type="string" required="true">
	<cfargument name="$URLRewriting" type="string" required="false" default="#application.wheels.URLRewriting#">
	<cfscript>
		var loc = {};

		// change to using ampersand so we can use it as a list delim below and so we don't "double replace" it
		arguments.params = Replace(arguments.params, "&amp;", "&", "all");

		// when rewriting is off we will already have "?controller=" etc in the url so we have to continue with an ampersand
		if (arguments.$URLRewriting == "Off")
		{
			loc.delim = "&";
		}
		else
		{
			loc.delim = "?";
		}

		loc.rv = "";
		loc.iEnd = ListLen(arguments.params, "&");
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.temp = listToArray(ListGetAt(arguments.params, loc.i, "&"), "=");
			loc.rv &= loc.delim & loc.temp[1] & "=";
			loc.delim = "&";
			if (ArrayLen(loc.temp) == 2)
			{
				loc.param = $URLEncode(loc.temp[2]);

				// correct double encoding of & and = since we parse the param string using & and = the developer has to url encode them on the input
				loc.param = Replace(loc.param, "%2526", "%26", "all");
				loc.param = Replace(loc.param, "%253D", "%3D", "all");

				if (application.wheels.obfuscateUrls && !ListFindNoCase("cfid,cftoken", loc.temp[1]))
				{
					// wrap in double quotes because in railo we have to pass it in as a string otherwise leading zeros are stripped
					loc.param = obfuscateParam("#loc.param#");
				}
				loc.rv &= loc.param;
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$args" returntype="void" access="public" output="false">
	<cfargument name="args" type="struct" required="true">
	<cfargument name="name" type="string" required="true">
	<cfargument name="reserved" type="string" required="false" default="">
	<cfargument name="combine" type="string" required="false" default="">
	<cfargument name="required" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		if (Len(arguments.combine))
		{
			loc.iEnd = ListLen(arguments.combine);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.item = ListGetAt(arguments.combine, loc.i);
				loc.first = ListGetAt(loc.item, 1, "/");
				loc.second = ListGetAt(loc.item, 2, "/");
				loc.required = false;
				if (ListLen(loc.item, "/") > 2 || ListFindNoCase(loc.first, arguments.required))
				{
					loc.required = true;
				}
				$combineArguments(args=arguments.args, combine="#loc.first#,#loc.second#", required=loc.required);
			}
		}
		if (application.wheels.showErrorInformation)
		{
			if (ListLen(arguments.reserved))
			{
				loc.iEnd = ListLen(arguments.reserved);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.item = ListGetAt(arguments.reserved, loc.i);
					if (StructKeyExists(arguments.args, loc.item))
					{
						$throw(type="Wheels.IncorrectArguments", message="The `#loc.item#` argument cannot be passed in since it will be set automatically by Wheels.");
					}
				}
			}
		}
		if (StructKeyExists(application.wheels.functions, arguments.name))
		{
			StructAppend(arguments.args, application.wheels.functions[arguments.name], false);
		}

		// make sure that the arguments marked as required exist
		if (Len(arguments.required))
		{
			loc.iEnd = ListLen(arguments.required);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.arg = ListGetAt(arguments.required, loc.i);
				if (!StructKeyExists(arguments.args, loc.arg))
				{
					$throw(type="Wheels.IncorrectArguments", message="The `#loc.arg#` argument is required but not passed in.");
				}
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$createObjectFromRoot" returntype="any" access="public" output="false">
	<cfargument name="path" type="string" required="true">
	<cfargument name="fileName" type="string" required="true">
	<cfargument name="method" type="string" required="true">
	<cfscript>
		var rv = "";
		var loc = {};
		loc.returnVariable = "rv";
		loc.method = arguments.method;
		loc.component = ListChangeDelims(arguments.path, ".", "/") & "." & ListChangeDelims(arguments.fileName, ".", "/");
		loc.argumentCollection = arguments;
	</cfscript>
	<cfinclude template="../../root.cfm">
	<cfreturn rv>
</cffunction>

<cffunction name="$debugPoint" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		var loc = {};
		if (!StructKeyExists(request.wheels, "execution"))
		{
			request.wheels.execution = {};
		}
		loc.iEnd = ListLen(arguments.name);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.name, loc.i);
			if (StructKeyExists(request.wheels.execution, loc.item))
			{
				request.wheels.execution[loc.item] = GetTickCount() - request.wheels.execution[loc.item];
			}
			else
			{
				request.wheels.execution[loc.item] = GetTickCount();
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$cachedControllerClassExists" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = false;
		if (StructKeyExists(application.wheels.controllers, arguments.name))
		{
			loc.rv = application.wheels.controllers[arguments.name];
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$fileExistsNoCase" returntype="any" access="public" output="false">
	<cfargument name="absolutePath" type="string" required="true">
	<cfscript>
		var loc = {};

		// return false by default when the file does not exist in the directory
		loc.rv = false;

		// break up the full path string in the path name only and the file name only
		loc.path = GetDirectoryFromPath(arguments.absolutePath);
		loc.file = Replace(arguments.absolutePath, loc.path, "");

		// get all existing files in the directory and place them in a list
		loc.dirInfo = $directory(directory=loc.path);
		loc.fileList = ValueList(loc.dirInfo.name);

		// loop through the file list and return the file name if exists regardless of case (the == operator is case insensitive)
		loc.iEnd = ListLen(loc.fileList);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.foundFile = ListGetAt(loc.fileList, loc.i);
			if (loc.foundFile == loc.file)
			{
				loc.rv = loc.foundFile;
				break;
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$objectFileName" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="objectPath" type="string" required="true">
	<cfargument name="type" type="string" required="true" hint="Can be either `controller` or `model`.">
	<cfscript>
		var loc = {};

		// by default we return Model or Controller so that the base component gets loaded
		loc.rv = capitalize(arguments.type);

		// we are going to store the full controller / model path in the existing / non-existing lists so we can have controllers / models in multiple places
		loc.fullObjectPath = arguments.objectPath & "/" & arguments.name;

		if (!ListFindNoCase(application.wheels.existingObjectFiles, loc.fullObjectPath) && !ListFindNoCase(application.wheels.nonExistingObjectFiles, loc.fullObjectPath))
		{
			// we have not yet checked if this file exists or not so let's do that here (the function below will return the file name with the correct case if it exists, false if not)
			loc.file = $fileExistsNoCase(ExpandPath(loc.fullObjectPath & ".cfc"));
			if (IsBoolean(loc.file) && !loc.file)
			{
				// no file exists, let's store that if caching is on so we don't have to check it again
				if (application.wheels.cacheFileChecking)
				{
					application.wheels.nonExistingObjectFiles = ListAppend(application.wheels.nonExistingObjectFiles, loc.fullObjectPath);
				}
			}
			else
			{
				// the file exists, let's store the proper case of the file if caching is turned on
				loc.file = SpanExcluding(loc.file, ".");
				loc.fullObjectPath = ListSetAt(loc.fullObjectPath, ListLen(loc.fullObjectPath, "/"), loc.file, "/");
				if (application.wheels.cacheFileChecking)
				{
					application.wheels.existingObjectFiles = ListAppend(application.wheels.existingObjectFiles, loc.fullObjectPath);
				}
				loc.rv = loc.file;
			}
		}
		else
		{
			// if the file exists we return the file name in its proper case
			loc.pos = ListFindNoCase(application.wheels.existingObjectFiles, loc.fullObjectPath);
			if (loc.pos)
			{
				loc.rv = ListLast(ListGetAt(application.wheels.existingObjectFiles, loc.pos), "/");
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$createControllerClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="controllerPaths" type="string" required="false" default="#application.wheels.controllerPath#">
	<cfargument name="type" type="string" required="false" default="controller">
	<cfscript>
		var loc = {};

		// let's allow for multiple controller paths so that plugins can contain controllers
		// the last path is the one we will instantiate the base controller on if the controller is not found on any of the paths
		loc.iEnd = ListLen(arguments.controllerPaths);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.controllerPath = ListGetAt(arguments.controllerPaths, loc.i);
			loc.fileName = $objectFileName(name=arguments.name, objectPath=loc.controllerPath, type=arguments.type);
			if (loc.fileName != "Controller" || loc.i == ListLen(arguments.controllerPaths))
			{
				application.wheels.controllers[arguments.name] = $createObjectFromRoot(path=loc.controllerPath, fileName=loc.fileName, method="$initControllerClass", name=arguments.name);
				loc.rv = application.wheels.controllers[arguments.name];
				break;
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$addToCache" returntype="void" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfargument name="value" type="any" required="true">
	<cfargument name="time" type="numeric" required="false" default="#application.wheels.defaultCacheTime#">
	<cfargument name="category" type="string" required="false" default="main">
	<cfscript>
		var loc = {};
		if (application.wheels.cacheCullPercentage > 0 && application.wheels.cacheLastCulledAt < DateAdd("n", -application.wheels.cacheCullInterval, Now()) && $cacheCount() >= application.wheels.maximumItemsToCache)
		{
			// cache is full so flush out expired items from this cache to make more room if possible
			loc.deletedItems = 0;
			loc.cacheCount = $cacheCount();
			for (loc.key in application.wheels.cache[arguments.category])
			{
				if (Now() > application.wheels.cache[arguments.category][loc.key].expiresAt)
				{
					$removeFromCache(key=loc.key, category=arguments.category);
					if (application.wheels.cacheCullPercentage < 100)
					{
						loc.deletedItems++;
						loc.percentageDeleted = (loc.deletedItems / loc.cacheCount) * 100;
						if (loc.percentageDeleted >= application.wheels.cacheCullPercentage)
						{
							break;
						}
					}
				}
			}
			application.wheels.cacheLastCulledAt = Now();
		}
		if ($cacheCount() < application.wheels.maximumItemsToCache)
		{
			loc.cacheItem = {};
			loc.cacheItem.expiresAt = DateAdd(application.wheels.cacheDatePart, arguments.time, Now());
			if (IsSimpleValue(arguments.value))
			{
				loc.cacheItem.value = arguments.value;
			}
			else
			{
				loc.cacheItem.value = Duplicate(arguments.value);
			}
			application.wheels.cache[arguments.category][arguments.key] = loc.cacheItem;
		}
	</cfscript>
</cffunction>

<cffunction name="$getFromCache" returntype="any" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfargument name="category" type="string" required="false" default="main">
	<cfscript>
		var loc = {};
		loc.rv = false;
		try
		{
			if (StructKeyExists(application.wheels.cache[arguments.category], arguments.key))
			{
				if (Now() > application.wheels.cache[arguments.category][arguments.key].expiresAt)
				{
					$removeFromCache(key=arguments.key, category=arguments.category);
				}
				else
				{
					if (IsSimpleValue(application.wheels.cache[arguments.category][arguments.key].value))
					{
						loc.rv = application.wheels.cache[arguments.category][arguments.key].value;
					}
					else
					{
						loc.rv = Duplicate(application.wheels.cache[arguments.category][arguments.key].value);
					}
				}
			}
		}
		catch (any e) {}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$removeFromCache" returntype="void" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfargument name="category" type="string" required="false" default="main">
	<cfscript>
		StructDelete(application.wheels.cache[arguments.category], arguments.key);
	</cfscript>
</cffunction>

<cffunction name="$cacheCount" returntype="numeric" access="public" output="false">
	<cfargument name="category" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		if (Len(arguments.category))
		{
			loc.rv = StructCount(application.wheels.cache[arguments.category]);
		}
		else
		{
			loc.rv = 0;
			for (loc.key in application.wheels.cache)
			{
				loc.rv += StructCount(application.wheels.cache[loc.key]);
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$clearCache" returntype="void" access="public" output="false">
	<cfargument name="category" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		if (Len(arguments.category))
		{
			StructClear(application.wheels.cache[arguments.category]);
		}
		else
		{
			StructClear(application.wheels.cache);
		}
	</cfscript>
</cffunction>

<cffunction name="$createModelClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="modelPaths" type="string" required="false" default="#application.wheels.modelPath#">
	<cfargument name="type" type="string" required="false" default="model">
	<cfscript>
		var loc = {};

		// let's allow for multiple model paths so that plugins can contain models
		// the last path is the one we will instantiate the base model on if the model is not found on any of the paths
		loc.iEnd = ListLen(arguments.modelPaths);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.modelPath = ListGetAt(arguments.modelPaths, loc.i);
			loc.fileName = $objectFileName(name=arguments.name, objectPath=loc.modelPath, type=arguments.type);
			if (loc.fileName != arguments.type || loc.i == ListLen(arguments.modelPaths))
			{
				application.wheels.models[arguments.name] = $createObjectFromRoot(path=loc.modelPath, fileName=loc.fileName, method="$initModelClass", name=arguments.name);
				loc.rv = application.wheels.models[arguments.name];
				break;
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$loadRoutes" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.appKey = $appKey();

		// clear out the route info
		ArrayClear(application[loc.appKey].routes);
		StructClear(application[loc.appKey].namedRoutePositions);

		// load developer routes first
		$include(template="config/routes.cfm");

		// add the wheels default routes at the end if requested
		if (application[loc.appKey].loadDefaultRoutes)
		{
			addDefaultRoutes();
		}

		// set lookup info for the named routes
		$setNamedRoutePositions();
	</cfscript>
</cffunction>

<cffunction name="$setNamedRoutePositions" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.appKey = $appKey();
		loc.iEnd = ArrayLen(application[loc.appKey].routes);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.route = application[loc.appKey].routes[loc.i];
			if (StructKeyExists(loc.route, "name") && len(loc.route.name))
			{
				if (!StructKeyExists(application[loc.appKey].namedRoutePositions, loc.route.name))
				{
					application[loc.appKey].namedRoutePositions[loc.route.name] = "";
				}
				application[loc.appKey].namedRoutePositions[loc.route.name] = ListAppend(application[loc.appKey].namedRoutePositions[loc.route.name], loc.i);
			}
		}
		</cfscript>
</cffunction>

<cffunction name="$clearModelInitializationCache">
	<cfscript>
		StructClear(application.wheels.models);
	</cfscript>
</cffunction>

<cffunction name="$clearControllerInitializationCache">
	<cfscript>
		StructClear(application.wheels.controllers);
	</cfscript>
</cffunction>

<cffunction name="$checkMinimumVersion" access="private" returntype="string" output="false">
	<cfargument name="engine" type="string" required="true">
	<cfargument name="version" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = "";
		loc.version = Replace(arguments.version, ".", ",", "all");
		loc.major = ListGetAt(loc.version, 1);
		loc.minor = 0;
		loc.patch = 0;
		if (ListLen(loc.version) > 1)
		{
			loc.minor = ListGetAt(loc.version, 2);
		}
		if (ListLen(loc.version) > 2)
		{
			loc.patch = ListGetAt(loc.version, 3);
		}
		if (arguments.engine == "Railo")
		{
			loc.minimumMajor = "3";
			loc.minimumMinor = "1";
			loc.minimumPatch = "2";
		}
		else if (arguments.engine == "Lucee")
		{
			loc.minimumMajor = "4";
			loc.minimumMinor = "5";
			loc.minimumPatch = "0";
		}
		else if (arguments.engine == "Adobe ColdFusion")
		{
			loc.minimumMajor = "8";
			loc.minimumMinor = "0";
			loc.minimumPatch = "1";
			loc.10 = {minimumMinor=0, minimumPatch=4};
		}
		if (loc.major < loc.minimumMajor || (loc.major == loc.minimumMajor && loc.minor < loc.minimumMinor) || (loc.major == loc.minimumMajor && loc.minor == loc.minimumMinor && loc.patch < loc.minimumPatch))
		{
			loc.rv = loc.minimumMajor & "." & loc.minimumMinor & "." & loc.minimumPatch;
		}
		if (StructKeyExists(loc, loc.major))
		{
			// special requirements for having a specific minor or patch version within a major release exists
			if (loc.minor < loc[loc.major].minimumMinor || (loc.minor == loc[loc.major].minimumMinor && loc.patch < loc[loc.major].minimumPatch))
			{
				loc.rv = loc.major & "." & loc[loc.major].minimumMinor & "." & loc[loc.major].minimumPatch;
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$loadPlugins" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.appKey = $appKey();
		loc.pluginPath = application[loc.appKey].webPath & application[loc.appKey].pluginPath;
		application[loc.appKey].PluginObj = $createObjectFromRoot(path="wheels", fileName="Plugins", method="init", pluginPath=loc.pluginPath, deletePluginDirectories=application[loc.appKey].deletePluginDirectories, overwritePlugins=application[loc.appKey].overwritePlugins, loadIncompatiblePlugins=application[loc.appKey].loadIncompatiblePlugins, wheelsEnvironment=application[loc.appKey].environment, wheelsVersion=application[loc.appKey].version);
		application[loc.appKey].plugins = application[loc.appKey].PluginObj.getPlugins();
		application[loc.appKey].incompatiblePlugins = application[loc.appKey].PluginObj.getIncompatiblePlugins();
		application[loc.appKey].dependantPlugins = application[loc.appKey].PluginObj.getDependantPlugins();
		application[loc.appKey].mixins = application[loc.appKey].PluginObj.getMixins();
	</cfscript>
</cffunction>

<cffunction name="$appKey" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.rv = "wheels";
		if (StructKeyExists(application, "$wheels"))
		{
			loc.rv = "$wheels";
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>