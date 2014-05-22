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
	returntype = return type of function (String)
	
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
	<cfset variables.marker = "@">

	<!--- 
	Used to collect any error for unreferenced methods
	 --->
	<cfset variables.errors = []>
	
	<!--- 
	overloads collection 
	--->
	<cfset variables.overloads = {}>
	
	<cffunction name="init" output="false">
		<cfargument name="wheelsDirectory" type="string" required="true" hint="the full path to the wheels directory to process the classes and generate documentation for">
		<cfargument name="wheelsAPIChapterDirectory" type="string" required="true" hint="the full path to the wheels api directory in the documentation root. Is used to generate chapters and function references.">
		<cfargument name="wheelsComponentPath" type="string" required="true" hint="the component path to the wheels directory">
		<cfargument name="outputPath" type="string" required="true" hint="the path to the output directory">
		<cfset variables.wheelsDirectory = ListChangeDelims(arguments.wheelsDirectory, "/", "\")>
		<cfset variables.wheelsAPIChapterDirectory = ListChangeDelims(arguments.wheelsAPIChapterDirectory, "/", "\")>
		<cfset variables.wheelsComponentPath = arguments.wheelsComponentPath>
		<cfset variables.outputPath = ListChangeDelims(arguments.outputPath, "/", "\")>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="overload" access="public" returntype="void" output="false"
		hint="overloads to the documentation. sometimes we have parameters or other aspects of the documentation that we can't put in the code, but need to document. overloads allow us to do this.">
		<cfargument name="method" type="string" required="true" hint="the method name the overload is targeting">
		<cfargument name="part" type="string" required="true" hint="which part of the method the overload should target. valid parts are: categories, chapters, examples, functions, hint, parameters">
		<cfargument name="value" type="any" required="true" hint="the value to overload with. all parts take a value of type sting EXCEPT parameters with take a struct which can contain the keys: default, hint, name, required, type">
		<cfargument name="position" type="string" required="false" default="" hint="can either be a numeric for a position in an array or if targeting a parameter you may pass the name of the parameter. you can leave blank for an additions. ignored for hint and examples parts since they are strings.">
		<cfset var loc = {}>
		<cfset loc.value = "">
		
		<cfif !ListFindNoCase("categories,chapters,examples,functions,hint,parameters", arguments.part)>
			<cfthrow type="WheelsApiGenerator" message="part is not valid. valid parts are: categories, chapters, example, functions, hint, name, parameters, returntype">
		</cfif>
		
		<cfif arguments.part eq "parameters">
			<cfif !IsStruct(arguments.value)>
				<cfthrow type="WheelsApiGenerator" message="parameters take a struct as a value which can contain the keys: default, hint, name, required, type">
			</cfif>
			<cfset loc.value = {}>
			<cfloop collection="#arguments.value#" item="loc.v">
				<cfif ListFindNoCase("default,hint,name,required,type", loc.v)>
					<cfset loc.value[loc.v] = arguments.value[loc.v]>
				</cfif>
			</cfloop>
		<cfelseif ListFindNoCase("examples,hint", arguments.part)>
			<cfset arguments.position = "">
		<cfelseif ListFindNoCase("categories,chapters,functions", arguments.part) && Len(arguments.position) && !IsNumeric(arguments.position)>
			<cfthrow type="WheelsApiGenerator" message="the position for categories, chapters or functions must be either a numeric or blank value">
		</cfif>
		
		<!--- see if the method name exists in the overload structure --->
		<cfif !StructKeyExists(variables.overloads, arguments.method)>
			<cfset variables.overloads[arguments.method] = {}>
		</cfif>
		
		<!--- see if the part is defined in the method overload structure --->
		<cfif !StructKeyExists(variables.overloads[arguments.method], arguments.part)>
			<cfset variables.overloads[arguments.method][arguments.part] = []>
		</cfif>
		
		<cfset loc.temp = {}>
		<cfset loc.temp.position = arguments.position>
		<cfset loc.temp.value = loc.value>
		
		<cfif !ListFindNoCase("examples,hint", arguments.part)>
			<cfset variables.overloads[arguments.method][arguments.part][1] = loc.temp>
		<cfelse>
			<cfset ArrayAppend(variables.overloads[arguments.method][arguments.part], loc.temp)>
		</cfif>
	</cffunction>

	<cffunction name="build" access="public" returntype="struct" output="false">
		<cfset var loc = {}>
		<cfset loc.ret = {errors = "", data = ""}>
		<cfset $cleanup()>
		<cfset $processClasses()>
		<cfset loc.ret.errors = $expandMarkers()>
		<cfif ArrayIsEmpty(loc.ret.errors)>
			<cfset $compactData()>
			<cfset $overloadData()>
			<cfset loc.pageGenerator = createObject("component", "PageGenerator").init(
				wheelsAPIChapterDirectory = variables.wheelsAPIChapterDirectory
				,data = variables.data
			)>
			<cfset loc.pageGenerator.build()>
			<cfset loc.ret.data = variables.data>
		</cfif>
		<cfset $createOutputPath()>
		<cfset $generateXML()>
		<cfreturn loc.ret>
	</cffunction>
	
	
	<cffunction name="$generateXML">
		<cffile action="write" file="#variables.outputPath#/cfwheels-api.xml" output="#toXML()#">
	</cffunction>
	
	
	<cffunction name="toXML" access="public" returntype="string" output="false">
		<cfset var loc = {}>
		<cfset loc.functionNames = ListSort(StructKeyList(variables.data), "textNoCase")>
		<cfoutput>
		<cfxml variable="loc.xmldoc" casesensitive="yes">
		<functions wheelsversion="#application.wheels.version#">
			<cfloop list="#loc.functionNames#" index="loc.functionName">
			<cfset loc._function = variables.data[loc.functionName]>
			<function name="#loc.functionName#" categories="#ArrayToList(loc._function['categories'])#" chapters="#ArrayToList(loc._function['chapters'])#" related="#ArrayToList(loc._function['functions'])#">
				<returntype>#loc._function["returntype"]#</returntype>
				<description><![CDATA[#loc._function["hint"]#]]></description>
				<examples><![CDATA[#loc._function["examples"]#]]></examples>
		 		<arguments>
					<cfloop array="#loc._function['parameters']#" index="loc.parameter">
					<argument name="#loc.parameter.name#">
						<type>#loc.parameter.type#</type>
						<required>#loc.parameter.required#</required>
						<defaultValue>#loc.parameter.default#</defaultValue>
						<description><![CDATA[#loc.parameter.hint#]]></description>
					</argument>
					</cfloop>
				</arguments>
			</function>
			</cfloop>
		</functions>
		</cfxml>
		</cfoutput>
		<cfreturn ToString(loc.xmldoc)>
	</cffunction>

	<cffunction name="$processClasses" access="private" returntype="void" output="false">
		<!--- loop through the main wheels directory and get a list of all the cfcs in it --->
		<cfdirectory action="list" filter="*.cfc" directory="#variables.wheelsDirectory#" name="loc.classes">
		<cfloop query="loc.classes">
			<cfset loc.class = ListFirst(name, '.')>
			<cfset loc.component = CreateObject("component", "#variables.wheelsComponentPath#.#loc.class#")>
			<cfset loc.functions = []>
			<cfloop collection="#loc.component#" item="loc.i">
				<cfif IsCustomFunction(loc.component[loc.i])>
					<cfset ArrayAppend(loc.functions, getMetaData(loc.component[loc.i]))>
				</cfif>
			</cfloop>
			<cfloop array="#loc.functions#" index="loc.function">
				<!--- only process public API functions --->
				<cfif
					left(loc.function.name, 1) neq "$"
					and loc.function.access eq "public"
					and StructKeyExists(loc.function, "examples")
				>
					<cfloop list="categories,functions,chapters,returntype" index="loc.i">
						<cfif !StructKeyExists(loc.function, loc.i)>
							<cfset loc.function[loc.i] = "">
						</cfif>
					</cfloop>
					
					<cfif !len(loc.function.returntype)>
						<cfset loc.function.returntype = "any">
					</cfif>
					
					<cfset loc.temp = {}>
					<cfset loc.temp.class = loc.class>
					<cfset loc.temp.name = loc.function.name>
					<cfset loc.temp.chapters = ListToArray(loc.function.chapters)>
					<cfset loc.temp.functions = ListToArray(loc.function.functions)>
					<cfset loc.temp.categories = ListToArray(loc.function.categories)>
					<cfset loc.temp.hint = loc.function.hint>
					<cfset loc.temp.examples = loc.function.examples>
					<cfset loc.temp.returntype = loc.function.returntype>
					<cfset loc.temp.parameters = []>
					<cfif StructKeyExists(loc.function, "parameters")>
						<cfloop array="#loc.function.parameters#" index="loc.parameter">
							<cfif Left(loc.parameter.name, 1) neq "$">
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
							</cfif>
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
		
		<!--- loop through all the overloads --->
		<cfloop collection="#variables.overloads#" item="loc.i">
		
			<!--- see if overload key exists in the data struct --->
			<cfif StructKeyExists(variables.data, loc.i)>
			
				<!--- reference the current overload --->
				<cfset loc.overload = variables.overloads[loc.i]>
				
				<!--- loop through the parts of the overload --->
				<cfloop collection="#loc.overload#" item="loc.part">
				
					<!--- see if this part exists in the data struct --->
					<cfif StructKeyExists(variables.data[loc.i], loc.part)>
					
						<cfloop array="#loc.overload[loc.part]#" index="loc.arr">

	 						<cfif ListFindNoCase("examples,hint", loc.part)>
							
								<cfset variables.data[loc.i][loc.part] = loc.arr.value>
	
							<cfelseif loc.part eq "parameters" and len(loc.arr.position) and !IsNumeric(loc.arr.position)>
								
								<cfset loc.l = ArrayLen(variables.data[loc.i][loc.part])>
								<cfloop from="1" to="#loc.l#" index="loc.parameter">
									<cfif variables.data[loc.i][loc.part][loc.parameter].name eq loc.arr.position>
										<cfset StructAppend(variables.data[loc.i][loc.part][loc.parameter], loc.arr.value, true)>
									</cfif>
								</cfloop>
							
							<cfelseif IsNumeric(loc.arr.position)>

								<cfif ArrayIsDefined(variables.data[loc.i][loc.part], loc.arr.position)>
									<cfif IsStruct(loc.arr.value)>
										<cfset StructAppend(variables.data[loc.i][loc.part][loc.arr.position], loc.arr.value, true)>
									<cfelse>
										<cfset variables.data[loc.i][loc.part][loc.arr.position] = loc.arr.value>
									</cfif>
								</cfif>

							<cfelse>
							
								<cfset ArrayAppend(variables.data[loc.i][loc.part], loc.arr.value)>
							
							</cfif>
					
						</cfloop>
					
					</cfif>

				</cfloop>
				
			</cfif>
			
		</cfloop>

	</cffunction>
	
	<cffunction name="$cleanup">
		<cfif DirectoryExists(variables.outputPath)>
			<cfdirectory action="delete" directory="#variables.outputPath#" recurse="true">
		</cfif>
	</cffunction>
	
	<cffunction name="$createOutputPath">
		<cfif !DirectoryExists(variables.outputPath)>
			<cfdirectory action="create" directory="#variables.outputPath#">
		</cfif>	
	</cffunction>
	
</cfcomponent>