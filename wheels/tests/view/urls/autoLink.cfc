<cfcomponent extends="wheelsMapping.test">
	
	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
	</cffunction>

	<cffunction name="test_link_urls">
		<cfset loc.str = 'blah blah <a href="http://cfwheels.org/download">http://cfwheels.org/download</a> Download Wheels from http://cfwheels.org/download blah blah'>
		<cfset loc.r = loc.controller.autoLink(loc.str, "URLs")>
		<cfset loc.e = 'blah blah <a href="http://cfwheels.org/download">http://cfwheels.org/download</a> Download Wheels from <a href="http://cfwheels.org/download">http://cfwheels.org/download</a> blah blah'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_link_email">
		<cfset loc.str = 'blah blah <a href="mailto:tpetruzzi@gmail.com">tpetruzzi@gmail.com</a> Download Wheels from tpetruzzi@gmail.com blah blah'>
		<cfset loc.r = loc.controller.autoLink(loc.str, "emailAddresses")>
		<cfset loc.e = 'blah blah <a href="mailto:tpetruzzi@gmail.com">tpetruzzi@gmail.com</a> Download Wheels from <a href="mailto:tpetruzzi@gmail.com">tpetruzzi@gmail.com</a> blah blah'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_do_not_include_punctuation">
		<cfset loc.str = 'The best http://cfwheels.org, Framework around. Download Wheels from http://cfwheels.org/download.?!'>
		<cfset loc.r = loc.controller.autoLink(loc.str, "URLs")>
		<cfset loc.e = 'The best <a href="http://cfwheels.org">http://cfwheels.org</a>, Framework around. Download Wheels from <a href="http://cfwheels.org/download">http://cfwheels.org/download</a>.?!'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_overloaded_argument_become_link_attributes">
		<cfset loc.str = 'Download Wheels from http://cfwheels.org/download'>
		<cfset loc.r = loc.controller.autoLink(text=loc.str, link="URLs", target="_blank", class="wheels-href")>
		<cfset loc.e = 'Download Wheels from <a class="wheels-href" href="http://cfwheels.org/download" target="_blank">http://cfwheels.org/download</a>'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_issue_560">
		<cfset loc.str = 'http://www.foo.uk'>
		<cfset loc.r = loc.controller.autoLink(loc.str)>
		<cfset loc.e = '<a href="http://www.foo.uk">http://www.foo.uk</a>'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>