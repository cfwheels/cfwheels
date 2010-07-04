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

	<cffunction name="test_in_like_operators">
			<cfset result = model("author").$whereClause(where="id IN (1,2,3)")>
			<cfset assert("Right(result[2], 2) IS 'IN'")>
			<cfset result = model("author").$whereClause(where="id NOT IN (1,2,3)")>
			<cfset assert("Right(result[2], 6) IS 'NOT IN'")>
			<cfset result = model("author").$whereClause(where="lastName LIKE 'Djurner'")>
			<cfset assert("Right(result[2], 4) IS 'LIKE'")>
			<cfset result = model("author").$whereClause(where="lastName NOT LIKE 'Djurner'")>
			<cfset assert("Right(result[2], 8) IS 'NOT LIKE'")>
	</cffunction>

</cfcomponent>