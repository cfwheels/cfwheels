<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller")>
	
	<cffunction name="test_confirm_is_escaped">
		<cfset loc.e = loc.controller.buttonTo(confirm="Mark as: 'Completed'?")>
		<cfset loc.r = '<form action="/a/b/index.cfm/" method="post" onsubmit="return confirm(''Mark as: \''Completed\''?'');"><input type="submit" value="" /></form>'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_disabled_is_escaped">
		<cfset loc.e = loc.controller.buttonTo(disable="Mark as: 'Completed'?")>
		<cfset loc.r = '<form action="/a/b/index.cfm/" method="post"><input onclick="this.disabled=true;this.value=''Mark as: \''Completed\''?'';this.form.submit();" type="submit" value="" /></form>'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>