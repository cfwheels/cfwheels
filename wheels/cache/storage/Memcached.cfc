<cfcomponent extends="Base" output="false">
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="servers" type="string" required="false" default="127.0.0.1:11211" />
		<cfargument name="timeout" type="numeric" required="false" default="60" />
		<cfargument name="timeunit" type="string" required="false" default="SECONDS" />
		<cfscript>
			variables.$instance = {};
			variables.$instance.cache = false;
			variables.$instance.available = false;
			StructAppend(variables.$instance, arguments);
			variables.$instance.cache = variables.$connect();
		</cfscript>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="isAvailable" access="public" output="false" returntype="boolean">
		<cfreturn IsObject(variables.$instance.cache)>
	</cffunction>
	
	<cffunction name="set" access="public" output="false" returntype="void">
		<cfargument name="key" type="string" required="true">
		<cfargument name="value" type="any" required="true">
		<cfscript>
			variables.$instance.cache.set(arguments.key, arguments.value);
		</cfscript>
	</cffunction>
	
	<cffunction name="get" access="public" output="false" returntype="any">
		<cfargument name="key" type="string" required="true">
		<cfscript>
			var loc = {};
			
			loc.value = variables.$instance.cache.get(arguments.key);
			
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
		<!--- don't do anything as memcached decides when to evict content from the cache with it's internal lru logic --->
		<cfreturn 0>
	</cffunction>
	
	<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="key" type="string" required="true">
		<cfscript>
			variables.$instance.cache.delete(arguments.key);
		</cfscript>
	</cffunction>
	
	<cffunction name="count" access="public" output="false" returntype="numeric">
		<cfscript>
			var loc = {};
			loc.stats = variables.$instance.cache.getStats();
			loc.totalItems = 0;
			
			for (loc.item in loc.stats)
			{
				// for some reason memcached always shows two items in the cache over what there really is
				loc.totalItems = loc.totalItems + (loc.stats[loc.item]["curr_items"] - 2);
			}
		</cfscript>
		<cfreturn loc.totalItems>
	</cffunction>
	
	<cffunction name="flush" access="public" output="false" returntype="void">
		<cfscript>
			variables.$instance.cache.flush();
		</cfscript>
	</cffunction>
	
	<cffunction name="$connect" access="private" output="false" returntype="any">
		<cfargument name="servers" type="string" required="false" default="#Trim(REReplace(variables.$instance.servers, '\s+', ' ', 'all'))#">
		<cfargument name="defaultTimeout" type="string" required="false" default="#variables.$instance.timeout#">
		<cfargument name="defaultUnit" type="string" required="false" default="#variables.$instance.timeunit#">
		<cfscript>
			var loc = {};

			loc.factory = CreateObject("component", "wheelsMapping.vendor.memcached.MemcachedFactory").init(argumentCollection=arguments);
			loc.memcached = loc.factory.getMemcached();
			
			if (!StructIsEmpty(loc.memcached.getVersions()))
			{
				return loc.memcached;
			}
		</cfscript>
		<cfreturn false>
	</cffunction>	
	
</cfcomponent>