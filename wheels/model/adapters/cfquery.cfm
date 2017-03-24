<cffunction name="$executeQuery" returntype="struct" access="public" output="false">
	<cfargument name="queryAttributes" type="struct" required="true">
	<cfargument name="sql" type="array" required="true">
	<cfargument name="parameterize" type="boolean" required="true">
	<cfargument name="limit" type="numeric" required="true">
	<cfargument name="offset" type="numeric" required="true">
	<cfargument name="comment" type="string" required="true">
	<cfargument name="debugName" type="string" required="true">
	<cfargument name="primaryKey" type="string" required="true">
	<cfscript>

		// Since we allow the developer to pass in the name to use for the query variable we need to avoid name clashing.
		// We do this by putting all our own variables inside a $wheels struct.
		local.$wheels = {};
		local.$wheels.rv = {};

	</cfscript>
	<cfquery attributeCollection="#arguments.queryAttributes#"><cfset local.$wheels.pos = 0><cfloop array="#arguments.sql#" index="local.$wheels.i"><cfset local.$wheels.pos = local.$wheels.pos + 1><cfif IsStruct(local.$wheels.i)><cfset local.$wheels.queryParamAttributes = $queryParams(local.$wheels.i)><cfif NOT IsBinary(local.$wheels.i.value) AND local.$wheels.i.value IS "null" AND local.$wheels.pos GT 1 AND (Right(arguments.sql[local.$wheels.pos-1], 2) IS "IS" OR Right(arguments.sql[local.$wheels.pos-1], 6) IS "IS NOT")>NULL<cfelseif StructKeyExists(local.$wheels.queryParamAttributes, "list")><cfif arguments.parameterize>(<cfqueryparam attributeCollection="#local.$wheels.queryParamAttributes#">)<cfelse>(#PreserveSingleQuotes(local.$wheels.i.value)#)</cfif><cfelse><cfif arguments.parameterize><cfqueryparam attributeCollection="#local.$wheels.queryParamAttributes#"><cfelse>#$quoteValue(str=local.$wheels.i.value, sqlType=local.$wheels.i.type)#</cfif></cfif><cfelse><cfset local.$wheels.i = Replace(PreserveSingleQuotes(local.$wheels.i), "[[comma]]", ",", "all")>#PreserveSingleQuotes(local.$wheels.i)#</cfif>#chr(13)##chr(10)#</cfloop><cfif arguments.limit>LIMIT #arguments.limit#<cfif arguments.offset>#chr(13)##chr(10)#OFFSET #arguments.offset#</cfif></cfif><cfif Len(arguments.comment)>#arguments.comment#</cfif></cfquery>
	<cfif StructKeyExists(local, arguments.debugName)>
		<cfset local.$wheels.rv.query = local[arguments.debugName]>
	</cfif>
	<cfscript>

		// Get / set the primary key name / value when Lucee / ACF cannot retrieve it for us.
		local.$wheels.id = $identitySelect(
			primaryKey=arguments.primaryKey,
			queryAttributes=arguments.queryAttributes,
			result=local.$wheels.result
		);
		if (StructKeyExists(local.$wheels, "id")) {
			StructAppend(local.$wheels.result, local.$wheels.id);
		}

		local.$wheels.rv.result = local.$wheels.result;
		return local.$wheels.rv;
	</cfscript>
</cffunction>
