<cfcomponent output="false">

	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="defaultCacheTime" type="numeric" required="true">
		<cfargument name="cacheCullPercentage" type="numeric" required="true">
		<cfargument name="cacheCullInterval" type="numeric" required="true">
		<cfargument name="maximumItemsToCache" type="numeric" required="true">
		<cfargument name="cacheDatePart" type="string" required="true">
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