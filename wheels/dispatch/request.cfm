<cffunction name="$init" returntype="any" access="public" output="false">
	<cfreturn this>
</cffunction>

<cffunction name="$createParams" returntype="struct" access="public" output="false">
	<cfargument name="path" type="string" required="true">
	<cfargument name="route" type="struct" required="true">
	<cfargument name="formScope" type="struct" required="true">
	<cfargument name="urlScope" type="struct" required="true">
	<cfscript>
		var loc = {};

		loc.returnValue = $getParameterMap(argumentCollection=arguments);

		// go through the matching route pattern and add URL variables from the route to the struct
		loc.iEnd = ListLen(arguments.route.pattern, "/");
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.route.pattern, loc.i, "/");
			if (Left(loc.item, 1) == "[")
			{
				loc.returnValue[ReplaceList(loc.item, "[,]", "")] = [];
				loc.returnValue[ReplaceList(loc.item, "[,]", "")][1] = ListGetAt(arguments.path, loc.i, "/");
			}
		}

		// decrypt all values except controller and action
		if (application.wheels.obfuscateUrls)
		{
			for (loc.key in loc.returnValue)
			{
				if (loc.key != "controller" && loc.key != "action")
				{
					loc.iEnd = ArrayLen(loc.returnValue[loc.key]);
					for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
					{
						try
						{
							loc.returnValue[loc.key][loc.i] = deobfuscateParam(loc.returnValue[loc.key][loc.i]);
						}
						catch(Any e)
						{}
					}
				}
			}
		}

		if (StructCount(loc.returnValue))
		{
			// loop through form variables, merge any date variables into one, fix checkbox submissions
			loc.dates = {};
			for (loc.key in loc.returnValue)
			{
				if (FindNoCase("($checkbox)", loc.key))
				{
					// if no other form parameter exists with this name it means that the checkbox was left blank and therefore we force the value to the unchecked values for the checkbox (to get around the problem that unchecked checkboxes don't post at all)
					loc.formParamName = ReplaceNoCase(loc.key, "($checkbox)", "");
					if (!StructKeyExists(loc.returnValue, loc.formParamName))
					{
						loc.returnValue[loc.formParamName] = [];
						loc.iEnd = ArrayLen(loc.returnValue[loc.key]);
						for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
							loc.returnValue[loc.formParamName][loc.i] = loc.returnValue[loc.key][loc.i];
					}
					StructDelete(loc.returnValue, loc.key);
				}
				else if (REFindNoCase(".*\((\$year|\$month|\$day|\$hour|\$minute|\$second)\)$", loc.key))
				{
					loc.temp = ListToArray(loc.key, "(");
					loc.firstKey = loc.temp[1];
					loc.secondKey = SpanExcluding(loc.temp[2], ")");

					loc.iEnd = ArrayLen(loc.returnValue[loc.key]);
					for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
					{
						if (!StructKeyExists(loc.dates, loc.firstKey))
							loc.dates[loc.firstKey] = [];
						loc.dates[loc.firstKey][loc.i][ReplaceNoCase(loc.secondKey, "$", "")] = loc.returnValue[loc.key][loc.i];
					}
				}
			}
			for (loc.key in loc.dates)
			{
				loc.iEnd = ArrayLen(loc.dates[loc.key]);
				for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
				{
					if (!StructKeyExists(loc.dates[loc.key][loc.i], "year"))
						loc.dates[loc.key][loc.i].year = 1899;
					if (!StructKeyExists(loc.dates[loc.key][loc.i], "month"))
						loc.dates[loc.key][loc.i].month = 1;
					if (!StructKeyExists(loc.dates[loc.key][loc.i], "day"))
						loc.dates[loc.key][loc.i].day = 1;
					if (!StructKeyExists(loc.dates[loc.key][loc.i], "hour"))
						loc.dates[loc.key][loc.i].hour = 0;
					if (!StructKeyExists(loc.dates[loc.key][loc.i], "minute"))
						loc.dates[loc.key][loc.i].minute = 0;
					if (!StructKeyExists(loc.dates[loc.key][loc.i], "second"))
						loc.dates[loc.key][loc.i].second = 0;
					if (!StructKeyExists(loc.returnValue, loc.key) || !IsArray(loc.returnValue[loc.key]))
						loc.returnValue[loc.key] = [];
					try
					{
						loc.returnValue[loc.key][loc.i] = CreateDateTime(loc.dates[loc.key][loc.i].year, loc.dates[loc.key][loc.i].month, loc.dates[loc.key][loc.i].day, loc.dates[loc.key][loc.i].hour, loc.dates[loc.key][loc.i].minute, loc.dates[loc.key][loc.i].second);
					}
					catch(Any e)
					{
						loc.returnValue[loc.key][loc.i] = "";
					}
				}
				if (StructKeyExists(loc.returnValue, "#loc.key#($year)"))
					StructDelete(loc.returnValue, "#loc.key#($year)");
				if (StructKeyExists(loc.returnValue, "#loc.key#($month)"))
					StructDelete(loc.returnValue, "#loc.key#($month)");
				if (StructKeyExists(loc.returnValue, "#loc.key#($day)"))
					StructDelete(loc.returnValue, "#loc.key#($day)");
				if (StructKeyExists(loc.returnValue, "#loc.key#($hour)"))
					StructDelete(loc.returnValue, "#loc.key#($hour)");
				if (StructKeyExists(loc.returnValue, "#loc.key#($minute)"))
					StructDelete(loc.returnValue, "#loc.key#($minute)");
				if (StructKeyExists(loc.returnValue, "#loc.key#($second)"))
					StructDelete(loc.returnValue, "#loc.key#($second)");
			}
			// add form variables to the params struct
			$createNestedParamStruct(params=loc.returnValue);
			// find any new structs and convert them
			$createNewArrayStruct(params=loc.returnValue);
		}

		/************************************
		*	We now do the routing and controller
		*	params after we have built all other params
		*	so that we don't have more logic around
		*	params in arrays
		************************************/

		// add controller and action unless they already exist
		if (!StructKeyExists(loc.returnValue, "controller"))
			loc.returnValue.controller = arguments.route.controller;
		if (!StructKeyExists(loc.returnValue, "action"))
			loc.returnValue.action = arguments.route.action;

		// convert controller to upperCamelCase and action to normal camelCase
		loc.returnValue.controller = REReplace(loc.returnValue.controller, "-([a-z])", "\u\1", "all");
		loc.returnValue.action = REReplace(loc.returnValue.action, "-([a-z])", "\u\1", "all");

		// add name of route to params if a named route is running
		if (StructKeyExists(arguments.route, "name") && Len(arguments.route.name) && !StructKeyExists(loc.returnValue, "route"))
			loc.returnValue.route = arguments.route.name;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$getParameterMap" returntype="struct" access="public" output="false">
	<cfargument name="formScope" type="struct" required="true">
	<cfargument name="urlScope" type="struct" required="true">
	<cfargument name="parameters" type="struct" required="false" default="#Duplicate(GetPageContext().getRequest().getParameterMap())#">
	<cfargument name="multipart" type="any" required="false" default="#$multipartData()#">
	<cfscript>
		var loc = {};
		loc.original = {};
		loc.multipart = {};
		loc.parameters = {};
		// merge our coldfusion scopes together
		loc.original = Duplicate(arguments.formScope);
		StructDelete(loc.original, "fieldnames", false);
		StructAppend(loc.original, arguments.urlScope, true);
		// if the form our url scopes were set after the request started, we need to make sure that they are in arrays
		for (loc.item in loc.original)
		{
			loc.parameters[loc.item] = [];
			ArrayAppend(loc.parameters[loc.item], loc.original[loc.item]);
		}
		// get our values from the parameter map, this will always contain url variables and will contain form parameters when not a multipart form
		for (loc.item in arguments.parameters)
		{
			loc.parameters[loc.item] = [];
			loc.iEnd = ArrayLen(arguments.parameters[loc.item]);
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
				loc.parameters[loc.item][loc.i] = arguments.parameters[loc.item][loc.i];
		}
		// if this is defined, then we have a multipart for and will be getting our form values from here
		if (!ArrayIsEmpty(arguments.multipart))
		{
			// build our multipart struct
			loc.iEnd = ArrayLen(arguments.multipart);
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
			{
				loc.param = arguments.multipart[loc.i];
				if (!StructKeyExists(loc.multipart, loc.param.key))
					loc.multipart[loc.param.key] = [];
				ArrayAppend(loc.multipart[loc.param.key], loc.param.value);
			}

			// now overwrite our parameters with the multipart values
			for (loc.item in loc.multipart)
				loc.parameters[loc.item] = loc.multipart[loc.item];
		}
		// overwrite any parameters in our map with the right values from the url
		for (loc.item in arguments.urlScope)
		{
			loc.parameters[loc.item] = [];
			ArrayAppend(loc.parameters[loc.item], arguments.urlScope[loc.item]);
		}
	</cfscript>
	<cfreturn loc.parameters />
