<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_associate_with_a_single_key_from_the_composite">
		<cfset loc.shops = model("shop").findone(
				include="city"
			)>
		<cfset assert("IsObject(loc.shops)")>
	</cffunction>

</cfcomponent>