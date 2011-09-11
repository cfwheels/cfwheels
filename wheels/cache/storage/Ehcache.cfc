<cfcomponent extends="Base" output="false">
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="defaultCacheTime" type="numeric" required="true">
		<cfargument name="idleTime" type="numeric" required="false" default="240">
		<cfscript>
			variables.$instance = {};
			variables.$instance.timeSpan = CreateTimeSpan(0, 0, arguments.defaultCacheTime, 0);
			variables.$instance.idleTime = CreateTimeSpan(0, 0, arguments.idleTime, 0);
		</cfscript>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="isAvailable" access="public" output="false" returntype="boolean">
		<cfreturn StructKeyExists(GetFunctionList(), "cacheGet")>
	</cffunction>
	
	<cffunction name="set" access="public" output="false" returntype="void">
		<cfargument name="key" type="string" required="true">
		<cfargument name="value" type="any" required="true">
		<cfscript>
			CachePut(arguments.key, arguments.value, variables.$instance.timeSpan, variables.$instance.idleTime);
		</cfscript>
	</cffunction>
	
	<cffunction name="get" access="public" output="false" returntype="any">
		<cfargument name="key" type="string" required="true">
		<cfscript>
			var loc = {};
			loc.value = CacheGet(arguments.key);
			if (!StructKeyExists(loc, "value"))
			{
				loc.value = false;
			}
		</cfscript>
		<cfreturn loc.value>
	</cffunction>
	
	<cffunction name="evict" access="public" output="false" returntype="numeric">
		<cfargument name="keys" type="array" required="false" default="#ArrayNew(1)#">
		<cfargument name="strategy" type="any" required="true">
		<cfargument name="currentTime" type="date" required="true">
		<cfscript>
			var loc = {};
			
			if (ArrayIsEmpty(arguments.keys))
			{
				arguments.keys = CacheGetAllIds();
			}
			
			loc.expiredKeys = arguments.strategy.getExpired(keys=arguments.keys, storage=this, currentTime=arguments.currentTime);
			
			for (loc.i = 1; loc.i lte ArrayLen(loc.expiredKeys); loc.i++)
			{
				delete(key=loc.expiredKeys[loc.i]);
				}
		</cfscript>
		<cfreturn ArrayLen(loc.expiredKeys)>
	</cffunction>
	
	<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="key" type="string" required="true">
		<cfscript>
			CacheRemove(arguments.key, false);
		</cfscript>
	</cffunction>	
	
	<cffunction name="count" access="public" output="false" returntype="numeric">
		<cfreturn ArrayLen(CacheGetAllIds()) />
	</cffunction>
	
	<cffunction name="flush" access="public" output="false" returntype="void">
		<cfscript>
			var loc = {};
			loc.keys = CacheGetAllIds();
			
			for (loc.i = 1; loc.i lte ArrayLen(loc.keys); loc.i++)
			{
				delete(loc.keys[loc.i]);
			}
		</cfscript>
	</cffunction>
	
</cfcomponent>