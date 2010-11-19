<cfcomponent name="MemcachedFactory" hint="The Factory for Memcached, should be a scope singleton">
	
	<cfscript>
		instance = StructNew();
		FactoryServers = "";
		FactoryTimeout = 0;
		FactoryUnit = "";
	</cfscript>
	
	<cffunction name="init" access="public" returntype="MemcachedFactory" output="false"
		hint="Our constructor.">
		<cfargument name="servers" type="string" required="false" hint="comma delimited list of servers" />
		<cfargument name="defaultTimeout" type="numeric" required="false" default="-1" 
				hint="the number of nano/micro/milli/seconds to wait for the response.  
				a timeout setting of 0 will wait forever for a response from the server
				*** this defaults to 400  ***
				"/>
		<cfargument name="defaultUnit" type="string" required="false" default=""
				hint="The timeout unit to use for the timeout this will 
					*** this defaults to milliseconds ***
				"/>
		<!--- <cfargument name="servers" type="array" required="false" /> --->
		<cfscript>
			// if (structKeyExists(arguments, "servers")) { }
			
			if (NOT structKeyExists(arguments, "servers") or listlen(arguments.servers) eq 0) {
				arguments.servers = "127.0.0.1:11211";
			}
			
			setMemcached(createObject("component", "com.Memcached").init(arguments.servers));
			if (arguments.defaultTimeout gt -1)	{
				instance.Memcached.setDefaultRequestTimeout = arguments.defaultTimeout;
			}
			if (len(trim(arguments.defaultUnit)))	{
				instance.Memcached.setDefaultTimeoutUnit = arguments.defaultUnit;
			}
			FactoryServers = arguments.servers;
			FactoryTimeout = arguments.defaultTimeout;
			FactoryUnit = arguments.defaultUnit;
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="getMemcached" access="public" returntype="any" output="false"
		hint="Returns the main library class, that is used in all processing" >
		<cfif not StructkeyExists(instance,"Memcached") or isSimpleValue(instance.Memcached)>
			<!------------ if we can't find the instance.Memcached object, then i guess we need to reinit---->
			<cfset this.init()>
		</cfif>
		<cfreturn instance.Memcached />
	</cffunction>
	
	<cffunction name="setMemcached" access="private" returntype="void" output="false">
		<cfargument name="Memcached" type="any" required="true" />
		<cfset instance.Memcached = arguments.Memcached />
	</cffunction>
</cfcomponent>