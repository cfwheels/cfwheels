<cffunction name="_controller" returntype="any" access="private" output="false">
	<cfargument name="name" type="any" required="true">

	<cfif NOT structKeyExists(application.wheels.controllers, arguments.name)>
   	<cflock name="controllerLock" type="exclusive" timeout="30">
			<cfif NOT structKeyExists(application.wheels.controllers, arguments.name)>
				<cfset application.wheels.controllers[arguments.name] = createObject("component", "controllerRoot.#lCase(arguments.name)#")._initControllerClass(arguments.name)>
			</cfif>
		</cflock>
	</cfif>

	<cfreturn application.wheels.controllers[arguments.name]>
</cffunction>

<cffunction name="_flatten" returntype="any" access="private" output="false">
	<cfargument name="values" type="any" required="false" default="">
	<cfset var locals = structNew()>

	<cfset locals.result = "">
	<cfif isStruct(arguments.values)>
		<cfloop collection="#arguments.values#" item="locals.i">
			<cfif isSimpleValue(arguments.values[locals.i])>
				<cfset locals.element = lCase(locals.i) & "=" & """" & lCase(arguments.values[locals.i]) & """">
			<cfelse>
				<cfset locals.element = _flatten(arguments.values[locals.i])>
			</cfif>
			<cfset locals.result = listAppend(locals.result, locals.element, "&")>
		</cfloop>
	<cfelseif isArray(arguments.values)>
		<cfloop from="1" to="#arrayLen(arguments.values)#" index="locals.i">
			<cfif isSimpleValue(arguments.values[locals.i])>
				<cfset locals.element = lCase(locals.i) & "=" & """" & lCase(arguments.values[locals.i]) & """">
			<cfelse>
				<cfset locals.element = _flatten(arguments.values[locals.i])>
			</cfif>
			<cfset locals.result = listAppend(locals.result, locals.element, "&")>
		</cfloop>
	</cfif>

	<cfreturn listSort(locals.result, "text", "asc", "&")>
</cffunction>

<cffunction name="_hashStruct" returntype="any" access="private" output="false">
	<cfargument name="args" type="any" required="false" default="">
	<cfreturn hash(_flatten(arguments.args))>
</cffunction>

