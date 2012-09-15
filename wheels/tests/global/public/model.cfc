<cfcomponent extends="wheelsMapping.Test">
	
	<cffunction name="test_model_in_subfolder">
		<cfset loc.path = 'subfolder1/subfolder2'>
		<cfset loc.fullPath = ListChangeDelims(ListAppend(application.wheels.modelPath, loc.path, "/"), '.', '/')>
		<cfset loc.a = model("#loc.path#/UserTablelessSubFolder")>
		<cfset assert('IsObject(loc.a)')>
		<cfset assert('getMetaData(loc.a).name eq "#loc.fullPath#.UserTablelessSubFolder"')>
	</cffunction>
	
	<cffunction name="test_model_in_subfolder_with_leading_forward">
		<cfset loc.path = '/subfolder1/subfolder2'>
		<cfset loc.fullPath = ListChangeDelims(ListAppend(application.wheels.modelPath, loc.path, "/"), '.', '/')>
		<cfset loc.a = model("#loc.path#/UserTablelessSubFolder")>
		<cfset assert('IsObject(loc.a)')>
		<cfset assert('getMetaData(loc.a).name eq "#loc.fullPath#.UserTablelessSubFolder"')>
	</cffunction>
	
	<cffunction name="test_model_in_subfolder_with_trailing_forward">
		<cfset loc.path = 'subfolder1/subfolder2/'>
		<cfset loc.fullPath = ListChangeDelims(ListAppend(application.wheels.modelPath, loc.path, "/"), '.', '/')>
		<cfset loc.a = model("#loc.path#/UserTablelessSubFolder")>
		<cfset assert('IsObject(loc.a)')>
		<cfset assert('getMetaData(loc.a).name eq "#loc.fullPath#.UserTablelessSubFolder"')>
	</cffunction>
	
</cfcomponent>