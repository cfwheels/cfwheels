<cfcomponent extends="wheels.test">

	<cffunction name="setup">
		<cfset controller = createobject("component", "wheels.tests.ControllerWithModel")>
		<cfset modelusers = controller.model("ModelUsers")>
	</cffunction>

	<cffunction name="test_setting_and_getting_properties">
		<cfset loc = {}>

		<cfset loc.properties = modelusers.properties()>
		<cfset assert("listlen(structkeylist(loc.properties)) eq 14")>

		<cfset loc.args = {}>
		<cfset loc.args.Address = "1313 mockingbird lane">
		<cfset loc.args.City = "deerfield beach">
		<cfset loc.args.Fax = "9545551212">
		<cfset loc.args.FirstName = "anthony">
		<cfset loc.args.LastName = "petruzzi">
		<cfset loc.args.Password = "it's a secret">
		<cfset loc.args.Phone = "9544826106">
		<cfset loc.args.State = "fl">
		<cfset loc.args.UserName = "tonypetruzzi">
		<cfset loc.args.ZipCode = "33441">
		<cfset loc.args.Id = "">
		<cfset loc.args.birthday = "11/01/1975">
		<cfset loc.args.birthdaymonth = "11">
		<cfset loc.args.birthdayyear = "1975">

		<cfset modelusers.properties(loc.args)>

		<cfset loc.properties = modelusers.properties()>

		<cfset halt(false, "loc.properties")>
		<cfloop collection="#loc.properties#" item="loc.i">
			<cfset assert("loc.properties[loc.i] eq loc.args[loc.i]")>
		</cfloop>

	</cffunction>

</cfcomponent>