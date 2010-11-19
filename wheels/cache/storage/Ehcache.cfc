<cfcomponent implements="AbstractStorage" output="false">
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="timeSpan" type="numeric" required="false" default="#application.wheels.defaultCacheTime#">
		<cfargument name="idleTime" type="numeric" required="false" default="240">
		<cfscript>
			variables.$instance = {};
			variables.$instance.timeSpan = CreateTimeSpan(0, 0, arguments.timeSpan, 0);
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
				loc.value = false;
		</cfscript>
		<cfreturn loc.value>
	</cffunction>
	
	<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="key" type="string" required="true">
		<cfscript>
			CacheRemove(arguments.key, false);
		</cfscript>
	</cffunction>	
	
</cfcomponent>