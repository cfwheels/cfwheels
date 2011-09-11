<cfcomponent extends="Base" output="false">
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfscript>
			variables.$instance = {};
			variables.$instance.cache = {};
		</cfscript>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="isAvailable" access="public" output="false" returntype="boolean">
		<cfreturn StructKeyExists(variables, "$instance") && StructKeyExists(variables.$instance, "cache")>
	</cffunction>
	
	<cffunction name="set" access="public" output="false" returntype="void">
		<cfargument name="key" type="string" required="true">
		<cfargument name="value" type="any" required="true">
		<cfscript>
			variables.$instance.cache[arguments.key] = arguments.value;
		</cfscript>
	</cffunction>
	
	<cffunction name="get" access="public" output="false" returntype="any">
		<cfargument name="key" type="string" required="true">
		<cfscript>
			var loc = {};
			loc.value = false;
			
			if (StructKeyExists(variables.$instance.cache, arguments.key))
			{
				if (IsSimpleValue(variables.$instance.cache[arguments.key]))
				{
					loc.value = variables.$instance.cache[arguments.key];
				}
				else
				{
					loc.value = Duplicate(variables.$instance.cache[arguments.key]);
				}
			}
		</cfscript>
		<cfreturn loc.value>
	</cffunction>
	
	<cffunction name="evict" access="public" output="false" returntype="numeric">
		<cfargument name="keys" type="array" required="false" default="#ArrayNew(1)#">
		<cfargument name="strategy" type="any" required="true">
		<cfargument name="currentTime" type="date" required="false" default="#now()#">
		<cfscript>
			var loc = {};
			
			loc.expiredKeys = arguments.strategy.expired(keys=arguments.keys, storage=this, currentTime=arguments.currentTime);
			
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
			StructDelete(variables.$instance.cache, arguments.key, false);
		</cfscript>
	</cffunction>
	
	<cffunction name="count" access="public" output="false" returntype="numeric">
		<cfreturn StructCount(variables.$instance.cache) />
	</cffunction>
	
	<cffunction name="flush" access="public" output="false" returntype="void">
		<cfset StructClear(variables.$instance.cache)>
	</cffunction>
	
	<cffunction name="keys" access="public" output="false" returntype="array">
		<cfreturn ListToArray(StructKeyList(variables.$instance.cache))>
	</cffunction>
	
</cfcomponent>