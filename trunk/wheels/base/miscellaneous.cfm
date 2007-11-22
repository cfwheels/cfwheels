<cffunction name="encryptParam" returntype="any" access="public" output="false">
	<cfargument name="param" type="any" required="true">
	<cfset var local = structNew()>

	<cfset local.encrypted_param = arguments.param>

	<cfif isNumeric(local.encrypted_param)>
		<cfset local.length = len(local.encrypted_param)>
		<cfset local.a = (10^local.length) + reverse(local.encrypted_param)>
		<cfset local.b = "0">
		<cfloop from="1" to="#local.length#" index="local.i">
			<cfset local.b = (local.b + left(right(local.encrypted_param, local.i), 1))>
		</cfloop>
		<cfset local.encrypted_param = formatbaseN((local.b+154),16) & formatbasen(bitxor(local.a,461),16)>
	</cfif>

	<cfreturn local.encrypted_param>
</cffunction>

<cffunction name="decryptParam" returntype="any" access="public" output="false">
	<cfargument name="param" type="any" required="true">
	<cfset var local = structNew()>

	<cftry>
		<cfset local.checksum = left(arguments.param, 2)>
		<cfset local.decrypted_param = right(arguments.param, (len(arguments.param)-2))>
		<cfset local.z = bitxor(inputbasen(local.decrypted_param,16),461)>
		<cfset local.decrypted_param = "">
		<cfloop from="1" to="#(len(local.z)-1)#" index="local.i">
				<cfset local.decrypted_param = local.decrypted_param & left(right(local.z, local.i),1)>
		</cfloop>
		<cfset local.checksumtest = "0">
		<cfloop from="1" to="#len(local.decrypted_param)#" index="local.i">
				<cfset local.checksumtest = (local.checksumtest + left(right(local.decrypted_param, local.i),1))>
		</cfloop>
		<cfif left(tostring(formatbaseN((local.checksumtest+154),10)),2) IS NOT left(inputbaseN(local.checksum, 16),2)>
			<cfset local.decrypted_param = arguments.param>
		</cfif>
		<cfcatch>
			<cfset local.decrypted_param = arguments.param>
		</cfcatch>
	</cftry>

	<cfreturn local.decrypted_param>
</cffunction>


<cffunction name="addRoute" returntype="any" access="public" output="false">
	<cfargument name="pattern" type="any" required="false" default="">
	<cfset var local = structNew()>

	<cfif NOT structKeyExists(arguments, "controller") AND arguments.pattern Does Not Contain "[controller]">
		<cfset arguments.controller = application.settings.default_controller>
	</cfif>

	<cfif NOT structKeyExists(arguments, "action") AND arguments.pattern Does Not Contain "[action]">
		<cfset arguments.action = application.settings.default_action>
	</cfif>

	<cfset local.this_route = structNew()>
	<cfset local.this_route.pattern = arguments.pattern>
	<cfloop collection="#arguments#" item="local.i">
		<cfif local.i IS NOT "pattern">
			<cfset local.this_route[local.i] = arguments[local.i]>
		</cfif>
	</cfloop>

	<cfset arrayAppend(application.wheels.routes, local.this_route)>

</cffunction>


<cffunction name="model" returntype="any" access="public" output="false">
	<cfargument name="name" type="any" required="true">
	<cfset var local = structNew()>
	<cfif application.settings.environment IS NOT "production">
		<cfinclude template="../errors/model.cfm">
	</cfif>

	<cfif NOT structKeyExists(application.wheels.models, arguments.name)>
   	<cflock name="model_lock" type="exclusive" timeout="30">
			<cfif NOT structKeyExists(application.wheels.models, arguments.name)>
				<cfset application.wheels.models[arguments.name] = createObject("component", "models.#lCase(arguments.name)#")._initModelClass(arguments.name)>
			</cfif>
		</cflock>
	</cfif>

	<cfreturn application.wheels.models[arguments.name]>
</cffunction>


<cffunction name="setPaginationInfo" returntype="any" access="public" output="false">
	<cfargument name="query" type="any" required="true">
	<cfargument name="current_page" type="any" required="true">
	<cfargument name="total_pages" type="any" required="true">
	<cfargument name="handle" type="any" required="false" default="paginated">
	<cfset var local = structNew()>

	<cfset request.wheels[arguments.handle] = structNew()>
	<cfset request.wheels[arguments.handle].current_page = arguments.current_page>
	<cfset request.wheels[arguments.handle].total_pages = arguments.total_pages>
	<cfset request.wheels[arguments.handle].total_records = arguments.query.recordcount>

	<cfreturn true>
</cffunction>