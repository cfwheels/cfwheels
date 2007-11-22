<cffunction name="CFW_flatten" returntype="any" access="public" output="false">
	<cfargument name="values" type="any" required="false" default="">
	<cfset var local = structNew()>

	<cfset local.output = "">
	<cfif isStruct(arguments.values)>
		<cfloop collection="#arguments.values#" item="local.i">
			<cfif isSimpleValue(arguments.values[local.i])>
				<cfset local.output = local.output & "&" & local.i & "=""" & arguments.values[local.i] & """">
			<cfelse>
				<cfset local.output = local.output & "&" & CFW_flatten(arguments.values[local.i])>
			</cfif>
		</cfloop>
	<cfelseif isArray(arguments.values)>
		<cfloop from="1" to="#arrayLen(arguments.values)#" index="local.i">
			<cfif isSimpleValue(arguments.values[local.i])>
				<cfset local.output = local.output & "&" & local.i & "=""" & arguments.values[local.i] & """">
			<cfelse>
				<cfset local.output = local.output & "&" & CFW_flatten(arguments.values[local.i])>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn right(local.output, len(local.output)-1)>
</cffunction>


<cffunction name="CFW_hashArguments" returntype="any" access="public" output="false">
	<cfargument name="args" type="any" required="false" default="">
	<cfreturn hash(listSort(CFW_flatten(arguments.args), "text", "asc", "&"))>
</cffunction>


<cffunction name="CFW_controller" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfset var local = structNew()>

	<cfif NOT structKeyExists(application.wheels.controllers, arguments.name)>
   	<cflock name="controller_lock" type="exclusive" timeout="30">
			<cfif NOT structKeyExists(application.wheels.controllers, arguments.name)>
				<cfset application.wheels.controllers[arguments.name] = createObject("component", "controllers.#lCase(arguments.name)#")._initControllerClass(arguments.name)>
			</cfif>
		</cflock>
	</cfif>

	<cfreturn application.wheels.controllers[arguments.name]>
</cffunction>


<cffunction name="CFW_hashStruct" returntype="any" access="public" output="false">
	<cfargument name="args" type="any" required="true">
	<cfset var local = structNew()>

	<cfset local.output = "">
	<cfloop collection="#arguments.args#" item="local.i">
		<cfif isSimpleValue(arguments.args[local.i])>
			<cfset local.element = lCase(local.i) & "=" & """" & lCase(arguments.args[local.i]) & """">
			<cfset local.output = listAppend(local.output, local.element, chr(7))>
		</cfif>
	</cfloop>
	<cfset local.output = hash(listSort(local.output, "text", "asc", chr(7)))>

	<cfreturn local.output>
</cffunction>
