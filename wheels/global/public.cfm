<!--- PUBLIC CONFIGURATION FUNCTIONS --->

<cffunction name="addFormat" returntype="void" access="public" output="false">
	<cfargument name="extension" type="string" required="true">
	<cfargument name="mimeType" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.appKey = $appKey();
		application[loc.appKey].formats[arguments.extension] = arguments.mimeType;
	</cfscript>
</cffunction>

<cffunction name="addRoute" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="false" default="">
	<cfargument name="pattern" type="string" required="true">
	<cfargument name="controller" type="string" required="false" default="">
	<cfargument name="action" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.appKey = $appKey();

		// throw errors when controller or action is not passed in as arguments and not included in the pattern
		if (!Len(arguments.controller) && !FindNoCase("[controller]", arguments.pattern))
		{
			$throw(type="Wheels.IncorrectArguments", message="The `controller` argument is not passed in or included in the pattern.", extendedInfo="Either pass in the `controller` argument to specifically tell CFWheels which controller to call or include it in the pattern to tell CFWheels to determine it dynamically on each request based on the incoming URL.");
		}
		if (!Len(arguments.action) && !FindNoCase("[action]", arguments.pattern))
		{
			$throw(type="Wheels.IncorrectArguments", message="The `action` argument is not passed in or included in the pattern.", extendedInfo="Either pass in the `action` argument to specifically tell CFWheels which action to call or include it in the pattern to tell CFWheels to determine it dynamically on each request based on the incoming URL.");
		}

		loc.thisRoute = Duplicate(arguments);
		loc.thisRoute.variables = "";
		if (Find(".", loc.thisRoute.pattern))
		{
			loc.thisRoute.format = ListLast(loc.thisRoute.pattern, ".");
			loc.thisRoute.formatVariable = ReplaceList(loc.thisRoute.format, "[,]", "");
			loc.thisRoute.pattern = ListFirst(loc.thisRoute.pattern, ".");
		}
		loc.iEnd = ListLen(loc.thisRoute.pattern, "/");
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(loc.thisRoute.pattern, loc.i, "/");
			if (REFind("^\[", loc.item))
			{
				loc.thisRoute.variables = ListAppend(loc.thisRoute.variables, ReplaceList(loc.item, "[,]", ""));
			}
		}
		ArrayAppend(application[loc.appKey].routes, loc.thisRoute);
	</cfscript>
</cffunction>

<cffunction name="addDefaultRoutes" returntype="void" access="public" output="false">
	<cfscript>
		addRoute(pattern="[controller]/[action]/[key]");
		addRoute(pattern="[controller]/[action]");
		addRoute(pattern="[controller]", action="index");
	</cfscript>
</cffunction>

<cffunction name="set" returntype="void" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.appKey = $appKey();
		if (ArrayLen(arguments) > 1)
		{
			for (loc.key in arguments)
			{
				if (loc.key != "functionName")
				{
					loc.iEnd = ListLen(arguments.functionName);
					for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
					{
						application[loc.appKey].functions[Trim(ListGetAt(arguments.functionName, loc.i))][loc.key] = arguments[loc.key];
					}
				}
			}
		}
		else
		{
			application[loc.appKey][StructKeyList(arguments)] = arguments[1];
		}
	</cfscript>
</cffunction>

<!--- PUBLIC HELPER FUNCTIONS --->

<cffunction name="setPagination" access="public" output="false" returntype="void">
	<cfargument name="totalRecords" type="numeric" required="true">
	<cfargument name="currentPage" type="numeric" required="false" default="1">
	<cfargument name="perPage" type="numeric" required="false" default="25">
	<cfargument name="handle" type="string" required="false" default="query">
	<cfscript>
		var loc = {};

		// should be documented as a controller function but needs to be placed here because the findAll() method calls it

		// all numeric values must be integers
		arguments.totalRecords = Fix(arguments.totalRecords);
		arguments.currentPage = Fix(arguments.currentPage);
		arguments.perPage = Fix(arguments.perPage);

		// totalRecords cannot be negative
		if (arguments.totalRecords < 0)
		{
			arguments.totalRecords = 0;
		}

		// perPage less then zero
		if (arguments.perPage <= 0)
		{
			arguments.perPage = 25;
		}

		// calculate the total pages the query will have
		arguments.totalPages = Ceiling(arguments.totalRecords/arguments.perPage);

		// currentPage shouldn't be less then 1 or greater then the number of pages
		if (arguments.currentPage >= arguments.totalPages)
		{
			arguments.currentPage = arguments.totalPages;
		}
		if (arguments.currentPage < 1)
		{
			arguments.currentPage = 1;
		}

		// as a convinence for cfquery and cfloop when doing oldschool type pagination
		// startrow for cfquery and cfloop
		arguments.startRow = (arguments.currentPage * arguments.perPage) - arguments.perPage + 1;

		// maxrows for cfquery
		arguments.maxRows = arguments.perPage;

		// endrow for cfloop
		arguments.endRow = (arguments.startRow - 1) + arguments.perPage;

		// endRow shouldn't be greater then the totalRecords or less than startRow
		if (arguments.endRow >= arguments.totalRecords)
		{
			arguments.endRow = arguments.totalRecords;
		}
		if (arguments.endRow < arguments.startRow)
		{
			arguments.endRow = arguments.startRow;
		}

		loc.args = Duplicate(arguments);
		StructDelete(loc.args, "handle");
		request.wheels[arguments.handle] = loc.args;
	</cfscript>
