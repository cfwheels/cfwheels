<cfcomponent extends="wheelsMapping.controller">

	<cfset user = model("user").findOne(where="lastname = 'Petruzzi'")>

</cfcomponent>