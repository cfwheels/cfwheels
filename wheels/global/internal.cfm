<cffunction name="$htmlFormat" returntype="string" access="public" output="false">
	<cfargument name="string" type="string" required="true" />
	<cfscript>
		var loc = {};
		if (!StructKeyExists(application.wheels.vendor, "stringEscapeUtils"))
		{
			loc.filePaths = [];
			loc.filePaths[1] = ExpandPath("wheels/vendor/commons-lang/commons-lang-2.5.jar");
			loc.javaLoader = CreateObject("component", "#application.wheels.wheelsComponentPath#.vendor.javaloader.JavaLoader").init(loc.filePaths);
			application.wheels.vendor.stringEscapeUtils = loc.javaLoader.create("org.apache.commons.lang.StringEscapeUtils");
		}
	</cfscript>
	<cfreturn application.wheels.vendor.stringEscapeUtils.escapeHtml(ToString(arguments.string)) />
</cffunction>

<cffunction name="$initializeRequestScope" returntype="void" access="public" output="false">
	<cfscript>
		if (!StructKeyExists(request, "wheels"))
		{
			request.wheels = {};
			request.wheels.vendor = {};
			request.wheels.routes = {};
			request.wheels.params = {};
			request.wheels.cache = {};
			
			// create a structure to track the transaction status for all adapters
			request.wheels.transactions = {};
	
			// store cache info for output in debug area
			request.wheels.cacheCounts = {};
			request.wheels.cacheCounts.hits = 0;
			request.wheels.cacheCounts.misses = 0;
			request.wheels.cacheCounts.culls = 0;
		}
	</cfscript>
</cffunction>

<cffunction name="$toXml" returntype="xml" access="public" output="false">
	<cfargument name="data" type="any" required="true">
	<cfscript>
		// only instantiate the toXml object once per request
		if (!StructKeyExists(request.wheels.vendor, "toXml"))
			request.wheels.vendor.toXml = $createObjectFromRoot(path="#application.wheels.wheelsComponentPath#.vendor.toXml", fileName="toXML", method="init");
	</cfscript>
	<cfreturn request.wheels.vendor.toXml.toXml(arguments.data) />
</cffunction>