<cffunction name="_singularize" returntype="any" access="private" output="false">
	<cfargument name="text" type="any" required="true">
	<cfset var locals = structNew()>

	<cfset locals.result = arguments.text>
	<cfset locals.firstLetter = left(locals.result, 1)>

	<cfset locals.singularizationRules = arrayNew(2)>
	<cfset locals.singularizationRules[1][1] = "equipment">
	<cfset locals.singularizationRules[1][2] = "equipment">
	<cfset locals.singularizationRules[2][1] = "information">
	<cfset locals.singularizationRules[2][2] = "information">
	<cfset locals.singularizationRules[3][1] = "rice">
	<cfset locals.singularizationRules[3][2] = "rice">
	<cfset locals.singularizationRules[4][1] = "money">
	<cfset locals.singularizationRules[4][2] = "money">
	<cfset locals.singularizationRules[5][1] = "species">
	<cfset locals.singularizationRules[5][2] = "species">
	<cfset locals.singularizationRules[6][1] = "series">
	<cfset locals.singularizationRules[6][2] = "series">
	<cfset locals.singularizationRules[7][1] = "fish">
	<cfset locals.singularizationRules[7][2] = "fish">
	<cfset locals.singularizationRules[8][1] = "sheep">
	<cfset locals.singularizationRules[8][2] = "sheep">
	<!--- Irregulars --->
	<cfset locals.singularizationRules[9][1] = "person">
	<cfset locals.singularizationRules[9][2] = "people">
	<cfset locals.singularizationRules[10][1] = "man">
	<cfset locals.singularizationRules[10][2] = "men">
	<cfset locals.singularizationRules[11][1] = "child">
	<cfset locals.singularizationRules[11][2] = "children">
	<cfset locals.singularizationRules[12][1] = "sex">
	<cfset locals.singularizationRules[12][2] = "sexes">
	<cfset locals.singularizationRules[13][1] = "move">
	<cfset locals.singularizationRules[13][2] = "moves">
	<!--- Everything else --->
	<cfset locals.singularizationRules[14][1] = "(quiz)zes$">
	<cfset locals.singularizationRules[14][2] = "\1">
	<cfset locals.singularizationRules[15][1] = "(matr)ices$">
	<cfset locals.singularizationRules[15][2] = "\1ix">
	<cfset locals.singularizationRules[16][1] = "(vert|ind)ices$">
	<cfset locals.singularizationRules[16][2] = "\1ex">
	<cfset locals.singularizationRules[17][1] = "^(ox)en">
	<cfset locals.singularizationRules[17][2] = "\1">
	<cfset locals.singularizationRules[18][1] = "(alias|status)es$">
	<cfset locals.singularizationRules[18][2] = "\1">
	<cfset locals.singularizationRules[19][1] = "([octop|vir])i$">
	<cfset locals.singularizationRules[19][2] = "\1us">
	<cfset locals.singularizationRules[20][1] = "(cris|ax|test)es$">
	<cfset locals.singularizationRules[20][2] = "\1is">
	<cfset locals.singularizationRules[21][1] = "(shoe)s$">
	<cfset locals.singularizationRules[21][2] = "\1">
	<cfset locals.singularizationRules[22][1] = "(o)es$">
	<cfset locals.singularizationRules[22][2] = "\1">
	<cfset locals.singularizationRules[23][1] = "(bus)es$">
	<cfset locals.singularizationRules[23][2] = "\1">
	<cfset locals.singularizationRules[24][1] = "([m|l])ice$">
	<cfset locals.singularizationRules[24][2] = "\1ouse">
	<cfset locals.singularizationRules[25][1] = "(x|ch|ss|sh)es$">
	<cfset locals.singularizationRules[25][2] = "\1">
	<cfset locals.singularizationRules[26][1] = "(m)ovies$">
	<cfset locals.singularizationRules[26][2] = "\1ovie">
	<cfset locals.singularizationRules[27][1] = "(s)eries$">
	<cfset locals.singularizationRules[27][2] = "\1eries">
	<cfset locals.singularizationRules[28][1] = "([^aeiouy]|qu)ies$">
	<cfset locals.singularizationRules[28][2] = "\1y">
	<cfset locals.singularizationRules[29][1] = "([lr])ves$">
	<cfset locals.singularizationRules[29][2] = "\1f">
	<cfset locals.singularizationRules[30][1] = "(tive)s$">
	<cfset locals.singularizationRules[30][2] = "\1">
	<cfset locals.singularizationRules[31][1] = "(hive)s$">
	<cfset locals.singularizationRules[31][2] = "\1">
	<cfset locals.singularizationRules[32][1] = "([^f])ves$">
	<cfset locals.singularizationRules[32][2] = "\1fe">
	<cfset locals.singularizationRules[33][1] = "(^analy)ses$">
	<cfset locals.singularizationRules[33][2] = "\1sis">
	<cfset locals.singularizationRules[34][1] = "((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$">
	<cfset locals.singularizationRules[34][2] = "\1\2sis">
	<cfset locals.singularizationRules[35][1] = "([ti])a$">
	<cfset locals.singularizationRules[35][2] = "\1um">
	<cfset locals.singularizationRules[36][1] = "(n)ews$">
	<cfset locals.singularizationRules[36][2] = "\1ews">
	<cfset locals.singularizationRules[37][1] = "s$">
	<cfset locals.singularizationRules[37][2] = "">

	<cfloop from="1" to="#arrayLen(locals.singularizationRules)#" index="locals.i">
		<cfif REFindNoCase(locals.singularizationRules[locals.i][1], arguments.text)>
			<cfset locals.result = REReplaceNoCase(arguments.text, locals.singularizationRules[locals.i][1], locals.singularizationRules[locals.i][2])>
			<cfset locals.result = locals.firstLetter & right(locals.result, len(locals.result)-1)>
			<cfbreak>
		</cfif>
	</cfloop>

	<cfreturn locals.result>
</cffunction>

