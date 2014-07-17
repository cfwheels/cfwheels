<cffunction name="$initializeRequestScope" returntype="void" access="public" output="false">
	<cfscript>
		if (!StructKeyExists(request, "wheels"))
		{
			request.wheels = {};
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
		if (!StructKeyExists(request.wheels, "toXml"))
			request.wheels.toXml = $createObjectFromRoot(path="#application.wheels.wheelsComponentPath#.vendor.toXml", fileName="toXML", method="init");
	</cfscript>
	<cfreturn request.wheels.toXml.toXml(arguments.data) />
</cffunction>

<cffunction name="$convertToString" returntype="string" access="public" output="false">
	<cfargument name="value" type="Any" required="true">
	<cfargument name="type" type="string" required="false" default="">
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
					loc.str = ListAppend(loc.str, loc.key & "=" & arguments.value[loc.key]);
				}
				arguments.value = loc.str;
				break;
			case "binary":
				arguments.value = ToString(arguments.value);
				break;
			case "float": case "integer":
				arguments.value = Val(arguments.value);
				break;
			case "boolean":
				if(len(arguments.value))
				{
					arguments.value = ( arguments.value IS true );
				}
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
	<cfscript>
		var loc = {};
		loc.list = ListToArray(arguments.list, arguments.delim);
		for (loc.i = 1; loc.i lte ArrayLen(loc.list); loc.i++)
			loc.list[loc.i] = Trim(loc.list[loc.i]);
		if (arguments.returnAs == "array")
			return loc.list;
	</cfscript>
	<cfreturn ArrayToList(loc.list, arguments.delim)>
</cffunction>

