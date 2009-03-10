<cffunction name="$insertDefaults" returntype="struct" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="input" type="struct" required="true">
	<cfargument name="reserved" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		if (application.settings.environment != "production")
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
		StructAppend(arguments.input, application.settings[arguments.name], false);
		loc.returnValue = arguments.input;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$createObjectFromRoot" returntype="any" access="public" output="false">
	<cfargument name="objectType" type="string" required="true">
	<cfargument name="fileName" type="string" required="true">
	<cfset var loc = {}>
	<cfinclude template="../../root.cfm">
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$debugPoint" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		if (!StructKeyExists(request.wheels, "execution"))
			request.wheels.execution = {};
		loc.iEnd = ListLen(arguments.name);
		for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
		{
			loc.item = ListGetAt(arguments.name, loc.i);
			if (StructKeyExists(request.wheels.execution, loc.item))
				request.wheels.execution[loc.item] = GetTickCount() - request.wheels.execution[loc.item];
			else
				request.wheels.execution[loc.item] = GetTickCount();
		}
	</cfscript>
</cffunction>

<cffunction name="$controller" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfset var loc = {}>
	<cfif NOT StructKeyExists(application.wheels.controllers, arguments.name)>
	   	<cflock name="controllerLock" type="exclusive" timeout="30">
			<cfif NOT StructKeyExists(application.wheels.controllers, arguments.name)>
				<cfscript>
					loc.fileName = $capitalize(arguments.name);
					
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
						if (FileExists(ExpandPath("#application.wheels.viewPath#/#arguments.name#/helpers.cfm")))
							application.wheels.existingHelperFiles = ListAppend(application.wheels.existingHelperFiles, arguments.name);
						else
							application.wheels.nonExistingHelperFiles = ListAppend(application.wheels.nonExistingHelperFiles, arguments.name);
					}

					if (!ListFindNoCase(application.wheels.existingControllerFiles, arguments.name))
						loc.fileName = "Controller";
					application.wheels.controllers[arguments.name] = $createObjectFromRoot(objectType="controllerClass", fileName=loc.fileName, name=arguments.name);
				</cfscript>
			</cfif>
		</cflock>
	</cfif>

	<cfreturn application.wheels.controllers[arguments.name]>
</cffunction>

