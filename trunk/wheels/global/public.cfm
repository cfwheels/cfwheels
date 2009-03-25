<cffunction name="set" returntype="void" access="public" output="false" hint="Use to configure a global setting.">
	<cfscript>
		var loc = {};
		if (ArrayLen(arguments) == 2)
		{
			for (loc.key in arguments)
			{
				if (loc.key != "functionName")
					loc.insKey = loc.key;
			}
			application.wheels[arguments.functionName][loc.insKey] = arguments[loc.insKey];
		}	
		else
		{
			application.wheels[StructKeyList(arguments)] = arguments[1];
		}	
	</cfscript>
</cffunction>

<cffunction name="get" returntype="any" access="public" output="false" hint="Returns the current setting for the supplied variable name.">
	<cfargument name="name" type="string" required="true" hint="Variable name to get setting for">
	<cfargument name="functionName" type="string" required="false" default="" hint="Function name to get setting for">
	<cfscript>
		var loc = {};
		if (Len(arguments.functionName))
			loc.returnValue = application.wheels[arguments.functionName][arguments.name];
		else
			loc.returnValue = application.wheels[arguments.name];
	</cfscript>
	<cfreturn loc.returnValue>	
</cffunction>

<cffunction name="URLFor" returntype="string" access="public" output="false" hint="Creates an internal URL based on supplied arguments.">
	<cfargument name="route" type="string" required="false" default="" hint="Name of a route that you have configured in 'config/routes.cfm'">
	<cfargument name="controller" type="string" required="false" default="" hint="Name of the controller to include in the URL">
	<cfargument name="action" type="string" required="false" default="" hint="Name of the action to include in the URL">
	<cfargument name="key" type="any" required="false" default="" hint="Key(s) to include in the URL">
	<cfargument name="params" type="string" required="false" default="" hint="Any additional params to be set in the query string">
	<cfargument name="anchor" type="string" required="false" default="" hint="Sets an anchor name to be appended to the path">
	<cfargument name="onlyPath" type="boolean" required="false" default="#application.wheels.URLFor.onlyPath#" hint="If true, returns only the relative URL (no protocol, host name or port)">
	<cfargument name="host" type="string" required="false" default="#application.wheels.URLFor.host#" hint="Set this to override the current host">
	<cfargument name="protocol" type="string" required="false" default="#application.wheels.URLFor.protocol#" hint="Set this to override the current protocol">
	<cfargument name="port" type="numeric" required="false" default="#application.wheels.URLFor.port#" hint="Set this to override the current port number">
	<cfscript>
		var loc = {};
		if (application.wheels.environment != "production")
		{
			if (!Len(arguments.route) && !Len(arguments.controller) && !Len(arguments.action))
				$throw(type="Wheels.IncorrectArguments", message="The 'route', 'controller' or 'action' argument is required.", extendedInfo="Pass in either the name of a 'route' you have configured in 'confirg/routes.cfm' or a 'controller' / 'action' / 'key' combination.");
			if (Len(arguments.route) && (Len(arguments.controller) || Len(arguments.action) || (IsObject(arguments.key) || Len(arguments.key))))
				$throw(type="Wheels.IncorrectArguments", message="The 'route' argument is mutually exclusive with the 'controller', 'action' and 'key' arguments.", extendedInfo="Choose whether to use a pre-configured 'route' or 'controller' / 'action' / 'key' combination.");
			if (arguments.onlyPath && (Len(arguments.host) || Len(arguments.protocol)))
				$throw(type="Wheels.IncorrectArguments", message="Can't use the 'host' or 'protocol' arguments when 'onlyPath' is 'true'.", extendedInfo="Set 'onlyPath' to 'false' so that linkTo will create absolute URLs and thus allowing you to set the 'host' and 'protocol' on the link.");
		}
		// get primary key values if an object was passed in
		if (IsObject(arguments.key))
		{
			arguments.key = arguments.key.key();
		}
		
		// build the link
		loc.returnValue = application.wheels.webPath & ListLast(cgi.script_name, "/");
		if (Len(arguments.route))
		{
			// link for a named route
			loc.route = application.wheels.routes[application.wheels.namedRoutePositions[arguments.route]];
			if (application.wheels.URLRewriting == "Off")
			{
				loc.returnValue = loc.returnValue & "?controller=" & REReplace(REReplace(loc.route.controller, "([A-Z])", "-\l\1", "all"), "^-", "", "one");
				loc.returnValue = loc.returnValue & "&action=" & REReplace(REReplace(loc.route.action, "([A-Z])", "-\l\1", "all"), "^-", "", "one");
				loc.iEnd = ListLen(loc.route.variables);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.property = ListGetAt(loc.route.variables, loc.i);
					loc.returnValue = loc.returnValue & "&" & loc.property & "=" & URLEncodedFormat(arguments[loc.property]);
				}		
			}
			else
			{
				loc.iEnd = ListLen(loc.route.pattern, "/");
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.property = ListGetAt(loc.route.pattern, loc.i, "/");
					if (loc.property Contains "[")
						loc.returnValue = loc.returnValue & "/" & URLEncodedFormat(arguments[Mid(loc.property, 2, Len(loc.property)-2)]); // get param from arguments
					else
						loc.returnValue = loc.returnValue & "/" & loc.property; // add hard coded param from route
				}		
			}
		}
		else
		{
			// link based on controller/action/key
			if (Len(arguments.controller))
				loc.returnValue = loc.returnValue & "?controller=" & REReplace(REReplace(arguments.controller, "([A-Z])", "-\l\1", "all"), "^-", "", "one"); // add controller from arguments
			else
				loc.returnValue = loc.returnValue & "?controller=" & REReplace(REReplace(variables.params.controller, "([A-Z])", "-\l\1", "all"), "^-", "", "one"); // keep the controller name from the current request
			if (Len(arguments.action))
				loc.returnValue = loc.returnValue & "&action=" & REReplace(REReplace(arguments.action, "([A-Z])", "-\l\1", "all"), "^-", "", "one");
			if (Len(arguments.key))
			{
				if (application.wheels.obfuscateUrls)
					loc.returnValue = loc.returnValue & "&key=" & obfuscateParam(URLEncodedFormat(arguments.key));
				else
					loc.returnValue = loc.returnValue & "&key=" & URLEncodedFormat(arguments.key);
			}
		}

		if (application.wheels.URLRewriting != "Off")
		{
			loc.returnValue = Replace(loc.returnValue, "?controller=", "/");
			loc.returnValue = Replace(loc.returnValue, "&action=", "/");
			loc.returnValue = Replace(loc.returnValue, "&key=", "/");
		}
		if (application.wheels.URLRewriting == "On")
		{
			loc.returnValue = Replace(loc.returnValue, "rewrite.cfm", "");
			loc.returnValue = Replace(loc.returnValue, "//", "");
		}

		if (Len(arguments.params))
			loc.returnValue = loc.returnValue & $constructParams(arguments.params);
		if (Len(arguments.anchor))
			loc.returnValue = loc.returnValue & "##" & arguments.anchor;
				
		if (!arguments.onlyPath)
		{
			if (arguments.port != 0)
				loc.returnValue = ":" & arguments.port & loc.returnValue;
			else if (cgi.server_port != 80)
				loc.returnValue = ":" & cgi.server_port & loc.returnValue;
			if (Len(arguments.host))
				loc.returnValue = arguments.host & loc.returnValue;
			else
				loc.returnValue = cgi.server_name & loc.returnValue;
			if (Len(arguments.protocol))
				loc.returnValue = arguments.protocol & "://" & loc.returnValue;
			else
				loc.returnValue = SpanExcluding(cgi.server_protocol, "/") & "://" & loc.returnValue;
		}
		loc.returnValue = LCase(loc.returnValue);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="obfuscateParam" returntype="string" access="public" output="false" hint="Obfuscates a value.">
	<cfargument name="param" type="any" required="true" hint="Value to obfuscate">
	<cfscript>
		var loc = {};
		if (IsValid("integer", arguments.param) && IsNumeric(arguments.param) && arguments.param > 0)
		{
			loc.length = Len(arguments.param);
			loc.a = (10^loc.length) + Reverse(arguments.param);
			loc.b = "0";
			for (loc.i=1; loc.i <= loc.length; loc.i++)
				loc.b = (loc.b + Left(Right(arguments.param, loc.i), 1));
			loc.returnValue = FormatBaseN((loc.b+154),16) & FormatBaseN(BitXor(loc.a,461),16);
		}
		else
		{
			loc.returnValue = arguments.param;
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="deobfuscateParam" returntype="string" access="public" output="false" hint="Deobfuscates a value.">
	<cfargument name="param" type="string" required="true" hint="Value to deobfuscate">
	<cfscript>
		var loc = {};
		if (Val(arguments.param) != arguments.param)
		{
			try
			{
				loc.checksum = Left(arguments.param, 2);
				loc.returnValue = Right(arguments.param, (Len(arguments.param)-2));
				loc.z = BitXor(InputBasen(loc.returnValue,16),461);
				loc.returnValue = "";
				for (loc.i=1; loc.i <= Len(loc.z)-1; loc.i++)
					loc.returnValue = loc.returnValue & Left(Right(loc.z, loc.i),1);
				loc.checksumtest = "0";
				for (loc.i=1; loc.i <= Len(loc.returnValue); loc.i++)
					loc.checksumtest = (loc.checksumtest + Left(Right(loc.returnValue, loc.i),1));
				if (Left(ToString(FormatBaseN((loc.checksumtest+154),10)),2) != Left(InputBasen(loc.checksum, 16),2))
					loc.returnValue = arguments.param;
			}
			catch(Any e)
			{
	    	loc.returnValue = arguments.param;
			}
		}
		else
		{
    	loc.returnValue = arguments.param;
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="addRoute" returntype="void" access="public" output="false" hint="Adds a new route to your application.">
	<cfargument name="name" type="string" required="true" hint="Name for the route">
	<cfargument name="pattern" type="string" required="true" hint="The URL pattern for the route">
	<cfargument name="controller" type="string" required="false" default="" hint="Controller to call when route matches (unless the controller name exists in the pattern)">
	<cfargument name="action" type="string" required="false" default="" hint="Action to call when route matches (unless the action name exists in the pattern)">
	<cfscript>
		var loc = {};
		
		// throw errors when controller or action is not passed in as arguments and not included in the pattern
		if (!Len(arguments.controller) && arguments.pattern Does Not Contain "[controller]")
			$throw(type="Wheels.IncorrectArguments", message="The 'controller' argument is not passed in or included in the pattern.", extendedInfo="Either pass in the 'controller' argument to specifically tell Wheels which controller to call or include it in the pattern to tell Wheels to determine it dynamically on each request based on the incoming URL.");
		if (!Len(arguments.action) && arguments.pattern Does Not Contain "[action]")
			$throw(type="Wheels.IncorrectArguments", message="The 'action' argument is not passed in or included in the pattern.", extendedInfo="Either pass in the 'action' argument to specifically tell Wheels which action to call or include it in the pattern to tell Wheels to determine it dynamically on each request based on the incoming URL.");
		
		loc.thisRoute = StructCopy(arguments);
		loc.thisRoute.variables = "";
		loc.iEnd = ListLen(arguments.pattern, "/");
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.pattern, loc.i, "/");
			if (loc.i Contains "[")
				loc.thisRoute.variables = ListAppend(loc.thisRoute.variables, ReplaceList(loc.item, "[,]", ","));
		}
		ArrayAppend(application.wheels.routes, loc.thisRoute);
	</cfscript>
</cffunction>

<cffunction name="model" returntype="any" access="public" output="false" hint="Returns a reference to the requested model so that class level methods can be called on it.">
	<cfargument name="name" type="string" required="true" hint="Name of the model (class name) to get a reference to">
	<cfscript>
		loc.args.name = arguments.name;
		loc.returnValue = $doubleCheckedLock(name="modelLock", condition="$cachedModelClassExists", execute="$createModelClass", conditionArgs=loc.args, executeArgs=loc.args);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="pluginNames" returntype="string" access="public" output="false" hint="Returns a list of all installed plugins.">
	<cfreturn StructKeyList(application.wheels.plugins)>
</cffunction>