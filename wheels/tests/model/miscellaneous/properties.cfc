<cfcomponent extends="wheelsMapping.test">

	<cfset global.user = createobject("component", "wheelsMapping.model").$initModelClass("Users")>

	<cffunction name="test_setting_and_getting_properties">

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

		<cfset loc.user.setproperties(loc.args)>

		<cfset loc.properties = loc.user.properties()>

		<cfloop collection="#loc.properties#" item="loc.i">
			<cfset assert("loc.properties[loc.i] eq loc.args[loc.i]")>
		</cfloop>

		<cfset loc.args.FirstName = "per">
		<cfset loc.args.LastName = "djurner">

		<cfset loc.user.setproperties(firstname="per", lastname="djurner")>
		<cfset loc.properties = loc.user.properties()>

		<cfloop collection="#loc.properties#" item="loc.i">
			<cfset assert("loc.properties[loc.i] eq loc.args[loc.i]")>
		</cfloop>

		<cfset loc.args.FirstName = "chris">
		<cfset loc.args.LastName = "peters">
		<cfset loc.args.ZipCode = "33333">

		<cfset loc.params = {}>
		<cfset loc.params.lastname = "peters">
		<cfset loc.params.zipcode = "33333">

		<cfset loc.user.setproperties(firstname="chris", properties=loc.params)>
		<cfset loc.properties = loc.user.properties()>

		<cfloop collection="#loc.properties#" item="loc.i">
			<cfset assert("loc.properties[loc.i] eq loc.args[loc.i]")>
		</cfloop>
	</cffunction>

</cfcomponent>