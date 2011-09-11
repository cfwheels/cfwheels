<cfcomponent extends="Base" output="false">
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="timeout" type="numeric" required="true" hint="in seconds">
		<cfargument name="cullPercentage" type="numeric" required="true">
		<cfargument name="cullInterval" type="numeric" required="true">
		<cfargument name="maxItems" type="numeric" required="true">
		<cfset variables.$instance = {}>
		<cfset StructAppend(variables.$instance, arguments)>
		<cfset setCulledAt()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="expired" access="public" output="false" returntype="array">
		<cfargument name="keys" type="array" required="true">
		<cfargument name="storage" type="any" required="true">
		<cfargument name="currentTime" type="date" required="false" default="#now()#">
		<cfscript>
			var loc = {};
			loc.expiredKeys = [];
			loc.counter = 0;
			
			// prevent numerous method calls
			loc.cullPercentage = getCullPercentage();
			loc.storageCount = arguments.storage.count();
			loc.maxItems = getMaxItems();
			loc.culledAt = getCulledAt();
			
			// update when this method was last ran
			setCulledAt(arguments.currentTime);
			
			// see if we should even runs this
			if (
				loc.storageCount lt loc.maxItems
				&& DateCompare(loc.culledAt, arguments.currentTime) eq -1
				&& ArrayIsEmpty(arguments.keys)
			){
				return loc.expiredKeys;
			}
			
			// no keys were passed in so get all keys in the storage
			if (ArrayIsEmpty(arguments.keys))
			{
				arguments.keys = arguments.storage.keys();
			}
			
			loc.numKeys = ArrayLen(arguments.keys);
			
			// loop though all the key
			for (loc.iKey = 1; loc.iKey lte loc.numKeys; loc.iKey++)
			{
				// the current key
				loc.key = arguments.keys[loc.iKey];
				// if the index is greater then the maximumItems allowed in the cache, expire it
				if (loc.iKey gte loc.maxItems)
				{
					ArrayAppend(loc.expiredKeys, loc.key);
				}
				else
				{
					// get info about the key
					loc.cacheItem = arguments.storage.get(loc.key);
					// is the key passed it's TTL?
					if (arguments.currentTime gte loc.cacheItem.expiresAt)
					{
						ArrayAppend(loc.expiredKeys, loc.key);
						// see if we have a cull percentage
						if (loc.cullPercentage gt 0)
						{
							// calculate the percentage deleted
							loc.percentageDeleted = (ArrayLen(loc.expiredKeys) / loc.numKeys) * 100;
							// if we've satisfied out percentage, exit
							if (loc.percentageDeleted gte loc.cullPercentage)
							{
								break;
							}
						}
					}
				}
			}
		</cfscript>
		<cfreturn loc.expiredKeys>
	</cffunction>
	
	<cffunction name="setCulledAt" returntype="void"
		hine="the time culling the cache was last ran">
		<cfargument name="value" type="date" required="false" default="#now()#">
		<cfset variables.$instance.culledAt = arguments.value>
	</cffunction>
	
	<cffunction name="getCulledAt">
		<cfreturn variables.$instance.culledAt>
	</cffunction>
	
	<cffunction name="getTimeOut">
		<cfreturn variables.$instance.timeout>
	</cffunction>
	
	<cffunction name="getCullPercentage">
		<cfreturn variables.$instance.cullPercentage>
	</cffunction>
	
	<cffunction name="getCullInterval">
		<cfreturn variables.$instance.cullInterval>
	</cffunction>
	
	<cffunction name="getMaxItems">
		<cfreturn variables.$instance.maxItems>
	</cffunction>

</cfcomponent>