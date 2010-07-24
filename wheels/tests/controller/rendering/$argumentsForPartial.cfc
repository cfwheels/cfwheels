<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="setupAndTeardown.cfm">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>
	
	<cffunction name="$injectIntoVariablesScope" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="data" type="any" required="true" />
		<cfset variables[arguments.name] = arguments.data />
		<cfreturn />
	</cffunction>

	<cffunction name="test_name_is_not_a_function">
		<cfset query = QueryNew("a,b,c,e") />
		<cfset controller.$injectIntoVariablesScope = this.$injectIntoVariablesScope />
		<cfset controller.$injectIntoVariablesScope(name="query", data=query) />
		<cfset loc.e = controller.$argumentsForPartial($name="query", $dataFunction=true)>
		<cfset assert('IsStruct(loc.e) and StructIsEmpty(loc.e)') />
	</cffunction>

</cfcomponent>