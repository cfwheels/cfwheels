<!--- PUBLIC CONFIGURATION FUNCTIONS --->

<cffunction name="addRoute" returntype="void" access="public" output="false" hint="Adds a new route to your application."
	examples=
	'
		<!--- Adds a route which will invoke the `profile` action on the `user` controller with `params.userName` set when the URL matches the `pattern` argument --->
		<cfset addRoute(name="userProfile", pattern="user/[username]", controller="user", action="profile")>
	'
	categories="configuration" chapters="using-routes" functions="">
	<cfargument name="name" type="string" required="false" default="" hint="Name for the route.">
	<cfargument name="pattern" type="string" required="true" hint="The URL pattern for the route.">
	<cfargument name="controller" type="string" required="false" default="" hint="Controller to call when route matches (unless the controller name exists in the pattern).">
	<cfargument name="action" type="string" required="false" default="" hint="Action to call when route matches (unless the action name exists in the pattern).">
	<cfscript>
		var loc = {};

		// throw errors when controller or action is not passed in as arguments and not included in the pattern
		if (!Len(arguments.controller) && arguments.pattern Does Not Contain "[controller]")
			$throw(type="Wheels.IncorrectArguments", message="The `controller` argument is not passed in or included in the pattern.", extendedInfo="Either pass in the `controller` argument to specifically tell Wheels which controller to call or include it in the pattern to tell Wheels to determine it dynamically on each request based on the incoming URL.");
		if (!Len(arguments.action) && arguments.pattern Does Not Contain "[action]")
			$throw(type="Wheels.IncorrectArguments", message="The `action` argument is not passed in or included in the pattern.", extendedInfo="Either pass in the `action` argument to specifically tell Wheels which action to call or include it in the pattern to tell Wheels to determine it dynamically on each request based on the incoming URL.");

		loc.thisRoute = Duplicate(arguments);
		loc.thisRoute.variables = "";
		loc.iEnd = ListLen(arguments.pattern, "/");
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.pattern, loc.i, "/");
			if (loc.item Contains "[")
				loc.thisRoute.variables = ListAppend(loc.thisRoute.variables, ReplaceList(loc.item, "[,]", ","));
		}
		ArrayAppend(application.wheels.routes, loc.thisRoute);
	</cfscript>
</cffunction>

<cffunction name="addDefaultRoutes" returntype="void" access="public" output="false" hint="Adds the default Wheels routes to your application. Only use this method if you have set `loadDefaultRoutes` to `false` and want to control exactly where in the route order you want to place the default routes."
	examples=
	'
		<!--- Adds the default routes to your application (done in "routes.cfm") --->
		<cfset addDefaultRoutes()>
	'
	categories="configuration" chapters="using-routes" functions="">
	<cfscript>
		addRoute(pattern="[controller]/[action]/[key]");
		addRoute(pattern="[controller]/[action]");
		addRoute(pattern="[controller]", action="index");
	</cfscript>
</cffunction>

