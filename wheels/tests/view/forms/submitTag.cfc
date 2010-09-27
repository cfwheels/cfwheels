<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="ControllerWithModel")>
	</cffunction>

	<cffunction name="test_defaults">
		<cfset loc.e = loc.controller.submitTag()>
		<cfset loc.r = '<input type="submit" value="Save changes" />'>
		<cfset debug('loc.e', false)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_disabled_is_escaped">
		<cfset loc.e = loc.controller.submitTag(disable="Mark as: 'Completed'?")>
		<cfset loc.r = '<input onclick="this.disabled=true;this.value=''Mark as: \''Completed\''?'';this.form.submit();" type="submit" value="Save changes" />'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>