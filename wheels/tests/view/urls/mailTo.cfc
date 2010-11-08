<cfcomponent extends="wheelsMapping.Test">

	<cfset loc.controller = controller(name="dummy")>

	<cffunction name="test_x_mailTo_valid">
		<cfset loc.controller.mailTo(emailAddress="webmaster@yourdomain.com", name="Contact our Webmaster")>
	</cffunction>

</cfcomponent>