</cffunction>

<cffunction name="$createNestedParamStruct" returntype="struct" access="public" output="false">
	<cfargument name="params" type="struct" required="true" />
	<cfscript>
		var loc = {};
		for (loc.key in arguments.params)
		{
			if (Find("[", loc.key) && Right(loc.key, 1) == "]")
			{
				// object form field
				loc.name = SpanExcluding(loc.key, "[");
				// we split the key into an array so the developer can have multiple levels of params passed in
				loc.nested = ListToArray(ReplaceList(loc.key, loc.name & "[,]", ""), "[", true);
				if (!StructKeyExists(arguments.params, loc.name))
					arguments.params[loc.name] = {};
				loc.struct = arguments.params[loc.name]; // we need a reference to the struct so we can nest other structs if needed
				loc.iEnd = ArrayLen(loc.nested);
				for (loc.i = 1; loc.i lte loc.iEnd; loc.i++) // looping over the array allows for infinite nesting
				{
					loc.item = loc.nested[loc.i];
					if (!Len(loc.item)) // if we have an empty struct item it means that the developer is passing in new items
						loc.item = "new";
					if (!StructKeyExists(loc.struct, loc.item))
						loc.struct[loc.item] = {};
					if (loc.i != loc.iEnd)
						loc.struct = loc.struct[loc.item]; // pass the new reference (structs pass a reference instead of a copy) to the next iteration
					else if (IsArray(arguments.params[loc.key]) && ArrayLen(arguments.params[loc.key]) == 1)
						loc.struct[loc.item] = arguments.params[loc.key][1];
					else if (IsArray(arguments.params[loc.key]))
						loc.struct[loc.item] = $arrayToStruct(arguments.params[loc.key]);
					else
						loc.struct[loc.item] = arguments.params[loc.key];
				}
				// delete the original key so it doesn't show up in the params
				StructDelete(arguments.params, loc.key, false);
			}
			else if (IsArray(arguments.params[loc.key]) && ArrayLen(arguments.params[loc.key]) == 1)
				arguments.params[loc.key] = arguments.params[loc.key][1];
		}
	</cfscript>
	<cfreturn arguments.params />
