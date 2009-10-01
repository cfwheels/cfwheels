<cfcomponent extends="wheelsMapping.controller">

	<cfset ModelUsers = model("ModelUsers").new()>
	<cfset ModelUsers.addError("firstname", "firstname error1")>
	<cfset ModelUsers.addError("firstname", "firstname error2")>
	<cfset ModelUsers.addError("firstname", "firstname error2")>

</cfcomponent>