<cffunction name="setTableName" returntype="any" access="private" output="false">
	<cfargument name="name" type="any" required="true">
	<cfset variables.class.table_name = arguments.name>
</cffunction>


<cffunction name="setPrimaryKey" returntype="any" access="private" output="false">
	<cfargument name="name" type="any" required="true">
	<cfset variables.class.primary_key = arguments.name>
</cffunction>


<cffunction name="getClassData" returntype="any" access="public" output="false">
	<cfreturn variables.class>
</cffunction>


<cffunction name="getColumns" returntype="any" access="public" output="false">
	<cfreturn variables.class.columns>
</cffunction>


<cffunction name="getAssociations" returntype="any" access="public" output="false">
	<cfreturn variables.class.associations>
</cffunction>