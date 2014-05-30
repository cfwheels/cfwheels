<!--- PUBLIC CONFIGURATION FUNCTIONS --->
	
<!--- TODO: move setPagination function to controller, it's only here for now to maintain backwards compatibility --->
<cffunction name="setPagination" access="public" output="false" returntype="void" hint="Allows you to set a pagination handle for a custom query so you can perform pagination on it in your view with `paginationLinks()`."
	examples=
	'
		<!---
			Note that there are two ways to do pagination yourself using
			a custom query.

			1) Do a query that grabs everything that matches and then use
			the `cfouput` or `cfloop` tag to page through the results.

			2) Use your database to make 2 queries. The first query
			basically does a count of the total number of records that match
			the criteria and the second query actually selects the page of
			records for retrieval.

			In the example below, we will show how to write a custom query
			using both of these methods. Note that the syntax where your
			database performs the pagination will differ depending on the
			database engine you are using. Plese consult your database
			engine''s documentation for the correct syntax.

			also note that the view code will differ depending on the method
			used.
		--->

		<!---
			First method: Handle the pagination through your CFML engine
		--->

		<!--- Model code --->
		<!--- In your model (ie. User.cfc), create a custom method for your custom query --->
		<cffunction name="myCustomQuery">
			<cfargument name="page" type="numeric">
			<cfargument name="perPage" type="numeric" required="false" default="25">

			<cfquery name="local.customQuery" datasource="##get(''dataSourceName'')##">
				SELECT * FROM users
			</cfquery>

			<cfset setPagination(totalRecords=local.customQuery.RecordCount, currentPage=arguments.page, perPage=arguments.perPage, handle="myCustomQueryHandle")>
			<cfreturn customQuery>
		</cffunction>

		<!--- Controller code --->
		<cffunction name="list">
			<cfparam name="params.page" default="1">
			<cfparam name="params.perPage" default="25">

			<cfset allUsers = model("user").myCustomQuery(page=params.page, perPage=params.perPage)>
			<!---
				Because we''re going to let `cfoutput`/`cfloop` handle the pagination,
				we''re going to need to get some addition information about the
				pagination.
			 --->
			<cfset paginationData = pagination("myCustomQueryHandle")>
		</cffunction>

		<!--- View code (using `cfloop`) --->
		<!--- Use the information from `paginationData` to page through the records --->
		<cfoutput>
		<ul>
		    <cfloop query="allUsers" startrow="##paginationData.startrow##" endrow="##paginationData.endrow##">
		        <li>##allUsers.firstName## ##allUsers.lastName##</li>
		    </cfloop>
		</ul>
		##paginationLinks(handle="myCustomQueryHandle")##
		</cfoutput>

		<!--- View code (using `cfoutput`) --->
		<!--- Use the information from `paginationData` to page through the records --->
		<ul>
		    <cfoutput query="allUsers" startrow="##paginationData.startrow##" maxrows="##paginationData.maxrows##">
		        <li>##allUsers.firstName## ##allUsers.lastName##</li>
		    </cfoutput>
		</ul>
		<cfoutput>##paginationLinks(handle="myCustomQueryHandle")##</cfoutput>


		<!---
			Second method: Handle the pagination through the database
		--->

		<!--- Model code --->
		<!--- In your model (ie. `User.cfc`), create a custom method for your custom query --->
		<cffunction name="myCustomQuery">
			<cfargument name="page" type="numeric">
			<cfargument name="perPage" type="numeric" required="false" default="25">

			<cfquery name="local.customQueryCount" datasource="##get(''dataSouceName'')##">
				SELECT COUNT(*) AS theCount FROM users
			</cfquery>

			<cfquery name="local.customQuery" datasource="##get(''dataSourceName'')##">
				SELECT * FROM users
				LIMIT ##arguments.page## OFFSET ##arguments.perPage##
			</cfquery>

			<!--- Notice the we use the value from the first query for `totalRecords`  --->
			<cfset setPagination(totalRecords=local.customQueryCount.theCount, currentPage=arguments.page, perPage=arguments.perPage, handle="myCustomQueryHandle")>
			<!--- We return the second query --->
			<cfreturn customQuery>
		</cffunction>

		<!--- Controller code --->
		<cffunction name="list">
			<cfparam name="params.page" default="1">
			<cfparam name="params.perPage" default="25">
			<cfset allUsers = model("user").myCustomQuery(page=params.page, perPage=params.perPage)>
		</cffunction>

		<!--- View code (using `cfloop`) --->
		<cfoutput>
		<ul>
		    <cfloop query="allUsers">
		        <li>##allUsers.firstName## ##allUsers.lastName##</li>
		    </cfloop>
		</ul>
		##paginationLinks(handle="myCustomQueryHandle")##
		</cfoutput>

		<!--- View code (using `cfoutput`) --->
		<ul>
		    <cfoutput query="allUsers">
		        <li>##allUsers.firstName## ##allUsers.lastName##</li>
		    </cfoutput>
		</ul>
		<cfoutput>##paginationLinks(handle="myCustomQueryHandle")##</cfoutput>
	'
	categories="model-class,miscellaneous" chapters="getting-paginated-data" functions="findAll,paginationLinks">
		<cfargument name="totalRecords" type="numeric" required="true" hint="Total count of records that should be represented by the paginated links.">
		<cfargument name="currentPage" type="numeric" required="false" default="1" hint="Page number that should be represented by the data being fetched and the paginated links.">
		<cfargument name="perPage" type="numeric" required="false" default="25" hint="Number of records that should be represented on each page of data.">
		<cfargument name="handle" type="string" required="false" default="query" hint="Name of handle to reference in @paginationLinks.">
		<cfscript>
		var loc = {};

		// all numeric values must be integers
		arguments.totalRecords = fix(arguments.totalRecords);
		arguments.currentPage = fix(arguments.currentPage);
		arguments.perPage = fix(arguments.perPage);

		// totalRecords cannot be negative
		if (arguments.totalRecords lt 0)
		{
			arguments.totalRecords = 0;
		}

		// perPage less then zero
		if (arguments.perPage lte 0)
		{
			arguments.perPage = 25;
		}

		// calculate the total pages the query will have
		arguments.totalPages = Ceiling(arguments.totalRecords/arguments.perPage);

		// currentPage shouldn't be less then 1 or greater then the number of pages
		if (arguments.currentPage gte arguments.totalPages)
		{
			arguments.currentPage = arguments.totalPages;
		}

		if (arguments.currentPage lt 1)
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
		if (arguments.endRow gte arguments.totalRecords)
		{
			arguments.endRow = arguments.totalRecords;
		}

		if (arguments.endRow lt arguments.startRow)
		{
			arguments.endRow = arguments.startRow;
		}

		loc.args = duplicate(arguments);
		structDelete(loc.args, "handle", false);
		request.wheels[arguments.handle] = loc.args;
	</cfscript>
