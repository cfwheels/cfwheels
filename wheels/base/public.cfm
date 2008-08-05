<cffunction name="obfuscateParam" returntype="string" access="public" output="false">
	<cfargument name="param" type="numeric" required="true">
	<cfset var loc = {}>

	<cfset loc.result = arguments.param>

	<cfif IsNumeric(loc.result)>
		<cfset loc.length = Len(loc.result)>
		<cfset loc.a = (10^loc.length) + Reverse(loc.result)>
		<cfset loc.b = "0">
		<cfloop from="1" to="#loc.length#" index="loc.i">
			<cfset loc.b = (loc.b + Left(Right(loc.result, loc.i), 1))>
		</cfloop>
		<cfset loc.result = FormatBaseN((loc.b+154),16) & FormatBaseN(BitXor(loc.a,461),16)>
	</cfif>

	<cfreturn loc.result>
</cffunction>

<cffunction name="deobfuscateParam" returntype="string" access="public" output="false">
	<cfargument name="param" type="string" required="true">
	<cfset var loc = {}>

	<cftry>
		<cfset loc.checksum = Left(arguments.param, 2)>
		<cfset loc.result = Right(arguments.param, (Len(arguments.param)-2))>
		<cfset loc.z = BitXor(InputBasen(loc.result,16),461)>
		<cfset loc.result = "">
		<cfloop from="1" to="#(Len(loc.z)-1)#" index="loc.i">
				<cfset loc.result = loc.result & Left(Right(loc.z, loc.i),1)>
		</cfloop>
		<cfset loc.checksumtest = "0">
		<cfloop from="1" to="#Len(loc.result)#" index="loc.i">
				<cfset loc.checksumtest = (loc.checksumtest + Left(Right(loc.result, loc.i),1))>
		</cfloop>
		<cfif Left(ToString(FormatBaseN((loc.checksumtest+154),10)),2) IS NOT Left(InputBasen(loc.checksum, 16),2)>
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
	<cfset var loc = {}>

	<cfset loc.thisRoute = StructCopy(arguments)>

	<cfset loc.thisRoute.variables = "">
	<cfloop list="#arguments.pattern#" index="loc.i" delimiters="/">
		<cfif loc.i Contains "[">
			<cfset loc.thisRoute.variables = ListAppend(loc.thisRoute.variables, ReplaceList(loc.i, "[,]", ","))>
		</cfif>
	</cfloop>

	<cfset ArrayAppend(application.wheels.routes, loc.thisRoute)>

</cffunction>

<cffunction name="model" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		if (application.settings.environment IS NOT "production")
		{
			if (!Len(application.settings.database.datasource))
				$throw(type="Wheels.MissingDataSource", message="No data source has been added.", extendedInfo="Tell Wheels what data source you want to use by specifying it in 'config/database.cfm'. Don't forget to also add the data source in the ColdFusion Administrator. When you have made your changes you need to issue a '?reload=true' request or restart the ColdFusion service for the changes to be picked up by Wheels.");
		}
		$doubleCheckedLock(name="modelLock", path=application.wheels.models, key=arguments.name, method="$createClass", args=arguments);
	</cfscript>
	<cfreturn application.wheels.models[arguments.name]>
</cffunction>