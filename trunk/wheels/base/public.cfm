<cffunction name="obfuscateParam" returntype="any" access="public" output="false">
	<cfargument name="param" type="any" required="true">
	<cfset var locals = structNew()>

	<cfset locals.result = arguments.param>

	<cfif isNumeric(locals.result)>
		<cfset locals.length = len(locals.result)>
		<cfset locals.a = (10^locals.length) + reverse(locals.result)>
		<cfset locals.b = "0">
		<cfloop from="1" to="#locals.length#" index="locals.i">
			<cfset locals.b = (locals.b + left(right(locals.result, locals.i), 1))>
		</cfloop>
		<cfset locals.result = formatbaseN((locals.b+154),16) & formatbasen(bitxor(locals.a,461),16)>
	</cfif>

	<cfreturn locals.result>
</cffunction>

<cffunction name="deobfuscateParam" returntype="any" access="public" output="false">
	<cfargument name="param" type="any" required="true">
	<cfset var locals = structNew()>

	<cftry>
		<cfset locals.checksum = left(arguments.param, 2)>
		<cfset locals.result = right(arguments.param, (len(arguments.param)-2))>
		<cfset locals.z = bitxor(inputbasen(locals.result,16),461)>
		<cfset locals.result = "">
		<cfloop from="1" to="#(len(locals.z)-1)#" index="locals.i">
				<cfset locals.result = locals.result & left(right(locals.z, locals.i),1)>
		</cfloop>
		<cfset locals.checksumtest = "0">
		<cfloop from="1" to="#len(locals.result)#" index="locals.i">
				<cfset locals.checksumtest = (locals.checksumtest + left(right(locals.result, locals.i),1))>
		</cfloop>
		<cfif left(tostring(formatbaseN((locals.checksumtest+154),10)),2) IS NOT left(inputbaseN(locals.checksum, 16),2)>
			<cfset locals.result = arguments.param>
		</cfif>
		<cfcatch>
			<cfset locals.result = arguments.param>
		</cfcatch>
	</cftry>

	<cfreturn locals.result>
</cffunction>

<cffunction name="addRoute" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfargument name="pattern" type="any" required="true">
	<cfargument name="controller" type="any" required="true">
	<cfargument name="action" type="any" required="true">
	<cfset var locals = structNew()>

	<cfset locals.thisRoute = structCopy(arguments)>

	<cfset locals.thisRoute.variables = "">
	<cfloop list="#arguments.pattern#" index="locals.i" delimiters="/">
		<cfif locals.i Contains "[">
			<cfset locals.thisRoute.variables = listAppend(locals.thisRoute.variables, replaceList(locals.i, "[,]", ","))>
		</cfif>
	</cfloop>

	<cfset arrayAppend(application.wheels.routes, locals.thisRoute)>

</cffunction>

<cffunction name="model" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfif application.settings.environment IS NOT "production">
		<cfinclude template="../errors/model.cfm">
	</cfif>
	<cfset $doubleCheckedLock(name="modelLock", path=application.wheels.models, key=arguments.name, method="$createClass", args=arguments)>
	<cfreturn application.wheels.models[arguments.name]>
</cffunction>

<cffunction name="$createClass" returntype="any" access="private" output="false">
	<cfargument name="name" type="string" required="true">
	<cfreturn CreateObject("component", "modelRoot.#arguments.name#").$initClass(arguments.name)>
</cffunction>
