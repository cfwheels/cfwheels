<cffunction name="setDatasource" returntype="any" access="public" output="false">
	<cfargument name="datasource" type="any" required="false" default="#application.settings.database.datasource#">
	<cfargument name="username" type="any" required="false" default="#application.settings.database.username#">
	<cfargument name="password" type="any" required="false" default="#application.settings.database.password#">
	<cfset setCreateDatasource(argumentCollection=arguments)>
	<cfset setReadDatasource(argumentCollection=arguments)>
	<cfset setUpdateDatasource(argumentCollection=arguments)>
	<cfset setDeleteDatasource(argumentCollection=arguments)>
</cffunction>

<cffunction name="setCreateDatasource" returntype="any" access="public" output="false">
	<cfargument name="datasource" type="any" required="false" default="#application.settings.database.create.datasource#">
	<cfargument name="username" type="any" required="false" default="#application.settings.database.create.username#">
	<cfargument name="password" type="any" required="false" default="#application.settings.database.create.password#">
	<cfset variables.class.database.create.datasource = arguments.datasource>
	<cfset variables.class.database.create.username = arguments.username>
	<cfset variables.class.database.create.password = arguments.password>
</cffunction>

<cffunction name="setReadDatasource" returntype="any" access="public" output="false">
	<cfargument name="datasource" type="any" required="false" default="#application.settings.database.read.datasource#">
	<cfargument name="username" type="any" required="false" default="#application.settings.database.read.username#">
	<cfargument name="password" type="any" required="false" default="#application.settings.database.read.password#">
	<cfset variables.class.database.read.datasource = arguments.datasource>
	<cfset variables.class.database.read.username = arguments.username>
	<cfset variables.class.database.read.password = arguments.password>
</cffunction>

<cffunction name="setUpdateDatasource" returntype="any" access="public" output="false">
	<cfargument name="datasource" type="any" required="false" default="#application.settings.database.update.datasource#">
	<cfargument name="username" type="any" required="false" default="#application.settings.database.update.username#">
	<cfargument name="password" type="any" required="false" default="#application.settings.database.update.password#">
	<cfset variables.class.database.update.datasource = arguments.datasource>
	<cfset variables.class.database.update.username = arguments.username>
	<cfset variables.class.database.update.password = arguments.password>
</cffunction>

<cffunction name="setDeleteDatasource" returntype="any" access="public" output="false">
	<cfargument name="datasource" type="any" required="false" default="#application.settings.database.delete.datasource#">
	<cfargument name="username" type="any" required="false" default="#application.settings.database.delete.username#">
	<cfargument name="password" type="any" required="false" default="#application.settings.database.delete.password#">
	<cfset variables.class.database.delete.datasource = arguments.datasource>
	<cfset variables.class.database.delete.username = arguments.username>
	<cfset variables.class.database.delete.password = arguments.password>
</cffunction>

<cffunction name="setTable" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfset variables.class.tableName = arguments.name>
</cffunction>

<cffunction name="setPrimaryKey" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfset variables.class.primaryKey = arguments.name>
</cffunction>

<cffunction name="_getModelClassData" returntype="any" access="public" output="false">
	<cfreturn variables.class>
</cffunction>

<cffunction name="_getFieldList" returntype="any" access="public" output="false">
		<cfreturn variables.class.fieldList>
</cffunction>

<cffunction name="_getFields" returntype="any" access="public" output="false">
	<cfreturn variables.class.fields>
</cffunction>

<cffunction name="_getComposedFieldList" returntype="any" access="public" output="false">
		<cfreturn variables.class.composedFieldList>
</cffunction>

<cffunction name="_getComposedFields" returntype="any" access="public" output="false">
	<cfreturn variables.class.composedFields>
</cffunction>

<cffunction name="_getAssociations" returntype="any" access="public" output="false">
	<cfif structKeyExists(variables.class, "associations")>
		<cfreturn variables.class.associations>
	<cfelse>
		<cfreturn structNew()>
	</cfif>
</cffunction>