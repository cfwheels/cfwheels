<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_table_name_with_star_translates_to_all_fields">
		<cfset loc.model = model("post") />
		<cfset loc.r = loc.model.$createSQLFieldList(list="posts.*", include="") />
		<cfset loc.properties = loc.model.$classData().properties />
		<cfset assert('ListLen(loc.r) eq StructCount(loc.properties)') />
	</cffunction>

	<cffunction name="test_wrong_table_alias_in_select_throws_error">
		<cfset loc.model = model("post") />
		<cfset raised('loc.model.$createSQLFieldList(list="comments.*", include="")') />
	</cffunction>

</cfcomponent>