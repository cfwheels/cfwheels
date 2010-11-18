<cfinterface>

	<cffunction name="isAvailable" access="public" description="Method to determine if the cache can be used" output="false" returntype="boolean" />

	<cffunction name="add" access="public" description="Add a specified key and value to the storage mechanism." output="false" returntype="void">
		<cfargument name="key" type="string" required="true">
		<cfargument name="value" type="any" required="true">
	</cffunction>

	<cffunction name="get" access="public" description="Get a specified key from the storage mechanism." output="false" returntype="any">
		<cfargument name="key" type="string" required="true">
	</cffunction>

	<cffunction name="delete" access="public" description="Deletes a specified key from the storage mechanism." output="false" returntype="void">
		<cfargument name="key" type="string" required="true">
	</cffunction>

</cfinterface>