<cfcomponent extends="wheelsMapping.test">

	<cfset global.dispatch = createobject("component", "wheelsMapping.dispatch")>

	<cffunction name="test_default_day_to_1">
		<cfset loc.formScope = {}>
		<cfset loc.formScope["obj[published]($month)"] = 2>
		<cfset loc.formScope["obj[published]($year)"] = 2000>
		<cfset loc.foundRoute = {pattern="", controller="wheels", action="wheels"}>
		<cfset loc.params = loc.dispatch.$createParams("home", loc.foundRoute, loc.formScope)>
		<cfset loc.e = loc.params.obj.published>
		<cfset loc.r = CreateDateTime(2000, 2, 1, 0, 0, 0)>
		<cfset assert('datecompare(loc.r, loc.e) eq 0')>
	</cffunction>

	<cffunction name="test_default_month_to_1">
		<cfset loc.formScope = {}>
		<cfset loc.formScope["obj[published]($day)"] = 30>
		<cfset loc.formScope["obj[published]($year)"] = 2000>
		<cfset loc.foundRoute = {pattern="", controller="wheels", action="wheels"}>
		<cfset loc.params = loc.dispatch.$createParams("home", loc.foundRoute, loc.formScope)>
		<cfset loc.e = loc.params.obj.published>
		<cfset loc.r = CreateDateTime(2000, 1, 30, 0, 0, 0)>
		<cfset assert('datecompare(loc.r, loc.e) eq 0')>
	</cffunction>

	<cffunction name="test_default_year_to_1899">
		<cfset loc.formScope = {}>
		<cfset loc.formScope["obj[published]($year)"] = 1899>
		<cfset loc.foundRoute = {pattern="", controller="wheels", action="wheels"}>
		<cfset loc.params = loc.dispatch.$createParams("home", loc.foundRoute, loc.formScope)>
		<cfset loc.e = loc.params.obj.published>
		<cfset loc.r = CreateDateTime(1899, 1, 1, 0, 0, 0)>
		<cfset assert('datecompare(loc.r, loc.e) eq 0')>
	</cffunction>

</cfcomponent>