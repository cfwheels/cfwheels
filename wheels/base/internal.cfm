<cffunction name="CFW_constructParams" returntype="any" access="private" output="false">
	<cfargument name="params" type="any" required="true">
	<cfset var local = structNew()>

	<cfset local.delim = "?">
	<cfif application.settings.obfuscate_urls>
		<cfset local.params = "">
		<cfloop list="#arguments.params#" delimiters="&" index="local.i">
			<cfset local.temp = listToArray(local.i, "=")>
			<cfset local.params = local.params & local.delim & local.temp[1] & "=">
			<cfif arrayLen(local.temp) IS 2>
				<cfset local.params = local.params & encryptParam(local.temp[2])>
			</cfif>
			<cfset local.delim = "&">
		</cfloop>
	<cfelse>
		<cfset local.params = local.delim & arguments.params>
	</cfif>

	<cfreturn local.params>
</cffunction>


<cffunction name="CFW_trimHTML" returntype="any" access="private" output="false">
	<cfargument name="str" type="any" required="true">
	<cfreturn replaceList(trim(arguments.str), "#chr(9)#,#chr(10)#,#chr(13)#", ",,")>
</cffunction>


<cffunction name="CFW_getAttributes" returntype="any" access="private" output="false">
	<cfset var local = structNew()>

	<cfset local.attributes = "">
	<cfloop collection="#arguments#" item="local.i">
		<cfif local.i Does Not Contain "_" AND listFindNoCase(arguments.CFW_named_arguments, local.i) IS 0>
			<cfset local.attributes = "#local.attributes# #lCase(local.i)#=""#arguments[local.i]#""">
		</cfif>
	</cfloop>

	<cfreturn local.attributes>
</cffunction>


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
