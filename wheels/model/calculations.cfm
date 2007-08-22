<cffunction name="sum" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="true">
	<cfargument name="where" type="any" required="false" default="">
	<cfargument name="include" type="any" required="false" default="">
	<cfargument name="distinct" type="any" required="false" default="false">
	<cfset arguments.type = "SUM">
	<cfreturn calculate(argumentCollection=arguments)>
</cffunction>


<cffunction name="minimum" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="true">
	<cfargument name="where" type="any" required="false" default="">
	<cfargument name="include" type="any" required="false" default="">
	<cfargument name="distinct" type="any" required="false" default="false">
	<cfset arguments.type = "MIN">
	<cfreturn calculate(argumentCollection=arguments)>
</cffunction>


<cffunction name="maximum" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="true">
	<cfargument name="where" type="any" required="false" default="">
	<cfargument name="include" type="any" required="false" default="">
	<cfargument name="distinct" type="any" required="false" default="false">
	<cfset arguments.type = "MAX">
	<cfreturn calculate(argumentCollection=arguments)>
</cffunction>


<cffunction name="average" returntype="any" access="public" output="false">
	<cfargument name="field" type="any" required="true">
	<cfargument name="where" type="any" required="false" default="">
	<cfargument name="include" type="any" required="false" default="">
	<cfargument name="distinct" type="any" required="false" default="false">
	<cfset arguments.type = "AVG">
	<cfreturn calculate(argumentCollection=arguments)>
</cffunction>


<cffunction name="count" returntype="any" access="public" output="false">
	<cfargument name="where" type="any" required="false" default="">
	<cfargument name="include" type="any" required="false" default="">
	<cfargument name="distinct" type="any" required="false" default="false">
	<cfset arguments.field = variables.class.primary_key>
	<cfset arguments.type = "COUNT">
	<cfreturn calculate(argumentCollection=arguments)>
</cffunction>


<cffunction name="calculate" returntype="any" access="public" output="false">
	<cfargument name="type" type="any" required="true">
	<cfargument name="field" type="any" required="true">
	<cfargument name="where" type="any" required="false" default="">
	<cfargument name="include" type="any" required="false" default="">
	<cfargument name="distinct" type="any" required="false" default="false">
	<cfset var local = structNew()>

	<cfif len(arguments.include) IS NOT 0>
		<cfset arguments.distinct = true>
	</cfif>

	<cfif arguments.distinct>
		<cfset arguments.select = "#arguments.type#(DISTINCT #variables.class.table_name#.#arguments.field#) AS result">
	<cfelse>
		<cfset arguments.select = "#arguments.type#(#variables.class.table_name#.#arguments.field#) AS result">
	</cfif>

	<cfset local.query = FL_query(argumentCollection=arguments)>

	<cfif len(local.query.result) IS NOT 0>
		<cfset local.result = local.query.result>
	<cfelse>
		<cfset local.result = 0>
	</cfif>

	<cfreturn local.result>
</cffunction>