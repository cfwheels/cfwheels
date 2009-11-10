<cfcomponent extends="wheelsMapping.controller">

	<cfset ModelUsers1 = model("Users").findOne(where="lastname = 'petruzzi'")>

</cfcomponent>