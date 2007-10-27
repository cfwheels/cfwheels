<cffunction name="addToCache" returntype="any" access="public" output="false">
	<cfargument name="key" type="any" required="true">
	<cfargument name="value" type="any" required="true">
	<cfargument name="cache_time" type="any" required="true">
	<cfargument name="category" type="any" required="false" default="main">
	<cfargument name="FL_type" type="any" required="false" default="external">
	<cfset var local = structNew()>

	<cfif arguments.FL_type IS "external" AND application.settings.cache_cull_percentage GT 0 AND application.wheels.cache_last_culled_at LT dateAdd("s", -application.settings.cache_cull_interval, now()) AND cacheCount() GTE application.settings.maximum_items_to_cache>
		<!--- cache is full so flush out expired items from this cache to make more room if possible --->
		<cfset local.deleted_items = 0>
		<cfset local.cache_count = cacheCount()>
		<cfloop collection="#application.wheels.cache[arguments.FL_type][arguments.category]#" item="local.i">
			<cfif now() GT application.wheels.cache[arguments.FL_type][arguments.category][local.i].expires_at>
				<cfset structDelete(application.wheels.cache[arguments.FL_type][arguments.category], local.i)>
				<cfif application.settings.cache_cull_percentage LT 100>
					<cfset local.deleted_items = local.deleted_items + 1>
					<cfset local.percentage_deleted = (local.deleted_items / local.cache_count) * 100>
					<cfif local.percentage_deleted GTE application.settings.cache_cull_percentage>
						<cfbreak>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<cfset application.wheels.cache_last_culled_at = now()>
	</cfif>

	<cfif arguments.FL_type IS "internal" OR cacheCount() LT application.settings.maximum_items_to_cache>
		<cfset application.wheels.cache[arguments.FL_type][arguments.category][arguments.key] = structNew()>
		<cfset application.wheels.cache[arguments.FL_type][arguments.category][arguments.key].expires_at = dateAdd("s", arguments.cache_time, now())>
		<cfif isSimpleValue(arguments.value)>
			<cfset application.wheels.cache[arguments.FL_type][arguments.category][arguments.key].value = arguments.value>
		<cfelse>
			<cfset application.wheels.cache[arguments.FL_type][arguments.category][arguments.key].value = duplicate(arguments.value)>
		</cfif>
	</cfif>

</cffunction>


<cffunction name="getFromCache" returntype="any" access="public" output="false">
	<cfargument name="key" type="any" required="true">
	<cfargument name="category" type="any" required="false" default="main">
	<cfargument name="FL_type" type="any" required="false" default="external">

	<cfif structKeyExists(application.wheels.cache[arguments.FL_type][arguments.category], arguments.key)>
		<cfif now() GT application.wheels.cache[arguments.FL_type][arguments.category][arguments.key].expires_at>
			<cfset structDelete(application.wheels.cache[arguments.FL_type][arguments.category], arguments.key)>
			<cfreturn false>
		<cfelse>
			<cfif isSimpleValue(application.wheels.cache[arguments.FL_type][arguments.category][arguments.key].value)>
				<cfreturn application.wheels.cache[arguments.FL_type][arguments.category][arguments.key].value>
			<cfelse>
				<cfreturn duplicate(application.wheels.cache[arguments.FL_type][arguments.category][arguments.key].value)>
			</cfif>
		</cfif>
	<cfelse>
		<cfreturn false>
	</cfif>

</cffunction>


<cffunction name="removeFromCache" returntype="any" access="public" output="false">
	<cfargument name="key" type="any" required="true">
	<cfargument name="category" type="any" required="false" default="main">
	<cfargument name="FL_type" type="any" required="false" default="external">

	<cfif structKeyExists(application.wheels.cache[arguments.FL_type][arguments.category], arguments.key)>
		<cfset structDelete(application.wheels.cache[arguments.FL_type][arguments.category], arguments.key)>
	</cfif>

	<cfreturn true>
</cffunction>


<cffunction name="dumpCache" returntype="any" access="public" output="true">
	<cfargument name="category" type="any" required="false" default="">
	<cfargument name="FL_type" type="any" required="false" default="external">
	<cfif len(arguments.category) IS NOT 0>
		<cfdump var="#application.wheels.cache[arguments.FL_type][arguments.category]#">
	<cfelse>
		<cfdump var="#application.wheels.cache[arguments.FL_type]#">
	</cfif>
</cffunction>


<cffunction name="cacheCount" returntype="any" access="public" output="false">
	<cfargument name="category" type="any" required="false" default="">
	<cfargument name="FL_type" type="any" required="false" default="external">
	<cfset var local = structNew()>

	<cfif len(arguments.category) IS NOT 0>
		<cfset local.total = structCount(application.wheels.cache[arguments.FL_type][arguments.category])>
	<cfelse>
		<cfset local.total = 0>
		<cfloop collection="#application.wheels.cache[arguments.FL_type]#" item="local.i">
			<cfset local.total = local.total + structCount(application.wheels.cache[arguments.FL_type][local.i])>
		</cfloop>
	</cfif>

	<cfreturn local.total>
</cffunction>


<cffunction name="clearCache" returntype="any" access="public" output="true">
	<cfargument name="category" type="any" required="false" default="">
	<cfargument name="FL_type" type="any" required="false" default="external">
	<cfset var local = structNew()>

	<cfif len(arguments.category) IS NOT 0>
		<cfset structClear(application.wheels.cache[arguments.FL_type][arguments.category])>
	<cfelse>
		<cfloop collection="#application.wheels.cache[arguments.FL_type]#" item="local.i">
			<cfset structClear(application.wheels.cache[local.i])>
		</cfloop>
	</cfif>

	<cfreturn true>
</cffunction>