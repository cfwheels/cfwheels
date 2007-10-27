<cffunction name="FL_initModel" returntype="any" access="public" output="false">
	<cfset var local = structNew()>

	<cfset variables.class.model_name = listLast(getMetaData(this).name, ".")>

	<!--- call the init function if the developer has created one (for setting up associations, validations etc) --->
	<cfif structKeyExists(variables, "init")>
		<cfset init()>
	</cfif>

	<cfif NOT structKeyExists(variables.class, "table_name")>
		<cfset variables.class.table_name = pluralize(variables.class.model_name)>
	</cfif>

	<cfif NOT structKeyExists(variables.class, "primary_key")>
		<cfset variables.class.primary_key = "id">
	</cfif>

	<cfquery name="local.query" datasource="#application.settings.dsn#" timeout="#application.settings.query_timeout#" username="#application.settings.username#" password="#application.settings.password#">
	SELECT<cfif application.wheels.database.type IS "sqlserver"> TOP 1</cfif> *
	FROM #variables.class.table_name#
	<cfif application.wheels.database.type IS "mysql">LIMIT 1</cfif>
	</cfquery>

	<cfset local.query_metadata = getMetaData(local.query)>
	<cfloop from="1" to="#arrayLen(local.query_metadata)#" index="local.i">
		<cfset local.name = local.query_metadata[local.i].Name>
		<cfset local.type = spanExcluding(local.query_metadata[local.i].TypeName, " ")>
		<cfset "variables.class.columns.#local.name#.type" = local.type>
		<cfset "variables.class.columns.#local.name#.cfsqltype" = application.wheels.adapter.getCFSQLType(local.type)>
		<cfif local.name IS variables.class.primary_key>
			<cfset "variables.class.columns.#local.name#.primary_key" = true>
		<cfelse>
			<cfset "variables.class.columns.#local.name#.primary_key" = false>
		</cfif>
	</cfloop>

	<!--- create a list of all columns in the table --->
	<cfset variables.class.field_list = lCase(local.query.columnlist)>

	<!--- create a list of the virtual fields if they exist --->
	<cfif structKeyExists(variables.class, "virtual_fields")>
		<cfset variables.class.virtual_field_list = structKeyList(variables.class.virtual_fields)>
	<cfelse>
		<cfset variables.class.virtual_field_list = "">
	</cfif>

	<!--- create a list of all attributes (columns in the table and composed columns) --->
	<cfset variables.class.attribute_list = variables.class.field_list>
	<cfif variables.class.virtual_field_list IS NOT "">
		<cfset variables.class.attribute_list = listAppend(variables.class.attribute_list, variables.class.virtual_field_list)>
	</cfif>

	<cfreturn this>
</cffunction>


<cffunction name="FL_initObject" returntype="any" access="public" output="false">
	<cfargument name="attributes" type="any" required="no" default="">
	<cfset var local = structNew()>

	<!--- create a reference to the class data for this object --->
	<cflock name="model_lock" type="readonly" timeout="30">
		<cfset variables.class = application.wheels.models[listLast(getMetaData(this).name, ".")].getClassData()>
	</cflock>

	<!--- setup object attributes in the this scope --->
	<cfif isQuery(arguments.attributes) AND arguments.attributes.recordcount IS NOT 0>
		<cfloop list="#arguments.attributes.columnlist#" index="local.i">
			<cfset this[local.i] = arguments.attributes[local.i][1]>
		</cfloop>
	<cfelseif isStruct(arguments.attributes) AND NOT structIsEmpty(arguments.attributes)>
		<cfloop collection="#arguments.attributes#" item="local.i">
			<cfset this[local.i] = arguments.attributes[local.i]>
		</cfloop>
	</cfif>

	<cfreturn this>
</cffunction>
