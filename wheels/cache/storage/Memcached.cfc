<cfcomponent implements="AbstractStorage" output="false">
	
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
			
			if (!StructKeyExists(loc, "value") || (IsSimpleValue(loc.value) && !Len(Trim(loc.value))))
				loc.value = false;
		</cfscript>
		<cfreturn loc.value>
	</cffunction>
	
	<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="key" type="string" required="true">
		<cfscript>
			variables.$instance.cache.delete(arguments.key);
		</cfscript>
	</cffunction>
	
	<cffunction name="$connect" access="private" output="false" returntype="any">
		<cfargument name="servers" type="string" required="false" default="#Trim(REReplace(variables.$instance.servers, '\s+', ' ', 'all'))#">
		<cfargument name="defaultTimeout" type="string" required="false" default="#variables.$instance.timeout#">
		<cfargument name="defaultUnit" type="string" required="false" default="#variables.$instance.timeunit#">
		<cfscript>
			var loc = {};
			
			try
			{
				loc.factory = CreateObject("component", "wheelsMapping.vendor.memcached.MemcachedFactory").init(argumentCollection=arguments);
				loc.memcached = loc.factory.getMemcached();
				
				if (!StructIsEmpty(loc.memcached.getVersions()))
					return loc.memcached;
			}
			catch (Any e)
			{
			}
		</cfscript>
		<cfreturn false>
	</cffunction>	
	
</cfcomponent>