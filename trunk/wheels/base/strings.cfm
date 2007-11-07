<cffunction name="excerpt" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfargument name="phrase" type="any" required="true">
	<cfargument name="radius" type="any" required="false" default="100">
	<cfargument name="excerpt_string" type="any" required="false" default="...">
	<cfset var local = structNew()>

	<cfset local.pos = findNoCase(arguments.phrase, arguments.text, 1)>
	<cfif local.pos IS NOT 0>
		<cfset local.excerpt_string_start = arguments.excerpt_string>
		<cfset local.excerpt_string_end = arguments.excerpt_string>
		<cfset local.start = local.pos-arguments.radius>
		<cfif local.start LTE 0>
			<cfset local.start = 1>
			<cfset local.excerpt_string_start = "">
		</cfif>
		<cfset local.count = len(arguments.phrase)+(arguments.radius*2)>
		<cfif local.count GT (len(arguments.text)-local.start)>
			<cfset local.excerpt_string_end = "">
		</cfif>
		<cfset local.output = local.excerpt_string_start & mid(arguments.text, local.start, local.count) & local.excerpt_string_end>
	<cfelse>
		<cfset local.output = "">
	</cfif>

	<cfreturn local.output>
</cffunction>


<cffunction name="capitalize" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfreturn uCase(left(arguments.text, 1)) & lCase(mid(arguments.text, 2, len(arguments.text)-1))>
</cffunction>


<cffunction name="titleize" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfset var local = structNew()>

	<cfset local.output = "">
	<cfloop list="#arguments.text#" delimiters=" " index="local.i">
		<cfset local.output = listAppend(local.output, capitalize(local.i), " ")>
	</cfloop>

	<cfreturn local.output>
</cffunction>


<cffunction name="cycle" returntype="any" access="public" output="false">
	<cfargument name="values" type="any" required="true">
	<cfargument name="name" type="any" required="false" default="default">
	<cfset var local = structNew()>

	<cfif NOT isDefined("request.wheels.cycle.#arguments.name#")>
		<cfset "request.wheels.cycle.#arguments.name#" = listGetAt(arguments.values, 1)>
	<cfelse>
		<cfset local.found_at = listFindNoCase(arguments.values, request.wheels.cycle[arguments.name])>
		<cfif local.found_at IS listLen(arguments.values)>
			<cfset local.found_at = 0>
		</cfif>
		<cfset "request.wheels.cycle.#arguments.name#" = listGetAt(arguments.values, local.found_at + 1)>
	</cfif>

	<cfreturn request.wheels.cycle[arguments.name]>
</cffunction>


<cffunction name="truncate" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfargument name="length" type="any" required="true">
	<cfargument name="truncate_string" type="any" required="false" default="...">
	<cfset var local = structNew()>

	<cfif len(arguments.text) GT arguments.length>
		<cfset local.output = left(arguments.text, arguments.length-3) & arguments.truncate_string>
	<cfelse>
		<cfset local.output = arguments.text>
	</cfif>

	<cfreturn local.output>
</cffunction>


<cffunction name="humanize" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfset var local = structNew()>
	<cfset local.output = replace(arguments.text, "_id", "", "all")>
	<cfset local.output = replace(local.output, "_", " ", "all")>
	<cfreturn capitalize(local.output)>
</cffunction>


<cffunction name="camelcase" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfset var local = structNew()>
	<cfset local.output = REReplace(arguments.text, "_([a-z])", "\u\1", "all")>
	<cfreturn local.output>
</cffunction>


<cffunction name="underscore" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfset var local = structNew()>
	<cfset local.output = REReplace(arguments.text, "([A-Z])", "_\l\1", "all")>
	<cfif left(local.output, 1) IS "_">
		<cfset local.output = right(local.output, len(local.output)-1)>
	</cfif>
	<cfreturn local.output>
</cffunction>


