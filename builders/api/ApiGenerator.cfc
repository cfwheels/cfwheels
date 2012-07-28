<cfcomponent output="false" hint="compile the api documentation for the current release">

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
		<cfargument name="wheelsDirectory" type="string" required="true" hint="the full path to the wheels directory to process the classes and generate documentation for">
		<cfargument name="overloads" type="struct" required="false" default="#StructNew()#" hint="overload to the documentation. sometimes we have parameters or other aspects of the documentation that we can't put in the code, but need to document. overloads allow us to do this.">
		<cfset variables.wheelsDirectory = arguments.wheelsDirectory>
		<cfset variables.overloads = arguments.overloads>
		<cfreturn this>
	</cffunction>

	<cffunction name="build" access="public" returntype="struct" output="false">
		<cfset var loc = {}>
		<cfset loc.ret = {errors = "", data = ""}>
		<cfset $processClasses()>
		<cfset loc.ret.errors = $expandMarkers()>
		<cfif ArrayIsEmpty(loc.ret.errors)>
			<cfset $compactData()>
			<cfset $overloadData()>
			<cfset loc.ret.data = variables.data>
		</cfif>
		<cfreturn loc.ret>
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
					and StructKeyExists(loc.function, "examples")
				>
					<cfloop list="categories,functions,chapters" index="loc.i">
						<cfif !StructKeyExists(loc.function, loc.i)>
							<cfset loc.function[loc.i] = "">
						</cfif>
					</cfloop>
				
					<cfset loc.temp = {}>
					<cfset loc.temp.class = loc.class>
					<cfset loc.temp.name = loc.function.name>
					<cfset loc.temp.chapters = ListToArray(loc.function.chapters)>
					<cfset loc.temp.functions = ListToArray(loc.function.functions)>>
					<cfset loc.temp.categories = ListToArray(loc.function.categories)>
					<cfset loc.temp.hint = loc.function.hint>
					<cfset loc.temp.examples = loc.function.examples>
					<cfset loc.temp.parameters = []>
					<cfif StructKeyExists(loc.function, "parameters")>
						<cfloop array="#loc.function.parameters#" index="loc.parameter">
							<cfset loc.temp1 = {}>
							<cfset loc.temp1.name = loc.parameter.name>
							<cfset loc.temp1.type = loc.parameter.type>
							<cfset loc.temp1.required = loc.parameter.required>
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
	
	<cffunction name="$compactData" access="private" output="false" hint="compacts the data by removing duplicate function entries across the classes">
		<cfset var loc = {}>
		<cfset loc._data = {}>
		<cfloop collection="#variables.data#" item="loc.f">
			<cfset loc.function = duplicate(variables.data[loc.f])>
			<cfif !StructKeyExists(loc._data, loc.function.name)>
				<!--- remove the class key since we don't need it --->
				<cfset StructDelete(loc.function, "class", false)>
				<cfset loc._data[loc.function.name] = loc.function>
			</cfif>
		</cfloop>
		<cfreturn variables.data = loc._data>
	</cffunction>
	
	<cffunction name="$overloadData" access="private">
		<cfset var loc = {}>
		<cfloop collection="#variables.overloads#" item="loc.i">
			<cfset loc.overload = variables.overloads[loc.i]>
			<cfif StructKeyExists(variables.data, loc.i)>
				<cfloop collection="#loc.overload#" item="loc.j">
				<!--- 
				see if this element of the overload is a string or array
				for string we copy them over.
				
				for array we loop through them and see if they are a string, struct or empty
				string we copy
				struct we merge
				empty we do nothing
				 --->
					<cfset loc.value = loc.overload[loc.j]>
					<cfif IsSimpleValue(loc.value)>
						<cfset variables.data[loc.i][loc.j] = loc.value>
					<cfelseif IsArray(loc.value)>
						<cfloop from="1" to="#ArrayLen(loc.value)#" index="loc.v">
							<cfif IsSimpleValue(loc.value[loc.v]) AND len(loc.value[loc.v])>
								<cfset variables.data[loc.i][loc.j][loc.v] = loc.value[loc.v]>
							<cfelseif IsStruct(loc.value[loc.v])>
								<cfset StructAppend(variables.data[loc.i][loc.j][loc.v], loc.value[loc.v], true)>
							</cfif>
						</cfloop>
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
	</cffunction>

</cfcomponent>