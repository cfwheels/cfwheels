<cfcomponent extends="wheelsMapping.Test">

	<cfset params = {controller="test", action="test"}>
	<cfset loc.controller = controller("dummy", params)>
	
	<cffunction name="setup">
		<cfset args = StructNew()>
		<cfset args.$testingMode = true>
	</cffunction>
	
	<cffunction name="test_only_file_supplied">
		<cfset args.file = "../wheels/tests/_assets/files/cfwheels-logo.png">
		<cfset loc.r = loc.controller.sendFile(argumentCollection=args)>
		<cfset assert('loc.r.file eq "cfwheels-logo.png"')>
		<cfset assert('loc.r.mime eq "image/png"')>
		<cfset assert('loc.r.name eq "cfwheels-logo.png"')>
	</cffunction>
	
	<cffunction name="test_file_and_name_supplied">
		<cfset args.file = "../wheels/tests/_assets/files/cfwheels-logo.png">
		<cfset args.name = "A Weird FileName.png">
		<cfset loc.r = loc.controller.sendFile(argumentCollection=args)>
		<cfset assert('loc.r.file eq "cfwheels-logo.png"')>
		<cfset assert('loc.r.mime eq "image/png"')>
		<cfset assert('loc.r.name eq "A Weird FileName.png"')>
	</cffunction>
	
	<cffunction name="test_change_disposition">
		<cfset args.file = "../wheels/tests/_assets/files/cfwheels-logo.png">
		<cfset args.disposition = "attachment">
		<cfset loc.r = loc.controller.sendFile(argumentCollection=args)>
		<cfset assert('loc.r.file eq "cfwheels-logo.png"')>
		<cfset assert('loc.r.disposition eq "attachment"')>
		<cfset assert('loc.r.mime eq "image/png"')>
		<cfset assert('loc.r.name eq "cfwheels-logo.png"')>
	</cffunction>
	
	<cffunction name="test_overload_mimetype">
		<cfset args.file = "../wheels/tests/_assets/files/cfwheels-logo.png">
		<cfset args.type = "wheels/custom">
		<cfset loc.r = loc.controller.sendFile(argumentCollection=args)>
		<cfset assert('loc.r.file eq "cfwheels-logo.png"')>
		<cfset assert('loc.r.disposition eq "attachment"')>
		<cfset assert('loc.r.mime eq "wheels/custom"')>
		<cfset assert('loc.r.name eq "cfwheels-logo.png"')>
	</cffunction>
	
	<cffunction name="test_no_extension_one_file_exists">
		<cfset args.file = "../wheels/tests/_assets/files/sendFile">
		<cfset loc.r = loc.controller.sendFile(argumentCollection=args)>
		<cfset assert('loc.r.file eq "sendFile.txt"')>
		<cfset assert('loc.r.mime eq "text/plain"')>
		<cfset assert('loc.r.name eq "sendFile.txt"')>
	</cffunction>
	
	<cffunction name="test_no_extension_multiple_files_exists">
		<cfset args.file = "../wheels/tests/_assets/files/cfwheels-logo">
		<cfset loc.r = raised("loc.controller.sendFile(argumentCollection=args)")>
		<cfset assert('loc.r eq "Wheels.FileNotFound"')>
	</cffunction>
	
	<cffunction name="test_specifying_a_directory">
		<cfset args.directory = expandPath("/wheelsMapping/tests/_assets")>
		<cfset args.file = "files/cfwheels-logo.png">
		<cfset loc.r = loc.controller.sendFile(argumentCollection=args)>
		<cfset assert('loc.r.file eq "cfwheels-logo.png"')>
		<cfset assert('loc.r.mime eq "image/png"')>
		<cfset assert('loc.r.name eq "cfwheels-logo.png"')>
	</cffunction>

	<cffunction name="test_ram_resource">
		<cfdocument format="PDF" name="cfwheels_pdf"><p>Test</p></cfdocument>
		<cffile action="write" file="ram://cfwheels.pdf" output="#cfwheels_pdf#"> 
		<cfset args.file = "ram://cfwheels.pdf">
		<cfset args.deleteFile=true>
		<cfset loc.r = loc.controller.sendFile(argumentCollection=args)>
		<cfset assert('loc.r.file eq "ram://cfwheels.pdf"')>
		<cfset assert('loc.r.mime eq "application/pdf"')>
		<cfset assert('loc.r.name eq "cfwheels.pdf"')>
	</cffunction>
	
	<cffunction name="test_non_existent_ram_resource"> 
		<cfset args.file = "ram://doesnt_exist.pdf">  
		<cfset loc.r = raised("loc.controller.sendFile(argumentCollection=args)")>
		<cfset assert('loc.r eq "Wheels.FileNotFound"')>
	</cffunction>
</cfcomponent>