<cffunction name="singularize" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfset var local = structNew()>

	<cfset local.output = arguments.text>
	<cfset local.first_letter = left(local.output, 1)>

	<cfset local.singularization_rules = arrayNew(2)>
	<cfset local.singularization_rules[1][1] = "equipment">
	<cfset local.singularization_rules[1][2] = "equipment">
	<cfset local.singularization_rules[2][1] = "information">
	<cfset local.singularization_rules[2][2] = "information">
	<cfset local.singularization_rules[3][1] = "rice">
	<cfset local.singularization_rules[3][2] = "rice">
	<cfset local.singularization_rules[4][1] = "money">
	<cfset local.singularization_rules[4][2] = "money">
	<cfset local.singularization_rules[5][1] = "species">
	<cfset local.singularization_rules[5][2] = "species">
	<cfset local.singularization_rules[6][1] = "series">
	<cfset local.singularization_rules[6][2] = "series">
	<cfset local.singularization_rules[7][1] = "fish">
	<cfset local.singularization_rules[7][2] = "fish">
	<cfset local.singularization_rules[8][1] = "sheep">
	<cfset local.singularization_rules[8][2] = "sheep">
	<!--- Irregulars --->
	<cfset local.singularization_rules[9][1] = "person">
	<cfset local.singularization_rules[9][2] = "people">
	<cfset local.singularization_rules[10][1] = "man">
	<cfset local.singularization_rules[10][2] = "men">
	<cfset local.singularization_rules[11][1] = "child">
	<cfset local.singularization_rules[11][2] = "children">
	<cfset local.singularization_rules[12][1] = "sex">
	<cfset local.singularization_rules[12][2] = "sexes">
	<cfset local.singularization_rules[13][1] = "move">
	<cfset local.singularization_rules[13][2] = "moves">
	<!--- Everything else --->
	<cfset local.singularization_rules[14][1] = "(quiz)zes$">
	<cfset local.singularization_rules[14][2] = "\1">
	<cfset local.singularization_rules[15][1] = "(matr)ices$">
	<cfset local.singularization_rules[15][2] = "\1ix">
	<cfset local.singularization_rules[16][1] = "(vert|ind)ices$">
	<cfset local.singularization_rules[16][2] = "\1ex">
	<cfset local.singularization_rules[17][1] = "^(ox)en">
	<cfset local.singularization_rules[17][2] = "\1">
	<cfset local.singularization_rules[18][1] = "(alias|status)es$">
	<cfset local.singularization_rules[18][2] = "\1">
	<cfset local.singularization_rules[19][1] = "([octop|vir])i$">
	<cfset local.singularization_rules[19][2] = "\1us">
	<cfset local.singularization_rules[20][1] = "(cris|ax|test)es$">
	<cfset local.singularization_rules[20][2] = "\1is">
	<cfset local.singularization_rules[21][1] = "(shoe)s$">
	<cfset local.singularization_rules[21][2] = "\1">
	<cfset local.singularization_rules[22][1] = "(o)es$">
	<cfset local.singularization_rules[22][2] = "\1">
	<cfset local.singularization_rules[23][1] = "(bus)es$">
	<cfset local.singularization_rules[23][2] = "\1">
	<cfset local.singularization_rules[24][1] = "([m|l])ice$">
	<cfset local.singularization_rules[24][2] = "\1ouse">
	<cfset local.singularization_rules[25][1] = "(x|ch|ss|sh)es$">
	<cfset local.singularization_rules[25][2] = "\1">
	<cfset local.singularization_rules[26][1] = "(m)ovies$">
	<cfset local.singularization_rules[26][2] = "\1ovie">
	<cfset local.singularization_rules[27][1] = "(s)eries$">
	<cfset local.singularization_rules[27][2] = "\1eries">
	<cfset local.singularization_rules[28][1] = "([^aeiouy]|qu)ies$">
	<cfset local.singularization_rules[28][2] = "\1y">
	<cfset local.singularization_rules[29][1] = "([lr])ves$">
	<cfset local.singularization_rules[29][2] = "\1f">
	<cfset local.singularization_rules[30][1] = "(tive)s$">
	<cfset local.singularization_rules[30][2] = "\1">
	<cfset local.singularization_rules[31][1] = "(hive)s$">
	<cfset local.singularization_rules[31][2] = "\1">
	<cfset local.singularization_rules[32][1] = "([^f])ves$">
	<cfset local.singularization_rules[32][2] = "\1fe">
	<cfset local.singularization_rules[33][1] = "(^analy)ses$">
	<cfset local.singularization_rules[33][2] = "\1sis">
	<cfset local.singularization_rules[34][1] = "((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$">
	<cfset local.singularization_rules[34][2] = "\1\2sis">
	<cfset local.singularization_rules[35][1] = "([ti])a$">
	<cfset local.singularization_rules[35][2] = "\1um">
	<cfset local.singularization_rules[36][1] = "(n)ews$">
	<cfset local.singularization_rules[36][2] = "\1ews">
	<cfset local.singularization_rules[37][1] = "s$">
	<cfset local.singularization_rules[37][2] = "">

	<cfloop from="1" to="#arrayLen(local.singularization_rules)#" index="local.i">
		<cfif REFindNoCase(local.singularization_rules[local.i][1], arguments.text)>
			<cfset local.output = REReplaceNoCase(arguments.text, local.singularization_rules[local.i][1], local.singularization_rules[local.i][2])>
			<cfset local.output = local.first_letter & right(local.output, len(local.output)-1)>
			<cfbreak>
		</cfif>
	</cfloop>

	<cfreturn local.output>
</cffunction>


