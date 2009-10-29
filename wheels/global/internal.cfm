<cffunction name="$cgiScope" returntype="struct" access="public" output="false" hint="This copies all the variables Wheels needs from the CGI scope to the request scope.">
	<cfargument name="keys" type="string" required="false" default="request_method,http_x_requested_with,http_referer,server_name,path_info,script_name,query_string,remote_addr,server_port,server_protocol">
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
		var applicationPath = Replace(GetCurrentTemplatePath(), "\", "/", "all");
		var callingPath = Replace(GetBaseTemplatePath(), "\", "/", "all");
		if (ListLen(callingPath, "/") GT ListLen(applicationPath, "/") || GetFileFromPath(callingPath) == "root.cfm")
			$abort();
	</cfscript>
</cffunction>

<cffunction name="$URLEncode" returntype="string" access="public" output="false">
	<cfargument name="param" type="string" required="true">
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
	<cfargument name="params" type="any" required="true">
	<cfscript>
		var loc = {};
		arguments.params = Replace(arguments.params, "&amp;", "&", "all"); // change to using ampersand so we can use it as a list delim below and so we don't "double replace" the ampersand below
		// when rewriting is off we will already have "?controller=" etc in the url so we have to continue with an ampersand
		if (application.wheels.URLRewriting == "Off")
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
				if (application.wheels.obfuscateUrls)
					loc.param = obfuscateParam(loc.param);
				loc.returnValue = loc.returnValue & loc.param;
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$insertDefaults" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="input" type="struct" required="true">
	<cfargument name="reserved" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		if (application.wheels.showErrorInformation)
		{
			if (ListLen(arguments.reserved))
			{
				loc.iEnd = ListLen(arguments.reserved);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.item = ListGetAt(arguments.reserved, loc.i);
					if (StructKeyExists(arguments.input, loc.item))
						$throw(type="Wheels.IncorrectArguments", message="The '#loc.item#' argument is not allowed.", extendedInfo="Do not pass in the '#loc.item#' argument. It will be set automatically by Wheels.");
				}
			}
		}
		StructAppend(arguments.input, application.wheels.functions[arguments.name], false);
	</cfscript>
</cffunction>

<cffunction name="$createObjectFromRoot" returntype="any" access="public" output="false">
	<cfargument name="path" type="string" required="true">
	<cfargument name="fileName" type="string" required="true">
	<cfargument name="method" type="string" required="true">
	<cfscript>
		var loc = {};
		arguments.returnVariable = "loc.returnValue";
		arguments.component = arguments.path & "." & arguments.fileName;
		StructDelete(arguments, "path");
		StructDelete(arguments, "fileName");
	</cfscript>
	<cfinclude template="../../root.cfm">
	<cfreturn loc.returnValue>
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

<cffunction name="$createControllerClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.fileName = capitalize(arguments.name);

		// check if the controller file exists and store the results for performance reasons
		if (!ListFindNoCase(application.wheels.existingControllerFiles, arguments.name) && !ListFindNoCase(application.wheels.nonExistingControllerFiles, arguments.name))
		{
			if (FileExists(ExpandPath("#application.wheels.controllerPath#/#loc.fileName#.cfc")))
				application.wheels.existingControllerFiles = ListAppend(application.wheels.existingControllerFiles, arguments.name);
			else
				application.wheels.nonExistingControllerFiles = ListAppend(application.wheels.nonExistingControllerFiles, arguments.name);
		}

		// check if the controller's view helper file exists and store the results for performance reasons
		if (!ListFindNoCase(application.wheels.existingHelperFiles, arguments.name) && !ListFindNoCase(application.wheels.nonExistingHelperFiles, arguments.name))
		{
			if (FileExists(ExpandPath("#application.wheels.viewPath#/#LCase(arguments.name)#/helpers.cfm")))
				application.wheels.existingHelperFiles = ListAppend(application.wheels.existingHelperFiles, arguments.name);
			else
				application.wheels.nonExistingHelperFiles = ListAppend(application.wheels.nonExistingHelperFiles, arguments.name);
		}

		if (!ListFindNoCase(application.wheels.existingControllerFiles, arguments.name))
			loc.fileName = "Controller";
		application.wheels.controllers[arguments.name] = $createObjectFromRoot(path=application.wheels.controllerComponentPath, fileName=loc.fileName, method="$initControllerClass", name=arguments.name);
		loc.returnValue = application.wheels.controllers[arguments.name];
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$controller" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = $doubleCheckedLock(name="controllerLock", condition="$cachedControllerClassExists", execute="$createControllerClass", conditionArgs=arguments, executeArgs=arguments);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$hashStruct" returntype="string" access="public" output="false">
	<cfargument name="args" type="struct" required="true">
	<cfreturn Hash(SerializeJSON(arguments.args))>
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
							break;
					}
				}
			}
			application.wheels.cacheLastCulledAt = Now();
		}
		if ($cacheCount() < application.wheels.maximumItemsToCache)
		{
			application.wheels.cache[arguments.category][arguments.key] = {};
			application.wheels.cache[arguments.category][arguments.key].expiresAt = DateAdd("n", arguments.time, Now());
			if (IsSimpleValue(arguments.value))
				application.wheels.cache[arguments.category][arguments.key].value = arguments.value;
			else
				application.wheels.cache[arguments.category][arguments.key].value = duplicate(arguments.value);
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
				$removeFromCache(key=arguments.key, category=arguments.category);
			}
			else
			{
				if (IsSimpleValue(application.wheels.cache[arguments.category][arguments.key].value))
					loc.returnValue = application.wheels.cache[arguments.category][arguments.key].value;
				else
					loc.returnValue = Duplicate(application.wheels.cache[arguments.category][arguments.key].value);
			}
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
				loc.returnValue = loc.returnValue + StructCount(application.wheels.cache[loc.key]);
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
	<cfscript>
		var loc = {};
		loc.fileName = capitalize(arguments.name);
		if (FileExists(ExpandPath("#application.wheels.modelPath#/#loc.fileName#.cfc")))
			application.wheels.existingModelFiles = ListAppend(application.wheels.existingModelFiles, arguments.name);
		else
			loc.fileName = "Model";
		application.wheels.models[arguments.name] = $createObjectFromRoot(path=application.wheels.modelComponentPath, fileName=loc.fileName, method="$initModelClass", name=arguments.name);
		loc.returnValue = application.wheels.models[arguments.name];
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
	<cfif not application.wheels.showErrorInformation>
		<cfreturn loc.ret>
	</cfif>
	<!--- set return value --->
	<cfset loc.data = []>
	<cfset loc.ret = {message=arguments.message, line="", method="", template="", data=loc.data}>
	<!---
	create an exception so we can get the TagContext and display what file and line number the
	deprecated method is being called in
	 --->
	<cfset loc.exception = createObject("java","java.lang.Exception").init()>
	<cfset loc.tagcontext = loc.exception.tagcontext>
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
		<cfset loc.ret.method = rereplacenocase(loc.context.raw_trace, ".*\$func([^\.]*)\..*", "\1")>
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