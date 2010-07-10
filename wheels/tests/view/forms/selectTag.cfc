<cfcomponent extends="wheelsMapping.test">

	<cffunction name="setup">
		<cfset loc.controller = $controller(name="dummy")>
		<cfset loc.options.simplevalues = '<select id="testselect" name="testselect"><option value="first">first</option><option value="second">second</option><option value="third">third</option></select>'>
		<cfset loc.options.complexvalues = '<select id="testselect" name="testselect"><option value="1">first</option><option value="2">second</option><option value="3">third</option></select>'>
		<cfset loc.options.single_column_query = '<select id="testselect" name="testselect"><option value="first">first</option><option value="second">second</option><option value="third">third</option></select>'>
		<cfset loc.options.empty_query = '<select id="testselect" name="testselect"></select>'>
	</cffunction>

	<cffunction name="test_list_for_option_values">
		<cfset loc.args.name = "testselect">
		<cfset loc.args.options = "first,second,third">
		<cfset halt("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.simplevalues eq loc.r')>
	</cffunction>

	<cffunction name="test_struct_for_option_values">
		<cfset loc.args.name = "testselect">
		<cfset loc.args.options = {1="first", 2="second", 3="third"}>
		<cfset halt("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.complexvalues eq loc.r')>
	</cffunction>

	<cffunction name="test_one_dimensional_array_for_option_values">
		<cfset loc.args.name = "testselect">
		<cfset loc.args.options = ["first", "second", "third"]>
		<cfset halt("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.simplevalues eq loc.r')>
	</cffunction>

	<cffunction name="test_two_dimensional_array_for_option_values">
		<cfset loc.args.name = "testselect">
		<cfset loc.first = [1, "first"]>
		<cfset loc.second = [2, "second"]>
		<cfset loc.third = [3, "third"]>
		<cfset loc.args.options = [loc.first, loc.second, loc.third]>
		<cfset halt("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.complexvalues eq loc.r')>
	</cffunction>

	<cffunction name="test_three_dimensional_array_for_option_values">
		<cfset loc.args.name = "testselect">
		<cfset loc.first = [1, "first", "a"]>
		<cfset loc.second = [2, "second", "b"]>
		<cfset loc.third = [3, "third", "c"]>
		<cfset loc.args.options = [loc.first, loc.second, loc.third]>
		<cfset halt("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.complexvalues eq loc.r')>
	</cffunction>

	<cffunction name="test_query_for_option_values">
		<cfset loc.q = querynew("")>
		<cfset loc.id = [1,2,3]>
		<cfset loc.name = ["first", "second", "third"]>
		<cfset queryaddcolumn(loc.q, "id", loc.id)>
		<cfset queryaddcolumn(loc.q, "name", loc.name)>
		<cfset loc.args.name = "testselect">
		<cfset loc.args.options = loc.q>
		<cfset halt("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.complexvalues eq loc.r')>
	</cffunction>

	<cffunction name="test_one_column_query_for_options">
		<cfset loc.q = querynew("")>
		<cfset loc.id = ["first", "second", "third"]>
		<cfset queryaddcolumn(loc.q, "id", loc.id)>
		<cfset loc.args.name = "testselect">
		<cfset loc.args.options = loc.q>
		<cfset halt("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.single_column_query eq loc.r')>
	</cffunction>

	<cffunction name="test_query_with_no_records_for_option_values_">
		<cfset loc.q = querynew("")>
		<cfset loc.id = []>
		<cfset loc.name = []>
		<cfset queryaddcolumn(loc.q, "id", loc.id)>
		<cfset queryaddcolumn(loc.q, "name", loc.name)>
		<cfset loc.args.name = "testselect">
		<cfset loc.args.options = loc.q>
		<cfset halt("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.empty_query eq loc.r')>
	</cffunction>

	<cffunction name="test_query_with_no_records_or_columns_for_option_values_">
		<cfset loc.q = querynew("")>
		<cfset loc.args.name = "testselect">
		<cfset loc.args.options = loc.q>
		<cfset halt("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.empty_query eq loc.r')>
	</cffunction>

</cfcomponent>