<cffunction name="pluralize" returntype="any" access="public" output="false">
	<cfargument name="text" type="any" required="true">
	<cfset var local = structNew()>

	<cfset local.output = arguments.text>
	<cfset local.first_letter = left(local.output, 1)>

	<cfset local.pluralization_rules = arrayNew(2)>
	<!--- Uncountables --->
	<cfset local.pluralization_rules[1][1] = "equipment">
	<cfset local.pluralization_rules[1][2] = "equipment">
	<cfset local.pluralization_rules[2][1] = "information">
	<cfset local.pluralization_rules[2][2] = "information">
	<cfset local.pluralization_rules[3][1] = "rice">
	<cfset local.pluralization_rules[3][2] = "rice">
	<cfset local.pluralization_rules[4][1] = "money">
	<cfset local.pluralization_rules[4][2] = "money">
	<cfset local.pluralization_rules[5][1] = "species">
	<cfset local.pluralization_rules[5][2] = "species">
	<cfset local.pluralization_rules[6][1] = "series">
	<cfset local.pluralization_rules[6][2] = "series">
	<cfset local.pluralization_rules[7][1] = "fish">
	<cfset local.pluralization_rules[7][2] = "fish">
	<cfset local.pluralization_rules[8][1] = "sheep">
	<cfset local.pluralization_rules[8][2] = "sheep">
	<!--- Irregulars --->
	<cfset local.pluralization_rules[9][1] = "person">
	<cfset local.pluralization_rules[9][2] = "people">
	<cfset local.pluralization_rules[10][1] = "man">
	<cfset local.pluralization_rules[10][2] = "men">
	<cfset local.pluralization_rules[11][1] = "child">
	<cfset local.pluralization_rules[11][2] = "children">
	<cfset local.pluralization_rules[12][1] = "sex">
	<cfset local.pluralization_rules[12][2] = "sexes">
	<cfset local.pluralization_rules[13][1] = "move">
	<cfset local.pluralization_rules[13][2] = "moves">
	<!--- Everything else --->
	<cfset local.pluralization_rules[14][1] = "(quiz)$">
	<cfset local.pluralization_rules[14][2] = "\1zes">
	<cfset local.pluralization_rules[15][1] = "^(ox)$">
	<cfset local.pluralization_rules[15][2] = "\1en">
	<cfset local.pluralization_rules[16][1] = "([m|l])ouse$">
	<cfset local.pluralization_rules[16][2] = "\1ice">
	<cfset local.pluralization_rules[17][1] = "(matr|vert|ind)ix|ex$">
	<cfset local.pluralization_rules[17][2] = "\1ices">
	<cfset local.pluralization_rules[18][1] = "(x|ch|ss|sh)$">
	<cfset local.pluralization_rules[18][2] = "\1es">
	<cfset local.pluralization_rules[19][1] = "([^aeiouy]|qu)ies$">
	<cfset local.pluralization_rules[19][2] = "\1y">
	<cfset local.pluralization_rules[20][1] = "([^aeiouy]|qu)y$">
	<cfset local.pluralization_rules[20][2] = "\1ies">
	<cfset local.pluralization_rules[21][1] = "(hive)$">
	<cfset local.pluralization_rules[21][2] = "\1s">
	<cfset local.pluralization_rules[22][1] = "(?:([^f])fe|([lr])f)$">
	<cfset local.pluralization_rules[22][2] = "\1\2ves">
	<cfset local.pluralization_rules[23][1] = "sis$">
	<cfset local.pluralization_rules[23][2] = "ses">
	<cfset local.pluralization_rules[24][1] = "([ti])um$">
	<cfset local.pluralization_rules[24][2] = "\1a">
	<cfset local.pluralization_rules[25][1] = "(buffal|tomat)o$">
	<cfset local.pluralization_rules[25][2] = "\1oes">
	<cfset local.pluralization_rules[26][1] = "(bu)s$">
	<cfset local.pluralization_rules[26][2] = "\1ses">
	<cfset local.pluralization_rules[27][1] = "(alias|status)">
	<cfset local.pluralization_rules[27][2] = "\1es">
	<cfset local.pluralization_rules[28][1] = "(octop|vir)us$">
	<cfset local.pluralization_rules[28][2] = "\1i">
	<cfset local.pluralization_rules[29][1] = "(ax|test)is$">
	<cfset local.pluralization_rules[29][2] = "\1es">
	<cfset local.pluralization_rules[30][1] = "s$">
	<cfset local.pluralization_rules[30][2] = "s">
	<cfset local.pluralization_rules[31][1] = "$">
	<cfset local.pluralization_rules[31][2] = "s">

	<cfloop from="1" to="#arrayLen(local.pluralization_rules)#" index="local.i">
		<cfif REFindNoCase(local.pluralization_rules[local.i][1], arguments.text)>
			<cfset local.output = REReplaceNoCase(arguments.text, local.pluralization_rules[local.i][1], local.pluralization_rules[local.i][2])>
			<cfset local.output = local.first_letter & right(local.output, len(local.output)-1)>
			<cfbreak>
		</cfif>
	</cfloop>

	<cfreturn local.output>
</cffunction>