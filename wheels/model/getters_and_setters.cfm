<cffunction name="getModelName" returntype="any" access="public" output="false">
	<cfreturn variables.class.model_name>
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


<cffunction name="getClassData" returntype="any" access="public" output="false">
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


