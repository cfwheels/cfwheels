<cfcomponent extends="wheelsMapping.Test">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset loc.controller = controller("dummy", params)>
	<cfset loc.controller.before1 = before1>
	<cfset loc.controller.before2 = before2>
	<cfset loc.controller.before3 = before3>
	<cfset loc.controller.after1 = after1>
	<cfset loc.controller.after2 = after2>

	<cffunction name="test_return_correct_type">

		<cfset loc.controller.filters(through="before1", type="before")>
		<cfset loc.controller.filters(through="before2", type="before")>
		<cfset loc.controller.filters(through="before3", type="before")>
		<cfset loc.controller.filters(through="after1", type="after")>
		<cfset loc.controller.filters(through="after2", type="after")>

		<cfset loc.before = loc.controller.filterChain("before")>
		<cfset loc.after = loc.controller.filterChain("after")>
		<cfset loc.all = loc.controller.filterChain()>

		<cfset assert('ArrayLen(loc.before) eq 3')>
		<cfset assert('loc.before[1].through eq "before1"')>
		<cfset assert('loc.before[2].through eq "before2"')>
		<cfset assert('loc.before[3].through eq "before3"')>

		<cfset assert('ArrayLen(loc.after) eq 2')>
		<cfset assert('loc.after[1].through eq "after1"')>
		<cfset assert('loc.after[2].through eq "after2"')>

		<cfset assert('ArrayLen(loc.all) eq 5')>
	</cffunction>


	<cffunction name="before1">
		<cfreturn "before1">
	</cffunction>

	<cffunction name="before2">
		<cfreturn "before2">
	</cffunction>

	<cffunction name="before3">
		<cfreturn "before3">
	</cffunction>

	<cffunction name="after1">
		<cfreturn "after1">
	</cffunction>

	<cffunction name="after2">
		<cfreturn "after2">
	</cffunction>

</cfcomponent>