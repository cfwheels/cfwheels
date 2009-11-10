<cfcomponent extends="wheelsMapping.controller">

	<cfset user = model("user").new()>
	<cfset user.addError("firstname", "firstname error1")>
	<cfset user.addError("firstname", "firstname error2")>
	<cfset user.addError("firstname", "firstname error2")>

</cfcomponent>