</cffunction>

<cffunction name="controller" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="params" type="struct" required="false" default="#StructNew()#">
	<cfscript>
		var loc = {};
		loc.args = {};
		loc.args.name = arguments.name;
		loc.rv = $doubleCheckedLock(name="controllerLock#application.applicationName#", condition="$cachedControllerClassExists", execute="$createControllerClass", conditionArgs=loc.args, executeArgs=loc.args);
		if (!StructIsEmpty(arguments.params))
		{
			loc.rv = loc.rv.$createControllerObject(arguments.params);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="get" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="functionName" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		loc.appKey = $appKey();
		if (Len(arguments.functionName))
		{
			loc.rv = application[loc.appKey].functions[arguments.functionName][arguments.name];
		}
		else
		{
			loc.rv = application[loc.appKey][arguments.name];
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="model" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfreturn $doubleCheckedLock(name="modelLock#application.applicationName#", condition="$cachedModelClassExists", execute="$createModelClass", conditionArgs=arguments, executeArgs=arguments)>
</cffunction>

<cffunction name="obfuscateParam" returntype="string" access="public" output="false">
	<cfargument name="param" type="any" required="true">
	<cfscript>
		var loc = {};
		loc.rv = arguments.param;
		if (IsValid("integer", arguments.param) && IsNumeric(arguments.param) && arguments.param > 0 && Left(arguments.param, 1) != 0)
		{
			loc.iEnd = Len(arguments.param);
			loc.a = (10^loc.iEnd) + Reverse(arguments.param);
			loc.b = 0;
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.b += Left(Right(arguments.param, loc.i), 1);
			}
			if (IsValid("integer", loc.a))
			{
				loc.rv = FormatBaseN(loc.b+154, 16) & FormatBaseN(BitXor(loc.a, 461), 16);
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="deobfuscateParam" returntype="string" access="public" output="false">
	<cfargument name="param" type="string" required="true">
	<cfscript>
		var loc = {};
		if (Val(arguments.param) != arguments.param)
		{
			try
			{
				loc.checksum = Left(arguments.param, 2);
				loc.rv = Right(arguments.param, Len(arguments.param)-2);
				loc.z = BitXor(InputBasen(loc.rv, 16), 461);
				loc.rv = "";
				loc.iEnd = Len(loc.z) - 1;
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.rv &= Left(Right(loc.z, loc.i), 1);
				}
				loc.checkSumTest = 0;
				loc.iEnd = Len(loc.rv);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.checkSumTest += Left(Right(loc.rv, loc.i), 1);
				}
				loc.c1 = ToString(FormatBaseN(loc.checkSumTest+154, 10));
				loc.c2 = InputBasen(loc.checksum, 16);
				if (loc.c1 != loc.c2)
				{
					loc.rv = arguments.param;
				}
			}
			catch (any e)
			{
	    		loc.rv = arguments.param;
			}
		}
		else
		{
    		loc.rv = arguments.param;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="pluginNames" returntype="string" access="public" output="false">
	<cfreturn StructKeyList(application.wheels.plugins)>
</cffunction>

<cffunction name="URLFor" returntype="string" access="public" output="false">
	<cfargument name="route" type="string" required="false" default="">
	<cfargument name="controller" type="string" required="false" default="">
	<cfargument name="action" type="string" required="false" default="">
	<cfargument name="key" type="any" required="false" default="">
	<cfargument name="params" type="string" required="false" default="">
	<cfargument name="anchor" type="string" required="false" default="">
	<cfargument name="onlyPath" type="boolean" required="false">
	<cfargument name="host" type="string" required="false">
	<cfargument name="protocol" type="string" required="false">
	<cfargument name="port" type="numeric" required="false">
	<cfargument name="$URLRewriting" type="string" required="false" default="#application.wheels.URLRewriting#">
	<cfscript>
		var loc = {};
		$args(name="URLFor", args=arguments);
		loc.params = {};
		if (StructKeyExists(variables, "params"))
		{
			StructAppend(loc.params, variables.params);
		}
		if (application.wheels.showErrorInformation)
		{
			if (arguments.onlyPath && (Len(arguments.host) || Len(arguments.protocol) || arguments.port))
			{
				$throw(type="Wheels.IncorrectArguments", message="Can't use the `host`, `protocol` and `port` arguments when `onlyPath` is `true`.", extendedInfo="Set `onlyPath` to `false` so that absolute URLs are created, thus allowing you to set `host`, `protocol` and `port`.");
			}
		}

		// get primary key values if an object was passed in
		if (IsObject(arguments.key))
		{
			arguments.key = arguments.key.key();
		}

		// build the link (could use some refactoring, lots of duplication related to obfuscating for example)
		loc.rv = application.wheels.webPath & ListLast(request.cgi.script_name, "/");
		if (Len(arguments.route))
		{
			// link for a named route
			loc.route = $findRoute(argumentCollection=arguments);
			if (arguments.$URLRewriting == "Off")
			{
				loc.rv &= "?controller=";
				if (Len(arguments.controller))
				{
					loc.rv &= hyphenize(arguments.controller);
				}
				else
				{
					loc.rv &= hyphenize(loc.route.controller);
				}
				loc.rv &= "&action=";
				if (Len(arguments.action))
				{
					loc.rv &= hyphenize(arguments.action);
				}
				else
				{
					loc.rv &= hyphenize(loc.route.action);
				}

				// add it the format if it exists
				if (StructKeyExists(loc.route, "formatVariable") && StructKeyExists(arguments, loc.route.formatVariable))
				{
					loc.rv &= "&#loc.route.formatVariable#=#arguments[loc.route.formatVariable]#";
				}

				loc.iEnd = ListLen(loc.route.variables);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.property = ListGetAt(loc.route.variables, loc.i);
					if (loc.property != "controller" && loc.property != "action")
					{
						loc.param = $URLEncode(arguments[loc.property]);
						if (application.wheels.obfuscateUrls)
						{
							loc.param = obfuscateParam("#loc.param#");
						}
						loc.rv &= "&" & loc.property & "=" & loc.param;
					}
				}
			}
			else
			{
				loc.iEnd = ListLen(loc.route.pattern, "/");
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.property = ListGetAt(loc.route.pattern, loc.i, "/");
					if (Find("[", loc.property))
					{
						loc.property = Mid(loc.property, 2, Len(loc.property)-2);
						if (application.wheels.showErrorInformation && !StructKeyExists(arguments, loc.property))
						{
							$throw(type="Wheels", message="Incorrect Arguments", extendedInfo="The route chosen by CFWheels `#loc.route.name#` requires the argument `#loc.property#`. Pass the argument `#loc.property#` or change your routes to reflect the proper variables needed.");
						}
						loc.param = $URLEncode(arguments[loc.property]);
						if (loc.property == "controller" || loc.property == "action")
						{
							loc.param = hyphenize(loc.param);
						}
						else if (application.wheels.obfuscateUrls)
						{
							// wrap in double quotes because in railo we have to pass it in as a string otherwise leading zeros are stripped
							loc.param = obfuscateParam("#loc.param#");
						}
						loc.rv &= "/" & loc.param; // get param from arguments
					}
					else
					{
						loc.rv &= "/" & loc.property; // add hard coded param from route
					}
				}
				// add it the format if it exists
				if (StructKeyExists(loc.route, "formatVariable") && StructKeyExists(arguments, loc.route.formatVariable))
				{
					loc.rv &= ".#arguments[loc.route.formatVariable]#";
				}
			}
		}
		else
		{
			// link based on controller/action/key
			// when no controller or action was passed in we link to the current page (controller/action only, not query string etc) by default
			if (!Len(arguments.controller) && !Len(arguments.action) && StructKeyExists(loc.params, "action"))
			{
				arguments.action = loc.params.action;
			}
			if (!Len(arguments.controller) && StructKeyExists(loc.params, "controller"))
			{
				arguments.controller = loc.params.controller;
			}
			if (Len(arguments.key) && !Len(arguments.action) && StructKeyExists(loc.params, "action"))
			{
				arguments.action = loc.params.action;
			}
			loc.rv &= "?controller=" & hyphenize(arguments.controller);
			if (Len(arguments.action))
			{
				loc.rv &= "&action=" & hyphenize(arguments.action);
			}
			if (Len(arguments.key))
			{
				loc.param = $URLEncode(arguments.key);
				if (application.wheels.obfuscateUrls)
				{
					// wrap in double quotes because in railo we have to pass it in as a string otherwise leading zeros are stripped
					loc.param = obfuscateParam("#loc.param#");
				}
				loc.rv &= "&key=" & loc.param;
			}
		}

		if (arguments.$URLRewriting != "Off")
		{
			loc.rv = Replace(loc.rv, "?controller=", "/");
			loc.rv = Replace(loc.rv, "&action=", "/");
			loc.rv = Replace(loc.rv, "&key=", "/");
		}
		if (arguments.$URLRewriting == "On")
		{
			loc.rv = Replace(loc.rv, application.wheels.rewriteFile, "");
			loc.rv = Replace(loc.rv, "//", "/");
		}

		if (Len(arguments.params))
		{
			loc.rv &= $constructParams(params=arguments.params, $URLRewriting=arguments.$URLRewriting);
		}
		if (Len(arguments.anchor))
		{
			loc.rv &= "##" & arguments.anchor;
		}
		if (!arguments.onlyPath)
		{
			loc.rv = $prependUrl(path=loc.rv, argumentCollection=arguments);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="capitalize" returntype="string" access="public" output="false">
	<cfargument name="text" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = arguments.text;
		if (Len(loc.rv))
		{
			loc.rv = UCase(Left(loc.rv, 1)) & Mid(loc.rv, 2, Len(loc.rv)-1);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="humanize" returntype="string" access="public" output="false">
	<cfargument name="text" type="string" required="true">
	<cfargument name="except" type="string" required="false" default="">
	<cfscript>
		var loc = {};

		// add a space before every capitalized word
		loc.rv = REReplace(arguments.text, "([[:upper:]])", " \1", "all");

		// fix abbreviations so they form a word again (example: aURLVariable)
		loc.rv = REReplace(loc.rv, "([[:upper:]]) ([[:upper:]])(?:\s|\b)", "\1\2", "all");

		if (Len(arguments.except))
		{
			loc.iEnd = ListLen(arguments.except, " ");
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.item = ListGetAt(arguments.except, loc.i);
				loc.rv = ReReplaceNoCase(loc.rv, "#loc.item#(?:\b)", "#loc.item#", "all");
			}
		}

		// capitalize the first letter and trim final result (which removes the leading space that happens if the string starts with an upper case character)
		loc.rv = Trim(capitalize(loc.rv));
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="pluralize" returntype="string" access="public" output="false">
	<cfargument name="word" type="string" required="true">
	<cfargument name="count" type="numeric" required="false" default="-1">
	<cfargument name="returnCount" type="boolean" required="false" default="true">
	<cfreturn $singularizeOrPluralize(text=arguments.word, which="pluralize", count=arguments.count, returnCount=arguments.returnCount)>
</cffunction>

<cffunction name="singularize" returntype="string" access="public" output="false">
	<cfargument name="word" type="string" required="true">
	<cfreturn $singularizeOrPluralize(text=arguments.word, which="singularize")>
</cffunction>

<cffunction name="toXHTML" returntype="string" access="public" output="false">
	<cfargument name="text" type="string" required="true">
	<cfreturn Replace(arguments.text, "&", "&amp;", "all")>
</cffunction>

<cffunction name="mimeTypes" returntype="string" access="public" output="false">
	<cfargument name="extension" required="true" type="string">
	<cfargument name="fallback" required="false" type="string" default="application/octet-stream">
	<cfscript>
		var loc = {};
		loc.rv = arguments.fallback;
		if (StructKeyExists(application.wheels.mimetypes, arguments.extension))
		{
			loc.rv = application.wheels.mimetypes[arguments.extension];
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="hyphenize" returntype="string" access="public" output="false">
	<cfargument name="string" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = REReplace(arguments.string, "([A-Z][a-z])", "-\l\1", "all");
		loc.rv = REReplace(loc.rv, "([a-z])([A-Z])", "\1-\l\2", "all");
		loc.rv = REReplace(loc.rv, "^-", "", "one");
		loc.rv = LCase(loc.rv);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>