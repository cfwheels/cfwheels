<cfcomponent extends="wheelsMapping.Controller">

	<cfset user = model("UserAutomaticValidations").findOne(where="lastname = 'Petruzzi'")>

</cfcomponent>