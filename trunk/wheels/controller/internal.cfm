<cffunction name="$constructParams" returntype="string" access="private" output="false">
	<cfargument name="params" type="any" required="true">
	<cfset var loc = structNew()>

	<cfset loc.delim = "?">
	<cfif application.settings.obfuscateUrls>
		<cfset loc.params = "">
		<cfloop list="#arguments.params#" delimiters="&" index="loc.i">
			<cfset loc.temp = listToArray(loc.i, "=")>
			<cfset loc.params = loc.params & loc.delim & loc.temp[1] & "=">
			<cfif arrayLen(loc.temp) IS 2>
				<cfset loc.params = loc.params & obfuscateParam(loc.temp[2])>
			</cfif>
			<cfset loc.delim = "&">
		</cfloop>
	<cfelse>
		<cfset loc.params = loc.delim & arguments.params>
	</cfif>

	<cfreturn loc.params>
</cffunction>