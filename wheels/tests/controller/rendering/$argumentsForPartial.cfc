<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="setupAndTeardown.cfm">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset loc.controller = controller("dummy", params)>
	
	<cffunction name="$injectIntoVariablesScope" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="data" type="any" required="true" />
		<cfset variables[arguments.name] = arguments.data />
		<cfreturn />
	</cffunction>

	<cffunction name="test_name_is_not_a_function">
		<cfset query = QueryNew("a,b,c,e") />
		<cfset loc.controller.$injectIntoVariablesScope = this.$injectIntoVariablesScope />
		<cfset loc.controller.$injectIntoVariablesScope(name="query", data=query) />
		<cfset loc.e = loc.controller.$argumentsForPartial($name="query", $dataFunction=true)>
		<cfset assert('IsStruct(loc.e) and StructIsEmpty(loc.e)') />
	</cffunction>

</cfcomponent>