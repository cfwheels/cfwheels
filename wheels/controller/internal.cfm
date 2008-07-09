<cffunction name="$constructParams" returntype="string" access="private" output="false">
	<cfargument name="params" type="any" required="true">
	<cfset var local = structNew()>

	<cfset local.delim = "?">
	<cfif application.settings.obfuscateUrls>
		<cfset local.params = "">
		<cfloop list="#arguments.params#" delimiters="&" index="local.i">
			<cfset local.temp = listToArray(local.i, "=")>
			<cfset local.params = local.params & local.delim & local.temp[1] & "=">
			<cfif arrayLen(local.temp) IS 2>
				<cfset local.params = local.params & obfuscateParam(local.temp[2])>
			</cfif>
			<cfset local.delim = "&">
		</cfloop>
	<cfelse>
		<cfset local.params = local.delim & arguments.params>
	</cfif>

	<cfreturn local.params>
</cffunction>

<cffunction name="$trimHTML" returntype="string" access="private" output="false">
	<cfargument name="str" type="string" required="true">
	<cfreturn replaceList(trim(arguments.str), "#chr(9)#,#chr(10)#,#chr(13)#", ",,")>
</cffunction>

<cffunction name="$getAttributes" returntype="string" access="private" output="false">
	<cfset var local = structNew()>

	<cfset local.attributes = "">
	<cfloop collection="#arguments#" item="local.i">
		<cfif local.i Does Not Contain "_" AND listFindNoCase(arguments._named_arguments, local.i) IS 0>
			<cfset local.attributes = "#local.attributes# #lCase(local.i)#=""#arguments[local.i]#""">
		</cfif>
	</cfloop>

	<cfreturn local.attributes>
</cffunction>
