<cffunction name="init" returntype="any" access="public" output="false">
	<cfargument name="storage" type="string" required="false" default="#application.wheels.cacheStorage#">
	<cfargument name="cacheSettings" type="struct" required="false" default="#application.wheels.cacheSettings#">
	<cfargument name="defaultCacheTime" type="numeric" required="false" default="#application.wheels.defaultCacheTime#">
	<cfargument name="cacheCullPercentage" type="numeric" required="false" default="#application.wheels.cacheCullPercentage#">
	<cfargument name="cacheCullInterval" type="numeric" required="false" default="#application.wheels.cacheCullInterval#">
	<cfargument name="maximumItemsToCache" type="numeric" required="false" default="#application.wheels.maximumItemsToCache#">
	<cfargument name="cacheDatePart" type="string" required="false" default="#application.wheels.cacheDatePart#">
	<cfargument name="showDebugInformation" type="boolean" required="false" default="#application.wheels.showDebugInformation#">
	<cfargument name="nameSpaces" type="string" required="false" default="actions,images,pages,partials,schemas">
	<cfargument name="defaultNameSpace" type="string" required="false" default="internal">
	<cfscript>
		var loc = {};

		// setup our instance scope
		variables.$instance = {};
		StructAppend(variables.$instance, arguments);
		variables.$instance.cacheLastCulledAt = Now();

		// the actual cache of items is stored where ever the storage component is supposed to
		variables.$instance.cache = CreateObject("component", "storage.#arguments.storage#").init(argumentCollection=arguments.cacheSettings);

		// now we just keep the cache stats in our cache object
		variables.$instance.stats = {};
		variables.$instance.stats[arguments.defaultNameSpace] = {};
		loc.iEnd = ListLen(arguments.nameSpaces);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			variables.$instance.stats[Trim(ListGetAt(arguments.nameSpaces, loc.i))] = {};
	</cfscript>
	<cfreturn this>
</cffunction>

<cffunction name="add" returntype="void" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfargument name="value" type="any" required="true">
	<cfargument name="time" type="numeric" required="false" default="#variables.$instance.defaultCacheTime#">
	<cfargument name="category" type="string" required="false" default="#variables.$instance.defaultNameSpace#">
	<cfargument name="currentTime" type="date" required="false" default="#Now()#">
	<cfscript>
		var loc = {};
		purge(argumentCollection=arguments);
		if (count() < variables.$instance.maximumItemsToCache)
		{
			// set our stats in the cache object
			loc.newItem = {};
			loc.newItem.addedAt = arguments.currentTime;
			loc.newItem.expiresAt = DateAdd(variables.$instance.cacheDatePart, arguments.time, arguments.currentTime);
			loc.newItem.hitCount = 0;
			variables.$instance.stats[arguments.category][arguments.key] = loc.newItem;
			variables.$instance.cache.set(arguments.key, arguments.value);
		}
	</cfscript>
</cffunction>

<cffunction name="get" returntype="any" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfargument name="category" type="string" required="false" default="#variables.$instance.defaultNameSpace#">
	<cfargument name="currentTime" type="date" required="false" default="#Now()#">
	<cfscript>
		var loc = {};
		loc.returnValue = false;
		if (StructKeyExists(variables.$instance.stats[arguments.category], arguments.key))
		{
			if (arguments.currentTime gt variables.$instance.stats[arguments.category][arguments.key].expiresAt)
			{
				if (variables.$instance.showDebugInformation)
					request.wheels.cacheCounts.culls = request.wheels.cacheCounts.culls + 1;
				remove(key=arguments.key, category=arguments.category);
			}
			else
			{
				if (variables.$instance.showDebugInformation)
					request.wheels.cacheCounts.hits = request.wheels.cacheCounts.hits + 1;
				variables.$instance.stats[arguments.category][arguments.key].hitCount++;

				// we now depend on the storage component to deliver an object back that does not reference the cached object
				loc.returnValue = variables.$instance.cache.get(arguments.key);
			}
		}

		if (variables.$instance.showDebugInformation && IsBoolean(loc.returnValue) && !loc.returnValue)
			request.wheels.cacheCounts.misses = request.wheels.cacheCounts.misses + 1;

		return loc.returnValue;
	</cfscript>
</cffunction>

<cffunction name="remove" returntype="void" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfargument name="category" type="string" required="false" default="#variables.$instance.defaultNameSpace#">
	<cfset variables.$instance.cache.delete(arguments.key)>
	<cfset StructDelete(variables.$instance.stats[arguments.category], arguments.key)>
</cffunction>

<cffunction name="count" returntype="numeric" access="public" output="false">
	<cfargument name="category" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		if (Len(arguments.category))
		{
			loc.returnValue = StructCount(variables.$instance.stats[arguments.category]);
		}
		else
		{
			loc.returnValue = 0;
			for (loc.category in variables.$instance.stats)
				loc.returnValue = loc.returnValue + StructCount(variables.$instance.stats[loc.category]);
		}
		return loc.returnValue;
	</cfscript>
</cffunction>

<cffunction name="clear" returntype="void" access="public" output="false">
	<cfargument name="category" type="string" required="false" default="">
	<cfscript>
		for (loc.category in variables.$instance.stats)
		{
			if (!Len(arguments.category) || arguments.category == loc.category)
			{
				for (loc.key in variables.$instance.stats[loc.category])
					variables.$instance.cache.delete(loc.key);
				StructClear(variables.$instance.stats[loc.category]);
			}
		}
	</cfscript>
</cffunction>

<cffunction name="purge" returntype="void" access="public" output="false">
	<cfargument name="category" type="string" required="false" default="#variables.$instance.defaultNameSpace#">
	<cfargument name="currentTime" type="date" required="false" default="#Now()#">
	<cfscript>
		if (variables.$instance.cacheCullPercentage gt 0 && variables.$instance.cacheLastCulledAt < DateAdd("n", -variables.$instance.cacheCullInterval, arguments.currentTime) && count() gte variables.$instance.maximumItemsToCache)
		{
			// cache is full so flush out expired items from this cache to make more room if possible
			loc.deletedItems = 0;
			loc.count = this.count();
			for (loc.key in variables.$instance.cache[arguments.category])
			{
				if (arguments.currentTime gt variables.$instance.stats[arguments.category][loc.key].expiresAt)
				{
					this.remove(key=loc.key, category=arguments.category);
					if (variables.$instance.cacheCullPercentage < 100)
					{
						loc.deletedItems++;
						loc.percentageDeleted = (loc.deletedItems / loc.count) * 100;
						if (loc.percentageDeleted gte variables.$instance.cacheCullPercentage)
							break;
					}
				}
			}
			variables.$instance.cacheLastCulledAt = arguments.currentTime;
		}
	</cfscript>
</cffunction>