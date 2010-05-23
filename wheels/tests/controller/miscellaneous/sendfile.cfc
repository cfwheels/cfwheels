<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="test", action="test"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>
	
	<cffunction name="setup">
		<cfset args = StructNew()>
		<cfset args.$testingMode = true>
	</cffunction>
	
	<cffunction name="test_only_file_supplied">
		<cfset args.file = "../wheels/tests/_assets/files/wheelslogo.jpg">
		<cfset loc.r = controller.sendFile(argumentCollection=args)>
		<cfset assert('loc.r.file eq "wheelslogo.jpg"')>
		<cfset assert('loc.r.mime eq "image/jpg"')>
		<cfset assert('loc.r.name eq "wheelslogo.jpg"')>
	</cffunction>
	
	<cffunction name="test_file_and_name_supplied">
		<cfset args.file = "../wheels/tests/_assets/files/wheelslogo.jpg">
		<cfset args.name = "A Weird FileName.jpg">
		<cfset loc.r = controller.sendFile(argumentCollection=args)>
		<cfset assert('loc.r.file eq "wheelslogo.jpg"')>
		<cfset assert('loc.r.mime eq "image/jpg"')>
		<cfset assert('loc.r.name eq "A Weird FileName.jpg"')>
	</cffunction>
	
	<cffunction name="test_change_disposition">
		<cfset args.file = "../wheels/tests/_assets/files/wheelslogo.jpg">
		<cfset args.disposition = "attachment">
		<cfset loc.r = controller.sendFile(argumentCollection=args)>
		<cfset assert('loc.r.file eq "wheelslogo.jpg"')>
		<cfset assert('loc.r.disposition eq "attachment"')>
		<cfset assert('loc.r.mime eq "image/jpg"')>
		<cfset assert('loc.r.name eq "wheelslogo.jpg"')>
	</cffunction>
	
	<cffunction name="test_overload_mimetype">
		<cfset args.file = "../wheels/tests/_assets/files/wheelslogo.jpg">
		<cfset args.type = "wheels/custom">
		<cfset loc.r = controller.sendFile(argumentCollection=args)>
		<cfset assert('loc.r.file eq "wheelslogo.jpg"')>
		<cfset assert('loc.r.disposition eq "attachment"')>
		<cfset assert('loc.r.mime eq "wheels/custom"')>
		<cfset assert('loc.r.name eq "wheelslogo.jpg"')>
	</cffunction>
	
	<cffunction name="test_no_extension_one_file_exists">
		<cfset args.file = "../wheels/tests/_assets/files/sendFile">
		<cfset loc.r = controller.sendFile(argumentCollection=args)>
		<cfset assert('loc.r.file eq "sendFile.txt"')>
		<cfset assert('loc.r.mime eq "text/plain"')>
		<cfset assert('loc.r.name eq "sendFile.txt"')>
	</cffunction>
	
	<cffunction name="test_no_extension_multiple_files_exists">
		<cfset args.file = "../wheels/tests/_assets/files/wheelslogo">
		<cfset loc.r = raised("controller.sendFile(argumentCollection=args)")>
		<cfset assert('loc.r eq "Wheels.FileNotFound"')>
	</cffunction>
	
	<cffunction name="test_specifying_a_directory">
		<cfset args.directory = expandPath("/wheelsMapping/tests/_assets")>
		<cfset args.file = "files/wheelslogo.jpg">
		<cfset loc.r = controller.sendFile(argumentCollection=args)>
		<cfset assert('loc.r.file eq "wheelslogo.jpg"')>
		<cfset assert('loc.r.mime eq "image/jpg"')>
		<cfset assert('loc.r.name eq "wheelslogo.jpg"')>
	</cffunction>
	
</cfcomponent>