</cffunction>
	
<cffunction name="setCacheSettings" returntype="void" access="public" output="false" hint="Updates the settings for a cache category. Use this method in your settings files. You may also add specific arguments that you would like to pass to the storage component."
	examples='
		<!--- in config/settings.cfm, set the caching for partials to use ehcache --->
		<cfset setCacheSettings(category="partials", storage="ehcache") />
	'
	categories="configuration,caching" chapters="caching" functions="">
		<cfargument name="category" type="string" required="true" />
		<cfargument name="storage" type="string" required="true" hint="Could be memory, ehcache, or memcached." />
		<cfargument name="strategy" type="string" required="false" default="age" />
		<cfargument name="timeout" type="numeric" required="false" default="3600" hint="in seconds. default is 1 hour or 3600 seconds" />
		<cfargument name="cullPercentage" type="numeric" required="false" default="10" />
		<cfargument name="cullInterval" type="numeric" required="false" default="300" hint="in seconds. default is 5 minutes or 300 seconds" />
		<cfargument name="maximumItems" type="numeric" required="false" default="5000" />
		<cfscript>
		application.wheels.cacheSettings[arguments.category] = {};
		StructDelete(arguments, "category");
		StructAppend(application.wheels.cacheSettings[arguments.category], arguments);
	</cfscript>
