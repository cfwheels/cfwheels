<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.options.simplevalues = '<select id="testselect" name="testselect"><option value="first">first</option><option value="second">second</option><option value="third">third</option></select>'>
		<cfset loc.options.complexvalues = '<select id="testselect" name="testselect"><option value="1">first</option><option value="2">second</option><option value="3">third</option></select>'>
		<cfset loc.options.single_key_struct = '<select id="testselect" name="testselect"><option value="firstKeyName">first Value</option><option value="secondKeyName">second Value</option></select>'>
		<cfset loc.options.single_column_query = '<select id="testselect" name="testselect"><option value="first">first</option><option value="second">second</option><option value="third">third</option></select>'>
		<cfset loc.options.empty_query = '<select id="testselect" name="testselect"></select>'>
	</cffunction>

	<cffunction name="test_list_for_option_values">
		<cfset loc.args.name = "testselect">
		<cfset loc.args.options = "first,second,third">
		<cfset debug("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.simplevalues eq loc.r')>
	</cffunction>

	<cffunction name="test_struct_for_option_values">
		<cfset loc.args.name = "testselect">
		<cfset loc.args.options = {1="first", 2="second", 3="third"}>
		<cfset debug("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.complexvalues eq loc.r')>
	</cffunction>
	
	<cffunction name="test_array_of_structs_for_option_values">
		<cfset loc.args.name = "testselect">
		<cfset loc.args.options = []>
		<cfset loc.temp = {value="1", text="first"}>
		<cfset ArrayAppend(loc.args.options, loc.temp)>
		<cfset loc.temp = {value="2", text="second"}>
		<cfset ArrayAppend(loc.args.options, loc.temp)>
		<cfset loc.temp = {value="3", text="third"}>
		<cfset ArrayAppend(loc.args.options, loc.temp)>
		<cfset debug("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.complexvalues eq loc.r')>
	</cffunction>

	<cffunction name="test_array_of_structs_for_option_values_single_key">
		<cfset loc.args.name = "testselect">
		<cfset loc.args.options = []>
		<cfset loc.temp = {firstKeyName="first Value"}>
		<cfset ArrayAppend(loc.args.options, loc.temp)>
		<cfset loc.temp = {secondKeyName="second Value"}>
		<cfset ArrayAppend(loc.args.options, loc.temp)>
		<cfset debug("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.single_key_struct eq loc.r')>
	</cffunction>

	<cffunction name="test_one_dimensional_array_for_option_values">
		<cfset loc.args.name = "testselect">
		<cfset loc.args.options = ["first", "second", "third"]>
		<cfset debug("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.simplevalues eq loc.r')>
	</cffunction>

	<cffunction name="test_two_dimensional_array_for_option_values">
		<cfset loc.args.name = "testselect">
		<cfset loc.first = [1, "first"]>
		<cfset loc.second = [2, "second"]>
		<cfset loc.third = [3, "third"]>
		<cfset loc.args.options = [loc.first, loc.second, loc.third]>
		<cfset debug("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.complexvalues eq loc.r')>
	</cffunction>

	<cffunction name="test_three_dimensional_array_for_option_values">
		<cfset loc.args.name = "testselect">
		<cfset loc.first = [1, "first", "a"]>
		<cfset loc.second = [2, "second", "b"]>
		<cfset loc.third = [3, "third", "c"]>
		<cfset loc.args.options = [loc.first, loc.second, loc.third]>
		<cfset debug("loc.controller.selectTag(argumentcollection=loc.args)", false)>
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
		<cfset debug("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.complexvalues eq loc.r')>
	</cffunction>

	<cffunction name="test_one_column_query_for_options">
		<cfset loc.q = querynew("")>
		<cfset loc.id = ["first", "second", "third"]>
		<cfset queryaddcolumn(loc.q, "id", loc.id)>
		<cfset loc.args.name = "testselect">
		<cfset loc.args.options = loc.q>
		<cfset debug("loc.controller.selectTag(argumentcollection=loc.args)", false)>
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
		<cfset debug("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.empty_query eq loc.r')>
	</cffunction>

	<cffunction name="test_query_with_no_records_or_columns_for_option_values_">
		<cfset loc.q = querynew("")>
		<cfset loc.args.name = "testselect">
		<cfset loc.args.options = loc.q>
		<cfset debug("loc.controller.selectTag(argumentcollection=loc.args)", false)>
		<cfset loc.r = loc.controller.selectTag(argumentcollection=loc.args)>
		<cfset assert('loc.options.empty_query eq loc.r')>
	</cffunction>

</cfcomponent>