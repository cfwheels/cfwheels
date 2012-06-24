<cfcomponent output="false" hint="compile the api documentation for the current release">

	<!--- wheels directory --->
	<cfset variables.wheelsDirectory = ExpandPath('../wheels')>

	<!--- 
	store the location of a function in a struct
	used to translate '@' references in hints
	
	key = <function name>|<parameter name>
	value = hint
	
	 --->
	<cfset variables.parameterHints = {}>

	<!--- 
	holds all the data about functions from the processed
	functions
	
	key = <class-name>|<function-name>
	value = details from metadata (Struct)
	
	value struct
	------------
	class = class name (String)
	name = function name (String)
	chapters = chapter names (Array)
	categories = category names (Array)
	related = related function (Array)
	hint = the function hint (String)
	examples = function example (String)
	parameters = function arguments (Array of Structs)
	
	parameters array
	----------------
	name = argument name (String)
	type = arguments (String)
	required = is argument required (Boolean)
	default = default for arguments (String)
	hint = argument hint (String)
	 --->
	<cfset variables.data = {}>

	<!--- 
	look to see if a hint begind with the following text. if
	so then we need to replace it with text from the references
	method
	 --->
	<cfset variables.marker = "See documentation for @">

	<!--- 
	Used to collect any error for unreferenced methods
	 --->
	<cfset variables.errors = []>
	
	<cffunction name="init">
		<cfreturn this>
	</cffunction>

	<cffunction name="build" access="public" returntype="array" output="false">
		<cfset var loc = {}>
		<cfset $processClasses()>
		<cfreturn $expandMarkers()>
	</cffunction>


	<cffunction name="$processClasses" access="private" returntype="void" output="false">
		<!--- loop through the main wheels directory and get a list of all the cfcs in it --->
		<cfdirectory action="list" filter="*.cfc" directory="#variables.wheelsDirectory#" name="loc.classes">
		<!--- <cfdump var="#classes#"><cfabort> --->
		<cfloop query="loc.classes">
			<cfset loc.class = ListFirst(name, '.')>
			<cfset loc.meta = GetComponentMetaData("wheels.#loc.class#")>
			<cfloop array="#loc.meta.functions#" index="loc.function">
				<!--- only process public API functions --->
				<cfif
					left(loc.function.name, 1) neq "$"
					and loc.function.access eq "public"
					and StructKeyExists(loc.function, "chapters")
					and StructKeyExists(loc.function, "categories")
					and StructKeyExists(loc.function, "examples")
				>
					<cfset loc.temp = {}>
					<cfset loc.temp.class = loc.class>
					<cfset loc.temp.name = loc.function.name>
					<cfset loc.temp.chapters = ListToArray(loc.function.chapters)>
					<cfset loc.temp.categories = ListToArray(loc.function.categories)>
					<cfset loc.temp.hint = loc.function.hint>
					<cfset loc.temp.examples = loc.function.examples>
					<cfset loc.temp.parameters = []>
					<cfif StructKeyExists(loc.function, "parameters")>
						<cfloop array="#loc.function.parameters#" index="loc.parameter">
							<cfset loc.temp1 = {}>
							<cfset loc.temp1.name = loc.parameter.name>
							<cfset loc.temp1.type = loc.parameter.type>
							<cfset loc.temp1.required = loc.parameter.type>
							<cfset loc.temp1.default = "">
							<cfset loc.temp1.hint = "">
							<cfif StructKeyExists(loc.parameter, "default")>
								<cfset loc.temp1.default = loc.parameter.default>
							</cfif>
							<cfif StructKeyExists(loc.parameter, "hint")>
								<cfset loc.temp1.hint = loc.parameter.hint>
							</cfif>
							<cfset ArrayAppend(loc.temp.parameters, loc.temp1)>
							<cfset variables.parameterHints["#loc.function.name#|#loc.temp1.name#"] = loc.temp1.hint>
						</cfloop>
					</cfif>
					<cfset data["#loc.class#|#loc.function.name#"] = loc.temp>
				</cfif>
			</cfloop>
		</cfloop>
	
	</cffunction>
	
	
	<cffunction name="$expandMarkers" access="private" returntype="array" output="false">
		<cfset var loc = {}>
		<cfset loc.errors = []>
		<!--- replace marker --->
		<cfloop collection="#variables.data#" item="loc.dIndex">
			<cfset loc.current = variables.data[loc.dIndex]>
			<cfloop from="1" to="#ArrayLen(loc.current.parameters)#" index="loc.pIndex">
				<cfset loc.parameter = loc.current.parameters[loc.pIndex]>
				<cfif left(loc.parameter.hint, len(variables.marker)) eq variables.marker>
					<cfset loc.match = ReMatchNoCase("@[\w\d]+\b", loc.parameter.hint)>
					<cfset loc.match = Replace(loc.match[1], "@", "", "all")>
					<cfset loc.key = "#loc.match#|#loc.parameter.name#">
					<cfif StructKeyExists(variables.parameterHints, loc.key)>
						<cfset loc.referencedHint = variables.parameterHints[loc.key]>
						<cfset variables.data[loc.dIndex].parameters[loc.pIndex].hint = loc.referencedHint>
					<cfelse>
						<cfset loc.temp = {}>
						<cfset loc.temp.class = loc.current.class>
						<cfset loc.temp.method = loc.current.name>
						<cfset loc.temp.argument = loc.current.parameters[loc.pIndex]["name"]>
						<cfset ArrayAppend(loc.errors, loc.temp)>
					</cfif>
				</cfif>
			</cfloop>
		</cfloop>
		<cfreturn loc.errors>
	</cffunction>

</cfcomponent>