</cffunction>
	
<cffunction name="addFormat" returntype="void" access="public" output="false" hint="Adds a new MIME format to your Wheels application for use with responding to multiple formats."
	examples='
		<!--- Add the `js` format --->
		<cfset addFormat(extension="js", mimeType="text/javascript")>

		<!--- Add the `ppt` and `pptx` formats --->
		<cfset addFormat(extension="ppt", mimeType="application/vnd.ms-powerpoint")>
		<cfset addFormat(extension="pptx", mimeType="application/vnd.ms-powerpoint")>
	'
	categories="configuration,formats" chapters="responding-with-multiple-formats" functions="provides,renderWith">
		<cfargument name="extension" type="string" required="true" hint="File extension to add." />
		<cfargument name="mimeType" type="string" required="true" hint="Matching MIME type to associate with the file extension." />
		<cfset application.wheels.formats[lcase(arguments.extension)] = arguments.mimeType />
</cffunction>
	
<cffunction name="addRoute" returntype="void" access="public" output="false" hint="Adds a new route to your application."
	examples=
	'
		<!--- Example 1: Adds a route which will invoke the `profile` action on the `user` controller with `params.userName` set when the URL matches the `pattern` argument --->
		<cfset addRoute(name="userProfile", pattern="user/[username]", controller="user", action="profile")>

		<!--- Example 2: Category/product URLs. Note the order of precedence is such that the more specific route should be defined first so Wheels will fall back to the less-specific version if it''s not found --->
		<cfset addRoute(name="product", pattern="products/[categorySlug]/[productSlug]", controller="products", action="product")>
		<cfset addRoute(name="productCategory", pattern="products/[categorySlug]", controller="products", action="category")>
		<cfset addRoute(name="products", pattern="products", controller="products", action="index")>

		<!--- Example 3: Change the `home` route. This should be listed last because it is least specific --->
		<cfset addRoute(name="home", pattern="", controller="main", action="index")>
	'
	categories="configuration,routes" chapters="using-routes" functions="">
		<cfargument name="name" type="string" required="false" default="" hint="Name for the route. This is referenced as the `name` argument in functions based on @URLFor like @linkTo, @startFormTag, etc.">
		<cfargument name="pattern" type="string" required="true" hint="The URL pattern that the route will match.">
		<cfargument name="controller" type="string" required="false" default="" hint="Controller to call when route matches (unless the controller name exists in the pattern).">
		<cfargument name="action" type="string" required="false" default="" hint="Action to call when route matches (unless the action name exists in the pattern).">
		<cfscript>
		var loc = {};

		// throw errors when controller or action is not passed in as arguments and not included in the pattern
		if (!Len(arguments.controller) && arguments.pattern Does Not Contain "[controller]")
		{
			$throw(type="Wheels.IncorrectArguments", message="The `controller` argument is not passed in or included in the pattern.", extendedInfo="Either pass in the `controller` argument to specifically tell Wheels which controller to call or include it in the pattern to tell Wheels to determine it dynamically on each request based on the incoming URL.");
		}

		if (!Len(arguments.action) && arguments.pattern Does Not Contain "[action]")
		{
			$throw(type="Wheels.IncorrectArguments", message="The `action` argument is not passed in or included in the pattern.", extendedInfo="Either pass in the `action` argument to specifically tell Wheels which action to call or include it in the pattern to tell Wheels to determine it dynamically on each request based on the incoming URL.");
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
		ArrayAppend(application.wheels.routes, loc.thisRoute);
	</cfscript>
</cffunction>
	
<cffunction name="addDefaultRoutes" returntype="void" access="public" output="false" hint="Adds the default Wheels routes (for example, `[controller]/[action]/[key]`, etc.) to your application. Only use this method if you have set `loadDefaultRoutes` to `false` and want to control exactly where in the route order you want to place the default routes."
	examples=
	'
		<!--- Adds the default routes to your application (done in `config/routes.cfm`) --->
		<cfset addDefaultRoutes()>
	'
	categories="configuration,routes" chapters="using-routes" functions="">
		<cfscript>
		addRoute(pattern="[controller]/[action]/[key]");
		addRoute(pattern="[controller]/[action]");
		addRoute(pattern="[controller]", action="index");
	</cfscript>
</cffunction>
	
<cffunction name="set" returntype="void" access="public" output="false" hint="Use to configure a global setting or set a default for a function."
	examples=
	'
		<!--- Example 1: Set the `URLRewriting` setting to `Partial` --->
		<cfset set(URLRewriting="Partial")>

		<!--- Example 2: Set default values for the arguments in the `buttonTo` view helper. This works for the majority of Wheels functions/arguments. --->
		<cfset set(functionName="buttonTo", onlyPath=true, host="", protocol="", port=0, text="", confirm="", image="", disable="")>

		<!--- Example 3: Set the default values for a form helper to get the form marked up to your preferences --->
		<cfset set(functionName="textField", labelPlacement="before", prependToLabel="<div>", append="</div>", appendToLabel="<br />")>
	'
	categories="configuration,defaults" chapters="configuration-and-defaults" functions="get">
		<cfscript>
		var loc = {};
		if (ArrayLen(arguments) > 1)
		{
			for (loc.key in arguments)
			{
				if (loc.key != "functionName")
				{
					for (loc.i = 1; loc.i lte listlen(arguments.functionName); loc.i = loc.i + 1) {
						application.wheels.functions[Trim(ListGetAt(arguments.functionName, loc.i))][loc.key] = arguments[loc.key];
					}
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
	
<cffunction name="controller" returntype="any" access="public" output="false" hint="Creates and returns a controller object with your own custom `name` and `params`. Used primarily for testing purposes."
	examples='
		<cfset testController = controller("users", params)>
	'
	categories="global,miscellaneous" chapters="" functions="">
		<cfargument name="name" type="string" required="true" hint="Name of the controller to create.">
		<cfargument name="params" type="struct" required="false" default="#StructNew()#" hint="The params struct (combination of `form` and `URL` variables).">
		<cfscript>
		var loc = {};
		loc.args = {};
		loc.args.name = arguments.name;
		loc.returnValue = $doubleCheckedLock(name="controllerLock", condition="$cachedControllerClassExists", execute="$createControllerClass", conditionArgs=loc.args, executeArgs=loc.args);
		loc.returnValue = loc.returnValue.$createControllerObject(arguments.params);
	</cfscript>
		<cfreturn loc.returnValue>
</cffunction>
	
<cffunction name="deobfuscateParam" returntype="string" access="public" output="false" hint="Deobfuscates a value."
	examples=
	'
		<!--- Get the original value from an obfuscated one --->
		<cfset originalValue = deobfuscateParam("b7ab9a50")>
	'
	categories="global,miscellaneous" chapters="obfuscating-urls" functions="obfuscateParam">
		<cfargument name="param" type="string" required="true" hint="Value to deobfuscate.">
		<cfreturn arguments.param>
</cffunction>
	
<cffunction name="get" returntype="any" access="public" output="false" hint="Returns the current setting for the supplied Wheels setting or the current default for the supplied Wheels function argument."
	examples=
	'
		<!--- Get the current value for the `tableNamePrefix` Wheels setting --->
		<cfset setting = get("tableNamePrefix")>

		<!--- Get the default for the `message` argument of the `validatesConfirmationOf` method  --->
		<cfset setting = get(functionName="validatesConfirmationOf", name="message")>
	'
	categories="configuration,defaults" chapters="configuration-and-defaults" functions="set">
		<cfargument name="name" type="string" required="true" hint="Variable name to get setting for.">
		<cfargument name="functionName" type="string" required="false" default="" hint="Function name to get setting for.">
		<cfscript>
		var loc = {};
		if (Len(arguments.functionName))
		{
			loc.returnValue = application.wheels.functions[arguments.functionName][arguments.name];
		}
		else
		{
			loc.returnValue = application.wheels[arguments.name];
		}
	</cfscript>
		<cfreturn loc.returnValue>
</cffunction>
	
<cffunction name="model" returntype="any" access="public" output="false" hint="Returns a reference to the requested model so that class level methods can be called on it."
	examples=
	'
		<!--- The `model("author")` part of the code below gets a reference to the model from the application scope, and then the `findByKey` class level method is called on it --->
		<cfset authorObject = model("author").findByKey(1)>
	'
	categories="global,miscellaneous" chapters="object-relational-mapping" functions="">
		<cfargument name="name" type="string" required="true" hint="Name of the model to get a reference to.">
		<!--- we need an instance of the model to be able to build queries without adding the query data to the application scope model --->
		<cfreturn $doubleCheckedLock(name="modelLock", condition="$cachedModelClassExists", execute="$createModelClass", conditionArgs=arguments, executeArgs=arguments)>
</cffunction>
	
<cffunction name="obfuscateParam" returntype="string" access="public" output="false" hint="Obfuscates a value. Typically used for hiding primary key values when passed along in the URL."
	examples=
	'
		<!--- Obfuscate the primary key value `99` --->
		<cfset newValue = obfuscateParam(99)>
	'
	categories="global,miscellaneous" chapters="obfuscating-urls" functions="deobfuscateParam">
		<cfargument name="param" type="any" required="true" hint="Value to obfuscate.">
		<cfreturn arguments.param>
</cffunction>
	
<cffunction name="pluginNames" returntype="string" access="public" output="false" hint="Returns a list of all installed plugins' names."
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
		<!--- Create the URL for the `logOut` action on the `account` controller, typically resulting in `/account/log-out` --->
		##URLFor(controller="account", action="logOut")##

		<!--- Create a URL with an anchor set on it --->
		##URLFor(action="comments", anchor="comment10")##

		<!--- Create a URL based on a route called `products`, which expects params for `categorySlug` and `productSlug` --->
		##URLFor(route="product", categorySlug="accessories", productSlug="battery-charger")##
	'
	categories="global,miscellaneous" chapters="request-handling,linking-pages" functions="redirectTo,linkTo,startFormTag">
		<cfargument name="route" type="string" required="false" default="" hint="Name of a route that you have configured in `config/routes.cfm`.">
		<cfargument name="controller" type="string" required="false" default="" hint="Name of the controller to include in the URL.">
		<cfargument name="action" type="string" required="false" default="" hint="Name of the action to include in the URL.">
		<cfargument name="key" type="any" required="false" default="" hint="Key(s) to include in the URL.">
		<cfargument name="params" type="any" required="false" default="" hint="Any additional params to be set in the query string.">
		<cfargument name="anchor" type="string" required="false" default="" hint="Sets an anchor name to be appended to the path.">
		<cfargument name="onlyPath" type="boolean" required="false" hint="If `true`, returns only the relative URL (no protocol, host name or port).">
		<cfargument name="host" type="string" required="false" hint="Set this to override the current host.">
		<cfargument name="protocol" type="string" required="false" hint="Set this to override the current protocol.">
		<cfargument name="port" type="numeric" required="false" hint="Set this to override the current port number.">
		<cfargument name="$URLRewriting" type="string" required="false" default="#application.wheels.URLRewriting#">
		<cfscript>
		var loc = {};
		
		loc.returnValue = $args(name="URLFor", args=arguments);
		
		loc.params = {};
		if (StructKeyExists(variables, "params"))
		{
			StructAppend(loc.params, variables.params, true);
		}

		if (application.wheels.showErrorInformation)
		{
			if (arguments.onlyPath && (Len(arguments.host) || Len(arguments.protocol)))
			{
				$throw(type="Wheels.IncorrectArguments", message="Can't use the `host` or `protocol` arguments when `onlyPath` is `true`.", extendedInfo="Set `onlyPath` to `false` so that `linkTo` will create absolute URLs and thus allowing you to set the `host` and `protocol` on the link.");
			}
		}

		// get primary key values if an object was passed in
		if (IsObject(arguments.key))
		{
			arguments.key = arguments.key.key();
		}

		// build the link
		loc.returnValue = application.wheels.webPath & ListLast(request.cgi.script_name, "/");
		if (Len(arguments.route))
		{
			// link for a named route
			loc.route = $findRoute(argumentCollection=arguments);
			if (arguments.$URLRewriting == "Off")
			{
				loc.returnValue = loc.returnValue & "?controller=";
				if (Len(arguments.controller))
				{
					loc.returnValue = loc.returnValue & hyphenize(arguments.controller);
				}
				else
				{
					loc.returnValue = loc.returnValue & hyphenize(loc.route.controller);
				}

				loc.returnValue = loc.returnValue & "&action=";
				if (Len(arguments.action))
				{
					loc.returnValue = loc.returnValue & hyphenize(arguments.action);
				}
				else
				{
					loc.returnValue = loc.returnValue & hyphenize(loc.route.action);
				}

				// add it the format if it exists
				if (StructKeyExists(loc.route, "formatVariable") && StructKeyExists(arguments, loc.route.formatVariable))
				{
					loc.returnValue = loc.returnValue & "&#loc.route.formatVariable#=#arguments[loc.route.formatVariable]#";
				}

				loc.iEnd = ListLen(loc.route.variables);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.property = ListGetAt(loc.route.variables, loc.i);
					if (loc.property != "controller" && loc.property != "action")
					{
						loc.returnValue = loc.returnValue & "&" & loc.property & "=" & $URLEncode(arguments[loc.property]);
					}
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
						{
							$throw(type="Wheels", message="Incorrect Arguments", extendedInfo="The route chosen by Wheels `#loc.route.name#` requires the argument `#loc.property#`. Pass the argument `#loc.property#` or change your routes to reflect the proper variables needed.");
						}

						loc.param = $URLEncode(arguments[loc.property]);
						if (loc.property == "controller" || loc.property == "action")
						{
							loc.param = hyphenize(loc.param);
						}
						else if (application.wheels.obfuscateUrls)
						{
							loc.param = obfuscateParam(loc.param);
						}
						loc.returnValue = loc.returnValue & "/" & loc.param; // get param from arguments
					}
					else
					{
						loc.returnValue = loc.returnValue & "/" & loc.property; // add hard coded param from route
					}
				}
				// add it the format if it exists
				if (StructKeyExists(loc.route, "formatVariable") && StructKeyExists(arguments, loc.route.formatVariable))
				{
					loc.returnValue = loc.returnValue & ".#arguments[loc.route.formatVariable]#";
				}
			}
		}
		else // link based on controller/action/key
		{
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

			loc.returnValue = loc.returnValue & "?controller=" & hyphenize(arguments.controller);
			if (Len(arguments.action))
			{
				loc.returnValue = loc.returnValue & "&action=" & hyphenize(arguments.action);
			}

			if (Len(arguments.key))
			{
				loc.param = $URLEncode(arguments.key);
				if (application.wheels.obfuscateUrls)
				{
					loc.param = obfuscateParam(loc.param);
				}
				loc.returnValue = loc.returnValue & "&key=" & loc.param;
			}
		}

		if (arguments.$URLRewriting != "Off")
		{
			loc.returnValue = Replace(loc.returnValue, "?controller=", "/");
			loc.returnValue = Replace(loc.returnValue, "&action=", "/");
			loc.returnValue = Replace(loc.returnValue, "&key=", "/");
		}
		if (arguments.$URLRewriting == "On")
		{
			loc.returnValue = Replace(loc.returnValue, application.wheels.rewriteFile, "");
			loc.returnValue = REReplace(loc.returnValue, "/{2,}", "/", "ALL");
			loc.returnValue = REReplace(loc.returnValue, "(?!^/)/$", "");
		}


		arguments.params = $paramsToString(arguments.params);
		if (Len(arguments.params))
		{
			loc.returnValue = loc.returnValue & $constructParams(params=arguments.params, $URLRewriting=arguments.$URLRewriting);
		}

		if (Len(arguments.anchor))
		{
			loc.returnValue = loc.returnValue & "##" & arguments.anchor;
		}

		if (!arguments.onlyPath)
		{
			if (arguments.port != 0)
			{
				loc.returnValue = ":" & arguments.port & loc.returnValue; // use the port that was passed in by the developer
			}
			else if (request.cgi.server_port != 80 && request.cgi.server_port != 443)
			{
				loc.returnValue = ":" & request.cgi.server_port & loc.returnValue; // if the port currently in use is not 80 or 443 we set it explicitly in the URL
			}

			if (Len(arguments.host))
			{
				loc.returnValue = arguments.host & loc.returnValue;
			}
			else
			{
				loc.returnValue = request.cgi.server_name & loc.returnValue;
			}

			if (Len(arguments.protocol))
			{
				loc.returnValue = arguments.protocol & "://" & loc.returnValue;
			}
			else if (request.cgi.server_port_secure)
			{
				loc.returnValue = "https://" & loc.returnValue;
			}
			else
			{
				loc.returnValue = "http://" & loc.returnValue;
			}
		}
	</cfscript>
		<cfreturn loc.returnValue>
</cffunction>
	
<cffunction name="l" returntype="string" access="public" output="false" hint="Returns the localised value for the given locale"
	examples=
	'
		<!--- Return all the names of the months for US English --->
		<cfset monthNames = l("date.month_names", "en-US")>
	'
	categories="global,miscellaneous">
		<cfargument name="key" type="string" required="true">
		<cfargument name="locale" type="string" required="false" default="#application.wheels.locale#">
		<cfreturn evaluate('application.wheels.locales["#arguments.locale#"].#arguments.key#')>
</cffunction>
	
<cffunction name="timestamp" returntype="date" access="public" output="false" hint="Returns a UTC or local timestamp"
	examples=
	'
		<!--- Return current locale time --->
		<cfset currenttime = timestamp()>

		<!--- Return current UTC time --->
		<cfset currenttime = timestamp(utc=true)>

	'
	categories="global,miscellaneous">
		<cfargument name="utc" type="boolean" required="false" default="#application.wheels.utcTimestamps#">
		<cfif arguments.utc>
			<cfreturn DateConvert("local2Utc", Now())>
		</cfif>
		<cfreturn Now()>
</cffunction>
	
<cffunction name="semanticVersioning" access="public" returntype="boolean" output="false" hint="allows a developer to specify versions in an semantic way."
	examples=
	'
		Valid syantax is:

		[operator] [version]

		The following operators are supported:

		=  Equals version
		!= Not equal to version
		>  Greater than version
		<  Less than version
		>= Greater than or equal to
		<= Less than or equal to
		~> Approximately greater than

		The first six operators are self explanitory. The Approximate operator `~>` can be thought
		of as a `between` operator. For example, if the developer wanted their plugin to support a
		wheels version that was between 1.1 and 1.2, they could do:

		<cffunction name="init">
			<cfset this.version = "~> 1.1">
			<cfreturn this>
		</cffunction>

		To use, you pass in the version and versioning strings:

		<cfset loc.passed = semanticVersioning(this.version, application.wheels.version)>

		NOTE: to mentally perform the comparision swap the arguments.

		<cfset loc.passed = semanticVersioning("> 1.3", "1.2.5")>

		reads: is "1.2.5" greater or equal to "1.3"
		

	'
	categories="global,miscellaneous">
	<cfargument name="versioning" type="string" required="true">
	<cfargument name="version" type="string" required="true">
	<cfscript>
	var loc = {};

	// supported operators
	loc.operators = "=,!=,>,<,>=,<=,~>";
	// return value
	loc.ret = false;
	
	// split the string
	loc.arr = ListToArray(arguments.versioning, " ");

	// the array should only between two elements
	if (ArrayLen(loc.arr) != 2)
	{
		return false;
	}
	
	loc.operator = loc.arr[1];
	loc.versioning = loc.arr[2];
	
	// the first element of the array should be an operator
	if (
		!ListFindNoCase(loc.operators, loc.operator)
		OR !Len(Trim(arguments.version))
		OR !Len(Trim(loc.versioning))
	)
	{
		return false;
	}

	// make sure the delims are `.`. ACF version uses `,`.
	// also remove any `preview` versions which are designated by a `-`
	arguments.version = ListFirst(ListChangeDelims(arguments.version, ".", ".,"), "-");
	loc.versioning = ListFirst(ListChangeDelims(loc.versioning, ".", ".,"), "-");
	
	// split the passed in version into array elements
	loc.versionArr = $listClean(list=arguments.version, delim=".", returnAs="array");
	// split the versioning string into array elements
	loc.versioningArr = $listClean(list=loc.versioning, delim=".", returnAs="array");
	
	// cache the length of the arrays
	loc.versionArrLen = ArrayLen(loc.versionArr);
	loc.versioningArrLen = ArrayLen(loc.versioningArr);
	
	if (loc.operator eq "~>" AND loc.versioningArrLen GTE loc.versionArrLen)
	{
		loc.loops = loc.versioningArrLen;
	}
	else
	{
		loc.loops = max(loc.versionArrLen, loc.versioningArrLen);
	}
	
	ArrayResize(loc.versionArr, loc.loops);
	ArrayResize(loc.versioningArr, loc.loops);

	// create string that will be transformed to floats for comparisions
	loc.versionStr = "";
	loc.versioningStr = "";
	
	for (loc.i = 1; loc.i lte loc.loops; loc.i++)
	{

		loc.versioningPart = "0";
		if(ArrayIsDefined(loc.versioningArr, loc.i))
		{
			loc.versioningPart = loc.versioningArr[loc.i].toString();
		}
		
		loc.versionPart = "0";
		if(ArrayIsDefined(loc.versionArr, loc.i))
		{
			loc.versionPart = loc.versionArr[loc.i].toString();
		}

		if (loc.i EQ 2)
		{
			loc.versionStr &= ".";
			loc.versioningStr &= ".";
		}
		else if (loc.i GT 2)
		{
			loc.size = max(Len(loc.versioningPart), Len(loc.versionPart));
			loc.versionPart = loc.versionPart & RepeatString("0", loc.size - Len(loc.versionPart));
			loc.versioningPart = loc.versioningPart & RepeatString("0", loc.size - Len(loc.versioningPart));
		}

		loc.versionStr &= loc.versionPart;
		loc.versioningStr &= loc.versioningPart;

	}

	loc.versionStr = val(loc.versionStr);
	loc.versioningStr = val(loc.versioningStr);

	if (loc.operator eq "=" AND loc.versioningStr eq loc.versionStr)
	{
		return true;
	}
	else if (loc.operator eq "!=" AND loc.versioningStr neq loc.versionStr)
	{
		return true;
	}
	else if (loc.operator eq "<" AND loc.versionStr lt loc.versioningStr)
	{
		return true;
	}
	else if (loc.operator eq ">" AND loc.versionStr gt loc.versioningStr)
	{
		return true;
	}
	if (loc.operator eq "<=" AND loc.versionStr lte loc.versioningStr)
	{
		return true;
	}
	else if ((loc.operator eq ">=" OR loc.operator eq "~>") AND loc.versionStr gte loc.versioningStr)
	{
		return true;
	}
	</cfscript>
		<cfreturn false>
</cffunction>