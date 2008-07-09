<cffunction name="$controller" returntype="any" access="private" output="false">
	<cfargument name="name" type="string" required="true">

	<cfif NOT structKeyExists(application.wheels.controllers, arguments.name)>
   	<cflock name="controllerLock" type="exclusive" timeout="30">
			<cfif NOT structKeyExists(application.wheels.controllers, arguments.name)>
				<cfset application.wheels.controllers[arguments.name] = createObject("component", "controllerRoot.#$capitalize(arguments.name)#").$initControllerClass(arguments.name)>
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
			for (loc.i=1; loc.i<=loc.iEnd; loc.i++)
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
	<cfset var locals = structNew()>

	<cfif arguments.type IS "external" AND application.settings.cacheCullPercentage GT 0 AND application.wheels.cacheLastCulledAt LT dateAdd("n", -application.settings.cacheCullInterval, now()) AND $cacheCount() GTE application.settings.maximumItemsToCache>
		<!--- cache is full so flush out expired items from this cache to make more room if possible --->
		<cfset locals.deletedItems = 0>
		<cfset locals.cacheCount = $cacheCount()>
		<cfloop collection="#application.wheels.cache[arguments.type][arguments.category]#" item="locals.i">
			<cfif now() GT application.wheels.cache[arguments.type][arguments.category][locals.i].expiresAt>
				<cfset $removeFromCache(key=locals.i, category=arguments.category, type=arguments.type)>
				<cfif application.settings.cacheCullPercentage LT 100>
					<cfset locals.deletedItems = locals.deletedItems + 1>
					<cfset locals.percentageDeleted = (locals.deletedItems / locals.cacheCount) * 100>
					<cfif locals.percentageDeleted GTE application.settings.cacheCullPercentage>
						<cfbreak>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<cfset application.wheels.cacheLastCulledAt = now()>
	</cfif>

	<cfif arguments.type IS "internal" OR $cacheCount() LT application.settings.maximumItemsToCache>
		<cfset application.wheels.cache[arguments.type][arguments.category][arguments.key] = structNew()>
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

	<cfif structKeyExists(application.wheels.cache[arguments.type][arguments.category], arguments.key)>
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
	<cfset structDelete(application.wheels.cache[arguments.type][arguments.category], arguments.key)>
</cffunction>

<cffunction name="$cacheCount" returntype="numeric" access="private" output="false">
	<cfargument name="category" type="string" required="false" default="">
	<cfargument name="type" type="string" required="false" default="external">
	<cfset var locals = structNew()>

	<cfif len(arguments.category) IS NOT 0>
		<cfset locals.result = structCount(application.wheels.cache[arguments.type][arguments.category])>
	<cfelse>
		<cfset locals.result = 0>
		<cfloop collection="#application.wheels.cache[arguments.type]#" item="locals.i">
			<cfset locals.result = locals.result + structCount(application.wheels.cache[arguments.type][locals.i])>
		</cfloop>
	</cfif>

	<cfreturn locals.result>
</cffunction>

<cffunction name="$clearCache" returntype="void" access="private" output="false">
	<cfargument name="category" type="string" required="false" default="">
	<cfargument name="type" type="string" required="false" default="external">
	<cfset var locals = structNew()>

	<cfif len(arguments.category) IS NOT 0>
		<cfset structClear(application.wheels.cache[arguments.type][arguments.category])>
	<cfelse>
		<cfloop collection="#application.wheels.cache[arguments.type]#" item="locals.i">
			<cfset structClear(application.wheels.cache[locals.i])>
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
	<cfdbinfo attributeCollection="#arguments#">
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

<cffunction name="$singularizeOrPluralize" returntype="string" access="private" output="false">
	<cfargument name="text" type="string" required="true">
	<cfargument name="which" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = arguments.text;
		loc.firstLetter = Left(loc.returnValue, 1);
		loc.uncountables = "equipment,equipment,information,information,rice,rice,money,money,species,species,series,series,fish,fish,sheep,sheep";
		loc.irregulars = "person,people,man,men,child,children,sex,sexes,move,moves";
		if (arguments.which == "pluralize")
			loc.other = "(quiz)$,\1zes,^(ox)$,\1en,([m|l])ouse$,\1ice,(matr|vert|ind)ix|ex$,\1ices,(x|ch|ss|sh)$,\1es,([^aeiouy]|qu)ies$,\1y,([^aeiouy]|qu)y$,\1ies,(hive)$,\1s,(?:([^f])fe|([lr])f)$,\1\2ves,sis$,ses,([ti])um$,\1a,(buffal|tomat)o$,\1oes,(bu)s$,\1ses,(alias|status),\1es,(octop|vir)us$,\1i,(ax|test)is$,\1es,s$,s,$,s";
		else if (arguments.which == "singularize")
			loc.other = "(quiz)zes$,\1,(matr)ices$,\1ix,(vert|ind)ices$,\1ex,^(ox)en,\1,(alias|status)es$,\1,([octop|vir])i$,\1us,(cris|ax|test)es$,\1is,(shoe)s$,\1,(o)es$,\1,(bus)es$,\1,([m|l])ice$,\1ouse,(x|ch|ss|sh)es$,\1,(m)ovies$,\1ovie,(s)eries$,\1eries,([^aeiouy]|qu)ies$,\1y,([lr])ves$,\1f,(tive)s$,\1,(hive)s$,\1,([^f])ves$,\1fe,(^analy)ses$,\1sis,((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$,\1\2sis,([ti])a$,\1um,(n)ews$,\1ews,s$,¤";
		loc.ruleList = loc.uncountables & "," & loc.irregulars & "," & loc.other;
		loc.rules = ArrayNew(2);
		loc.count = 1;
		for (loc.i=1; loc.i<=ListLen(loc.ruleList); loc.i=loc.i+2)
		{
			loc.rules[loc.count][1] = ListGetAt(loc.ruleList, loc.i);
			loc.rules[loc.count][2] = ListGetAt(loc.ruleList, loc.i+1);
			loc.count++;
		}
		for (loc.i=1; loc.i<=ArrayLen(loc.rules); loc.i++)
		{
			if(REFindNoCase(loc.rules[loc.i][1], arguments.text))
			{
				loc.returnValue = REReplaceNoCase(arguments.text, loc.rules[loc.i][1], loc.rules[loc.i][2]);
				loc.returnValue = loc.firstLetter & Right(loc.returnValue, Len(loc.returnValue)-1);
				break;
			}
		}
		loc.returnValue = Replace(loc.returnValue, "¤", "", "all");
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$capitalize" returntype="string" access="public" output="false">
	<cfargument name="text" type="string" required="true">
	<cfscript>
		var returnValue = UCase(Left(arguments.text, 1)) & Right(arguments.text, Len(arguments.text)-1);
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$singularize" returntype="string" access="private" output="false">
	<cfargument name="text" type="string" required="true">
	<cfscript>
		var returnValue = $singularizeOrPluralize(text=arguments.text, which="singularize");
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$pluralize" returntype="string" access="private" output="false">
	<cfargument name="text" type="string" required="true">
	<cfscript>
		var returnValue = $singularizeOrPluralize(text=arguments.text, which="pluralize");
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<cffunction name="$createClass" returntype="any" access="private" output="false">
	<cfargument name="name" type="string" required="true">
	<cfreturn CreateObject("component", "modelRoot.#arguments.name#").$initClass(arguments.name)>
</cffunction>