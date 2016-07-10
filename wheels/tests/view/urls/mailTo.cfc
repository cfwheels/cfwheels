<cfcomponent extends="wheelsMapping.Test">

	<cfset loc.controller = controller(name="dummy")>

	<cffunction name="test_x_mailTo_valid">
		<cfset loc.actual = loc.controller.mailTo(emailAddress="webmaster@yourdomain.com", name="Contact our Webmaster")>
		<cfset loc.expected = '<a href="mailto:webmaster@yourdomain.com">Contact our Webmaster</a>'>
		<cfset assert(loc.actual == loc.expected)>
	</cffunction>

</cfcomponent>
