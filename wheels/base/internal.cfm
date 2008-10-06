<cffunction name="$controller" returntype="any" access="private" output="false">
	<cfargument name="name" type="string" required="true">
	<cfset var loc = {}>
	<cfset arguments.name = capitalize(arguments.name)>
	<cfif NOT StructKeyExists(application.wheels.controllers, arguments.name)>
   	<cflock name="controllerLock" type="exclusive" timeout="30">
			<cfif NOT StructKeyExists(application.wheels.controllers, arguments.name)>
				<cfset loc.rootObject = "controllerClass">
				<cfinclude template="../../root.cfm">
				<cfset application.wheels.controllers[arguments.name] = loc.rootObject>
			</cfif>
		</cflock>
	</cfif>

	<cfreturn application.wheels.controllers[arguments.name]>
</cffunction>

<cffunction name="$flatten" returntype="string" access="private" output="false">
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

<cffunction name="$hashStruct" returntype="string" access="private" output="false">
	<cfargument name="args" type="struct" required="true">
	<cfreturn Hash(ListSort($flatten(arguments.args), "text", "asc", "&"))>
</cffunction>

<cffunction name="$addToCache" returntype="void" access="private" output="false">
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

<cffunction name="$getFromCache" returntype="any" access="private" output="false">
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

<cffunction name="$removeFromCache" returntype="void" access="private" output="false">
	<cfargument name="key" type="string" required="true">
	<cfargument name="category" type="string" required="false" default="main">
	<cfargument name="type" type="string" required="false" default="external">
	<cfset StructDelete(application.wheels.cache[arguments.type][arguments.category], arguments.key)>
</cffunction>

<cffunction name="$cacheCount" returntype="numeric" access="private" output="false">
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

<cffunction name="$clearCache" returntype="void" access="private" output="false">
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

<cffunction name="$namedReadLock" returntype="any" access="private" output="false">
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

<cffunction name="$doubleCheckedLock" returntype="any" access="private" output="false">
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

<cffunction name="$directory" returntype="any" access="private" output="false">
	<cfset var loc = StructNew()>
	<cfset arguments.name = "loc.returnValue">
	<cfdirectory attributeCollection="#arguments#">
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$file" returntype="any" access="private" output="false">
	<cfset var loc = StructNew()>
	<cfset arguments.variable = "loc.returnValue">
	<cffile attributeCollection="#arguments#">
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$throw" returntype="void" access="private" output="false">
	<cfthrow attributeCollection="#arguments#">
</cffunction>

<cffunction name="$invoke" returntype="any" access="private" output="false">
	<cfset var loc = StructNew()>
	<cfset arguments.returnVariable = "loc.returnValue">
	<cfinvoke attributeCollection="#arguments#">
	<cfif StructKeyExists(loc, "returnValue")>
		<cfreturn loc.returnValue>
	</cfif>
</cffunction>

<cffunction name="$dbinfo" returntype="any" access="private" output="false">
	<cfset var loc = StructNew()>
	<cfset arguments.name = "loc.returnValue">
	<!--- we have to use this cfif here to get around a bug with railo --->
	<cfif StructKeyExists(arguments, "table")>
		<cfdbinfo datasource="#arguments.datasource#" name="#arguments.name#" type="#arguments.type#" username="#arguments.username#" password="#arguments.password#" table="#arguments.table#">
	<cfelse>
		<cfdbinfo datasource="#arguments.datasource#" name="#arguments.name#" type="#arguments.type#" username="#arguments.username#" password="#arguments.password#">
	</cfif>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$dump" returntype="void" access="private" output="true">
	<cfargument name="var" type="any" required="true">
	<cfargument name="abort" type="boolean" required="false" default="true">
	<cfdump var="#arguments.var#">
	<cfif arguments.abort>
		<cfabort>
	</cfif>
</cffunction>

<cffunction name="capitalize" returntype="string" access="public" output="false" hint="View, Helper, Returns the text with the first character converted to uppercase.">
	<cfargument name="text" type="string" required="true" hint="Text to capitalize">

	<!---
		EXAMPLES:
		#capitalize("wheels is a framework")#
		-> Wheels is a framework

		RELATED:
		 * [MiscellaneousHelpers Miscellaneous Helpers] (chapter)
		 * [autoLink autoLink()] (function)
		 * [cycle cycle()] (function)
		 * [excerpt excerpt()] (function)
		 * [highlight highlight()] (function)
		 * [pluralize pluralize()] (function)
		 * [resetCycle resetCycle()] (function)
		 * [simpleFormat simpleFormat()] (function)
		 * [singularize singularize()] (function)
		 * [stripLinks stripLinks()] (function)
		 * [stripTags stripTags()] (function)
		 * [titleize titleize()] (function)
		 * [truncate truncate()] (function)
	--->

	<cfreturn UCase(Left(arguments.text, 1)) & Mid(arguments.text, 2, Len(arguments.text)-1)>
</cffunction>

