<cfcomponent extends="wheelsMapping.test">

	<cffunction name="test_hashing_arguments_to_identical_result">
		<cfset loc.result1 = _method(1,2,3,4,5,6,7,8,9)>
		<cfset loc.result2 = _method(1,2,3,4,5,6,7,8,9)>
		<cfset assert("loc.result1 IS loc.result2")>
	</cffunction>

	<cffunction name="_method">
		<cfreturn $hashedKey(arguments)>
	</cffunction>

</cfcomponent>