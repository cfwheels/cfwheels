<!--- Place the functions that you want available in all views in your application here --->

<cffunction name="getCloudValues" output="false">
	<cfargument name="cloud_query" type="query" required="yes">
	<cfargument name="count_value_field" type="string" required="yes">

	<cfset var values = structNew()>

	<cfoutput query="arguments.cloud_query">
		<cfif NOT isDefined("values.max") OR evaluate(arguments.count_value_field) GT values.max>
			<cfset values.max = evaluate(arguments.count_value_field)>	
		</cfif>
		<cfif NOT isDefined("values.min") OR evaluate(arguments.count_value_field) LT values.min>
			<cfset values.min = evaluate(arguments.count_value_field)>	
		</cfif>
	</cfoutput>
	<cfset values.diff = values.max - values.min>
	<cfset values.distribution = values.diff / 5>

	<cfreturn values>
</cffunction>

<cffunction name="getCloudElementClass" output="false">
	<cfargument name="cloud_values" type="struct" required="yes">
	<cfargument name="count_value" type="numeric" required="yes">

	<cfset var class = "">

	<cfif arguments.count_value IS arguments.cloud_values.min>
		<cfset class = "cloudsize_1">
	<cfelseif arguments.count_value IS arguments.cloud_values.max>
		<cfset class = "cloudsize_7">
	<cfelseif arguments.count_value GT (arguments.cloud_values.min + (arguments.cloud_values.distribution*4))>
		<cfset class = "cloudsize_6">
	<cfelseif arguments.count_value GT (arguments.cloud_values.min + (arguments.cloud_values.distribution*3))>
		<cfset class = "cloudsize_5">
	<cfelseif arguments.count_value GT (arguments.cloud_values.min + (arguments.cloud_values.distribution*2))>
		<cfset class = "cloudsize_4">
	<cfelseif arguments.count_value GT (arguments.cloud_values.min + arguments.cloud_values.distribution)>
		<cfset class = "cloudsize_3">
	<cfelse>
		<cfset class="cloudsize_2">
	</cfif>

	<cfreturn class>
</cffunction>