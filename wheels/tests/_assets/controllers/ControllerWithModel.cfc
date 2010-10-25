<cfcomponent extends="wheelsMapping.Controller">

	<cfset user = model("user").findOne(where="lastname = 'Petruzzi'")>

</cfcomponent>