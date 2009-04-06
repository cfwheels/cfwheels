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
				if (application.wheels.obfuscateUrls)
					loc.returnValue = loc.returnValue & obfuscateParam(URLEncodedFormat(loc.temp[2]));
				else
					loc.returnValue = loc.returnValue & URLEncodedFormat(loc.temp[2]);
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$insertDefaults" returntype="struct" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="input" type="struct" required="true">
	<cfargument name="reserved" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		if (application.wheels.environment != "production")
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
		StructAppend(arguments.input, application.wheels[arguments.name], false);
		loc.returnValue = arguments.input;
	</cfscript>
	<cfreturn loc.returnValue>
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
			if (FileExists(ExpandPath("#application.wheels.viewPath#/#arguments.name#/helpers.cfm")))
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
		loc.args.name = arguments.name;
		loc.returnValue = $doubleCheckedLock(name="controllerLock", condition="$cachedControllerClassExists", execute="$createControllerClass", conditionArgs=loc.args, executeArgs=loc.args);
	</cfscript>
	<cfreturn loc.returnValue>
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
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
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

<cffunction name="capitalize" returntype="string" access="public" output="false" hint="Returns the text with the first character converted to uppercase.">
	<cfargument name="text" type="string" required="true" hint="Text to capitalize">
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
				if (arguments.which == "singularize" && loc.pos MOD 2 == 0)
					loc.returnValue = ListGetAt(loc.irregulars, loc.pos-1);
				else if (arguments.which == "pluralize" && loc.pos MOD 2 != 0)
					loc.returnValue = ListGetAt(loc.irregulars, loc.pos+1);
				else
					loc.returnValue = arguments.text;
			}
			else
			{
				if (arguments.which == "pluralize")
					loc.ruleList = "(quiz)$,\1zes,^(ox)$,\1en,([m|l])ouse$,\1ice,(matr|vert|ind)ix|ex$,\1ices,(x|ch|ss|sh)$,\1es,([^aeiouy]|qu)ies$,\1y,([^aeiouy]|qu)y$,\1ies,(hive)$,\1s,(?:([^f])fe|([lr])f)$,\1\2ves,sis$,ses,([ti])um$,\1a,(buffal|tomat|potat|volcan|her)o$,\1oes,(bu)s$,\1ses,(alias|status),\1es,(octop|vir)us$,\1i,(ax|test)is$,\1es,s$,s,$,s";
				else if (arguments.which == "singularize")
					loc.ruleList = "(quiz)zes$,\1,(matr)ices$,\1ix,(vert|ind)ices$,\1ex,^(ox)en,\1,(alias|status)es$,\1,([octop|vir])i$,\1us,(cris|ax|test)es$,\1is,(shoe)s$,\1,(o)es$,\1,(bus)es$,\1,([m|l])ice$,\1ouse,(x|ch|ss|sh)es$,\1,(m)ovies$,\1ovie,(s)eries$,\1eries,([^aeiouy]|qu)ies$,\1y,([lr])ves$,\1f,(tive)s$,\1,(hive)s$,\1,([^f])ves$,\1fe,(^analy)ses$,\1sis,((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$,\1\2sis,([ti])a$,\1um,(n)ews$,\1ews,s$,¤";
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
					if(REFindNoCase(loc.rules[loc.i][1], arguments.text))
					{
						loc.returnValue = REReplaceNoCase(arguments.text, loc.rules[loc.i][1], loc.rules[loc.i][2]);
						break;
					}
				}
				loc.returnValue = Replace(loc.returnValue, "¤", "", "all");
			}
		}
		if (arguments.returnCount && arguments.count != -1)
			loc.returnValue = arguments.count & " " & loc.returnValue;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="singularize" returntype="string" access="public" output="false" hint="Returns the singular form of the passed in word.">
	<cfargument name="word" type="string" required="true" hint="String to singularize">
	<cfreturn $singularizeOrPluralize(text=arguments.word, which="singularize")>
</cffunction>

<cffunction name="pluralize" returntype="string" access="public" output="false" hint="Returns the plural form of the passed in word.">
	<cfargument name="word" type="string" required="true" hint="The word to pluralize">
	<cfargument name="count" type="numeric" required="false" default="-1" hint="Pluralization will occur when this value is not 1">
	<cfargument name="returnCount" type="boolean" required="false" default="true" hint="Will return the count prepended to the pluralization when true and count is not -1">
	<cfreturn $singularizeOrPluralize(text=arguments.word, which="pluralize", count=arguments.count, returnCount=arguments.returnCount)>
</cffunction>

<cffunction name="humanize" returntype="string" access="public" output="false" hint="Returns readable text by capitalizing, converting camel casing to multiple words.">
	<cfargument name="text" type="string" required="true" hint="Text to humanize">
	<cfscript>
		var loc = {};
		loc.returnValue = REReplace(arguments.text, "([[:upper:]])", " \1", "all"); // adds a space before every capitalized word
		loc.returnValue = REReplace(loc.returnValue, "([[:upper:]]) ([[:upper:]]) ", "\1\2", "all"); // fixes abbreviations so they form a word again (example: aURLVariable)
		loc.returnValue = capitalize(loc.returnValue); // capitalize the first letter
	</cfscript>
	<cfreturn loc.returnValue>
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