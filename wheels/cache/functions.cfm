<cffunction name="init" returntype="any" access="public" output="false">
	<cfargument name="storage" type="string" required="false" default="#application.wheels.cacheStorage#">
	<cfargument name="strategy" type="string" required="false" default="#application.wheels.cacheStrategy#">
	<cfargument name="defaultCacheTime" type="numeric" required="false" default="#application.wheels.defaultCacheTime#">
	<cfargument name="cacheCullPercentage" type="numeric" required="false" default="#application.wheels.cacheCullPercentage#">
	<cfargument name="cacheCullInterval" type="numeric" required="false" default="#application.wheels.cacheCullInterval#">
	<cfargument name="maximumItemsToCache" type="numeric" required="false" default="#application.wheels.maximumItemsToCache#">
	<cfargument name="cacheDatePart" type="string" required="false" default="#application.wheels.cacheDatePart#">
	<cfscript>
		var loc = {};
		
		// setup our instance scope
		variables.$instance = {};
		StructAppend(variables.$instance, arguments);
		
		// the actual cache of items is stored where ever the storage component is supposed to
		variables.$instance.cache = CreateObject("component", "storage.#arguments.storage#").init(argumentCollection=arguments);
		variables.$instance.strategy = CreateObject("component", "strategy.#arguments.strategy#").init(argumentCollection=arguments);
	</cfscript>
	<cfreturn this>
</cffunction>

<cffunction name="add" returntype="void" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfargument name="value" type="any" required="true">
	<cfargument name="time" type="numeric" required="false" default="#variables.$instance.defaultCacheTime#">
	<cfargument name="currentTime" type="date" required="false" default="#Now()#">
	<cfscript>
		var loc = {};
		
		// evict any
		if (variables.$instance.strategy.evictOnSet())
			variables.$instance.cache.evict(strategy=variables.$instance.strategy, currentTime=arguments.currentTime);
		
		if (count() < variables.$instance.maximumItemsToCache)
		{
			// set our stats in the cache object
			loc.cacheItem = {};
			loc.cacheItem.addedAt = arguments.currentTime;
			loc.cacheItem.expiresAt = DateAdd(variables.$instance.cacheDatePart, arguments.time, arguments.currentTime);
			loc.cacheItem.hitCount = 0;
			
			if (IsSimpleValue(arguments.value))
				loc.cacheItem.value = arguments.value;
			else
				loc.cacheItem.value = Duplicate(arguments.value);
			
			// always cache our value along with our metadata
			variables.$instance.cache.set(arguments.key, loc.cacheItem);
		}
	</cfscript>
</cffunction>

<cffunction name="get" returntype="any" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfargument name="currentTime" type="date" required="false" default="#Now()#">
	<cfscript>
		var loc = {};
		
		// we rely on the storage object to pass back the struct that we passed in, otherwise it is a miss
		loc.evicted = false;
		loc.cacheItem = variables.$instance.cache.get(arguments.key);
		
		if (IsStruct(loc.cacheItem))
		{
			// if we are going to do an eviction here, we should have each storage object handle it with a strategy object
			// so the strategy object needs to be able to apply it's strategy to a single key / value
			
			// do eviction
			if (variables.$instance.strategy.evictOnGet())
			{
				loc.keys = [ arguments.key ];
				loc.evicted = variables.$instance.cache.evict(keys=loc.keys, strategy=variables.$instance.strategy, currentTime=arguments.currentTime);
			}
			
			if (!loc.evicted)
			{
				loc.cacheItem.hitCount++;
				variables.$instance.cache.set(arguments.key, loc.cacheItem);
			
				return loc.cacheItem.value;
			}
		}
	</cfscript>
	<cfreturn false>
</cffunction>

<cffunction name="remove" returntype="void" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfset variables.$instance.cache.delete(arguments.key)>
</cffunction>

<cffunction name="count" returntype="numeric" access="public" output="false">
	<cfreturn variables.$instance.cache.count()>
</cffunction>

<cffunction name="clear" returntype="void" access="public" output="false">
	<cfreturn variables.$instance.cache.flush()>
</cffunction>