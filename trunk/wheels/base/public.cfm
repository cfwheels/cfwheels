<cffunction name="obfuscateParam" returntype="string" access="public" output="false">
	<cfargument name="param" type="numeric" required="true">
	<cfset var loc = structNew()>

	<cfset loc.result = arguments.param>

	<cfif isNumeric(loc.result)>
		<cfset loc.length = len(loc.result)>
		<cfset loc.a = (10^loc.length) + reverse(loc.result)>
		<cfset loc.b = "0">
		<cfloop from="1" to="#loc.length#" index="loc.i">
			<cfset loc.b = (loc.b + left(right(loc.result, loc.i), 1))>
		</cfloop>
		<cfset loc.result = formatbaseN((loc.b+154),16) & formatbasen(bitxor(loc.a,461),16)>
	</cfif>

	<cfreturn loc.result>
</cffunction>

<cffunction name="deobfuscateParam" returntype="string" access="public" output="false">
	<cfargument name="param" type="string" required="true">
	<cfset var loc = structNew()>

	<cftry>
		<cfset loc.checksum = left(arguments.param, 2)>
		<cfset loc.result = right(arguments.param, (len(arguments.param)-2))>
		<cfset loc.z = bitxor(inputbasen(loc.result,16),461)>
		<cfset loc.result = "">
		<cfloop from="1" to="#(len(loc.z)-1)#" index="loc.i">
				<cfset loc.result = loc.result & left(right(loc.z, loc.i),1)>
		</cfloop>
		<cfset loc.checksumtest = "0">
		<cfloop from="1" to="#len(loc.result)#" index="loc.i">
				<cfset loc.checksumtest = (loc.checksumtest + left(right(loc.result, loc.i),1))>
		</cfloop>
		<cfif left(tostring(formatbaseN((loc.checksumtest+154),10)),2) IS NOT left(inputbaseN(loc.checksum, 16),2)>
			<cfset loc.result = arguments.param>
		</cfif>
		<cfcatch>
			<cfset loc.result = arguments.param>
		</cfcatch>
	</cftry>

	<cfreturn loc.result>
</cffunction>

<cffunction name="addRoute" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="pattern" type="string" required="true">
	<cfargument name="controller" type="string" required="true">
	<cfargument name="action" type="string" required="true">
	<cfset var loc = structNew()>

	<cfset loc.thisRoute = structCopy(arguments)>

	<cfset loc.thisRoute.variables = "">
	<cfloop list="#arguments.pattern#" index="loc.i" delimiters="/">
		<cfif loc.i Contains "[">
			<cfset loc.thisRoute.variables = listAppend(loc.thisRoute.variables, replaceList(loc.i, "[,]", ","))>
		</cfif>
	</cfloop>

	<cfset arrayAppend(application.wheels.routes, loc.thisRoute)>

</cffunction>

<cffunction name="model" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfif application.settings.environment IS NOT "production">
		<cfinclude template="../errors/model.cfm">
	</cfif>
	<cfset $doubleCheckedLock(name="modelLock", path=application.wheels.models, key=arguments.name, method="$createClass", args=arguments)>
	<cfreturn application.wheels.models[arguments.name]>
</cffunction>