<cffunction name="$flatten" returntype="string" access="public" output="false">
	<cfargument name="values" type="struct" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		if (IsStruct(arguments.values))
		{
			for (loc.key in arguments.values)
			{
				if (IsSimpleValue(arguments.values[loc.key]))
					loc.returnValue = loc.returnValue & "&" & loc.key & "=""" & arguments.values[loc.key] & """";
				else
					loc.returnValue = loc.returnValue & "&" & $flatten(arguments.values[loc.key]);
			}
		}
		else if (IsArray(arguments.values))
		{
			loc.iEnd = ArrayLen(arguments.values);
			for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
			{
				if (IsSimpleValue(arguments.values[loc.i]))
					loc.returnValue = loc.returnValue & "&" & loc.i & "=""" & arguments.values[loc.i] & """";
				else
					loc.returnValue = loc.returnValue & "&" & $flatten(arguments.values[loc.i]);
			}
		}
		loc.returnValue = Right(loc.returnValue, Len(loc.returnValue)-1);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$hashStruct" returntype="string" access="public" output="false">
	<cfargument name="args" type="struct" required="true">
	<cfreturn Hash(ListSort($flatten(arguments.args), "text", "asc", "&"))>
</cffunction>

<cffunction name="$addToCache" returntype="void" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfargument name="value" type="any" required="true">
	<cfargument name="time" type="numeric" required="true">
	<cfargument name="category" type="string" required="false" default="main">
	<cfargument name="type" type="string" required="false" default="external">
	<cfset var loc = {}>

	<cfif arguments.type IS "external" AND application.settings.cacheCullPercentage GT 0 AND application.wheels.cacheLastCulledAt LT dateAdd("n", -application.settings.cacheCullInterval, now()) AND $cacheCount() GTE application.settings.maximumItemsToCache>
		<!--- cache is full so flush out expired items from this cache to make more room if possible --->
		<cfset loc.deletedItems = 0>
		<cfset loc.cacheCount = $cacheCount()>
		<cfloop collection="#application.wheels.cache[arguments.type][arguments.category]#" item="loc.i">
			<cfif now() GT application.wheels.cache[arguments.type][arguments.category][loc.i].expiresAt>
				<cfset $removeFromCache(key=loc.i, category=arguments.category, type=arguments.type)>
				<cfif application.settings.cacheCullPercentage LT 100>
					<cfset loc.deletedItems = loc.deletedItems + 1>
					<cfset loc.percentageDeleted = (loc.deletedItems / loc.cacheCount) * 100>
					<cfif loc.percentageDeleted GTE application.settings.cacheCullPercentage>
						<cfbreak>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<cfset application.wheels.cacheLastCulledAt = now()>
	</cfif>

	<cfif arguments.type IS "internal" OR $cacheCount() LT application.settings.maximumItemsToCache>
		<cfset application.wheels.cache[arguments.type][arguments.category][arguments.key] = StructNew()>
		<cfset application.wheels.cache[arguments.type][arguments.category][arguments.key].expiresAt = dateAdd("n", arguments.time, now())>
		<cfif isSimpleValue(arguments.value)>
			<cfset application.wheels.cache[arguments.type][arguments.category][arguments.key].value = arguments.value>
		<cfelse>
			<cfset application.wheels.cache[arguments.type][arguments.category][arguments.key].value = duplicate(arguments.value)>
		</cfif>
	</cfif>

</cffunction>

<cffunction name="$getFromCache" returntype="any" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfargument name="category" type="string" required="false" default="main">
	<cfargument name="type" type="string" required="false" default="external">

	<cfif StructKeyExists(application.wheels.cache[arguments.type][arguments.category], arguments.key)>
		<cfif now() GT application.wheels.cache[arguments.type][arguments.category][arguments.key].expiresAt>
			<cfset $removeFromCache(key=arguments.key, category=arguments.category, type=arguments.type)>
			<cfreturn false>
		<cfelse>
			<cfif isSimpleValue(application.wheels.cache[arguments.type][arguments.category][arguments.key].value)>
				<cfreturn application.wheels.cache[arguments.type][arguments.category][arguments.key].value>
			<cfelse>
				<cfreturn duplicate(application.wheels.cache[arguments.type][arguments.category][arguments.key].value)>
			</cfif>
		</cfif>
	<cfelse>
		<cfreturn false>
	</cfif>

</cffunction>

<cffunction name="$removeFromCache" returntype="void" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfargument name="category" type="string" required="false" default="main">
	<cfargument name="type" type="string" required="false" default="external">
	<cfset StructDelete(application.wheels.cache[arguments.type][arguments.category], arguments.key)>
</cffunction>

<cffunction name="$cacheCount" returntype="numeric" access="public" output="false">
	<cfargument name="category" type="string" required="false" default="">
	<cfargument name="type" type="string" required="false" default="external">
	<cfset var loc = {}>

	<cfif Len(arguments.category) IS NOT 0>
		<cfset loc.result = structCount(application.wheels.cache[arguments.type][arguments.category])>
	<cfelse>
		<cfset loc.result = 0>
		<cfloop collection="#application.wheels.cache[arguments.type]#" item="loc.i">
			<cfset loc.result = loc.result + structCount(application.wheels.cache[arguments.type][loc.i])>
		</cfloop>
	</cfif>

	<cfreturn loc.result>
</cffunction>

<cffunction name="$clearCache" returntype="void" access="public" output="false">
	<cfargument name="category" type="string" required="false" default="">
	<cfargument name="type" type="string" required="false" default="external">
	<cfset var loc = {}>

	<cfif Len(arguments.category) IS NOT 0>
		<cfset structClear(application.wheels.cache[arguments.type][arguments.category])>
	<cfelse>
		<cfloop collection="#application.wheels.cache[arguments.type]#" item="loc.i">
			<cfset structClear(application.wheels.cache[loc.i])>
		</cfloop>
	</cfif>

</cffunction>

<cffunction name="$namedReadLock" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="object" type="any" required="true">
	<cfargument name="method" type="string" required="true">
	<cfargument name="args" type="struct" required="false" default="#StructNew()#">
	<cfset var loc = StructNew()>
	<cflock name="#arguments.name#" type="readonly" timeout="30">
		<cfset loc.returnValue = $invoke(component=arguments.object, method=arguments.method, argumentCollection=arguments.args)>
	</cflock>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$doubleCheckedLock" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="path" type="struct" required="true">
	<cfargument name="key" type="string" required="true">
	<cfargument name="method" type="string" required="true">
	<cfargument name="args" type="struct" required="false" default="#StructNew()#">
	<cfif NOT StructKeyExists(arguments.path, arguments.key)>
   	<cflock name="#arguments.name#" type="exclusive" timeout="30">
			<cfif NOT StructKeyExists(arguments.path, arguments.key)>
				<cfset arguments.path[arguments.key] = $invoke(method=arguments.method, argumentCollection=arguments.args)>
			</cfif>
		</cflock>
	</cfif>
	<cfreturn arguments.path[arguments.key]>
</cffunction>

<cffunction name="$capitalize" returntype="string" access="public" output="false">
	<cfargument name="text" type="string" required="true">
	<cfreturn UCase(Left(arguments.text, 1)) & Mid(arguments.text, 2, Len(arguments.text)-1)>
</cffunction>

<cffunction name="$singularizeOrPluralize" returntype="string" access="public" output="false">
	<cfargument name="text" type="string" required="true">
	<cfargument name="which" type="string" required="true">
	<cfargument name="count" type="numeric" required="false" default="-1">
	<cfargument name="returnCount" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		loc.returnValue = arguments.text;
		if (arguments.count != 1)
		{
			loc.uncountables = "advice,air,blood,deer,equipment,fish,food,furniture,garbage,graffiti,grass,homework,housework,information,knowledge,luggage,mathematics,meat,milk,money,music,pollution,research,rice,sand,series,sheep,soap,software,species,sugar,traffic,transportation,travel,trash,water";
			loc.irregulars = "child,children,foot,feet,man,men,move,moves,person,people,sex,sexes,tooth,teeth,woman,women";
			if (ListFindNoCase(loc.uncountables, arguments.text))
			{
				loc.returnValue = arguments.text;
			}
			else if (ListFindNoCase(loc.irregulars, arguments.text))
			{
				loc.pos = ListFindNoCase(loc.irregulars, arguments.text);
				if (arguments.which IS "singularize" && loc.pos MOD 2 == 0)
					loc.returnValue = ListGetAt(loc.irregulars, loc.pos-1);
				else if (arguments.which IS "pluralize" && loc.pos MOD 2 != 0)
					loc.returnValue = ListGetAt(loc.irregulars, loc.pos+1);
				else
					loc.returnValue = arguments.text;
			}
			else
			{
				if (arguments.which IS "pluralize")
					loc.ruleList = "(quiz)$,\1zes,^(ox)$,\1en,([m|l])ouse$,\1ice,(matr|vert|ind)ix|ex$,\1ices,(x|ch|ss|sh)$,\1es,([^aeiouy]|qu)ies$,\1y,([^aeiouy]|qu)y$,\1ies,(hive)$,\1s,(?:([^f])fe|([lr])f)$,\1\2ves,sis$,ses,([ti])um$,\1a,(buffal|tomat|potat|volcan|her)o$,\1oes,(bu)s$,\1ses,(alias|status),\1es,(octop|vir)us$,\1i,(ax|test)is$,\1es,s$,s,$,s";
				else if (arguments.which IS "singularize")
					loc.ruleList = "(quiz)zes$,\1,(matr)ices$,\1ix,(vert|ind)ices$,\1ex,^(ox)en,\1,(alias|status)es$,\1,([octop|vir])i$,\1us,(cris|ax|test)es$,\1is,(shoe)s$,\1,(o)es$,\1,(bus)es$,\1,([m|l])ice$,\1ouse,(x|ch|ss|sh)es$,\1,(m)ovies$,\1ovie,(s)eries$,\1eries,([^aeiouy]|qu)ies$,\1y,([lr])ves$,\1f,(tive)s$,\1,(hive)s$,\1,([^f])ves$,\1fe,(^analy)ses$,\1sis,((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$,\1\2sis,([ti])a$,\1um,(n)ews$,\1ews,s$,¤";
				loc.rules = ArrayNew(2);
				loc.count = 1;
				for (loc.i=1; loc.i LTE ListLen(loc.ruleList); loc.i=loc.i+2)
				{
					loc.rules[loc.count][1] = ListGetAt(loc.ruleList, loc.i);
					loc.rules[loc.count][2] = ListGetAt(loc.ruleList, loc.i+1);
					loc.count = loc.count + 1;
				}
				for (loc.i=1; loc.i LTE ArrayLen(loc.rules); loc.i=loc.i+1)
				{
					if(REFindNoCase(loc.rules[loc.i][1], arguments.text))
					{
						loc.returnValue = REReplaceNoCase(arguments.text, loc.rules[loc.i][1], loc.rules[loc.i][2]);
						break;
					}
				}
				loc.returnValue = Replace(loc.returnValue, "¤", "", "all");
			}
		}
		if (arguments.returnCount AND arguments.count != -1)
			loc.returnValue = arguments.count & " " & loc.returnValue;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$singularize" returntype="string" access="public" output="false">
	<cfargument name="word" type="string" required="true">
	<cfreturn $singularizeOrPluralize(text=arguments.word, which="singularize")>
</cffunction>

<cffunction name="$pluralize" returntype="string" access="public" output="false">
	<cfargument name="word" type="string" required="true">
	<cfargument name="count" type="numeric" required="false" default="-1">
	<cfargument name="returnCount" type="boolean" required="false" default="true">
	<cfreturn $singularizeOrPluralize(text=arguments.word, which="pluralize", count=arguments.count, returnCount=arguments.returnCount)>
</cffunction>

<cffunction name="$createClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.fileName = $capitalize(arguments.name);
		if (FileExists(ExpandPath("#application.wheels.modelPath#/#loc.fileName#.cfc")))
			application.wheels.existingModelFiles = ListAppend(application.wheels.existingModelFiles, arguments.name);
		else
			loc.fileName = "Model";
		loc.returnValue = $createObjectFromRoot(objectType="modelClass", fileName=loc.fileName, name=arguments.name);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>