<cffunction name="_pluralize" returntype="any" access="private" output="false">
	<cfargument name="text" type="any" required="true">
	<cfset var locals = structNew()>

	<cfset locals.result = arguments.text>
	<cfset locals.firstLetter = left(locals.result, 1)>

	<cfset locals.pluralizationRules = arrayNew(2)>
	<!--- Uncountables --->
	<cfset locals.pluralizationRules[1][1] = "equipment">
	<cfset locals.pluralizationRules[1][2] = "equipment">
	<cfset locals.pluralizationRules[2][1] = "information">
	<cfset locals.pluralizationRules[2][2] = "information">
	<cfset locals.pluralizationRules[3][1] = "rice">
	<cfset locals.pluralizationRules[3][2] = "rice">
	<cfset locals.pluralizationRules[4][1] = "money">
	<cfset locals.pluralizationRules[4][2] = "money">
	<cfset locals.pluralizationRules[5][1] = "species">
	<cfset locals.pluralizationRules[5][2] = "species">
	<cfset locals.pluralizationRules[6][1] = "series">
	<cfset locals.pluralizationRules[6][2] = "series">
	<cfset locals.pluralizationRules[7][1] = "fish">
	<cfset locals.pluralizationRules[7][2] = "fish">
	<cfset locals.pluralizationRules[8][1] = "sheep">
	<cfset locals.pluralizationRules[8][2] = "sheep">
	<!--- Irregulars --->
	<cfset locals.pluralizationRules[9][1] = "person">
	<cfset locals.pluralizationRules[9][2] = "people">
	<cfset locals.pluralizationRules[10][1] = "man">
	<cfset locals.pluralizationRules[10][2] = "men">
	<cfset locals.pluralizationRules[11][1] = "child">
	<cfset locals.pluralizationRules[11][2] = "children">
	<cfset locals.pluralizationRules[12][1] = "sex">
	<cfset locals.pluralizationRules[12][2] = "sexes">
	<cfset locals.pluralizationRules[13][1] = "move">
	<cfset locals.pluralizationRules[13][2] = "moves">
	<!--- Everything else --->
	<cfset locals.pluralizationRules[14][1] = "(quiz)$">
	<cfset locals.pluralizationRules[14][2] = "\1zes">
	<cfset locals.pluralizationRules[15][1] = "^(ox)$">
	<cfset locals.pluralizationRules[15][2] = "\1en">
	<cfset locals.pluralizationRules[16][1] = "([m|l])ouse$">
	<cfset locals.pluralizationRules[16][2] = "\1ice">
	<cfset locals.pluralizationRules[17][1] = "(matr|vert|ind)ix|ex$">
	<cfset locals.pluralizationRules[17][2] = "\1ices">
	<cfset locals.pluralizationRules[18][1] = "(x|ch|ss|sh)$">
	<cfset locals.pluralizationRules[18][2] = "\1es">
	<cfset locals.pluralizationRules[19][1] = "([^aeiouy]|qu)ies$">
	<cfset locals.pluralizationRules[19][2] = "\1y">
	<cfset locals.pluralizationRules[20][1] = "([^aeiouy]|qu)y$">
	<cfset locals.pluralizationRules[20][2] = "\1ies">
	<cfset locals.pluralizationRules[21][1] = "(hive)$">
	<cfset locals.pluralizationRules[21][2] = "\1s">
	<cfset locals.pluralizationRules[22][1] = "(?:([^f])fe|([lr])f)$">
	<cfset locals.pluralizationRules[22][2] = "\1\2ves">
	<cfset locals.pluralizationRules[23][1] = "sis$">
	<cfset locals.pluralizationRules[23][2] = "ses">
	<cfset locals.pluralizationRules[24][1] = "([ti])um$">
	<cfset locals.pluralizationRules[24][2] = "\1a">
	<cfset locals.pluralizationRules[25][1] = "(buffal|tomat)o$">
	<cfset locals.pluralizationRules[25][2] = "\1oes">
	<cfset locals.pluralizationRules[26][1] = "(bu)s$">
	<cfset locals.pluralizationRules[26][2] = "\1ses">
	<cfset locals.pluralizationRules[27][1] = "(alias|status)">
	<cfset locals.pluralizationRules[27][2] = "\1es">
	<cfset locals.pluralizationRules[28][1] = "(octop|vir)us$">
	<cfset locals.pluralizationRules[28][2] = "\1i">
	<cfset locals.pluralizationRules[29][1] = "(ax|test)is$">
	<cfset locals.pluralizationRules[29][2] = "\1es">
	<cfset locals.pluralizationRules[30][1] = "s$">
	<cfset locals.pluralizationRules[30][2] = "s">
	<cfset locals.pluralizationRules[31][1] = "$">
	<cfset locals.pluralizationRules[31][2] = "s">

	<cfloop from="1" to="#arrayLen(locals.pluralizationRules)#" index="locals.i">
		<cfif REFindNoCase(locals.pluralizationRules[locals.i][1], arguments.text)>
			<cfset locals.result = REReplaceNoCase(arguments.text, locals.pluralizationRules[locals.i][1], locals.pluralizationRules[locals.i][2])>
			<cfset locals.result = locals.firstLetter & right(locals.result, len(locals.result)-1)>
			<cfbreak>
		</cfif>
	</cfloop>

	<cfreturn locals.result>
