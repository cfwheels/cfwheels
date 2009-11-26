<cfcomponent extends="wheelsMapping.test">

	<cfset loadModels("shop")>

	<cffunction name="test_associate_with_a_single_key_from_the_composite">
		<cfset loc.shops = loc.shop.findone(
				include="city"
			)>
		<cfset assert("IsObject(loc.shops)")>
	</cffunction>

</cfcomponent>