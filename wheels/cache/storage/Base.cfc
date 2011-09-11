<cfcomponent output="false">

	<cffunction name="init" access="public" output="false" returntype="any"
		hint="Method to initialize the storage">
		<cfreturn this>
	</cffunction>

	<cffunction name="isAvailable" access="public" output="false" returntype="boolean"
		hint="Method to determine if the cache can be used">
		<cfreturn true>
	</cffunction>

	<cffunction name="set" access="public" output="false" returntype="void"
		hint="Add a specified key and value to the storage mechanism.">
		<cfargument name="key" type="string" required="true">
		<cfargument name="value" type="any" required="true">
	</cffunction>

	<cffunction name="get" access="public" output="false" returntype="any"
		hint="Get a specified key from the storage mechanism.">
		<cfargument name="key" type="string" required="true">
		<cfreturn "">
	</cffunction>
	
	<cffunction name="evict" access="public" output="false" returntype="numeric"
		hint="Decides what items to remove from the cache using the supplied strategy object.">
		<cfargument name="keys" type="array" required="false">
		<cfargument name="strategy" type="any" required="true">
		<cfargument name="currentTime" type="date" required="true">
		<cfreturn 0>
	</cffunction>

	<cffunction name="delete" access="public" output="false" returntype="void"
		hint="Deletes a specified key from the storage mechanism.">
		<cfargument name="key" type="string" required="true">
	</cffunction>
	
	<cffunction name="count" access="public" output="false" returntype="numeric"
		hint="Return the number of items in the cache.">
		<cfreturn 0>
	</cffunction>
	
	<cffunction name="flush" access="public" output="false" returntype="void"
		hint="Destroys everything in the cache.">
	</cffunction>

	<cffunction name="keys" access="public" output="false" returntype="array"
		hint="Return all the keys currently in the cache">
		<cfreturn ArrayNew(1)>
	</cffunction>

</cfcomponent>