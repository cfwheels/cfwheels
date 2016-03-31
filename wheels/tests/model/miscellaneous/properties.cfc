<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_key">
		<cfset loc.author = model("author").findOne()>
		<cfset loc.result = loc.author.key()>
		<cfset assert("loc.result IS loc.author.id")>
	</cffunction>

	<cffunction name="test_key_with_new">
		<cfset loc.author = model("author").new(id=1, firstName="Per", lastName="Djurner")>
		<cfset loc.result = loc.author.key()>
		<cfset assert("loc.result IS 1")>
	</cffunction>

	<cffunction name="test_setting_and_getting_properties">

		<cfset loc.user = model("user").new()>

		<cfset loc.args = {}>
		<cfset loc.args.Address = "1313 mockingbird lane">
		<cfset loc.args.City = "deerfield beach">
		<cfset loc.args.Fax = "9545551212">
		<cfset loc.args.FirstName = "anthony">
		<cfset loc.args.LastName = "Petruzzi">
		<cfset loc.args.Password = "it's a secret">
		<cfset loc.args.Phone = "9544826106">
		<cfset loc.args.State = "fl">
		<cfset loc.args.UserName = "tonypetruzzi">
		<cfset loc.args.ZipCode = "33441">
		<cfset loc.args.Id = "">
		<cfset loc.args.birthday = "11/01/1975">
		<cfset loc.args.birthdaymonth = "11">
		<cfset loc.args.birthdayyear = "1975">

		<cfset loc.user.setProperties(loc.args)>

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

	<cffunction name="test_setting_and_getting_properties_with_named_arguments">
		<cfset loc.author = model("author").findOne()>
		<cfset loc.author.setProperties(firstName="a", lastName="b")>
		<cfset loc.result = loc.author.properties()>
		<cfset assert('loc.result.firstName eq "a"')>
		<cfset assert('loc.result.lastName eq "b"')>
	</cffunction>

	<cffunction name="test_getting_nested_objects_with_simple_argument">
		<cfset loc.adam = {firstName="adam", lastName="chapman"}>
		<cfset loc.postOne = {views="1000", averageRating=1.0, body="This is the single body", title="this is the single title"}>
		<cfset loc.postTwo = {views="2000", averageRating=2.0, body="This is the arrays first body", title="this is the arrays first title"}>
		<cfset loc.postThree = {views="3000", averageRating=3.0, body="This is the arrays second body", title="this is the arrays second title"}>

		<cfset loc.author = model("author").new(loc.adam)>
		<cfset loc.author.post = model("post").new(loc.postOne)>
		<cfset loc.author.posts = [model("post").new(loc.postTwo), model("post").new(loc.postThree)]>

		<cfset loc.simpleAuthor = loc.author.properties(simple=true)>
		<cfset loc.complexAuthor = loc.author.properties()>

		<cfset loc.in = loc.simpleAuthor>
		<cfset loc.want = loc.adam>
		<cfset loc.want.post = loc.postOne>
		<cfset loc.want.posts = [loc.postTwo, loc.postThree]>

		<cfset assert("IsObject(loc.complexAuthor.post)")>
		<cfset assert("ListSort(StructKeyList(loc.in), 'textNoCase') eq ListSort(StructKeyList(loc.want), 'textNoCase')")>
		<cfset assert("ListSort(StructKeyList(loc.in.post), 'textNoCase') eq ListSort(StructKeyList(loc.want.post), 'textNoCase')")>
		<cfset assert("ListSort(StructKeyList(loc.in.posts[1]), 'textNoCase') eq ListSort(StructKeyList(loc.want.posts[1]), 'textNoCase')")>
		<cfset assert("ListSort(StructKeyList(loc.in.posts[2]), 'textNoCase') eq ListSort(StructKeyList(loc.want.posts[2]), 'textNoCase')")>
		<!--- this would be a lot simpler, but the JSON is serialised differently on ACF10 --->
		<!--- <cfset assert("SerializeJSON(loc.in) eq SerializeJSON(loc.want)")> --->
	</cffunction>

</cfcomponent>
