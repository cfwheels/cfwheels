<cffunction name="$performQuery" returntype="struct" access="public" output="false">
	<cfargument name="sql" type="array" required="true">
	<cfargument name="parameterize" type="boolean" required="true">
	<cfargument name="limit" type="numeric" required="false" default="0">
	<cfargument name="offset" type="numeric" required="false" default="0">
	<cfargument name="$primaryKey" type="string" required="false" default="">
	<cfargument name="$debugName" type="string" required="false" default="query">
	<cfscript>
		local.rv = {};
		local.args = {};
		local.args.dataSource = variables.dataSource;
		local.args.username = variables.username;
		local.args.password = variables.password;
		local.args.result = "local.result";
		local.args.name = "local." & arguments.$debugName;
		if (StructKeyExists(local.args, "username") && !Len(local.args.username)) {
			StructDelete(local.args, "username");
		}
		if (StructKeyExists(local.args, "password") && !Len(local.args.password)) {
			StructDelete(local.args, "password");
		}

		// Set queries in Lucee to not preserve single quotes on the entire cfquery block (we'll handle this individually in the SQL statement instead).
		if ($get("serverName") == "Lucee") {
			local.args.psq = false;
		}

		// Add a key as a comment for cached queries to ensure query is unique for the life of this application.
		if (StructKeyExists(arguments, "cachedwithin")) {
			local.comment = $comment("cachekey:#$get("cacheKey")#");
		}

		// Overloaded arguments are settings for the query.
		local.orgArgs = Duplicate(arguments);
		StructDelete(local.orgArgs, "sql");
		StructDelete(local.orgArgs, "parameterize");
		StructDelete(local.orgArgs, "$debugName");
		StructDelete(local.orgArgs, "limit");
		StructDelete(local.orgArgs, "offset");
		StructDelete(local.orgArgs, "$primaryKey");
		StructAppend(local.args, local.orgArgs);
	</cfscript>
	<cfquery attributeCollection="#local.args#"><cfset local.pos = 0><cfloop array="#arguments.sql#" index="local.i"><cfset local.pos = local.pos + 1><cfif IsStruct(local.i)><cfset local.queryParamAttributes = $queryParams(local.i)><cfif NOT IsBinary(local.i.value) AND local.i.value IS "null" AND local.pos GT 1 AND (Right(arguments.sql[local.pos-1], 2) IS "IS" OR Right(arguments.sql[local.pos-1], 6) IS "IS NOT")>NULL<cfelseif StructKeyExists(local.queryParamAttributes, "list")><cfif arguments.parameterize>(<cfqueryparam attributeCollection="#local.queryParamAttributes#">)<cfelse>(#PreserveSingleQuotes(local.i.value)#)</cfif><cfelse><cfif arguments.parameterize><cfqueryparam attributeCollection="#local.queryParamAttributes#"><cfelse>#$quoteValue(str=local.i.value, sqlType=local.i.type)#</cfif></cfif><cfelse><cfset local.i = Replace(PreserveSingleQuotes(local.i), "[[comma]]", ",", "all")>#PreserveSingleQuotes(local.i)#</cfif>#chr(13)##chr(10)#</cfloop><cfif arguments.limit>LIMIT #arguments.limit#<cfif arguments.offset>#chr(13)##chr(10)#OFFSET #arguments.offset#</cfif></cfif><cfif StructKeyExists(local, "comment")>#local.comment#</cfif></cfquery>
	<cfscript>
		if (StructKeyExists(local, arguments.$debugName)) {
			local.rv.query = local[arguments.$debugName];
		}

		// Get / set the primary key value if necessary.
		// Will be done on insert statement involving auto-incremented primary keys when Lucee/ACF cannot retrieve it for us.
		// This happens on non-supported databases (example: H2) and drivers (example: jTDS).
		local.$id = $identitySelect(queryAttributes=local.args, result=local.result, primaryKey=arguments.$primaryKey);
		if (StructKeyExists(local, "$id")) {
			StructAppend(local.result, local.$id);
		}

		local.rv.result = local.result;
		return local.rv;
	</cfscript>
</cffunction>
