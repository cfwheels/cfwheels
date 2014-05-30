<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_primarykey_returns_key">
		<cfset loc.author = model("author")>
		<cfset loc.e = loc.author.$classData().keys>
		<cfset loc.r = "id">
		<cfset assert("loc.e IS loc.r")>
		<cfset loc.r = loc.author.primaryKey()>
		<cfset assert("loc.e IS loc.r")>
		<cfset loc.r = loc.author.primaryKeys()>
		<cfset assert("loc.e IS loc.r")>
	</cffunction>

	<cffunction name="test_setprimarykey_appends_keys">
		<cfset loc.author = model("author")>
		<cfset loc.author = duplicate(loc.author)>
		<cfset loc.e = loc.author.$classData().keys>
		<cfset loc.r = "id">
		<cfset assert("loc.e IS loc.r")>
		<cfset loc.author.setprimaryKeys("id2,id3")>
		<cfset loc.e = "id,id2,id3">
		<cfset loc.r = loc.author.primaryKeys()>
		<cfset assert("loc.e IS loc.r")>
	</cffunction>
	

        <cffunction name="test_setprimarykey_not_append_duplicate_keys">
		<cfset loc.author = model("author")>
		<cfset loc.author = duplicate(loc.author)>
		<cfset loc.e = loc.author.$classData().keys>
		<cfset loc.r = "id">
		<cfset assert("loc.e IS loc.r")>
		<cfset loc.author.setprimaryKeys("id2")>
		<cfset loc.author.setprimaryKeys("id2")>
		<cfset loc.e = "id,id2">
		<cfset loc.r = loc.author.primaryKeys()>
		<cfset assert("loc.e IS loc.r")>
	</cffunction>


	<cffunction name="test_retrieve_primary_key_by_position">
		<cfset loc.author = model("author")>
		<cfset loc.author = duplicate(loc.author)>
		<cfset loc.author.setprimaryKeys("id2,id3")>
		<cfset loc.e = loc.author.primaryKeys(1)>
		<cfset loc.r = "id">
		<cfset assert("loc.e IS loc.r")>
		<cfset loc.e = loc.author.primaryKeys(2)>
		<cfset loc.r = "id2">
		<cfset assert("loc.e IS loc.r")>
	</cffunction>

</cfcomponent>
