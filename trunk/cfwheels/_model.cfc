<cfcomponent displayname="Application Model" hint="The base class of all models">

<cffunction name="setTableName" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="yes">
	<cfset variables.tableName = arguments.name>
</cffunction>


<cffunction name="getTableName" returntype="string" access="public" output="false">
	<cfreturn variables.tableName>
</cffunction>


<cffunction name="init" returntype="any" access="public" output="false">
	<cfset var get_columns_query = "">	
	<cfset var associationType = "">
	<cfset var associationName = "">
	<cfset var functionName = "">
	<cfset var firstField = "">
	<cfset var secondField = "">
	<cfset var innerName = "">
	<cfset var outerName = "">

	<!--- Init properties --->
	<cfset variables.model_name = listLast(getMetaData(this).name, ".")>
	<cfif NOT structKeyExists(variables, "table_name")>
		<cfset variables.table_name = pluralize(variables.model_name)>
	</cfif>
	<cfif NOT structKeyExists(variables, "primary_key")>
		<cfset variables.primary_key = "id">
	</cfif>

	<cfquery name="get_columns_query" username="#application.database.user#" password="#application.database.pass#" datasource="#application.database.name#">
	SELECT column_name, data_type, is_nullable, character_maximum_length, column_default
	FROM information_schema.columns
	WHERE table_name = '#variables.table_name#'
	</cfquery>

	<cfset variables.column_list = valueList(get_columns_query.column_name)>
	<cfloop query="get_columns_query">
		<cfset "variables.column_info.#column_name#.db_sql_type" = data_type>		
		<cfset "variables.column_info.#column_name#.cf_sql_type" = getCFSQLType(data_type)>		
		<cfset "variables.column_info.#column_name#.cf_data_type" = getCFDataType(data_type)>
		<cfset "variables.column_info.#column_name#.nullable" = is_nullable>		
		<cfset "variables.column_info.#column_name#.max_length" = character_maximum_length>		
		<cfset "variables.column_info.#column_name#.default" = column_default>		
	</cfloop>

	<cfreturn this>
</cffunction>


<cffunction name="getCFSQLType" returntype="string" access="private" output="false">
	<cfargument name="db_sql_type" type="string" required="yes">	
	<cfset var result = "">
	<cfinclude template="includes/db_#application.database.type#.cfm">
	<cfreturn result>
</cffunction>


<cffunction name="getCFDataType" returntype="string" access="private" output="false">
	<cfargument name="db_sql_type" type="string" required="yes">	
	<cfset var result = "">
	<cfinclude template="includes/cf_#application.database.type#.cfm">
	<cfreturn result>
</cffunction>


<cffunction name="new" access="public" output="false" hint="">
</cffunction>

<cffunction name="create" access="public" output="false" hint="">
</cffunction>

<cffunction name="save" access="public" output="false" hint="">
</cffunction>

<cffunction name="update" access="public" output="false" hint="">
</cffunction>

<cffunction name="destroy" access="public" output="false" hint="">
</cffunction>

<cffunction name="findByID" access="public" output="false" hint="">
</cffunction>

<cffunction name="findFirst" access="public" output="false" hint="">
</cffunction>

<cffunction name="findAll" access="public" output="false" hint="">
</cffunction>

</cfcomponent>
