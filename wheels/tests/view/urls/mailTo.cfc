<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>

	<cffunction name="test_x_mailTo_valid">
		<cfset loc.controller.mailTo(emailAddress="webmaster@yourdomain.com", name="Contact our Webmaster")>
	</cffunction>

</cfcomponent>