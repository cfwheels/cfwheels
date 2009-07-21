<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.controller = createobject("component", "wheels.Controller")>
		<cfset global.controller.$test_deprecated_method = $test_deprecated_method>
	</cffunction>
	
	<cffunction name="setup">
		<cfset loc = {}>
	</cffunction>

	<cffunction name="test_deprecated_message">
		<!--- correct message --->
		<cfset loc.a = global.controller.$test_deprecated_method()>
		<cfset loc.e = loc.a.message>
		<cfset loc.r = "_deprecated_">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>
	
	<cffunction name="test_deprecated_method_called">
		<!--- correct method name. regex might fail on different engines --->
		<cfset loc.a = global.controller.$test_deprecated_method()>
		<cfset loc.e = loc.a.method>
		<cfset loc.r = "test_deprecated_method_called">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>
	
	<cffunction name="$test_deprecated_method">
		<cfreturn $deprecated("_deprecated_", false)>		
	</cffunction>

</cfcomponent>