<cffunction name="FL_flatten" returntype="any" access="public" output="false">
	<cfargument name="values" type="any" required="false" default="">
	<cfset var local = structNew()>

	<cfset local.output = "">
	<cfif isStruct(arguments.values)>
		<cfloop collection="#arguments.values#" item="local.i">
			<cfif isSimpleValue(arguments.values[local.i])>
				<cfset local.output = local.output & "&" & local.i & "=""" & arguments.values[local.i] & """">
			<cfelse>
				<cfset local.output = local.output & "&" & FL_flatten(arguments.values[local.i])>
			</cfif>
		</cfloop>
	<cfelseif isArray(arguments.values)>
		<cfloop from="1" to="#arrayLen(arguments.values)#" index="local.i">
			<cfif isSimpleValue(arguments.values[local.i])>
				<cfset local.output = local.output & "&" & local.i & "=""" & arguments.values[local.i] & """">
			<cfelse>
				<cfset local.output = local.output & "&" & FL_flatten(arguments.values[local.i])>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn right(local.output, len(local.output)-1)>
</cffunction>


<cffunction name="FL_hashArguments" returntype="any" access="public" output="false">
	<cfargument name="args" type="any" required="false" default="">
	<cfreturn hash(listSort(FL_flatten(arguments.args), "text", "asc", "&"))>
</cffunction>
