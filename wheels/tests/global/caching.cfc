<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_hashing_arguments_to_identical_result">
		<cfset loc.result1 = _method(1,2,3,4,5,6,7,8,9)>
		<cfset loc.result2 = _method(1,2,3,4,5,6,7,8,9)>
		<cfset assert("loc.result1 IS loc.result2")>
		<cfset loc.result1 = _method("per", "was", "here")>
		<cfset loc.result2 = _method("per", "was", "here")>
		<cfset assert("loc.result1 IS loc.result2")>
		<cfset loc.result1 = _method(a=1, b=2)>
		<cfset loc.result2 = _method(a=1, b=2)>
		<cfset assert("loc.result1 IS loc.result2")>
		<cfset aStruct = StructNew()>
		<cfset aStruct.test1 = "a">
		<cfset aStruct.test2 = "b">
		<cfset anArray = ArrayNew(1)>
		<cfset anArray[1] = 1>
		<cfset loc.result1 = _method(a=aStruct, b=anArray)>
		<cfset loc.result2 = _method(a=aStruct, b=anArray)>
		<cfset assert("loc.result1 IS loc.result2")>
	</cffunction>

	<cffunction name="_method">
		<cfreturn $hashedKey(arguments)>
	</cffunction>

</cfcomponent>