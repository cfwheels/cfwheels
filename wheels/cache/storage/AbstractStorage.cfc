<cfinterface>

	<cffunction name="isAvailable" access="public" description="Method to determine if the cache can be used" output="false" returntype="boolean" />

	<cffunction name="set" access="public" description="Add a specified key and value to the storage mechanism." output="false" returntype="void">
		<cfargument name="key" type="string" required="true">
		<cfargument name="value" type="any" required="true">
	</cffunction>

	<cffunction name="get" access="public" description="Get a specified key from the storage mechanism." output="false" returntype="any">
		<cfargument name="key" type="string" required="true">
	</cffunction>
	
	<cffunction name="evict" access="public" description="Decides what items to remove from the cache using the supplied strategy object." output="false" returntype="numeric">
		<cfargument name="keys" type="array" required="false">
		<cfargument name="strategy" type="any" required="true">
		<cfargument name="currentTime" type="date" required="true">
	</cffunction>

	<cffunction name="delete" access="public" description="Deletes a specified key from the storage mechanism." output="false" returntype="void">
		<cfargument name="key" type="string" required="true">
	</cffunction>
	
	<cffunction name="count" access="public" description="Return the number of items in the cache." output="false" returntype="numeric" />
	
	<cffunction name="flush" access="public" description="Destroys everything in the cache." output="false" returntype="void" />

</cfinterface>