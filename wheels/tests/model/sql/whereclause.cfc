<cfcomponent extends="wheelsMapping.test">

	<cffunction name="test_numeric_operators">
		<cfset operators = "=,<>,!=,<,<=,!<,>,>=,!>">
		<cfloop list="#operators#" index="i">
			<cfset check = "Len(result[2]) IS (11+#Len(i)#) AND ArrayLen(result) IS 3 AND result[3].type IS 'cf_sql_integer' AND Right(result[2], #Len(i)#) IS '#i#'">
			<cfset result = model("author").$whereClause(where="id#i#0")>
			<cfset assert(check)>
			<cfset result = model("author").$whereClause(where="id#i# 11")>
			<cfset assert(check)>
			<cfset result = model("author").$whereClause(where="id #i#999")>
			<cfset assert(check)>
		</cfloop>
	</cffunction>

</cfcomponent>