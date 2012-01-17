<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.imagePath = application.wheels.webPath & application.wheels.imagePath>
	</cffunction>

	<cffunction name="test_defaults">
		<cfset loc.r = loc.controller.buttonTag()>
		<cfset loc.e = '<button type="submit" value="save">Save changes</button>'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_with_image">
		<cfset loc.r = loc.controller.buttonTag(image="http://www.cfwheels.com/logo.jpg")>
		<cfset loc.e = '<button type="submit" value="save"><img alt="Logo" src="http://www.cfwheels.com/logo.jpg" type="image" /></button>'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_with_disable">
		<cfset loc.r = loc.controller.buttonTag(disable="Are you sure?")>
		<cfset loc.e = '<button onclick="this.disabled=true;this.value=''Are you sure?'';this.form.submit();" type="submit" value="save">Save changes</button>'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_append_prepend">
		<cfset loc.r = loc.controller.buttonTag(append="a", prepend="p")>
		<cfset loc.e = 'p<button type="submit" value="save">Save changes</button>a'>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>