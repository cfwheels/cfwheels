<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.controller = createobject("component", "wheels.Controller")>
		<cfset global.options.simplevalues = '<select id="testselect" name="testselect"><option value="first">first</option><option value="second">second</option><option value="third">third</option></select>'>
		<cfset global.options.complexvalues = '<select id="testselect" name="testselect"><option value="1">first</option><option value="2">second</option><option value="3">third</option></select>'>
	</cffunction>

	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.a = {}>
	</cffunction>

	<cffunction name="test_list_for_option_values">
		<cfset loc.a.name = "testselect">
		<cfset loc.a.options = "first,second,third">
		<cfset halt(false, "global.controller.selectTag(argumentcollection=loc.a)")>
		<cfset loc.r = global.controller.selectTag(argumentcollection=loc.a)>
		<cfset assert('global.options.simplevalues eq loc.r')>
	</cffunction>

	<cffunction name="test_struct_for_option_values">
		<cfset loc.a.name = "testselect">
		<cfset loc.a.options = {1="first", 2="second", 3="third"}>
		<cfset halt(false, "global.controller.selectTag(argumentcollection=loc.a)")>
		<cfset loc.r = global.controller.selectTag(argumentcollection=loc.a)>
		<cfset assert('global.options.complexvalues eq loc.r')>
	</cffunction>

	<cffunction name="test_one_dimensional_array_for_option_values">
		<cfset loc.a.name = "testselect">
		<cfset loc.a.options = ["first", "second", "third"]>
		<cfset halt(false, "global.controller.selectTag(argumentcollection=loc.a)")>
		<cfset loc.r = global.controller.selectTag(argumentcollection=loc.a)>
		<cfset assert('global.options.simplevalues eq loc.r')>
	</cffunction>

	<cffunction name="test_two_dimensional_array_for_option_values">
		<cfset loc.a.name = "testselect">
		<cfset loc.a.options = [[1, "first"],[2, "second"], [3, "third"]]>
		<cfset halt(false, "global.controller.selectTag(argumentcollection=loc.a)")>
		<cfset loc.r = global.controller.selectTag(argumentcollection=loc.a)>
		<cfset assert('global.options.complexvalues eq loc.r')>
	</cffunction>

	<cffunction name="test_three_dimensional_array_for_option_values">
		<cfset loc.a.name = "testselect">
		<cfset loc.a.options = [[1, "first", "a"],[2, "second", "b"], [3, "third", "c"]]>
		<cfset halt(false, "global.controller.selectTag(argumentcollection=loc.a)")>
		<cfset loc.r = global.controller.selectTag(argumentcollection=loc.a)>
		<cfset assert('global.options.complexvalues eq loc.r')>
	</cffunction>

	<cffunction name="test_query_for_option_values">
		<cfset loc.q = querynew("")>
		<cfset loc.id = [1,2,3]>
		<cfset loc.name = ["first", "second", "third"]>
		<cfset queryaddcolumn(loc.q, "id", loc.id)>
		<cfset queryaddcolumn(loc.q, "name", loc.name)>
		<cfset loc.a.name = "testselect">
		<cfset loc.a.options = loc.q>
		<cfset halt(false, "global.controller.selectTag(argumentcollection=loc.a)")>
		<cfset loc.r = global.controller.selectTag(argumentcollection=loc.a)>
		<cfset assert('global.options.complexvalues eq loc.r')>
	</cffunction>

</cfcomponent>