</cffunction>

<cffunction name="_addToCache" returntype="any" access="private" output="false">
	<cfargument name="key" type="any" required="true">
	<cfargument name="value" type="any" required="true">
	<cfargument name="time" type="any" required="true">
	<cfargument name="category" type="any" required="false" default="main">
	<cfargument name="type" type="any" required="false" default="external">
	<cfset var locals = structNew()>

	<cfif arguments.type IS "external" AND application.settings.cacheCullPercentage GT 0 AND application.wheels.cacheLastCulledAt LT dateAdd("n", -application.settings.cacheCullInterval, now()) AND _cacheCount() GTE application.settings.maximumItemsToCache>
		<!--- cache is full so flush out expired items from this cache to make more room if possible --->
		<cfset locals.deletedItems = 0>
		<cfset locals.cacheCount = _cacheCount()>
		<cfloop collection="#application.wheels.cache[arguments.type][arguments.category]#" item="locals.i">
			<cfif now() GT application.wheels.cache[arguments.type][arguments.category][locals.i].expiresAt>
				<cfset structDelete(application.wheels.cache[arguments.type][arguments.category], locals.i)>
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

	<cfif arguments.type IS "internal" OR _cacheCount() LT application.settings.maximumItemsToCache>
		<cfset application.wheels.cache[arguments.type][arguments.category][arguments.key] = structNew()>
		<cfset application.wheels.cache[arguments.type][arguments.category][arguments.key].expiresAt = dateAdd("n", arguments.time, now())>
		<cfif isSimpleValue(arguments.value)>
			<cfset application.wheels.cache[arguments.type][arguments.category][arguments.key].value = arguments.value>
		<cfelse>
			<cfset application.wheels.cache[arguments.type][arguments.category][arguments.key].value = duplicate(arguments.value)>
		</cfif>
	</cfif>

</cffunction>

<cffunction name="_getFromCache" returntype="any" access="private" output="false">
	<cfargument name="key" type="any" required="true">
	<cfargument name="category" type="any" required="false" default="main">
	<cfargument name="type" type="any" required="false" default="external">

	<cfif structKeyExists(application.wheels.cache[arguments.type][arguments.category], arguments.key)>
		<cfif now() GT application.wheels.cache[arguments.type][arguments.category][arguments.key].expiresAt>
			<cfset structDelete(application.wheels.cache[arguments.type][arguments.category], arguments.key)>
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

<cffunction name="_removeFromCache" returntype="any" access="private" output="false">
	<cfargument name="key" type="any" required="true">
	<cfargument name="category" type="any" required="false" default="main">
	<cfargument name="type" type="any" required="false" default="external">

	<cfif structKeyExists(application.wheels.cache[arguments.type][arguments.category], arguments.key)>
		<cfset structDelete(application.wheels.cache[arguments.type][arguments.category], arguments.key)>
	</cfif>

	<cfreturn true>
</cffunction>

<cffunction name="_cacheCount" returntype="any" access="private" output="false">
	<cfargument name="category" type="any" required="false" default="">
	<cfargument name="type" type="any" required="false" default="external">
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

<cffunction name="_clearCache" returntype="any" access="private" output="false">
	<cfargument name="category" type="any" required="false" default="">
	<cfargument name="type" type="any" required="false" default="external">
	<cfset var locals = structNew()>

	<cfif len(arguments.category) IS NOT 0>
		<cfset structClear(application.wheels.cache[arguments.type][arguments.category])>
	<cfelse>
		<cfloop collection="#application.wheels.cache[arguments.type]#" item="locals.i">
			<cfset structClear(application.wheels.cache[locals.i])>
		</cfloop>
	</cfif>

	<cfreturn true>
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

<!--- Miscellaneous Methods --->

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

<cffunction name="$hashArguments" returntype="string" access="private" output="false">
	<cfargument name="args" type="struct" required="true">
	<cfreturn Hash(ListSort($flatten(arguments.args), "text", "asc", "&"))>
</cffunction>
