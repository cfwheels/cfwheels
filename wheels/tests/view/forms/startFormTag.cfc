<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset controller = createobject("component", "wheels.tests.ControllerBlank")>
		<cfset args= {}>
		<cfset args.host = "">
		<cfset args.method = "post">
		<cfset args.multipart = false>
		<cfset args.onlypath = true>
		<cfset args.port = 0>
		<cfset args.protocol = "">
		<cfset args.spamprotection = false>
		<cfset args.controller = "test">
		<cfset mypath = application.wheels.webPath>
	</cffunction>

	<cffunction name="test_no_controller_or_action_or_route_should_point_to_current_page">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset structdelete(loc.a, "controller")>
		<cfset loc.r = '<form method="post">'>
		<cfset loc.e = controller.startFormTag(argumentcollection=loc.a)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_with_controller">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.a.controller = "test">
		<cfset loc.actionpath = mypath & "test">
		<cfset loc.r = '<form action="#loc.actionpath#" method="post">'>
		<cfset loc.e = controller.startFormTag(argumentcollection=loc.a)>
		<cfset assert("loc.e eq loc.r", "testing this out")>
	</cffunction>

	<cffunction name="test_with_get_method">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.a.method = "get">
		<cfset loc.actionpath = mypath & "test">
		<cfset loc.e = controller.startFormTag(argumentcollection=loc.a)>
		<cfset loc.r = '<form action="#loc.actionpath#" method="get">'>
		<cfset assert("loc.e eq loc.r")>
		<cfset loc.a.method = "post">
	</cffunction>

	<cffunction name="test_with_multipart">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.actionpath = mypath & "test">
		<cfset loc.a.multipart = "true">
		<cfset loc.e = controller.startFormTag(argumentcollection=loc.a)>
		<cfset loc.r = '<form action="#loc.actionpath#" enctype="multipart/form-data" method="post">'>
		<cfset assert("loc.e eq loc.r")>
		<cfset loc.a.multipart = "false">
	</cffunction>

	<cffunction name="test_with_spamProtection">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.a.spamProtection = "true">
		<cfset loc.actionpath = removechars(mypath, len(mypath), 1)>
		<cfset loc.e = controller.startFormTag(argumentcollection=loc.a)>
		<cfset loc.r = '<form onsubmit="this.action=''#loc.actionpath#''+''/#loc.a.controller#'';" method="post">'>
		<cfset assert("loc.e eq loc.r")>
		<cfset loc.a.spamProtection = "false">
	</cffunction>

	<cffunction name="test_with_home_route">
		<cfset loc = {}>
		<cfset loc.a = duplicate(args)>
		<cfset loc.a.route = "home">
		<cfset loc.actionpath = mypath>
		<cfset halt(false, "variables.controller.startFormTag(argumentcollection=loc.a)")>
		<cfset loc.e = variables.controller.startFormTag(argumentcollection=loc.a)>
		<cfset loc.r = '<form action="#loc.actionpath#" method="post">'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>