<cffunction name="$hashedKey" returntype="string" access="public" output="false" hint="Creates a unique string based on any arguments passed in (used as a key for caching mostly).">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		
		// Make all cache keys domain specific
		StructInsert(arguments,ListLen(StructKeyList(arguments)) + 1,request.cgi.http_host,true);
		
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
				loc.returnValue = SerializeJSON(loc.values);
				// remove the characters that indicate array or struct so that we can sort it as a list below
				loc.returnValue = ReplaceList(loc.returnValue, "{,},[,]", ",,,");
				loc.returnValue = ListSort(loc.returnValue, "text");
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
	<cfargument name="defaultCacheTime" type="numeric" required="false" default="#application.wheels.defaultCacheTime#">
	<cfargument name="cacheDatePart" type="string" required="false" default="#application.wheels.cacheDatePart#">
	<cfscript>
		var loc = {};
		loc.cache = arguments.defaultCacheTime;
		if (IsNumeric(arguments.cache))
			loc.cache = arguments.cache;
		loc.list = "0,0,0,0";
		loc.dateParts = "d,h,n,s";
		loc.iEnd = ListLen(loc.dateParts);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			if (arguments.cacheDatePart == ListGetAt(loc.dateParts, loc.i))
				loc.list = ListSetAt(loc.list, loc.i, loc.cache);
		return CreateTimeSpan(ListGetAt(loc.list, 1),ListGetAt(loc.list, 2),ListGetAt(loc.list, 3),ListGetAt(loc.list, 4));
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
	<cfargument name="keys" type="string" required="false" default="request_method,http_x_requested_with,http_referer,server_name,path_info,script_name,query_string,remote_addr,server_port,server_port_secure,server_protocol,http_host,http_accept,content_type">
	<cfscript>
		var loc = {};
		loc.returnValue = {};
		loc.iEnd = ListLen(arguments.keys);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			loc.returnValue[ListGetAt(arguments.keys, loc.i)] = cgi[ListGetAt(arguments.keys, loc.i)];
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
		var loc = {};
		loc.applicationPath = Replace(GetCurrentTemplatePath(), "\", "/", "all");
		loc.callingPath = Replace(GetBaseTemplatePath(), "\", "/", "all");
		if (ListLen(loc.callingPath, "/") > ListLen(loc.applicationPath, "/") || GetFileFromPath(loc.callingPath) == "root.cfm")
		{
			$header(statusCode="404", statusText="Not Found");
			if (StructKeyExists(application, "wheels") && StructKeyExists(application.wheels, "eventPath"))
			{
				$includeAndOutput(template="#application.wheels.eventPath#/onmissingtemplate.cfm");
			}
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
		if (loc.routePos Contains ",")
		{
			// there are several routes with this name so we need to figure out which one to use by checking the passed in arguments
			loc.iEnd = ListLen(loc.routePos);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.returnValue = application.wheels.routes[ListGetAt(loc.routePos, loc.i)];
				loc.foundRoute = true;
				loc.jEnd = ListLen(loc.returnValue.variables);
				for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
				{
					loc.variable = ListGetAt(loc.returnValue.variables, loc.j);
					if (!StructKeyExists(arguments, loc.variable) || !Len(arguments[loc.variable]))
						loc.foundRoute = false;
				}
				if (loc.foundRoute)
					break;
			}
		}
		else
		{
			loc.returnValue = application.wheels.routes[loc.routePos];
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

				// correct double encoding of & and =
				// since we parse the param string using & and = the developer has to url encode them on the input
				loc.param = Replace(loc.param, "%2526", "%26", "all");
				loc.param = Replace(loc.param, "%253D", "%3D", "all");
				
				if (application.wheels.obfuscateUrls && !ListFindNoCase("cfid,cftoken", loc.temp[1]))
				{
					loc.param = obfuscateParam(loc.param);
				}
				loc.returnValue = loc.returnValue & loc.param;
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
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

<cffunction name="$createObjectFromRoot" returntype="any" access="public" output="false">
	<cfargument name="path" type="string" required="true">
	<cfargument name="fileName" type="string" required="true">
	<cfargument name="method" type="string" required="true">
	<cfscript>
		var returnValue = "";
		var loc = {};
		loc.returnVariable = "returnValue";
		loc.method = arguments.method;
		loc.component = ListChangeDelims(arguments.path, ".", "/") & "." & ListChangeDelims(arguments.fileName, ".", "/");
		loc.argumentCollection = arguments;
	</cfscript>
	<cfinclude template="../../root.cfm">
	<cfreturn returnValue>
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
		{
			returnValue = application.wheels.controllers[arguments.name];
		}
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$fileExistsNoCase" returntype="any" access="public" output="false">
	<cfargument name="absolutePath" type="string" required="true">
	<cfscript>
		var loc = {};

		// return false by default when the file does not exist in the directory
		loc.returnValue = false;

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
			{
				loc.returnValue = loc.foundFile;
				break;
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$objectFileName" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="objectPath" type="string" required="true">
	<cfargument name="type" type="string" required="true" hint="Can be either `controller` or `model`." />
	<cfscript>
		var loc = {};
		
		// by default we return Model or Controller so that the base component gets loaded
		loc.returnValue = capitalize(arguments.type);

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
				loc.returnValue = loc.file;
			}
		}
		else
		{
			// if the file exists we return the file name in its proper case
			loc.pos = ListFindNoCase(application.wheels.existingObjectFiles, loc.fullObjectPath);
			if (loc.pos)
			{
				loc.returnValue = ListLast(ListGetAt(application.wheels.existingObjectFiles, loc.pos), "/");
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
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
		loc.returnValue = false;
		if (StructKeyExists(application.wheels.cache[arguments.category], arguments.key))
		{
			if (Now() > application.wheels.cache[arguments.category][arguments.key].expiresAt)
			{
				if (application.wheels.showDebugInformation)
				{
					request.wheels.cacheCounts.culls++;
				}
				$removeFromCache(key=arguments.key, category=arguments.category);
			}
			else
			{
				if (application.wheels.showDebugInformation)
				{
					request.wheels.cacheCounts.hits++;
				}
				if (IsSimpleValue(application.wheels.cache[arguments.category][arguments.key].value))
				{
					loc.returnValue = application.wheels.cache[arguments.category][arguments.key].value;
				}
				else
				{
					loc.returnValue = Duplicate(application.wheels.cache[arguments.category][arguments.key].value);
				}
			}
		}
		if (application.wheels.showDebugInformation && IsBoolean(loc.returnValue) && !loc.returnValue)
		{
			request.wheels.cacheCounts.misses++;
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$removeFromCache" returntype="void" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfargument name="category" type="string" required="false" default="main">
	<cfset StructDelete(application.wheels.cache[arguments.category], arguments.key)>
</cffunction>

<cffunction name="$cacheCount" returntype="numeric" access="public" output="false">
	<cfargument name="category" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		if (Len(arguments.category))
		{
			loc.returnValue = StructCount(application.wheels.cache[arguments.category]);
		}
		else
		{
			loc.returnValue = 0;
			for (loc.key in application.wheels.cache)
			{
				loc.returnValue += StructCount(application.wheels.cache[loc.key]);
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
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
	<cfargument name="type" type="string" required="false" default="model" />
	<cfscript>
		var loc = {};
		// let's allow for multiple controller paths so that plugins can contain controllers
		// the last path is the one we will instantiate the base controller on if the controller is not found on any of the paths
		for (loc.i = 1; loc.i lte ListLen(arguments.modelPaths); loc.i++)
		{
			loc.modelPath = ListGetAt(arguments.modelPaths, loc.i);
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

<cffunction name="$loadRoutes" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.appKey = "wheels";
		if (StructKeyExists(application, "_wheels"))
		{
			loc.appKey = "_wheels";
		}

		// clear out the route info
		ArrayClear(application[loc.appKey].routes);
		StructClear(application[loc.appKey].namedRoutePositions);

		// load developer routes first
		$include(template="#application[loc.appKey].configPath#/routes.cfm");

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
		loc.appKey = "wheels";
		if (StructKeyExists(application, "_wheels"))
		{
			loc.appKey = "_wheels";
		}
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
	<cfset StructClear(application.wheels.models)>
</cffunction>

<cffunction name="$clearControllerInitializationCache">
	<cfset StructClear(application.wheels.controllers)>
</cffunction>

<cffunction name="$checkMinimumVersion" access="public" returntype="boolean" output="false">
	<cfargument name="version" type="string" required="true">
	<cfargument name="minVersion" type="string" required="true">
	<cfscript>
	var loc = {};
	loc.returnValue = true;
	arguments.version = ListChangeDelims(arguments.version, ".", ".,");
	arguments.minVersion = ListChangeDelims(arguments.minVersion, ".", ".,");
	arguments.version = ListToArray(arguments.version, ".");
	arguments.minVersion = ListToArray(arguments.minVersion, ".");

	// make version and minVersion the same length pad zeros to the end
	loc.minSize = Max(ArrayLen(arguments.version), ArrayLen(arguments.minVersion));

	ArrayResize(arguments.version, loc.minSize);
	ArrayResize(arguments.minVersion, loc.minSize);
	for(loc.i=1; loc.i <= loc.minSize; loc.i++)
	{
		loc.version = 0;
		if (ArrayIsDefined(arguments.version, loc.i))
		{
			loc.version = Val(arguments.version[loc.i]);
		}
		loc.minVersion = 0;
		if (ArrayIsDefined(arguments.minVersion, loc.i))
		{
			loc.minVersion = Val(arguments.minVersion[loc.i]);
		}
		if (loc.version > loc.minVersion)
		{
			loc.returnValue = true;
			break;
		}
		if (loc.version < loc.minVersion)
		{
			loc.returnValue = false;
			break;
		}
	}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$loadPlugins" returntype="void" access="public" output="false">
	<cfscript>
	var loc = {};
	loc.appKey = "wheels";
	if (StructKeyExists(application, "_wheels"))
	{
		loc.appKey = "_wheels";
	}
	loc.pluginPath = application[loc.appKey].webPath & application[loc.appKey].pluginPath;
	application[loc.appKey].PluginObj = $createObjectFromRoot(path="wheels", fileName="Plugins", method="init", pluginPath=loc.pluginPath, deletePluginDirectories=application[loc.appKey].deletePluginDirectories, overwritePlugins=application[loc.appKey].overwritePlugins, loadIncompatiblePlugins=application[loc.appKey].loadIncompatiblePlugins, wheelsEnvironment=application[loc.appKey].environment, wheelsVersion=application[loc.appKey].version);
	application[loc.appKey].plugins = application[loc.appKey].PluginObj.getPlugins();
	application[loc.appKey].incompatiblePlugins = application[loc.appKey].PluginObj.getIncompatiblePlugins();
	application[loc.appKey].dependantPlugins = application[loc.appKey].PluginObj.getDependantPlugins();
	application[loc.appKey].mixins = application[loc.appKey].PluginObj.getMixins();
	</cfscript>
</cffunction>