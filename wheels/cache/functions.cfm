<cffunction name="init" returntype="any" access="public" output="false">
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
		StructAppend(variables, arguments);
		variables.cacheLastCulledAt = Now();
		variables.cache = {};
		variables.cache[arguments.defaultNameSpace] = {};
		loc.iEnd = ListLen(arguments.nameSpaces);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			variables.cache[Trim(ListGetAt(arguments.nameSpaces, loc.i))] = {};
		return this;
	</cfscript>
</cffunction>

<cffunction name="add" returntype="void" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfargument name="value" type="any" required="true">
	<cfargument name="time" type="numeric" required="false" default="#variables.defaultCacheTime#">
	<cfargument name="category" type="string" required="false" default="#variables.defaultNameSpace#">
	<cfargument name="currentTime" type="date" required="false" default="#Now()#">
	<cfscript>
		var loc = {};
		if (variables.cacheCullPercentage > 0 && variables.cacheLastCulledAt < DateAdd("n", -variables.cacheCullInterval, arguments.currentTime) && this.count() >= variables.maximumItemsToCache)
		{
			// cache is full so flush out expired items from this cache to make more room if possible
			loc.deletedItems = 0;
			loc.count = this.count();
			for (loc.key in variables.cache[arguments.category])
			{
				if (arguments.currentTime > variables.cache[arguments.category][loc.key].expiresAt)
				{
					this.remove(key=loc.key, category=arguments.category);
					if (variables.cacheCullPercentage < 100)
					{
						loc.deletedItems++;
						loc.percentageDeleted = (loc.deletedItems / loc.count) * 100;
						if (loc.percentageDeleted >= variables.cacheCullPercentage)
							break;
					}
				}
			}
			variables.cacheLastCulledAt = arguments.currentTime;
		}
		if (this.count() < variables.maximumItemsToCache)
		{
			loc.newItem = {};
			loc.newItem.addedAt = arguments.currentTime;
			loc.newItem.expiresAt = DateAdd(variables.cacheDatePart, arguments.time, arguments.currentTime);
			loc.newItem.hitCount = 0;
			if (IsSimpleValue(arguments.value))
				loc.newItem.value = arguments.value;
			else
				loc.newItem.value = Duplicate(arguments.value);
			variables.cache[arguments.category][arguments.key] = loc.newItem;
		}
	</cfscript>
</cffunction>

<cffunction name="get" returntype="any" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfargument name="category" type="string" required="false" default="#variables.defaultNameSpace#">
	<cfargument name="currentTime" type="date" required="false" default="#Now()#">
	<cfscript>
		var loc = {};
		loc.returnValue = false;
		if (StructKeyExists(variables.cache[arguments.category], arguments.key))
		{
			if (arguments.currentTime > variables.cache[arguments.category][arguments.key].expiresAt)
			{
				if (variables.showDebugInformation)
					request.wheels.cacheCounts.culls = request.wheels.cacheCounts.culls + 1;
				this.remove(key=arguments.key, category=arguments.category);
			}
			else
			{
				if (variables.showDebugInformation)
					request.wheels.cacheCounts.hits = request.wheels.cacheCounts.hits + 1;
				variables.cache[arguments.category][arguments.key].hitCount++;
				if (IsSimpleValue(variables.cache[arguments.category][arguments.key].value))
					loc.returnValue = variables.cache[arguments.category][arguments.key].value;
				else
					loc.returnValue = Duplicate(variables.cache[arguments.category][arguments.key].value);
			}
		}

		if (variables.showDebugInformation && IsBoolean(loc.returnValue) && !loc.returnValue)
			request.wheels.cacheCounts.misses = request.wheels.cacheCounts.misses + 1;
			
		return loc.returnValue;
	</cfscript>
</cffunction>

<cffunction name="remove" returntype="void" access="public" output="false">
	<cfargument name="key" type="string" required="true">
	<cfargument name="category" type="string" required="false" default="#variables.defaultNameSpace#">
	<cfset StructDelete(variables.cache[arguments.category], arguments.key)>
</cffunction>

<cffunction name="count" returntype="numeric" access="public" output="false">
	<cfargument name="category" type="string" required="false" default="">
	<cfscript>
		var loc = {};
		if (Len(arguments.category))
		{
			loc.returnValue = StructCount(variables.cache[arguments.category]);
		}
		else
		{
			loc.returnValue = 0;
			for (loc.key in variables.cache)
				loc.returnValue = loc.returnValue + StructCount(variables.cache[loc.key]);
		}
		return loc.returnValue;
	</cfscript>
</cffunction>

<cffunction name="clear" returntype="void" access="public" output="false">
	<cfargument name="category" type="string" required="false" default="">
	<cfscript>
		for (loc.key in variables.cache)
			if (!Len(arguments.category) || arguments.category == loc.key)
				StructClear(variables.cache[loc.key]);
	</cfscript>
</cffunction>