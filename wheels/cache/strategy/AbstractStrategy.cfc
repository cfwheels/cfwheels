<cfinterface>

	<cffunction name="evictOnSet" access="public" description="Method to determine if the eviction policy evicts items when adding items to storage." output="false" returntype="boolean" />

	<cffunction name="evictOnGet" access="public" description="Method to determine if the eviction policy evicts found keys from the storage." output="false" returntype="boolean" />

	<cffunction name="getExpired" access="public" description="Method to find all of the keys that should be expired from the cache." output="false" returntype="array">
		<cfargument name="keys" type="array" required="true">
		<cfargument name="storage" type="any" required="true">
		<cfargument name="currentTime" type="date" required="true">
	</cffunction>


</cfinterface>