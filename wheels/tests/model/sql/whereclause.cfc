<cfcomponent extends="wheelsMapping.Test">

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

	<cffunction name="test_floats">
		<cfset result = model("post").$whereClause(where="averagerating IN(3.6,3.2)")>
		<cfset assert('arraylen(result) gte 4')>
		<cfset assert('isstruct(result[4])')>
		<cfset assert('result[4].datatype eq "float" OR result[4].datatype eq "float8" OR result[4].datatype eq "double" OR result[4].datatype eq "number"')>
		<cfset result = model("post").$whereClause(where="averagerating NOT IN(3.6,3.2)")>
		<cfset assert('arraylen(result) gte 4')>
		<cfset assert('isstruct(result[4])')>
		<cfset assert('result[4].datatype eq "float" OR result[4].datatype eq "float8" OR result[4].datatype eq "double" OR result[4].datatype eq "number"')>
		<cfset result = model("post").$whereClause(where="averagerating = 3.6")>
		<cfset assert('arraylen(result) gte 4')>
		<cfset assert('isstruct(result[4])')>
		<cfset assert('result[4].datatype eq "float" OR result[4].datatype eq "float8" OR result[4].datatype eq "double" OR result[4].datatype eq "number"')>
	</cffunction>

	<cffunction name="test_is_null">
		<cfset result = model("post").$whereClause(where="averagerating IS NULL")>
		<cfset assert('arraylen(result) gte 4')>
		<cfset assert('isstruct(result[4])')>
		<cfset result = model("post").$whereClause(where="averagerating IS NOT NULL")>
		<cfset assert('arraylen(result) gte 4')>
		<cfset assert('isstruct(result[4])')>
		<cfset assert('result[4].datatype eq "float" OR result[4].datatype eq "float8" OR result[4].datatype eq "double" OR result[4].datatype eq "number"')>
	</cffunction>

	<cffunction name="test_should_allow">

	</cffunction>


</cfcomponent>