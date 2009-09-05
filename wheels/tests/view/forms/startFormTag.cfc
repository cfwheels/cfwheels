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
		<cfset global.args.controller = "test">
		<cfset global.mypath = application.wheels.webPath>
	</cffunction>

	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.a = duplicate(global.args)>
	</cffunction>

	<cffunction name="test_no_controller_or_action_or_route_should_point_to_current_page">
		<cfset structdelete(loc.a, "controller")>
		<cfset loc.r = '<form action="#global.mypath#" method="post">'>
		<cfset loc.e = global.controller.startFormTag(argumentcollection=loc.a)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_with_controller">
		<cfset loc.a.controller = "test">
		<cfset loc.actionpath = global.mypath & "test">
		<cfset loc.r = '<form action="#loc.actionpath#" method="post">'>
		<cfset loc.e = global.controller.startFormTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r", "testing this out")>
	</cffunction>

	<cffunction name="test_with_get_method">
		<cfset loc.a.method = "get">
		<cfset loc.actionpath = global.mypath & "test">
		<cfset loc.e = global.controller.startFormTag(argumentcollection=loc.a)>
		<cfset loc.r = '<form action="#loc.actionpath#" method="get">'>
		<cfset assert("loc.e eq loc.r")>
		<cfset loc.a.method = "post">
	</cffunction>

	<cffunction name="test_with_multipart">
		<cfset loc.actionpath = global.mypath & "test">
		<cfset loc.a.multipart = "true">
		<cfset loc.e = global.controller.startFormTag(argumentcollection=loc.a)>
		<cfset loc.r = '<form action="#loc.actionpath#" enctype="multipart/form-data" method="post">'>
		<cfset assert("loc.e eq loc.r")>
		<cfset loc.a.multipart = "false">
	</cffunction>

	<cffunction name="test_with_spamProtection">
		<cfset loc.a.spamProtection = "true">
		<cfset loc.actionpath = removechars(global.mypath, len(global.mypath), 1)>
		<cfset loc.e = global.controller.startFormTag(argumentcollection=loc.a)>
		<cfset loc.r = '<form onsubmit="this.action=''#loc.actionpath#''+''/#loc.a.controller#'';" method="post">'>
		<cfset assert("loc.e eq loc.r")>
		<cfset loc.a.spamProtection = "false">
	</cffunction>

	<cffunction name="test_with_home_route">
		<cfset loc.a.route = "home">
		<cfset loc.actionpath = global.mypath>
		<cfset loc.e = global.controller.startFormTag(argumentcollection=loc.a)>
		<cfset loc.r = '<form action="#loc.actionpath#" method="post">'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>