<cffunction name="$convertToString" returntype="string" access="public" output="false">
	<cfargument name="value" type="Any" required="true">
	<cfargument name="type" type="string" required="false" default="">
	<cfargument name="delim" type="string" required="false" default=",">
	<cfscript>
		var loc = {};
		
		if (!len(arguments.type))
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
				for (loc.i = 1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.key = ListGetAt(loc.keyList, loc.i);
					loc.str = ListAppend(loc.str, loc.key & "=" & $convertToString(value=arguments.value[loc.key], delim=arguments.delim), arguments.delim);
				}
				arguments.value = loc.str;
				break;
			case "binary":
				arguments.value = ToString(arguments.value);
				break;
			case "float": case "integer":
				if(len(arguments.value)){
					arguments.value = Val(arguments.value);
				}
				break;
			case "boolean":
				arguments.value = ( arguments.value IS true );
				break;
			case "datetime":
				// createdatetime will throw an error
				if(IsDate(arguments.value))
				{
					arguments.value = CreateDateTime(year(arguments.value), month(arguments.value), day(arguments.value), hour(arguments.value), minute(arguments.value), second(arguments.value));
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
	<cfargument name="defaultValue" type="any" required="false" default="">
	<cfscript>
		var loc = {};
		loc.list = ListToArray(arguments.list, arguments.delim);
		loc.iEnd = ArrayLen(loc.list);
		for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
		{
			loc.list[loc.i] = Trim(loc.list[loc.i]);
		}

		switch (arguments.returnAs)
		{
			case "array":
			{// already an array so just break out
				break;
			}
			case "struct":
			{
				loc.s = {};
				for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
				{
					loc.s[loc.list[loc.i]] = arguments.defaultValue;
				}
				loc.list = loc.s;
				break;
			}
			default:
			{// create a list using the supplied delimeter
				loc.list = ArrayToList(loc.list, arguments.delim);
				break;
			}
		}
	</cfscript>
	<cfreturn loc.list>
</cffunction>

<cffunction name="$simpleHashedKey" returntype="string" access="public" output="false" hint="Same as $hashedKey but cannot handle binary data in queries.">
	<cfargument name="value" type="any" required="true">
	<cfscript>
		var returnValue = "";
		returnValue = SerializeJSON(arguments.value);
		// remove the characters that indicate array or struct so that we can sort it as a list below
		returnValue = ReplaceList(returnValue, "{,},[,]", ",,,");
		returnValue = ListSort(returnValue, "text");
		return returnValue;
	</cfscript>
</cffunction>

<cffunction name="$hashedKey" returntype="string" access="public" output="false" hint="Creates a unique string based on any arguments passed in (used as a key for caching mostly).">
	<cfscript>
		var loc = {};
		loc.returnValue = "";

		// we need to make sure we are looping through the passed in arguments in the same order everytime
		loc.values = [];
		loc.keyList = ListSort(StructKeyList(arguments), "textnocase", "asc");
		loc.iEnd = ListLen(loc.keyList);
		for (loc.i = 1; loc.i <= loc.iEnd; loc.i++)
			ArrayAppend(loc.values, arguments[ListGetAt(loc.keyList, loc.i)]);

		if (!ArrayIsEmpty(loc.values))
		{
			// this might fail if a query contains binary data so in those rare cases we fall back on using cfwddx (which is a little bit slower which is why we don't use it all the time)
			try
			{
				loc.returnValue = $simpleHashedKey(loc.values);
			}
			catch (Any e)
			{
				loc.returnValue = $wddx(input=loc.values);
			}
		}
		return Hash(loc.returnValue);
	</cfscript>
</cffunction>

<cffunction name="$timeSpanForCache" returntype="any" access="public" output="false">
	<cfargument name="cache" type="any" required="true">
	<cfargument name="timeout" type="numeric" required="false">
	<cfargument name="category" type="string" required="false">
	<cfscript>
		var loc = {};
		// if cache isn't a numeric value
		if (IsBoolean(arguments.cache))
		{
			// if cache is true, then assign a timeout
			if (arguments.cache)
			{
				// is a timeout supplied?
				if (StructKeyExists(arguments, "timeout"))
				{
					arguments.cache = arguments.timeout;
				}
				else
				{
					// is a category supplied?
					if (StructKeyExists(arguments, "category") && StructKeyExists(application.wheels.cacheSettings[arguments.category], "timeout"))
					{
						arguments.cache = application.wheels.cacheSettings[arguments.category].timeout;
					}
					else
					{
						// default the timeout to 1 hour / 3600 seconds
						arguments.cache = 3600;
					}
				}
			}
			else
			{
				// cache is false, don't cache
				arguments.cache = 0;
			}
		}
		return CreateTimeSpan(0,0,0,val(arguments.cache));
	</cfscript>
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

<!--- helper method to recursively map a structure to build mapping paths and retrieve its values so you can have your way with a deeply nested structure --->
<cffunction name="$mapStruct" returntype="void" access="public" output="false" mixin="dispatch">
	<cfargument name="map" type="struct" required="true" />
	<cfargument name="struct" type="struct" required="true" />
	<cfargument name="path" type="string" required="false" default="" />
	<cfscript>
		var loc = {};
		for (loc.item in arguments.struct)
		{
			if (IsStruct(arguments.struct[loc.item])) // go further down the rabit hole
			{
				$mapStruct(map=arguments.map, struct=arguments.struct[loc.item], path="#arguments.path#[#loc.item#]");
			}
			else // map our position and value
			{
				arguments.map["#arguments.path#[#loc.item#]"] = {};
				arguments.map["#arguments.path#[#loc.item#]"].value = arguments.struct[loc.item];
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$structKeysExist" returntype="boolean" access="public" output="false" hint="Check to see if all keys in the list exist for the structure and have length.">
	<cfargument name="struct" type="struct" required="true" />
	<cfargument name="keys" type="string" required="false" default="" />
	<cfscript>
		var loc = {};
		loc.returnValue = true;
		loc.iEnd = ListLen(arguments.keys);
		for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
		{
			if (!StructKeyExists(arguments.struct, ListGetAt(arguments.keys, loc.i)) || (IsSimpleValue(arguments.struct[ListGetAt(arguments.keys, loc.i)]) && !Len(arguments.struct[ListGetAt(arguments.keys, loc.i)])))
			{
				loc.returnValue = false;
				break;
			}
		}
	</cfscript>
	<cfreturn loc.returnValue />
</cffunction>

<cffunction name="$cgiScope" returntype="struct" access="public" output="false" hint="This copies all the variables Wheels needs from the CGI scope to the request scope.">
	<cfargument name="keys" type="string" required="false" default="request_method,http_x_requested_with,http_referer,server_name,path_info,script_name,query_string,remote_addr,server_port,server_port_secure,server_protocol,http_host,http_accept,content_type,http_x_rewrite_url,http_x_original_url,request_uri,redirect_url">
	<cfargument name="scope" type="struct" required="false" default="#cgi#">
	<cfscript>
		var loc = {};
		loc.returnValue = {};
		loc.iEnd = ListLen(arguments.keys);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.returnValue[ListGetAt(arguments.keys, loc.i)] = arguments.scope[ListGetAt(arguments.keys, loc.i)];
		}
		

		/* Fixes IIS issue that returns a blank cgi.path_info 
		   Fix: http://www.giancarlogomez.com/2012/06/you-are-not-going-crazy-cgipathinfo-is.html
		   Bug: https://bugbase.adobe.com/index.cfm?event=bug&id=3209090 
		*/
		if (!Len(loc.returnValue.path_info))
		{
			if (Len(loc.returnValue.http_x_rewrite_url))
			{// iis6 1/ IIRF (Ionics Isapi Rewrite Filter)
				loc.returnValue.path_info = ListFirst(loc.returnValue.http_x_rewrite_url,'?');
			}
			else if (Len(loc.returnValue.http_x_original_url))
			{// iis7 rewrite default
				loc.returnValue.path_info = ListFirst(loc.returnValue.http_x_original_url,"?");
			}
			else if (Len(loc.returnValue.request_uri))
			{// apache default
				loc.returnValue.path_info = ListFirst(loc.returnValue.request_uri,'?');
			}
			else if (Len(loc.returnValue.redirect_url))
			{// apache fallback
				loc.returnValue.path_info = ListFirst(loc.returnValue.redirect_url,'?');
			}
		}
			
		// finally lets remove the index.cfm because some of the custom cgi variables don't bring it back
		// like this it means at the root we are working with / instead of /index.cfm
		if (Len(loc.returnValue.path_info) gte 10 && Right(loc.returnValue.path_info, 10)  eq "/index.cfm")
		{// this will remove the index.cfm and the trailing slash
			loc.returnValue.path_info = Replace(loc.returnValue.path_info,'/index.cfm','');
			if (!Len(loc.returnValue.path_info))
			{// add back the forward slash if path_info was "/index.cfm"
				loc.returnValue.path_info = "/";
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
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
				arguments.input["$"&loc.key] = arguments.input[loc.key];
				StructDelete(arguments.input, loc.key);
			}
		}
	</cfscript>
	<cfreturn arguments.input>
</cffunction>

<cffunction name="$abortInvalidRequest" returntype="void" access="public" output="false">
	<cfscript>
		var applicationPath = Replace(GetCurrentTemplatePath(), "\", "/", "all");
		var callingPath = Replace(GetBaseTemplatePath(), "\", "/", "all");
		if (ListLen(callingPath, "/") GT ListLen(applicationPath, "/") || GetFileFromPath(callingPath) == "root.cfm")
		{
			$header(statusCode="404", statusText="Not Found");
			$includeAndOutput(template="#application.wheels.eventPath#/onmissingtemplate.cfm");
			$abort();
		}
	</cfscript>
</cffunction>

<cffunction name="$URLEncode" returntype="string" access="public" output="false">
	<cfargument name="param" type="string" required="false" default="">
	<cfscript>
		var returnValue = "";
		returnValue = URLEncodedFormat(arguments.param);
		returnValue = ReplaceList(returnValue, "%24,%2D,%5F,%2E,%2B,%21,%2A,%27,%28,%29", "$,-,_,.,+,!,*,',(,)"); // these characters are safe so set them back to their original values.
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$routeVariables" returntype="string" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.route = $findRoute(argumentCollection=arguments);
		loc.returnValue = loc.route.variables;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$findRoute" returntype="struct" access="public" output="false">
	<cfscript>
		var loc = {};

		// throw an error if a route with this name has not been set by developer in the config/routes.cfm file
		if (application.wheels.showErrorInformation && !StructKeyExists(application.wheels.namedRoutePositions, arguments.route))
			$throw(type="Wheels.RouteNotFound", message="Could not find the `#arguments.route#` route.", extendedInfo="Create a new route in `config/routes.cfm` with the name `#arguments.route#`.");

		loc.routePos = application.wheels.namedRoutePositions[arguments.route];
		
		if (ArrayLen(loc.routePos) gt 1)
		{
			// get our routes - we cache them in the request.wheels.routes scope to save time on subsequent calls to $findRoute
			if (StructKeyExists(request.wheels.routes, arguments.route))
			{
				loc.routeArray = request.wheels.routes[arguments.route];
			}
			else
			{
				loc.routeArray = [];
				for (loc.i = 1; loc.i lte ArrayLen(loc.routePos); loc.i++)
					loc.routeArray[loc.i] = application.wheels.routes[loc.routePos[loc.i]];
				request.wheels.routes[arguments.route] = loc.routeArray;
			}
			
			loc.foundRoute = false;
			while (!loc.foundRoute) // need to use a while loop here so we don't loop through all of the routes
			{
				if (application.wheels.showErrorInformation && !ArrayLen(loc.routeArray))
					$throw(type="Wheels.RouteMatchNotFound", message="Could not find a match for the `#arguments.route#` route.");

				// we always try to find the route on the first position because we are cleaning the array everytime we don't find a match
				loc.returnValue = loc.routeArray[1];
				loc.foundRoute = true;
				
				for (loc.i = 1; loc.i lte ListLen(loc.returnValue.variables); loc.i++)
				{
					loc.variable = ListGetAt(loc.returnValue.variables, loc.i);
					if (!StructKeyExists(arguments, loc.variable) || !Len(arguments[loc.variable]))
					{
						loc.foundRoute = false;
						break;
					}
				}
				
				// clean the array of all routes that contain the variable that failed
				if (!loc.foundRoute)
					for (loc.i = ArrayLen(loc.routeArray); loc.i gte 1; loc.i--)
						if (ListFindNoCase(loc.routeArray[loc.i].variables, loc.variable))
							ArrayDeleteAt(loc.routeArray, loc.i);
			}
		}
		else
		{
			loc.returnValue = application.wheels.routes[loc.routePos[1]];
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$cachedModelClassExists" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		var returnValue = false;
		if (StructKeyExists(application.wheels.models, arguments.name))
			returnValue = application.wheels.models[arguments.name];
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$constructParams" returntype="string" access="public" output="false">
	<cfargument name="params" type="string" required="true">
	<cfargument name="$URLRewriting" type="string" required="false" default="#application.wheels.URLRewriting#">
	<cfscript>
		var loc = {};
		arguments.params = Replace(arguments.params, "&amp;", "&", "all"); // change to using ampersand so we can use it as a list delim below and so we don't "double replace" the ampersand below
		// when rewriting is off we will already have "?controller=" etc in the url so we have to continue with an ampersand
		if (arguments.$URLRewriting == "Off")
			loc.delim = "&";
		else
			loc.delim = "?";
		loc.returnValue = "";
		loc.iEnd = ListLen(arguments.params, "&");
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.temp = listToArray(ListGetAt(arguments.params, loc.i, "&"), "=");
			loc.returnValue = loc.returnValue & loc.delim & loc.temp[1] & "=";
			loc.delim = "&";
			if (ArrayLen(loc.temp) == 2)
			{
				loc.param = $URLEncode(loc.temp[2]);
				if (application.wheels.obfuscateUrls && !ListFindNoCase("cfid,cftoken", loc.temp[1]))
					loc.param = obfuscateParam(loc.param);
				loc.returnValue = loc.returnValue & loc.param;
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$args" returntype="any" access="public" output="false">
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
						$throw(type="Wheels.IncorrectArguments", message="The `#loc.item#` argument cannot be passed in since it will be set automatically by Wheels.");
				}
			}
		}
		if (StructKeyExists(application.wheels.functions, arguments.name))
			StructAppend(arguments.args, application.wheels.functions[arguments.name], false);

		// make sure that the arguments marked as required exist
		if (Len(arguments.required))
		{
			loc.iEnd = ListLen(arguments.required);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.arg = ListGetAt(arguments.required, loc.i);
				if(!StructKeyExists(arguments.args, loc.arg))
				{
					$throw(type="Wheels.IncorrectArguments", message="The `#loc.arg#` argument is required but not passed in.");
				}
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$debugPoint" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		var loc = {};
		if (!StructKeyExists(request.wheels, "execution"))
			request.wheels.execution = {};
		loc.iEnd = ListLen(arguments.name);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.name, loc.i);
			if (StructKeyExists(request.wheels.execution, loc.item))
				request.wheels.execution[loc.item] = GetTickCount() - request.wheels.execution[loc.item];
			else
				request.wheels.execution[loc.item] = GetTickCount();
		}
	</cfscript>
</cffunction>

<cffunction name="$cachedControllerClassExists" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
		<cfscript>
			var returnValue = false;
			if (StructKeyExists(application.wheels.controllers, arguments.name))
				returnValue = application.wheels.controllers[arguments.name];
		</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$fileExistsNoCase" returntype="any" access="public" output="false">
	<cfargument name="absolutePath" type="string" required="true">
	<cfscript>
		var loc = {};

		// break up the full path string in the path name only and the file name only
		loc.path = GetDirectoryFromPath(arguments.absolutePath);
		loc.file = Replace(arguments.absolutePath, loc.path, "");

		// get all existing files in the directory and place them in a list
		loc.dirInfo = $directory(directory=loc.path);
		loc.fileList = ValueList(loc.dirInfo.name);

		// loop through the file list and return true if the file exists regardless of case (the == operator is case insensitive)
		loc.iEnd = ListLen(loc.fileList);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.foundFile = ListGetAt(loc.fileList, loc.i);
			if (loc.foundFile == loc.file)
				return loc.foundFile;
		}

		// the file wasn't found in the directory so we return false
		return false;
	</cfscript>
</cffunction>

<cffunction name="$objectFileName" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="objectPath" type="string" required="true">
	<cfargument name="type" type="string" required="true" hint="Can be either `controller` or `model`." />
	<cfscript>
		var loc = {};

		// we are going to store the full controller/model path in the existing / non-existing lists so we can have controllers/models in multiple places
		loc.fullObjectPath = arguments.objectPath & "/" & ListChangeDelims(arguments.name, "/", ".");
		
		if (!ListFindNoCase(application.wheels.existingObjectFiles, loc.fullObjectPath) && !ListFindNoCase(application.wheels.nonExistingObjectFiles, loc.fullObjectPath))
		{
			// we have not yet checked if this file exists or not so let's do that here
			// $fileExistsNoCase will return the file name with correct case if it exists, false if not
			loc.file = $fileExistsNoCase(ExpandPath("#loc.fullObjectPath#.cfc"));
			if (IsBoolean(loc.file) && !loc.file)
			{
				// no file exists, let's store that if caching is on so we don't have to check it again
				if (application.wheels.cacheFileChecking)
					application.wheels.nonExistingObjectFiles = ListAppend(application.wheels.nonExistingObjectFiles, loc.fullObjectPath);
			}
			else
			{				
				// the file exists, let's store the proper case of the file if caching is turned on
				loc.file = SpanExcluding(loc.file, ".");
				loc.fullObjectPath = ListSetAt(loc.fullObjectPath, ListLen(loc.fullObjectPath, "/"), loc.file, "/");
				if (application.wheels.cacheFileChecking)
					application.wheels.existingObjectFiles = ListAppend(application.wheels.existingObjectFiles, loc.fullObjectPath);
				return loc.file;
			}
		}
		else
		{
			// if the file exists we return the file name in its proper case
			loc.pos = ListFindNoCase(application.wheels.existingObjectFiles, loc.fullObjectPath);
			if (loc.pos)
				return ListLast(ListGetAt(application.wheels.existingObjectFiles, loc.pos), "/");
		}

		// by default we return "Model" or "Controller" so that the base component gets loaded
		return capitalize(arguments.type);
	</cfscript>
</cffunction>

<cffunction name="$createControllerClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="controllerPaths" type="string" required="false" default="#application.wheels.controllerPath#">
	<cfargument name="type" type="string" required="false" default="controller" />
	<cfscript>
		var loc = {};

		// let's allow for multiple controller paths so that plugins can contain controllers
		// the last path is the one we will instantiate the base controller on if the controller is not found on any of the paths
		for (loc.i = 1; loc.i lte ListLen(arguments.controllerPaths); loc.i++)
		{
			loc.controllerPath = ListGetAt(arguments.controllerPaths, loc.i);
			loc.fileName = $objectFileName(name=arguments.name, objectPath=loc.controllerPath, type=arguments.type);

			if (loc.fileName != "Controller" || loc.i == ListLen(arguments.controllerPaths))
			{
				application.wheels.controllers[arguments.name] = $createObjectFromRoot(path=loc.controllerPath, fileName=loc.fileName, method="$initControllerClass", name=arguments.name);
				loc.returnValue = application.wheels.controllers[arguments.name];
				break;
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$addToCache" returntype="void" access="public" output="false">
	<cfargument name="category" type="string" required="false" default="main" />
	<cfset application.wheels.caches[arguments.category].add(argumentCollection=arguments)>
</cffunction>

<cffunction name="$getFromCache" returntype="any" access="public" output="false">
	<cfargument name="category" type="string" required="false" default="main" />
	<cfscript>
		var cacheItem = application.wheels.caches[arguments.category].get(argumentCollection=arguments);
		
		if (application.wheels.showDebugInformation)
		{
			if (IsSimpleValue(cacheItem) && IsBoolean(cacheItem) && !cacheItem)
			{
				request.wheels.cacheCounts.misses = request.wheels.cacheCounts.misses + 1;
			}
			else
			{
				request.wheels.cacheCounts.hits = request.wheels.cacheCounts.hits + 1;
			}
		}
	</cfscript>
	<cfreturn cacheItem>
</cffunction>

<cffunction name="$removeFromCache" returntype="void" access="public" output="false">
	<cfargument name="category" type="string" required="true" />
	<cfset application.wheels.caches[arguments.category].remove(argumentCollection=arguments)>
</cffunction>

<cffunction name="$cacheCount" returntype="numeric" access="public" output="false">
	<cfargument name="category" type="string" required="false" default="" />
	<cfscript>
		var loc = {};
		loc.count = 0;
		
		if (Len(arguments.category))
			return application.wheels.caches[arguments.category].count();
			
		for (loc.item in application.wheels.caches)
			loc.count = loc.count + application.wheels.caches[loc.item].count();
	</cfscript>
	<cfreturn loc.count />
</cffunction>

<cffunction name="$cacheCapacity" returntype="numeric" access="public" output="false">
	<cfargument name="category" type="string" required="false" default="" />
	<cfscript>
		var loc = {};
		loc.capacity = 0;
		
		if (Len(arguments.category))
			return application.wheels.caches[arguments.category].capacity();
			
		for (loc.item in application.wheels.caches)
			loc.capacity = loc.capacity + application.wheels.caches[loc.item].capacity();
	</cfscript>
	<cfreturn loc.capacity />
</cffunction>

<cffunction name="$clearCache" returntype="void" access="public" output="false">
	<cfargument name="category" type="string" required="false" default="" />
	<cfscript>
		var loc = {};
		
		if (Len(arguments.category))
			return application.wheels.caches[arguments.category].clear();
			
		for (loc.item in application.wheels.caches)
			loc.count = loc.count + application.wheels.caches[loc.item].clear();
	</cfscript>
</cffunction>

<cffunction name="$createModelClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="modelPaths" type="string" required="false" default="#application.wheels.modelPath#">
	<cfargument name="type" type="string" required="false" default="model" />
	<cfscript>
		var loc = {};
		// let's allow for multiple controller paths so that plugins can contain controllers
		// the last path is the one we will instantiate the base controller on if the controller is not found on any of the paths
		for (loc.i = 1; loc.i lte ListLen(arguments.modelPaths); loc.i++)
		{
			loc.modelPath = ListGetAt(arguments.modelPaths, loc.i);
			arguments.name = ListChangeDelims(arguments.name, "/", ".\");
			loc.extendedPath = Reverse(ListRest(Reverse(arguments.name), "/"));
			loc.modelPath = ListAppend(loc.modelPath, loc.extendedPath, "/");
			arguments.name = ListLast(arguments.name, "/");
			loc.fileName = $objectFileName(name=arguments.name, objectPath=loc.modelPath, type=arguments.type);

			if (loc.fileName != arguments.type || loc.i == ListLen(arguments.modelPaths))
			{
				application.wheels.models[arguments.name] = $createObjectFromRoot(path=loc.modelPath, fileName=loc.fileName, method="$initModelClass", name=arguments.name);
				loc.returnValue = application.wheels.models[arguments.name];
				break;
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<!---
Used to announce to the developer that a feature they are using will be removed at some point.
DOES NOT work in production mode.

To use call $deprecated() from within the method you want to deprecate. You may pass an optional
custom message if desired. The method will return a structure containing the message and information
about where the deprecation occurrs like the called method, line number, template name and shows the
code that called the deprcated method.

Example:

Original foo()
<cffunction name="foo" returntype="any" access="public" output="false">
	<cfargument name="baz" type="numeric" required="true">
	<cfreturn baz++>
</cffunction>

Should now call bar() instead and marking foo() as deprecated
<cffunction name="foo" returntype="any" access="public" output="false">
	<cfargument name="baz" type="numeric" required="true">
	<cfset $deprecated("Calling foo is now deprecated, use bar() instead.")>
	<cfreturn bar(argumentscollection=arguments)>
</cffunction>

<cffunction name="bar" returntype="any" access="public" output="false">
	<cfargument name="baz" type="numeric" required="true">
	<cfreturn ++baz>
</cffunction>
 --->
<cffunction name="$deprecated" returntype="struct" access="public" output="false">
	<!--- a message to display instead of the default one. --->
	<cfargument name="message" type="string" required="false" default="You are using deprecated behavior which will be removed from the next major or minor release.">
	<!--- should you announce the deprecation. only used when writing tests. --->
	<cfargument name="announce" type="boolean" required="false" default="true">
	<cfset var loc = {}>
	<cfset loc.ret = {}>
	<cfset loc.tagcontext = []>
	<cfif not application.wheels.showDebugInformation>
		<cfreturn loc.ret>
	</cfif>
	<!--- set return value --->
	<cfset loc.data = []>
	<cfset loc.ret = {message=arguments.message, line="", method="", template="", data=loc.data}>
	<!---
	create an exception so we can get the TagContext and display what file and line number the
	deprecated method is being called in
	 --->
	<cftry>
		<cfthrow type="Expression">
		<cfcatch type="any">
			<cfset loc.exception = cfcatch>
		</cfcatch>
	</cftry>
	<cfif StructKeyExists(loc.exception, "tagcontext")>
		<cfset loc.tagcontext = loc.exception.tagcontext>
	</cfif>
	<!---
	TagContext is an array. The first element of the array will always be the context for this
	method announcing the deprecation. The second element will be the deprecated function that
	is being called. We need to look at the third element of the array to get the method that
	is calling the method marked for deprecation.
	 --->
	<cfif isArray(loc.tagcontext) and arraylen(loc.tagcontext) gte 3 and isStruct(loc.tagcontext[3])>
		<!--- grab and parse the information from the tagcontext. --->
		<cfset loc.context = loc.tagcontext[3]>
		<!--- the line number --->
		<cfset loc.ret.line = loc.context.line>
		<!--- the deprecated method that was called --->
		<cfif StructKeyExists(server, "railo")>
			<cfset loc.ret.method = rereplacenocase(loc.context.codePrintPlain, '.*\<cffunction name="([^"]*)">.*', "\1")>
		<cfelse>
			<cfset loc.ret.method = rereplacenocase(loc.context.raw_trace, ".*\$func([^\.]*)\..*", "\1")>
		</cfif>
		<!--- the user template where the method called occurred --->
		<cfset loc.ret.template = loc.context.template>
		<!--- try to get the code --->
 		<cfif len(loc.ret.template) and FileExists(loc.ret.template)>
			<!--- grab a one line radius from where the deprecation occurred. --->
			<cfset loc.startAt = loc.ret.line - 1>
			<cfif loc.startAt lte 0>
				<cfset loc.startAt = loc.ret.line>
			</cfif>
			<cfset loc.stopAt = loc.ret.line + 1>
			<cfset loc.counter = 1>
			<cfloop file="#loc.ret.template#" index="loc.i">
				<cfif loc.counter gte loc.startAt and loc.counter lte loc.stopAt>
					<cfset arrayappend(loc.ret.data, loc.i)>
				</cfif>
				<cfif loc.counter gt loc.stopAt>
					<cfbreak>
				</cfif>
				<cfset loc.counter++>
			</cfloop>
		</cfif>
		<!--- change template name from full to relative path. --->
		<cfset loc.ret.template = listchangedelims(removechars(loc.ret.template, 1, len(expandpath(application.wheels.webpath))), "/", "\/")>
	</cfif>
	<!--- append --->
	<cfif arguments.announce>
		<cfset arrayappend(request.wheels.deprecation, loc.ret)>
	</cfif>
	<cfreturn loc.ret>
</cffunction>

<cffunction name="$loadRoutes" returntype="void" access="public" output="false">
	<cfscript>
		// clear out the route info
		ArrayClear(application.wheels.routes);
		StructClear(application.wheels.namedRoutePositions);

		// load developer routes first
		$include(template="#application.wheels.configPath#/routes.cfm");

		// add the wheels default routes at the end if requested
		if (application.wheels.loadDefaultRoutes)
			addDefaultRoutes();

		// set lookup info for the named routes
		$setNamedRoutePositions();
		</cfscript>
</cffunction>

<cffunction name="$setNamedRoutePositions" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.iEnd = ArrayLen(application.wheels.routes);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.route = application.wheels.routes[loc.i];
			if (StructKeyExists(loc.route, "name") && len(loc.route.name))
			{
				if (!StructKeyExists(application.wheels.namedRoutePositions, loc.route.name))
					application.wheels.namedRoutePositions[loc.route.name] = ArrayNew(1);
				ArrayAppend(application.wheels.namedRoutePositions[loc.route.name], loc.i);
			}
		}
		</cfscript>
</cffunction>

<cffunction name="$clearModelInitializationCache">
	<cfset StructClear(application.wheels.models)>
</cffunction>

<cffunction name="$clearControllerInitializationCache">
	<cfset StructClear(application.wheels.controllers)>
</cffunction>

<cffunction name="$checkMinimumVersion" access="public" returntype="boolean" output="false">
	<cfargument name="version" type="string" required="true">
	<cfargument name="minversion" type="string" required="true">
	<cfreturn semanticVersioning(">= #arguments.minversion#", arguments.version)>
</cffunction>

<cffunction name="$loadPlugins" returntype="void" access="public" output="false">
	<cfscript>
	application.wheels.PluginObj = $createObjectFromRoot(
		path="wheels"
		,fileName="Plugins"
		,method="init"
		,pluginPath="#application.wheels.webPath & application.wheels.pluginPath#"
	);
	
	application.wheels.plugins = application.wheels.PluginObj.getPlugins();
	application.wheels.incompatiblePlugins = application.wheels.PluginObj.getIncompatiblePlugins();
	application.wheels.dependantPlugins = application.wheels.PluginObj.getDependantPlugins();
	application.wheels.mixins = application.wheels.PluginObj.getMixins();
	</cfscript>
</cffunction>

<cffunction name="$loadLocales" returntype="struct" access="public" output="false">
	<cfargument name="path" type="string" required="false" default="#expandPath('/wheelsMapping/locales')#">
	<cfscript>
	var loc = {};
	loc.locales = {};
	// scan the locales directory
	loc.files = $directory(directory="#arguments.path#", action="list");
	// loop through all locales and put into application variable
	loc.count = loc.files.recordcount;
	for(loc.i = 1; loc.i lte loc.count; loc.i++)
	{
		// make paths system agnostic
		loc.path = ListChangeDelims(loc.files["directory"][loc.i], "/", "\");
		// name of the locale file
		loc.name = loc.files["name"][loc.i];
		// name of the locale
		loc.locale = ListFirst(loc.name, ".");
		// read the locale file
		loc.content = FileRead("#loc.path#/#loc.name#", "utf-8");
		// deserialize the json
		loc.content = DeserializeJSON(loc.content);
		// add to application variable
		loc.locales[loc.locale] = loc.content;
	}
	</cfscript>
	<cfreturn loc.locales>
</cffunction>

<cffunction name="$paramsToString" access="public" returntype="string" output="false">
	<cfargument name="params" type="any" required="true">
	<cfreturn $convertToString(value=arguments.params, delim="&")>
</cffunction>

<cffunction name="$switchEnivronmentSecurity" access="public" returntype="string" output="false"
	hint="if allowed to switch the environment through a reload, will return the environment name, otherwise returns a blank string">
	<cfargument name="settings" type="struct" required="true" hint="a struct containing the settings for the wheels application">
	<cfargument name="scope" type="struct" required="true" hint="a scope in which to find the scopeEnvironmentNamingKey parameter to use to switch the environment">
	<cfargument name="settingAllowedToSwitchEnvironmentKey" type="string" required="false" default="allowedEnvironmentSwitchThroughURL" hint="the setting which tell us that we are allowed to switch environments. value of the setting must be a boolean">
	<cfargument name="settingPasswordToSwitchEnvironmentKey" type="string" required="false" default="reloadPassword" hint="the setting that tell us the password for switching environments">
	<cfargument name="scopeEnvironmentNamingKey" type="string" required="false" default="reload" hint="the key in the scope that gives us the environment name to switch to">
	<cfargument name="scopeEnvironmentPasswordKey" type="string" required="false" default="password" hint="the key in the scope that gives us the password for switching environment">
	<cfscript>
	var loc = {};

	// the new environment to switch to
	loc.environment = "";
	// setting: can they switch environments
	loc.setting_allowed = false;
	// setting: the password for switching environments
	loc.setting_password = "";
	// scope: the environment to switch to
	loc.scope_environment = "";
	// scope: the password
	loc.scope_password = "";

	if (StructKeyExists(arguments.settings, arguments.settingAllowedToSwitchEnvironmentKey) AND IsBoolean(arguments.settings[arguments.settingAllowedToSwitchEnvironmentKey]))
	{
		loc.setting_allowed = arguments.settings[arguments.settingAllowedToSwitchEnvironmentKey];
	}
	
	if (StructKeyExists(arguments.settings, arguments.settingPasswordToSwitchEnvironmentKey) && Len(Trim(arguments.settings[arguments.settingPasswordToSwitchEnvironmentKey])))
	{
		loc.setting_password = arguments.settings[arguments.settingPasswordToSwitchEnvironmentKey];
	}
	
	if (StructKeyExists(arguments.scope, arguments.scopeEnvironmentNamingKey))
	{
		loc.scope_environment = arguments.scope[arguments.scopeEnvironmentNamingKey];
	}
	
	if (StructKeyExists(arguments.scope, arguments.scopeEnvironmentPasswordKey))
	{
		loc.scope_password = arguments.scope[arguments.scopeEnvironmentPasswordKey];
	}
	
	if (loc.setting_allowed && Len(loc.scope_environment) && Len(loc.setting_password) && loc.setting_password eq loc.scope_password)
	{
		loc.environment = loc.scope_environment;
	}
	</cfscript>
	
	<cfreturn loc.environment>
</cffunction>

<cffunction name="$saveScopeSettings" access="public" returntype="struct" output="false"
	hint="saves the requested key from scope into a new struct">
	<cfargument name="scope" type="struct" required="true" hint="scope that you want to save the setting from">
	<cfargument name="keys" type="any" required="true" hint="a list or array of keys to save">
	<cfset var loc = {}>
	<cfset loc.saved = {}>
		
	<cfif !IsArray(arguments.keys)>
		<cfset arguments.keys = $listClean(list=arguments.keys, returnAs="array")>
	</cfif>
	
	<cfloop array="#arguments.keys#" index="loc.key">
		<cfif StructKeyExists(arguments.scope, loc.key)>
			<cfset loc.saved[loc.key] = duplicate(arguments.scope[loc.key])>
		</cfif>
	</cfloop>
	
	<cfreturn loc.saved>
</cffunction> 
