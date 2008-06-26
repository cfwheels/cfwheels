<cffunction name="_initModelClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfset var locals = structNew()>

	<!--- setup defaults --->
	<cfset variables.class = structNew()>
	<cfset variables.class.fields = structNew()>
	<cfset variables.class.composedFields = structNew()>
	<cfset variables.class.name = arguments.name>
	<cfset variables.class.tableName = _pluralize(variables.class.name)>
	<cfset variables.class.primaryKey = "id">
	<cfset variables.class.associations = {}>
	<cfloop list="create,read,update,delete" index="locals.i">
		<cfset variables.class.database[locals.i] = structNew()>
		<cfset variables.class.database[locals.i].datasource = application.settings.database[locals.i].datasource>
		<cfset variables.class.database[locals.i].username = application.settings.database[locals.i].username>
		<cfset variables.class.database[locals.i].password = application.settings.database[locals.i].password>
	</cfloop>

	<!--- call init to override defaults if it exists --->
	<cfif structKeyExists(variables, "init")>
		<cfset init()>
	</cfif>

	<cfquery name="locals.query" datasource="#variables.class.database.read.datasource#" username="#variables.class.database.read.username#" password="#variables.class.database.read.password#">
	SELECT<cfif application.wheels.database.type IS "sqlserver"> TOP 1</cfif> *
	FROM #variables.class.tableName#
	<cfif application.wheels.database.type IS "mysql">LIMIT 1</cfif>
	</cfquery>

	<!--- setup fields --->
	<cfset locals.queryMetadata = getMetaData(locals.query)>
	<cfloop from="1" to="#arrayLen(locals.queryMetadata)#" index="locals.i">
		<cfset locals.name = locals.queryMetadata[locals.i].name>
		<cfset locals.type = spanExcluding(locals.queryMetadata[locals.i].typeName, " ")>
		<cfset variables.class.fields[locals.name] = structNew()>
		<cfset variables.class.fields[locals.name].type = locals.type>
		<cfset variables.class.fields[locals.name].cfsqltype = application.wheels.adapter.getCFSQLType(locals.type)>
		<cfif locals.name IS variables.class.primaryKey>
			<cfset variables.class.fields[locals.name].primaryKey = true>
		<cfelse>
			<cfset variables.class.fields[locals.name].primaryKey = false>
		</cfif>
	</cfloop>
	<cfset variables.class.fieldList = structKeyList(variables.class.fields)>
	<cfset variables.class.composedFieldList = structKeyList(variables.class.composedFields)>
	<cfset variables.class.propertyList = listAppend(variables.class.fieldList, variables.class.composedFieldList)>

	<cfreturn this>
</cffunction>


<cffunction name="_createModelObject" returntype="any" access="private" output="false">
	<cfargument name="properties" type="any" required="true">
	<cfreturn createObject("component", "modelRoot.#variables.class.name#")._initModelObject(variables.class.name, arguments.properties)>
</cffunction>


<cffunction name="_initModelObject" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="yes">
	<cfargument name="properties" type="any" required="no" default="">
	<cfset var locals = structNew()>

	<cflock name="modelLock" type="readonly" timeout="30">
		<cfset variables.class = application.wheels.models[arguments.name]._getModelClassData()>
	</cflock>

	<!--- setup object properties in the this scope --->
	<cfif isQuery(arguments.properties) AND arguments.properties.recordCount IS NOT 0>
		<cfloop list="#arguments.properties.columnList#" index="locals.i">
			<cfset this[locals.i] = arguments.properties[locals.i][1]>
		</cfloop>
	<cfelseif isStruct(arguments.properties) AND NOT structIsEmpty(arguments.properties)>
		<cfloop collection="#arguments.properties#" item="locals.i">
			<cfset this[locals.i] = arguments.properties[locals.i]>
		</cfloop>
	</cfif>

	<cfreturn this>
</cffunction>
