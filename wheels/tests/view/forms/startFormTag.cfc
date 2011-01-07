<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.args= {}>
		<cfset loc.args.host = "">
		<cfset loc.args.method = "post">
		<cfset loc.args.multipart = false>
		<cfset loc.args.onlypath = true>
		<cfset loc.args.port = 0>
		<cfset loc.args.protocol = "">
		<cfset loc.args.spamprotection = false>
		<cfset loc.args.controller = "testcontroller">
	</cffunction>

	<cffunction name="test_no_controller_or_action_or_route_should_point_to_current_page">
		<cfset structdelete(loc.args, "controller")>
		<cfset loc.argsction = loc.controller.urlfor(argumentCollection=loc.args)>
		<cfset loc.e = '<form action="#loc.argsction#" method="post">'>
		<cfset loc.r = loc.controller.startFormTag(argumentcollection=loc.args)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_with_controller">
		<cfset loc.argsction = loc.controller.urlfor(argumentCollection=loc.args)>
		<cfset loc.e = '<form action="#loc.argsction#" method="post">'>
		<cfset loc.r = loc.controller.startFormTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r", "testing this out")>
	</cffunction>

	<cffunction name="test_with_get_method">
		<cfset loc.args.method = "get">
		<cfset loc.argsction = loc.controller.urlfor(argumentCollection=loc.args)>
		<cfset loc.e = '<form action="#loc.argsction#" method="get">'>
		<cfset loc.r = loc.controller.startFormTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_multipart">
		<cfset loc.args.multipart = "true">
		<cfset loc.argsction = loc.controller.urlfor(argumentCollection=loc.args)>
		<cfset loc.e = loc.controller.startFormTag(argumentcollection=loc.args)>
		<cfset loc.r = '<form action="#loc.argsction#" enctype="multipart/form-data" method="post">'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_spamProtection">
		<cfset loc.args.spamProtection = "true">
		<cfset loc.args.action = "myaction">
		<cfset loc.argsction = loc.controller.toXHTML(loc.controller.urlfor(argumentCollection=loc.args))>
		<cfset loc.e = '<form data-this-action="#Left(loc.argsction, int((Len(loc.argsction)/2)))##Right(loc.argsction, ceiling((Len(loc.argsction)/2)))#" method="post">'>
		<cfset loc.r = loc.controller.startFormTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_home_route">
		<cfset loc.args.route = "home">
		<cfset loc.argsction = loc.controller.toXHTML(loc.controller.urlfor(argumentCollection=loc.args))>
		<cfset loc.e = '<form action="#loc.argsction#" method="post">'>
		<cfset loc.r = loc.controller.startFormTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_external_link">
		<cfset loc.args.action = "https://www.cfwheels.com">
		<cfset loc.args.multipart = true>
		<cfset loc.e = '<form action="https://www.cfwheels.com" enctype="multipart/form-data" method="post">'>
		<cfset loc.r = loc.controller.startFormTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>
	
	<cffunction name="test_remote_link">
		<cfset loc.args.route = "home">
		<cfset loc.args.remote = "true">
		<cfset loc.action = loc.controller.toXHTML(loc.controller.urlfor(argumentCollection=loc.args))>
		<cfset loc.e = '<form action="#loc.action#" data-remote="true" method="post">'>
		<cfset loc.r = loc.controller.startFormTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>