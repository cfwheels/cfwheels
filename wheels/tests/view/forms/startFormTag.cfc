<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.controller = createobject("component", "wheels.Controller")>
		<cfset global.args= {}>
		<cfset global.args.host = "">
		<cfset global.args.method = "post">
		<cfset global.args.multipart = false>
		<cfset global.args.onlypath = true>
		<cfset global.args.port = 0>
		<cfset global.args.protocol = "">
		<cfset global.args.spamprotection = false>
		<cfset global.args.controller = "testcontroller">
	</cffunction>

	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.a = duplicate(global.args)>
	</cffunction>

	<cffunction name="test_no_controller_or_action_or_route_should_point_to_current_page">
		<cfset structdelete(loc.a, "controller")>
		<cfset loc.action = global.controller.urlfor(argumentCollection=loc.a)>
		<cfset loc.e = '<form action="#loc.action#" method="post">'>
		<cfset loc.r = global.controller.startFormTag(argumentcollection=loc.a)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_with_controller">
		<cfset loc.action = global.controller.urlfor(argumentCollection=loc.a)>
		<cfset loc.e = '<form action="#loc.action#" method="post">'>
		<cfset loc.r = global.controller.startFormTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r", "testing this out")>
	</cffunction>

	<cffunction name="test_with_get_method">
		<cfset loc.a.method = "get">
		<cfset loc.action = global.controller.urlfor(argumentCollection=loc.a)>
		<cfset loc.e = '<form action="#loc.action#" method="get">'>
		<cfset loc.r = global.controller.startFormTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_multipart">
		<cfset loc.a.multipart = "true">
		<cfset loc.action = global.controller.urlfor(argumentCollection=loc.a)>
		<cfset loc.e = global.controller.startFormTag(argumentcollection=loc.a)>
		<cfset loc.r = '<form action="#loc.action#" enctype="multipart/form-data" method="post">'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_spamProtection">
		<cfset loc.a.spamProtection = "true">
		<cfset loc.a.action = "myaction">
		<cfset loc.action = global.controller.urlfor(argumentCollection=loc.a)>
		<cfset loc.e = '<form onsubmit="this.action=''#Left(loc.action, int((Len(loc.action)/2)))#''+''#Right(loc.action, ceiling((Len(loc.action)/2)))#'';" method="post">'>
		<cfset loc.r = global.controller.startFormTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_with_home_route">
		<cfset loc.a.route = "home">
		<cfset loc.action = global.controller.urlfor(argumentCollection=loc.a)>
		<cfset loc.e = '<form action="#loc.action#" method="post">'>
		<cfset loc.r = global.controller.startFormTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>