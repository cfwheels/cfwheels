<cffunction name="setDatasource" returntype="any" access="public" output="false">
	<cfargument name="datasource" type="any" required="false" default="#application.settings.database.datasource#">
	<cfargument name="username" type="any" required="false" default="#application.settings.database.username#">
	<cfargument name="password" type="any" required="false" default="#application.settings.database.password#">
	<cfargument name="timeout" type="any" required="false" default="#application.settings.database.timeout#">
	<cfset setCreateDatasource(argumentCollection=arguments)>
	<cfset setReadDatasource(argumentCollection=arguments)>
	<cfset setUpdateDatasource(argumentCollection=arguments)>
	<cfset setDeleteDatasource(argumentCollection=arguments)>
</cffunction>

<cffunction name="setCreateDatasource" returntype="any" access="public" output="false">
	<cfargument name="datasource" type="any" required="false" default="#application.settings.database.create.datasource#">
	<cfargument name="username" type="any" required="false" default="#application.settings.database.create.username#">
	<cfargument name="password" type="any" required="false" default="#application.settings.database.create.password#">
	<cfargument name="timeout" type="any" required="false" default="#application.settings.database.create.timeout#">
	<cfset variables.class.database.create.datasource = arguments.datasource>
	<cfset variables.class.database.create.username = arguments.username>
	<cfset variables.class.database.create.password = arguments.password>
	<cfset variables.class.database.create.timeout = arguments.timeout>
</cffunction>

<cffunction name="setReadDatasource" returntype="any" access="public" output="false">
	<cfargument name="datasource" type="any" required="false" default="#application.settings.database.read.datasource#">
	<cfargument name="username" type="any" required="false" default="#application.settings.database.read.username#">
	<cfargument name="password" type="any" required="false" default="#application.settings.database.read.password#">
	<cfargument name="timeout" type="any" required="false" default="#application.settings.database.read.timeout#">
	<cfset variables.class.database.read.datasource = arguments.datasource>
	<cfset variables.class.database.read.username = arguments.username>
	<cfset variables.class.database.read.password = arguments.password>
	<cfset variables.class.database.read.timeout = arguments.timeout>
</cffunction>

<cffunction name="setUpdateDatasource" returntype="any" access="public" output="false">
	<cfargument name="datasource" type="any" required="false" default="#application.settings.database.update.datasource#">
	<cfargument name="username" type="any" required="false" default="#application.settings.database.update.username#">
	<cfargument name="password" type="any" required="false" default="#application.settings.database.update.password#">
	<cfargument name="timeout" type="any" required="false" default="#application.settings.database.update.timeout#">
	<cfset variables.class.database.update.datasource = arguments.datasource>
	<cfset variables.class.database.update.username = arguments.username>
	<cfset variables.class.database.update.password = arguments.password>
	<cfset variables.class.database.update.timeout = arguments.timeout>
</cffunction>

<cffunction name="setDeleteDatasource" returntype="any" access="public" output="false">
	<cfargument name="datasource" type="any" required="false" default="#application.settings.database.delete.datasource#">
	<cfargument name="username" type="any" required="false" default="#application.settings.database.delete.username#">
	<cfargument name="password" type="any" required="false" default="#application.settings.database.delete.password#">
	<cfargument name="timeout" type="any" required="false" default="#application.settings.database.delete.timeout#">
	<cfset variables.class.database.delete.datasource = arguments.datasource>
	<cfset variables.class.database.delete.username = arguments.username>
	<cfset variables.class.database.delete.password = arguments.password>
	<cfset variables.class.database.delete.timeout = arguments.timeout>
</cffunction>

<cffunction name="getModelName" returntype="any" access="public" output="false">
	<cfreturn variables.class.name>
</cffunction>

<cffunction name="setTableName" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfset variables.class.table_name = arguments.name>
</cffunction>

<cffunction name="getTableName" returntype="any" access="public" output="false">
	<cfreturn variables.class.table_name>
</cffunction>

<cffunction name="setPrimaryKey" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfset variables.class.primary_key = arguments.name>
</cffunction>

<cffunction name="getPrimaryKey" returntype="any" access="public" output="false">
	<cfreturn variables.class.primary_key>
</cffunction>

<cffunction name="getModelClassData" returntype="any" access="public" output="false">
	<cfreturn variables.class>
</cffunction>

<cffunction name="getColumns" returntype="any" access="public" output="false">
	<cfif structKeyExists(variables.class, "columns")>
		<cfreturn variables.class.columns>
	<cfelse>
		<cfreturn structNew()>
	</cfif>
</cffunction>

<cffunction name="getFieldList" returntype="any" access="public" output="false">
		<cfreturn variables.class.field_list>
</cffunction>

<cffunction name="getFields" returntype="any" access="public" output="false">
	<cfif structKeyExists(variables.class, "columns")>
		<cfreturn variables.class.columns>
	<cfelse>
		<cfreturn structNew()>
	</cfif>
</cffunction>

<cffunction name="getVirtualFieldList" returntype="any" access="public" output="false">
		<cfreturn variables.class.virtual_field_list>
</cffunction>

<cffunction name="getVirtualFields" returntype="any" access="public" output="false">
	<cfif structKeyExists(variables.class, "virtual_fields")>
		<cfreturn variables.class.virtual_fields>
	<cfelse>
		<cfreturn structNew()>
	</cfif>
</cffunction>

<cffunction name="getAttributeList" returntype="any" access="public" output="false">
		<cfreturn variables.class.attribute_list>
</cffunction>

<cffunction name="getAssociations" returntype="any" access="public" output="false">
	<cfif structKeyExists(variables.class, "associations")>
		<cfreturn variables.class.associations>
	<cfelse>
		<cfreturn structNew()>
	</cfif>
</cffunction>