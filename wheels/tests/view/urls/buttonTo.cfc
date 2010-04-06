<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>

	<cffunction name="setup">
		<cfset SavedConfig = duplicate(application.wheels.URLRewriting)>
		<cfset application.wheels.URLRewriting = "On">
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.URLRewriting = SavedConfig>
	</cffunction>

	<cffunction name="test_confirm_is_escaped">
		<cfset loc.e = '<form action="#application.wheels.webpath#" method="post" onsubmit="return confirm(''Mark as: \''Completed\''?'');"><input type="submit" value="" /></form>'>
		<cfset loc.r = loc.controller.buttonTo(confirm="Mark as: 'Completed'?")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_disabled_is_escaped">
		<cfset loc.e = '<form action="#application.wheels.webpath#" method="post"><input onclick="this.disabled=true;this.value=''Mark as: \''Completed\''?'';this.form.submit();" type="submit" value="" /></form>'>
		<cfset loc.r = loc.controller.buttonTo(disable="Mark as: 'Completed'?")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>