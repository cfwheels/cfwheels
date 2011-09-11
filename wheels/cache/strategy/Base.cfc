<cfcomponent output="false">

	<cffunction name="init" access="public" output="false" returntype="any">
		<cfreturn this>
	</cffunction>

	<cffunction name="evictOnSet" access="public" output="false" returntype="boolean"
		hint="Determines if the eviction policy should run when inserting keys in the storage.">
		<cfreturn true>
	</cffunction>

	<cffunction name="evictOnGet" access="public" output="false" returntype="boolean"
		hint="Determines if the eviction policy should run when retrieving keys from the storage.">
		<cfreturn true>
	</cffunction>
	
	<cffunction name="expired" access="public" output="false" returntype="array"
		hint="Returns all of the keys, and their values, that should be expired from the cache.">
		<cfargument name="keys" type="array" required="true">
		<cfargument name="storage" type="any" required="true">
		<cfargument name="currentTime" type="date" required="false" default="#now()#">
		<cfreturn ArrayNew(1)>
	</cffunction>

</cfcomponent>