<cffunction name="$singularizeOrPluralize" returntype="string" access="private" output="false">
	<cfargument name="text" type="string" required="true">
	<cfargument name="which" type="string" required="true">
	<cfargument name="count" type="numeric" required="false" default="-1">
	<cfargument name="returnCount" type="boolean" required="false" default="true">
	<cfscript>
		var loc = {};
		loc.returnValue = arguments.text;
		if (arguments.count != 1)
		{
			loc.firstLetter = Left(loc.returnValue, 1);
			loc.uncountables = "equipment,equipment,information,information,rice,rice,money,money,species,species,series,series,fish,fish,sheep,sheep";
			loc.irregulars = "person,people,man,men,child,children,sex,sexes,move,moves";
			if (arguments.which IS "pluralize")
				loc.other = "(quiz)$,\1zes,^(ox)$,\1en,([m|l])ouse$,\1ice,(matr|vert|ind)ix|ex$,\1ices,(x|ch|ss|sh)$,\1es,([^aeiouy]|qu)ies$,\1y,([^aeiouy]|qu)y$,\1ies,(hive)$,\1s,(?:([^f])fe|([lr])f)$,\1\2ves,sis$,ses,([ti])um$,\1a,(buffal|tomat)o$,\1oes,(bu)s$,\1ses,(alias|status),\1es,(octop|vir)us$,\1i,(ax|test)is$,\1es,s$,s,$,s";
			else if (arguments.which IS "singularize")
				loc.other = "(quiz)zes$,\1,(matr)ices$,\1ix,(vert|ind)ices$,\1ex,^(ox)en,\1,(alias|status)es$,\1,([octop|vir])i$,\1us,(cris|ax|test)es$,\1is,(shoe)s$,\1,(o)es$,\1,(bus)es$,\1,([m|l])ice$,\1ouse,(x|ch|ss|sh)es$,\1,(m)ovies$,\1ovie,(s)eries$,\1eries,([^aeiouy]|qu)ies$,\1y,([lr])ves$,\1f,(tive)s$,\1,(hive)s$,\1,([^f])ves$,\1fe,(^analy)ses$,\1sis,((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$,\1\2sis,([ti])a$,\1um,(n)ews$,\1ews,s$,¤";
			loc.ruleList = loc.uncountables & "," & loc.irregulars & "," & loc.other;
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
					loc.returnValue = loc.firstLetter & Right(loc.returnValue, Len(loc.returnValue)-1);
					break;
				}
			}
			loc.returnValue = Replace(loc.returnValue, "¤", "", "all");
		}
		if (arguments.returnCount AND arguments.count != -1)
			loc.returnValue = arguments.count & " " & loc.returnValue;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="singularize" returntype="string" access="public" output="false" hint="View, Helper, Returns the singular form of the passed in word.">
	<cfargument name="word" type="string" required="true" hint="String to singularize.">

	<!---
		EXAMPLES:
		#singularize("languages")#
		-> language

		RELATED:
		 * [MiscellaneousHelpers Miscellaneous Helpers] (chapter)
		 * [autoLink autoLink()] (function)
		 * [capitalize capitalize()] (function)
		 * [cycle cycle()] (function)
		 * [excerpt excerpt()] (function)
		 * [highlight highlight()] (function)
		 * [pluralize pluralize()] (function)
		 * [resetCycle resetCycle()] (function)
		 * [simpleFormat simpleFormat()] (function)
		 * [stripLinks stripLinks()] (function)
		 * [stripTags stripTags()] (function)
		 * [titleize titleize()] (function)
		 * [truncate truncate()] (function)
	--->

	<cfreturn $singularizeOrPluralize(text=arguments.word, which="singularize")>
</cffunction>

<cffunction name="pluralize" returntype="string" access="public" output="false" hint="View, Helper, Returns the plural form of the passed in word.">
	<cfargument name="word" type="string" required="true" hint="The word to pluralize.">
	<cfargument name="count" type="numeric" required="false" default="-1" hint="Pluralization will occur when this value is not 1.">
	<cfargument name="returnCount" type="boolean" required="false" default="true" hint="Will return the count prepended to the pluralization when true and count is not -1.">

	<!---
		EXAMPLES:
		#pluralize("person")#
		-> people

		Your search returned #pluralize(word="person", count=users.recordCount)#.

		RELATED:
		 * [MiscellaneousHelpers Miscellaneous Helpers] (chapter)
		 * [autoLink autoLink()] (function)
		 * [capitalize capitalize()] (function)
		 * [cycle cycle()] (function)
		 * [excerpt excerpt()] (function)
		 * [highlight highlight()] (function)
		 * [resetCycle resetCycle()] (function)
		 * [simpleFormat simpleFormat()] (function)
		 * [singularize singularize()] (function)
		 * [stripLinks stripLinks()] (function)
		 * [stripTags stripTags()] (function)
		 * [titleize titleize()] (function)
		 * [truncate truncate()] (function)
	--->

	<cfreturn $singularizeOrPluralize(text=arguments.word, which="pluralize", count=arguments.count, returnCount=arguments.returnCount)>
</cffunction>

<cffunction name="$createClass" returntype="any" access="private" output="false">
	<cfargument name="name" type="string" required="true">
	<cfset var loc = {}>
	<cfset arguments.name = capitalize(arguments.name)>
	<cfif fileExists(expandPath("#application.wheels.modelPath#/#arguments.name#.cfc"))>
		<cfset arguments.fileName = arguments.name>
	<cfelse>
		<cfset arguments.fileName = "Model">
	</cfif>
	<cfset loc.rootObject = "modelClass">
	<cfinclude template="../../root.cfm">
	<cfreturn loc.rootObject>
</cffunction>