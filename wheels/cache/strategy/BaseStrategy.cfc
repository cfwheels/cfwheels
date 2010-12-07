<cfcomponent output="false">

	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="defaultCacheTime" type="numeric" required="false" default="#application.wheels.defaultCacheTime#">
		<cfargument name="cacheCullPercentage" type="numeric" required="false" default="#application.wheels.cacheCullPercentage#">
		<cfargument name="cacheCullInterval" type="numeric" required="false" default="#application.wheels.cacheCullInterval#">
		<cfargument name="maximumItemsToCache" type="numeric" required="false" default="#application.wheels.maximumItemsToCache#">
		<cfargument name="cacheDatePart" type="string" required="false" default="#application.wheels.cacheDatePart#">
		<cfset variables.$instance = {}>
		<cfset StructAppend(variables.$instance, arguments)>
		<cfset variables.$instance.cacheLastCulledAt = Now()>
		<cfreturn this>
	</cffunction>

	<cffunction name="evictOnSet" access="public" output="false" returntype="boolean">
		<cfreturn true>
	</cffunction>

	<cffunction name="evictOnGet" access="public" output="false" returntype="boolean">
		<cfreturn true>
	</cffunction>

</cfcomponent>