<cffunction name="set" returntype="void" access="public" output="false" hint="Use to configure a global setting or set a default for a function."
	examples=
	'
		<!--- URL rewriting setting (determined and set automatically by Wheels, override it by setting it to "On", "Off" or "Partial") --->
		<cfset set(URLRewriting="Partial")>

		<!--- Database settings  --->
		<cfset set(dataSourceName = "")> <!--- set automatically by Wheels to the same name as the folder the application resides, override it by setting `dataSourceName` --->
		<cfset set(dataSourceUserName = "")>
		<cfset set(dataSourcePassword ="")>

		<!--- Caching settings --->
		<cfset set(cacheDatabaseSchema = false)>
		<cfset set(cacheFileChecking = false)>
		<cfset set(cacheImages = false)>
		<cfset set(cacheModelInitialization = false)>
		<cfset set(cacheControllerInitialization = false)>
		<cfset set(cacheRoutes = false)>
		<cfset set(cacheActions = false)>
		<cfset set(cachePages = false)>
		<cfset set(cachePartials = false)>
		<cfset set(cacheQueries = false)>
		<cfset set(maximumItemsToCache = 5000)>
		<cfset set(cacheCullPercentage = 10)>
		<cfset set(cacheCullInterval = 5)>
		<cfset set(defaultCacheTime = 60)>

		<!--- Error and debugging settings --->
		<cfset set(showDebugInformation = true)>
		<cfset set(showErrorInformation = true)>
		<cfset set(sendEmailOnError = false)>
		<cfset set(errorEmailAddress = "")>
		<cfset set(errorEmailSubject = "")>
		<cfset set(errorEmailServer = "")>

		<!--- Miscellaneous settings --->
		<cfset set(tableNamePrefix = "")>
		<cfset set(obfuscateURLs = false)>
		<cfset set(reloadPassword = "")>
		<cfset set(ipExceptions = "")>
		<cfset set(softDeleteProperty = "deletedAt")>
		<cfset set(timeStampOnCreateProperty = "createdAt")>
		<cfset set(timeStampOnUpdateProperty = "updatedAt")>
		<cfset set(overwritePlugins = true)>
		<cfset set(deletePluginDirectories = true)>

		<!--- Function defaults --->
		<cfset set(functionName="average", distinct=false)>
		<cfset set(functionName="buttonTo", onlyPath=true, host="", protocol="", port=0, text="", confirm="", image="", disable="")>
		<cfset set(functionName="caches", time=60)>
		<cfset set(functionName="checkBox", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", checkedValue=1, unCheckedValue=0)>
		<cfset set(functionName="checkBoxTag", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", value=1)>
		<cfset set(functionName="dateSelect", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", includeBlank=false, order="month,day,year", separator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names")>
		<cfset set(functionName="dateSelectTags", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, order="month,day,year", separator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names")>
		<cfset set(functionName="dateTimeSelect", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", includeBlank=false, dateOrder="month,day,year", dateSeparator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names", timeOrder="hour,minute,second", timeSeparator=":", minuteStep=1, separator=" - ")>
		<cfset set(functionName="dateTimeSelectTags", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, dateOrder="month,day,year", dateSeparator=" ", startYear=Year(Now())-5, endYear=Year(Now())+5, monthDisplay="names", timeOrder="hour,minute,second", timeSeparator=":", minuteStep=1, separator=" - ")>
		<cfset set(functionName="daySelectTag", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false)>
		<cfset set(functionName="delete", parameterize=true)>
		<cfset set(functionName="deleteAll", parameterize=true, instantiate=false)>
		<cfset set(functionName="distanceOfTimeInWords", includeSeconds=false)>
		<cfset set(functionName="errorMessageOn", prependText="", appendText="", wrapperElement="span", class="error-message")>
		<cfset set(functionName="errorMessagesFor", class="error-messages", showDuplicates=true)>
		<cfset set(functionName="exists", reload=false, parameterize=true)>
		<cfset set(functionName="fileField", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span")>
		<cfset set(functionName="fileFieldTag", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="")>
		<cfset set(functionName="findAll", reload=false, parameterize=true, perPage=10, order="")>
		<cfset set(functionName="findByKey", reload=false, parameterize=true)>
		<cfset set(functionName="findOne", reload=false, parameterize=true)>
		<cfset set(functionName="hiddenField", )>
		<cfset set(functionName="hourSelectTag", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false)>
		<cfset set(functionName="imageTag", )>
		<cfset set(functionName="javaScriptIncludeTag", type="text/javascript")>
		<cfset set(functionName="linkTo", onlyPath=true, host="", protocol="", port=0)>
		<cfset set(functionName="mailTo", encode=false)>
		<cfset set(functionName="minuteSelectTag", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, minuteStep=1)>
		<cfset set(functionName="monthSelectTag", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, monthDisplay="names")>
		<cfset set(functionName="paginationLinks", windowSize=2, alwaysShowAnchors=true, anchorDivider=" ... ", linkToCurrentPage=false, prependToLink="", appendToLink="", classForCurrent="", name="page")>
		<cfset set(functionName="passwordField", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span")>
		<cfset set(functionName="passwordFieldTag", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="")>
		<cfset set(functionName="radioButton", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span")>
		<cfset set(functionName="radioButtonTag", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="")>
		<cfset set(functionName="redirectTo", onlyPath=true, host="", protocol="", port=0, addToken=false, statusCode=302)>
		<cfset set(functionName="renderPage", layout=true)>
		<cfset set(functionName="renderPageToString", layout=true)>
		<cfset set(functionName="save", parameterize=true)>
		<cfset set(functionName="secondSelectTag", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false)>
		<cfset set(functionName="select", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", includeBlank=false, multiple=false, valueField="", textField="")>
		<cfset set(functionName="selectTag", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, multiple=false, valueField="", textField="")>
		<cfset set(functionName="sendEmail", layout=false, detectMultipart=true)>
		<cfset set(functionName="sendFile", disposition="attachment")>
		<cfset set(functionName="startFormTag", onlyPath=true, host="", protocol="", port=0, method="post", multipart=false, spamProtection=false)>
		<cfset set(functionName="styleSheetLinkTag", type="text/css", media="all")>
		<cfset set(functionName="submitTag", value="Save changes", image="", disable="")>
		<cfset set(functionName="sum", distinct=false)>
		<cfset set(functionName="textArea", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span")>
		<cfset set(functionName="textAreaTag", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="")>
		<cfset set(functionName="textField", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span")>
		<cfset set(functionName="textFieldTag", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="")>
		<cfset set(functionName="timeAgoInWords", includeSeconds=false)>
		<cfset set(functionName="timeSelect", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", errorElement="span", includeBlank=false, order="hour,minute,second", separator=":", minuteStep=1)>
		<cfset set(functionName="timeSelectTags", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, order="hour,minute,second", separator=":", minuteStep=1)>
		<cfset set(functionName="timeUntilInWords", includeSeconds=false)>
		<cfset set(functionName="update", parameterize=true)>
		<cfset set(functionName="updateAll", parameterize=true, instantiate=false)>
		<cfset set(functionName="URLFor", onlyPath=true, host="", protocol="", port=0)>
		<cfset set(functionName="validatesConfirmationOf", message="[property] should match confirmation")>
		<cfset set(functionName="validatesExclusionOf", message="[property] is reserved", allowBlank=false)>
		<cfset set(functionName="validatesFormatOf", message="[property] is invalid", allowBlank=false)>
		<cfset set(functionName="validatesInclusionOf", message="[property] is not included in the list", allowBlank=false)>
		<cfset set(functionName="validatesLengthOf", message="[property] is the wrong length", allowBlank=false, exactly=0, maximum=0, minimum=0, within="")>
		<cfset set(functionName="validatesNumericalityOf", message="[property] is not a number", allowBlank=false, onlyInteger=false)>
		<cfset set(functionName="validatesPresenceOf", message="[property] can''t be empty")>
		<cfset set(functionName="validatesUniquenessOf", message="[property] has already been taken")>
		<cfset set(functionName="verifies", handler=false)>
		<cfset set(functionName="yearSelectTag", label="", wrapLabel=true, prepend="", append="", prependToLabel="", appendToLabel="", includeBlank=false, startYear=Year(Now())-5, endYear=Year(Now())+5)>
	'
	categories="configuration" chapters="configuration-and-defaults" functions="get">
	<cfscript>
		var loc = {};
		if (ArrayLen(arguments) > 1)
		{
			for (loc.key in arguments)
			{
				if (loc.key != "functionName")
					for (loc.i = 1; loc.i lte listlen(arguments.functionName); loc.i = loc.i + 1) {
						application.wheels.functions[Trim(ListGetAt(arguments.functionName, loc.i))][loc.key] = arguments[loc.key];
					}
			}
		}
		else
		{
			application.wheels[StructKeyList(arguments)] = arguments[1];
		}
	</cfscript>
</cffunction>

<!--- PUBLIC GLOBAL FUNCTIONS --->

<!--- miscellaneous --->

<cffunction name="deobfuscateParam" returntype="string" access="public" output="false" hint="Deobfuscates a value."
	examples=
	'
		<!--- Get the original value from an obfuscated one --->
		<cfset originalValue = deobfuscateParam("b7ab9a50")>
	'
	categories="global,miscellaneous" chapters="obfuscating-urls" functions="obfuscateParam">
	<cfargument name="param" type="string" required="true" hint="Value to deobfuscate.">
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
				loc.iEnd = Len(loc.z)-1;
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
					loc.returnValue = loc.returnValue & Left(Right(loc.z, loc.i),1);
				loc.checksumtest = "0";
				loc.iEnd = Len(loc.returnValue);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
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

<cffunction name="get" returntype="any" access="public" output="false" hint="Returns the current setting for the supplied variable name."
	examples=
	'
		<!--- Get the current setting for the `tableNamePrefix` variable --->
		<cfset setting = get("tableNamePrefix")>

		<!--- Get the default for the `message` argument on the `validatesConfirmationOf` method  --->
		<cfset setting = get(functionName="validatesConfirmationOf", name="message")>
	'
	categories="global,miscellaneous" chapters="configuration-and-defaults" functions="set">
	<cfargument name="name" type="string" required="true" hint="Variable name to get setting for.">
	<cfargument name="functionName" type="string" required="false" default="" hint="Function name to get setting for.">
	<cfscript>
		var loc = {};
		if (Len(arguments.functionName))
			loc.returnValue = application.wheels.functions[arguments.functionName][arguments.name];
		else
			loc.returnValue = application.wheels[arguments.name];
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="model" returntype="any" access="public" output="false" hint="Returns a reference to the requested model so that class level methods can be called on it."
	examples=
	'
		<!--- The `model("author")` part of the code below gets a reference to the model in the application scope and then `findByKey` is called on it --->
		<cfset authorObject = model("author").findByKey(1)>
	'
	categories="global,miscellaneous" chapters="object-relational-mapping" functions="">
	<cfargument name="name" type="string" required="true" hint="Name of the model to get a reference to.">
	<cfreturn $doubleCheckedLock(name="modelLock", condition="$cachedModelClassExists", execute="$createModelClass", conditionArgs=arguments, executeArgs=arguments)>
</cffunction>

<cffunction name="obfuscateParam" returntype="string" access="public" output="false" hint="Obfuscates a value, typically used for hiding primary key values when passed along in the URL."
	examples=
	'
		<!--- Obfuscate the primary key value `99` --->
		<cfset newValue = obfuscateParam(99)>
	'
	categories="global,miscellaneous" chapters="obfuscating-urls" functions="deobfuscateParam">
	<cfargument name="param" type="any" required="true" hint="Value to obfuscate.">
	<cfscript>
		var loc = {};
		if (IsValid("integer", arguments.param) && IsNumeric(arguments.param) && arguments.param > 0)
		{
			loc.iEnd = Len(arguments.param);
			loc.a = (10^loc.iEnd) + Reverse(arguments.param);
			loc.b = "0";
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
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

<cffunction name="pluginNames" returntype="string" access="public" output="false" hint="Returns a list of all installed plugins."
	examples=
	'
		<!--- Check if the Scaffold plugin is installed --->
		<cfif ListFindNoCase("scaffold", pluginNames())>
			<!--- do something cool --->
		</cfif>
	'
	categories="global,miscellaneous" chapters="using-and-creating-plugins" functions="">
	<cfreturn StructKeyList(application.wheels.plugins)>
</cffunction>

<cffunction name="URLFor" returntype="string" access="public" output="false" hint="Creates an internal URL based on supplied arguments."
	examples=
	'
		<!--- Create the URL for the `logOut` action on the `account` controller, typically resulting in `/account/logout` --->
		##URLFor(controller="account", action="logOut")##

		<!--- Create a URL with an anchor set on it --->
		##URLFor(action="comments", anchor="comment10")##
	'
	categories="global,miscellaneous" chapters="request-handling,linking-pages" functions="redirectTo,linkTo,startFormTag">
	<cfargument name="route" type="string" required="false" default="" hint="Name of a route that you have configured in `config/routes.cfm`.">
	<cfargument name="controller" type="string" required="false" default="" hint="Name of the controller to include in the URL.">
	<cfargument name="action" type="string" required="false" default="" hint="Name of the action to include in the URL.">
	<cfargument name="key" type="any" required="false" default="" hint="Key(s) to include in the URL.">
	<cfargument name="params" type="string" required="false" default="" hint="Any additional params to be set in the query string.">
	<cfargument name="anchor" type="string" required="false" default="" hint="Sets an anchor name to be appended to the path.">
	<cfargument name="onlyPath" type="boolean" required="false" hint="If `true`, returns only the relative URL (no protocol, host name or port).">
	<cfargument name="host" type="string" required="false" hint="Set this to override the current host.">
	<cfargument name="protocol" type="string" required="false" hint="Set this to override the current protocol.">
	<cfargument name="port" type="numeric" required="false" hint="Set this to override the current port number.">
	<cfargument name="URLRewriting" type="string" required="false" default="#application.wheels.URLRewriting#" hint="Set this to override the default URL rewriting.">
	<cfscript>
		var loc = {};
		$insertDefaults(name="URLFor", input=arguments);
		loc.params = {};
		loc.scriptName = ListLast(request.cgi.script_name, "/");
		if (StructKeyExists(variables, "params"))
			StructAppend(loc.params, variables.params, true);
		if (application.wheels.showErrorInformation)
		{
			if (arguments.onlyPath && (Len(arguments.host) || Len(arguments.protocol)))
				$throw(type="Wheels.IncorrectArguments", message="Can't use the `host` or `protocol` arguments when `onlyPath` is `true`.", extendedInfo="Set `onlyPath` to `false` so that `linkTo` will create absolute URLs and thus allowing you to set the `host` and `protocol` on the link.");
		}

		// get primary key values if an object was passed in
		if (IsObject(arguments.key))
		{
			arguments.key = arguments.key.key();
		}

		// build the link
		loc.returnValue = application.wheels.webPath & loc.scriptName;
		if (Len(arguments.route))
		{
			// link for a named route
			loc.route = $findRoute(argumentCollection=arguments);
			if (arguments.URLRewriting == "Off")
			{
				loc.returnValue = loc.returnValue & "?controller=";
				if (Len(arguments.controller))
					loc.returnValue = loc.returnValue & $hyphenize(arguments.controller);
				else
					loc.returnValue = loc.returnValue & $hyphenize(loc.route.controller);
				loc.returnValue = loc.returnValue & "&action=";
				if (Len(arguments.action))
					loc.returnValue = loc.returnValue & $hyphenize(arguments.action);
				else
					loc.returnValue = loc.returnValue & $hyphenize(loc.route.action);
				loc.iEnd = ListLen(loc.route.variables);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.property = ListGetAt(loc.route.variables, loc.i);
					if (loc.property != "controller" && loc.property != "action")
						loc.returnValue = loc.returnValue & "&" & loc.property & "=" & $URLEncode(arguments[loc.property]);
				}
			}
			else
			{
				loc.iEnd = ListLen(loc.route.pattern, "/");
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.property = ListGetAt(loc.route.pattern, loc.i, "/");
					if (loc.property Contains "[")
					{
						loc.property = Mid(loc.property, 2, Len(loc.property)-2);
						if (application.wheels.showErrorInformation && !StructKeyExists(arguments, loc.property))
							$throw(type="Wheels", message="Incorrect Arguments", extendedInfo="The route chosen by Wheels `#loc.route.name#` requires the argument `#loc.property#`. Pass the argument `#loc.property#` or change your routes to reflect the proper variables needed.");
						loc.param = $URLEncode(arguments[loc.property]);
						if (loc.property == "controller" || loc.property == "action")
							loc.param = $hyphenize(loc.param);
						else if (application.wheels.obfuscateUrls)
							loc.param = obfuscateParam(loc.param);
						loc.returnValue = loc.returnValue & "/" & loc.param; // get param from arguments
					}
					else
					{
						loc.returnValue = loc.returnValue & "/" & loc.property; // add hard coded param from route
					}
				}
			}
		}
		else // link based on controller/action/key
		{

			// when no controller or action was passed in we link to the current page (controller/action only, not query string etc) by default
			if (!Len(arguments.controller) && StructKeyExists(loc.params, "controller"))
				arguments.controller = loc.params.controller;
			if (!Len(arguments.action) && StructKeyExists(loc.params, "action"))
				arguments.action = loc.params.action;
			loc.returnValue = loc.returnValue & "?controller=" & $hyphenize(arguments.controller);
			if (Len(arguments.action))
				loc.returnValue = loc.returnValue & "&action=" & $hyphenize(arguments.action);
			if (Len(arguments.key))
			{
				loc.param = $URLEncode(arguments.key);
				if (application.wheels.obfuscateUrls)
					loc.param = obfuscateParam(loc.param);
				loc.returnValue = loc.returnValue & "&key=" & loc.param;
			}
		}

		if (arguments.URLRewriting != "Off")
		{
			loc.returnValue = Replace(loc.returnValue, "?controller=", "/");
			loc.returnValue = Replace(loc.returnValue, "&action=", "/");
			loc.returnValue = Replace(loc.returnValue, "&key=", "/");
		}
		if (arguments.URLRewriting == "On")
		{
			loc.returnValue = Replace(loc.returnValue, application.wheels.rewriteFile, "");
			loc.returnValue = Replace(loc.returnValue, loc.scriptName, "");
			loc.returnValue = Replace(loc.returnValue, "//", "/");
		}

		if (Len(arguments.params))
			loc.returnValue = loc.returnValue & $constructParams(arguments.params);
		if (Len(arguments.anchor))
			loc.returnValue = loc.returnValue & "##" & arguments.anchor;

		if (!arguments.onlyPath)
		{
			if (arguments.port != 0)
				loc.returnValue = ":" & arguments.port & loc.returnValue; // use the port that was passed in by the developer
			else if (request.cgi.server_port != 80 && request.cgi.server_port != 443)
				loc.returnValue = ":" & request.cgi.server_port & loc.returnValue; // if the port currently in use is not 80 or 443 we set it explicitly in the URL
			if (Len(arguments.host))
				loc.returnValue = arguments.host & loc.returnValue;
			else
				loc.returnValue = request.cgi.server_name & loc.returnValue;
			if (Len(arguments.protocol))
				loc.returnValue = arguments.protocol & "://" & loc.returnValue;
			else
				loc.returnValue = SpanExcluding(LCase(request.cgi.server_protocol), "/") & "://" & loc.returnValue;
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<!--- string helpers --->

<cffunction name="capitalize" returntype="string" access="public" output="false" hint="Returns the text with the first character converted to uppercase."
	examples=
	'
		<!--- Capitalize a sentence, will result in "Wheels is a framework" --->
		##capitalize("wheels is a framework")##
	'
	categories="global,string" chapters="miscellaneous-helpers" functions="humanize,pluralize,singularize">
	<cfargument name="text" type="string" required="true" hint="Text to capitalize.">
	<cfreturn UCase(Left(arguments.text, 1)) & Mid(arguments.text, 2, Len(arguments.text)-1)>
</cffunction>

<cffunction name="humanize" returntype="string" access="public" output="false" hint="Returns readable text by capitalizing, converting camel casing to multiple words."
	examples=
	'
		<!--- Humanize a string, will result in "Wheels Is A Framework" --->
		##humanize("wheelsIsAFramework")##
	'
	categories="global,string" chapters="miscellaneous-helpers" functions="capitalize,pluralize,singularize">
	<cfargument name="text" type="string" required="true" hint="Text to humanize.">
	<cfscript>
		var loc = {};
		loc.returnValue = REReplace(arguments.text, "([[:upper:]])", " \1", "all"); // adds a space before every capitalized word
		loc.returnValue = REReplace(loc.returnValue, "([[:upper:]]) ([[:upper:]]) ", "\1\2", "all"); // fixes abbreviations so they form a word again (example: aURLVariable)
		loc.returnValue = Trim(capitalize(loc.returnValue)); // capitalize the first letter and trim final result (which removes the leading space that happens if the string starts with an upper case character)
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="pluralize" returntype="string" access="public" output="false" hint="Returns the plural form of the passed in word."
	examples=
	'
		<!--- Pluralize a word, will result in "people" --->
		##pluralize("person")##

		<!--- Pluralize based on the count passed in --->
		Your search returned ##pluralize(word="person", count=users.recordCount)##
	'
	categories="global,string" chapters="miscellaneous-helpers" functions="capitalize,humanize,singularize">
	<cfargument name="word" type="string" required="true" hint="The word to pluralize.">
	<cfargument name="count" type="numeric" required="false" default="-1" hint="Pluralization will occur when this value is not `1`.">
	<cfargument name="returnCount" type="boolean" required="false" default="true" hint="Will return `count` prepended to the pluralization when `true` and `count` is not `-1`.">
	<cfreturn $singularizeOrPluralize(text=arguments.word, which="pluralize", count=arguments.count, returnCount=arguments.returnCount)>
</cffunction>

<cffunction name="singularize" returntype="string" access="public" output="false" hint="Returns the singular form of the passed in word."
	examples=
	'
		<!--- Singularize a word, will result in "language" --->
		##singularize("languages")##
	'
	categories="global,string" chapters="miscellaneous-helpers" functions="capitalize,humanize,pluralize">
	<cfargument name="word" type="string" required="true" hint="String to singularize.">
	<cfreturn $singularizeOrPluralize(text=arguments.word, which="singularize")>
</cffunction>

<cffunction name="toXHTML" returntype="string" access="public" output="false" hint="returns an XHTML compliant string">
	<cfargument name="str" type="string" required="true" hint="string to make XHTML compliant">
	<cfset arguments.str = Replace(arguments.str, "&", "&amp;", "all")>
	<cfreturn arguments.str>
</cffunction>

<cffunction name="mimeTypes" returntype="string" access="public" output="false" hint="gets the associated mimetype from the extension">
	<cfargument name="extension" required="true" type="string" hint="the extension to get the mimetype for">
	<cfargument name="fallback" required="false" type="string" default="application/octet-stream" hint="the fallback mimetype to return. default to application/octet-stream">
	<cfif StructKeyExists(application.wheels.mimetypes, arguments.extension)>
		<cfset arguments.fallback = application.wheels.mimetypes[arguments.extension]>
	</cfif>
	<cfreturn arguments.fallback>
</cffunction>

<!--- PRIVATE FUNCTIONS --->

<cffunction name="$singularizeOrPluralize" returntype="string" access="public" output="false" hint="Called by singularize and pluralize to perform the conversion.">
	<cfargument name="text" type="string" required="true">
	<cfargument name="which" type="string" required="true">
	<cfargument name="count" type="numeric" required="false" default="-1">
	<cfargument name="returnCount" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};

		// by default we pluralize/singularize the entire string
		loc.text = arguments.text;

		if (REFind("[A-Z]", loc.text))
		{
			// only pluralize/singularize the last part of a camelCased variable (e.g. in "websiteStatusUpdate" we only change the "update" part)
			// also set a variable with the unchanged part of the string (to be prepended before returning final result)
			loc.upperCasePos = REFind("[A-Z]", Reverse(loc.text));
			loc.prepend = Mid(loc.text, 1, Len(loc.text)-loc.upperCasePos);
			loc.text = Reverse(Mid(Reverse(loc.text), 1, loc.upperCasePos));
		}

		// when count is 1 we don't need to pluralize at all so just set the return value to the input string
		loc.returnValue = loc.text;

		if (arguments.count != 1)
		{
			loc.uncountables = "advice,air,blood,deer,equipment,fish,food,furniture,garbage,graffiti,grass,homework,housework,information,knowledge,luggage,mathematics,meat,milk,money,music,pollution,research,rice,sand,series,sheep,soap,software,species,sugar,traffic,transportation,travel,trash,water";
			loc.irregulars = "child,children,foot,feet,man,men,move,moves,person,people,sex,sexes,tooth,teeth,woman,women";
			if (ListFindNoCase(loc.uncountables, loc.text))
				loc.returnValue = loc.text;
			else if (ListFindNoCase(loc.irregulars, loc.text))
			{
				loc.pos = ListFindNoCase(loc.irregulars, loc.text);
				if (arguments.which == "singularize" && loc.pos MOD 2 == 0)
					loc.returnValue = ListGetAt(loc.irregulars, loc.pos-1);
				else if (arguments.which == "pluralize" && loc.pos MOD 2 != 0)
					loc.returnValue = ListGetAt(loc.irregulars, loc.pos+1);
				else
					loc.returnValue = loc.text;
			}
			else
			{
				if (arguments.which == "pluralize")
					loc.ruleList = "(quiz)$,\1zes,^(ox)$,\1en,([m|l])ouse$,\1ice,(matr|vert|ind)ix|ex$,\1ices,(x|ch|ss|sh)$,\1es,([^aeiouy]|qu)y$,\1ies,(hive)$,\1s,(?:([^f])fe|([lr])f)$,\1\2ves,sis$,ses,([ti])um$,\1a,(buffal|tomat|potat|volcan|her)o$,\1oes,(bu)s$,\1ses,(alias|status),\1es,(octop|vir)us$,\1i,(ax|test)is$,\1es,s$,s,$,s";
				else if (arguments.which == "singularize")
					loc.ruleList = "(quiz)zes$,\1,(matr)ices$,\1ix,(vert|ind)ices$,\1ex,^(ox)en,\1,(alias|status)es$,\1,([octop|vir])i$,\1us,(cris|ax|test)es$,\1is,(shoe)s$,\1,(o)es$,\1,(bus)es$,\1,([m|l])ice$,\1ouse,(x|ch|ss|sh)es$,\1,(m)ovies$,\1ovie,(s)eries$,\1eries,([^aeiouy]|qu)ies$,\1y,([lr])ves$,\1f,(tive)s$,\1,(hive)s$,\1,([^f])ves$,\1fe,(^analy)ses$,\1sis,((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$,\1\2sis,([ti])a$,\1um,(n)ews$,\1ews,s$,#Chr(7)#";
				loc.rules = ArrayNew(2);
				loc.count = 1;
				loc.iEnd = ListLen(loc.ruleList);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i=loc.i+2)
				{
					loc.rules[loc.count][1] = ListGetAt(loc.ruleList, loc.i);
					loc.rules[loc.count][2] = ListGetAt(loc.ruleList, loc.i+1);
					loc.count = loc.count + 1;
				}
				loc.iEnd = ArrayLen(loc.rules);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					if(REFindNoCase(loc.rules[loc.i][1], loc.text))
					{
						loc.returnValue = REReplaceNoCase(loc.text, loc.rules[loc.i][1], loc.rules[loc.i][2]);
						break;
					}
				}
				loc.returnValue = Replace(loc.returnValue, Chr(7), "", "all");
			}
		}

		// this was a camelCased string and we need to prepend the unchanged part to the result
		if (StructKeyExists(loc, "prepend"))
			loc.returnValue = loc.prepend & loc.returnValue;

		// return the count number in the string (e.g. "5 sites" instead of just "sites")
		if (arguments.returnCount && arguments.count != -1)
			loc.returnValue = arguments.count & " " & loc.returnValue;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>