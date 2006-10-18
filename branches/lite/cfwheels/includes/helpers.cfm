<cffunction name="arrayDefinedAt" access="public" returntype="boolean" output="false" hint="Takes an array and position and lets us know if the position has a value">
	<cfargument name="array" required="true" type="array" hint="The array to check">
	<cfargument name="position" required="true" type="numeric" hint="The position to check for">

	<cfset var temp = "">
	
	<cftry>
		<cfset temp = array[position]>
		<cfreturn true>

		<cfcatch type="coldfusion.runtime.UndefinedElementException">
			<cfreturn false>
		</cfcatch>
		
		<cfcatch type="coldfusion.runtime.CfJspPage$ArrayBoundException">
			<cfreturn false>
		</cfcatch>
	</cftry>

</cffunction>
<cfset application.core.arrayDefinedAt = arrayDefinedAt>

<cffunction name="queryRowToStruct" access="public" returntype="struct" hint="Returns structure for a row in a query">
	<cfargument name="theQuery" required="yes" type="query" hint="The query to convert">
	<cfargument name="row" required="yes" type="numeric" hint="The row to return">
	
	<cfset var queryCols = listToArray(arguments.theQuery.columnList)>
	<cfset var queryRow = structNew()>
	<cfset var i = 1>
	
	<!--- Loop through each column in the query --->
	<cfloop index="i" from="1" to="#arrayLen(queryCols)#">
		<!--- For each row, change the column names into struct keys and the column data into struct values --->
		<cfset queryRow[queryCols[i]] = arguments.theQuery[queryCols[i]][currentRow]>
	</cfloop>
	
	<cfreturn queryRow>
	
</cffunction>

<cfset application.core.queryRowToStruct = queryRowToStruct>

<cffunction name="capitalize" access="public" returntype="string" output="false" hint="">
	<cfargument name="text" type="string" required="true" hint="">

	<cfset var output = uCase(left(arguments.text,1)) & lCase(right(arguments.text,len(arguments.text)-1))>
	
	<cfreturn output>
	
</cffunction>

<cfset application.core.capitalize = capitalize>