</cffunction>

<cffunction name="$createNewArrayStruct" returntype="void" access="public" output="false">
	<cfargument name="params" type="struct" required="true" />
	<cfscript>
		var loc = {};

		loc.newStructArray = StructFindKey(arguments.params, "new", "all");
		loc.iEnd = ArrayLen(loc.newStructArray);

		for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
		{
			loc.owner = loc.newStructArray[loc.i].owner.new;
			loc.value = loc.newStructArray[loc.i].value;
			loc.map = {};
			$mapStruct(map=loc.map, struct=loc.value);

			StructClear(loc.value); // clear the struct now that we have our paths and values

			for (loc.item in loc.map) // remap our new struct
			{
				// move the last element to the first
				loc.newPos = loc.item;
				loc.last = Replace(ListLast(loc.newPos, "["), "]", "");
				if (IsNumeric(loc.last))
				{
					loc.newPos = ListDeleteAt(loc.newPos, ListLen(loc.newPos, "["), "[");
					loc.newPos = ListPrepend(loc.newPos, "[" & loc.last, "]");
				}
				else
				{
					loc.newPos = ListPrepend(loc.newPos, "[1", "]");
				}
				loc.map[loc.item].newPos = ListToArray(Replace(loc.newPos, "]", "", "all"), "[", false);

				// loop through the position array and build our new struct
				loc.struct = loc.value;
				loc.jEnd = ArrayLen(loc.map[loc.item].newPos);
				for (loc.j = 1; loc.j lte loc.jEnd; loc.j++)
				{
					if (!StructKeyExists(loc.struct, loc.map[loc.item].newPos[loc.j]))
						loc.struct[loc.map[loc.item].newPos[loc.j]] = {};
					if (loc.j != loc.jEnd)
						loc.struct = loc.struct[loc.map[loc.item].newPos[loc.j]];
					else
						loc.struct[loc.map[loc.item].newPos[loc.j]] = loc.map[loc.item].value;
				}
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$findMatchingRoute" returntype="struct" access="public" output="false">
	<cfargument name="path" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.iEnd = ArrayLen(application.wheels.routes);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.currentRoute = application.wheels.routes[loc.i].pattern;
			if (arguments.path == "" && loc.currentRoute == "")
			{
				loc.returnValue = application.wheels.routes[loc.i];
				break;
			}
			else
			{
				if (ListLen(arguments.path, "/") >= ListLen(loc.currentRoute, "/") && loc.currentRoute != "")
				{
					loc.match = true;
					loc.jEnd = ListLen(loc.currentRoute, "/");
					for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
					{
						loc.item = ListGetAt(loc.currentRoute, loc.j, "/");
						loc.thisRoute = ReplaceList(loc.item, "[,]", ",");
						loc.thisURL = ListGetAt(arguments.path, loc.j, "/");
						if (Left(loc.item, 1) != "[" && loc.thisRoute != loc.thisURL)
							loc.match = false;
					}
					if (loc.match)
					{
						loc.returnValue = application.wheels.routes[loc.i];
						break;
					}
				}
			}
		}
		if (!StructKeyExists(loc, "returnValue"))
			$throw(type="Wheels.RouteNotFound", message="Wheels couldn't find a route that matched this request.", extendedInfo="Make sure there is a route setup in your `config/routes.cfm` file that matches the `#arguments.path#` request.");
		</cfscript>
		<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$getPathFromRequest" returntype="string" access="public" output="false">
	<cfargument name="pathInfo" type="string" required="true">
	<cfargument name="scriptName" type="string" required="true">
	<cfscript>
		var returnValue = "";
		// we want the path without the leading "/" so this is why we do some checking here
		if (arguments.pathInfo == arguments.scriptName || arguments.pathInfo == "/" || arguments.pathInfo == "")
			returnValue = "";
		else
			returnValue = Right(arguments.pathInfo, Len(arguments.pathInfo)-1);
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$request" returntype="string" access="public" output="false">
	<cfargument name="pathInfo" type="string" required="false" default="#request.cgi.path_info#">
	<cfargument name="scriptName" type="string" required="false" default="#request.cgi.script_name#">
	<cfargument name="formScope" type="struct" required="false" default="#form#">
	<cfargument name="urlScope" type="struct" required="false" default="#url#">
	<cfscript>
		var loc = {};
		if (application.wheels.showDebugInformation)
			$debugPoint("setup");

		// determine the path from the url, find a matching route for it and create the params struct
		loc.path = $getPathFromRequest(pathInfo=arguments.pathInfo, scriptName=arguments.scriptName);
		loc.route = $findMatchingRoute(path=loc.path);
		loc.params = $createParams(path=loc.path, route=loc.route, formScope=arguments.formScope, urlScope=arguments.urlScope);

		// set params in the request scope as well so we can display it in the debug info outside of the dispatch / controller context
		request.wheels.params = loc.params;

		if (application.wheels.showDebugInformation)
			$debugPoint("setup");

		// create the requested controller
		loc.controller = $controller(loc.params.controller).$createControllerObject(loc.params);
		loc.controller.$processAction();

		// if there is a delayed redirect pending we execute it here thus halting the rest of the request
		if (StructKeyExists(request.wheels, "redirect"))
			$location(argumentCollection=request.wheels.redirect);

		// clear out the flash (note that this is not done for redirects since the processing does not get here)
		loc.controller.flashClear();
	</cfscript>
	<cfreturn Trim(request.wheels.response)>
</cffunction>

<cffunction name="$multipartData" returntype="array" access="public" output="false"
	hint="returns an array of raw multipart form parts. each element in the array contains a struct with a 'key' and 'value' element.">
	<cfset var loc = {}>
	<cfset loc.data = []>

	<!---
	Railo always has the form.getRaw() even if the form is not multipart.
	Exit if the form post wasn't multipart
	 --->
	<cfif ListFirst(request.cgi.content_type, ";") neq "multipart/form-data">
		<cfreturn loc.data>
	</cfif>

	<cfif StructKeyExists(server, "railo")>
		<cfloop array="#form.getRaw()#" index="loc.i">
			<cfset loc.t = {key = loc.i.getName(), value = loc.i.getValue()}>
			<cfset arrayappend(loc.data, loc.t)>
		</cfloop>
	<cfelse>
		<cfloop array="#form.getPartsArray()#" index="loc.i">
			<cfif loc.i.isParam()>
				<cfset loc.t = {key = loc.i.getName(), value = loc.i.getStringValue()}>
				<cfset arrayappend(loc.data, loc.t)>
			</cfif>
		</cfloop>
	</cfif>
	<cfreturn loc.data>
</cffunction>