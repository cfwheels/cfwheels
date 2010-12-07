<cfcomponent extends="BaseStrategy" implements="AbstractStrategy" output="false">

	<cffunction name="getExpired" access="public" output="false" returntype="array">
		<cfargument name="keys" type="array" required="true">
		<cfargument name="storage" type="any" required="true">
		<cfargument name="currentTime" type="date" required="true">
		<cfscript>
			var loc = {};
			loc.expiredKeys = [];
			if ((variables.$instance.cacheCullPercentage gt 0 
					&& variables.$instance.cacheLastCulledAt < DateAdd("n", -variables.$instance.cacheCullInterval, arguments.currentTime) 
					&& arguments.storage.count() gte variables.$instance.maximumItemsToCache)
				|| ArrayLen(arguments.keys) == 1)
			{
				// cache is full so flush out expired items from this cache to make more room if possible
				for (loc.i = 1; loc.i lte ArrayLen(arguments.keys); loc.i++)
				{
					loc.key = arguments.keys[loc.i];
					loc.cacheItem = arguments.storage.get(loc.key);
					
					if (arguments.currentTime gt loc.cacheItem.expiresAt)
					{
						ArrayAppend(loc.expiredKeys, loc.key);
						if (variables.$instance.cacheCullPercentage < 100)
						{
							loc.percentageDeleted = (ArrayLen(loc.expiredKeys) / ArrayLen(arguments.keys)) * 100;
							if (loc.percentageDeleted gte variables.$instance.cacheCullPercentage)
								break;
						}
					}
				}
				variables.$instance.cacheLastCulledAt = arguments.currentTime;				
			}
		</cfscript>
		<cfreturn loc.expiredKeys>
	</cffunction>
	
	<cffunction name="checkExpired" access="public" output="false" returntype="array">
		<cfargument name="value" type="struct" required="true">
		<cfargument name="storage" type="AbstractStorage" required="true">
	</cffunction>

</cfcomponent>