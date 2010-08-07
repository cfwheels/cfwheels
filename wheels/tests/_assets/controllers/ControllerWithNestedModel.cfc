<cfcomponent extends="wheelsMapping.controller">

	<cfset user = model("author").findOne(where="lastname = 'Djurner'", include="profile")>

</cfcomponent>