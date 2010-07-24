<cfcomponent extends="wheelsMapping.test">

	<cffunction name="test_$hashedkey_accepts_undefined_value">
		<cfargument name="value1" type="string" required="false" default="asdfasdf" />
		<cfargument name="value2" type="string" required="false" /><!--- this creates an undefined value to test $hashedKey() --->
		<cfset loc.e = $hashedKey(argumentCollection=arguments)>
		<Cfset loc.r = Hash(arguments.value1) />
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_$hashedkey_accepts_generated_query">
		<cfargument name="a" type="string" required="false" default="asdfasdf" />
		<cfargument name="b" type="query" required="false" default="#QueryNew('a,b,c,e')#" /><!--- this creates a query that does not have sql metadata --->
		<cfset loc.e = $hashedKey(argumentCollection=arguments)>
		<Cfset loc.r = Hash(arguments.a & ListSort(ReplaceList(SerializeJSON(arguments.b), "{,}", ","), "text")) />
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>