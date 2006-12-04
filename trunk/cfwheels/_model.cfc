<cfcomponent displayname="Application Model" hint="The base class of all models">

<cffunction name="setTableName" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="yes">
	<cfset variables.tableName = arguments.name>
</cffunction>


<cffunction name="getTableName" returntype="string" access="public" output="false">
	<cfreturn variables.tableName>
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
