<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_automaticavalidations_should_not_be_set_for_primarykeys">
		<cfset loc.userphotos = model("UserPhoto").new()>
		<cfset assert('!loc.userphotos.$validationExists("userid")')>
	</cffunction>
	
</cfcomponent>