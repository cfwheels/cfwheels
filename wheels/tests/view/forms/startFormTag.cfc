<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>
	<cfset global.args= {}>
	<cfset global.args.host = "">
	<cfset global.args.method = "post">
	<cfset global.args.multipart = false>
	<cfset global.args.onlypath = true>
	<cfset global.args.port = 0>
	<cfset global.args.protocol = "">
	<cfset global.args.spamprotection = false>
	<cfset global.args.controller = "testcontroller">

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
		<cfset loc.argsction = Replace(loc.controller.urlfor(argumentCollection=loc.args), "&", "&amp;", "all")>
		<cfset loc.e = '<form method="post" onsubmit="this.action=''#Left(loc.argsction, int((Len(loc.argsction)/2)))#''+''#Right(loc.argsction, ceiling((Len(loc.argsction)/2)))#'';">'>
		<cfset loc.r = loc.controller.startFormTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_home_route">
		<cfset loc.args.route = "home">
		<cfset loc.argsction = Replace(loc.controller.urlfor(argumentCollection=loc.args), "&", "&amp;", "all")>
		<cfset loc.e = '<form action="#loc.argsction#" method="post">'>
		<cfset loc.r = loc.controller.startFormTag(argumentcollection=loc.args)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>