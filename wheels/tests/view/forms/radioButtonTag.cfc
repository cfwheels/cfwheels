<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = $controller(name="dummy")>
	</cffunction>

	<cffunction name="test_radioButtonTag_value_not_blank">
		<cfset loc.e = loc.controller.radioButtonTag(name="gender", value="m", label="Male", checked=true)>
		<cfset loc.r = '<label for="gender-m">Male<input checked="checked" id="gender-m" name="gender" type="radio" value="m" /></label>'>
		<cfset halt(expression='loc.e', halt=false, format="text")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_radioButtonTag_value_blank">
		<cfset loc.e = loc.controller.radioButtonTag(name="gender", value="", label="Male", checked=true)>
		<cfset loc.r = '<label for="gender">Male<input checked="checked" id="gender" name="gender" type="radio" value="" /></label>'>
		<cfset halt(expression='htmleditformat(loc.e)', halt=false, format="text")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>