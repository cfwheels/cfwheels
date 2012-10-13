<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="ControllerWithModel")>
		<cfset loc.user = model("user")>
	</cffunction>

	<cffunction name="test_with_list_as_options">
		<cfset loc.options = "Opt1,Opt2">
	    <cfset loc.r = loc.controller.select(objectName="user", property="firstname", options=loc.options, label=false)>
	    <cfset loc.e = '<select id="user-firstname" name="user[firstname]"><option value="Opt1">Opt1</option><option value="Opt2">Opt2</option></select>'>
	    <cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_with_array_as_options">
		<cfset loc.options = ArrayNew(1)>
		<cfset loc.options[1] = "Opt1">
		<cfset loc.options[2] = "Opt2">
		<cfset loc.options[3] = "Opt3">
	    <cfset loc.r = loc.controller.select(objectName="user", property="firstname", options=loc.options, label=false)>
	    <cfset loc.e = '<select id="user-firstname" name="user[firstname]"><option value="Opt1">Opt1</option><option value="Opt2">Opt2</option><option value="Opt3">Opt3</option></select>'>
	    <cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_with_struct_as_options">
		<cfset loc.options = StructNew()>
		<cfset loc.options.x = "xVal">
		<cfset loc.options.y = "yVal">
	    <cfset loc.r = loc.controller.select(objectName="user", property="firstname", options=loc.options, label=false)>
	    <cfset loc.e = '<select id="user-firstname" name="user[firstname]"><option value="x">xVal</option><option value="y">yVal</option></select>'>
	    <cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_setting_text_field">
		<cfset loc.users = loc.user.findAll(returnAs="objects", order="id")>
	    <cfset loc.r = loc.controller.select(objectName="user", property="firstname", options=loc.users, valueField="id", textField="firstName", label=false)>
	    <cfset loc.e = '<select id="user-firstname" name="user[firstname]"><option value="#loc.users[1].id#">Tony</option><option value="#loc.users[2].id#">Chris</option><option value="#loc.users[3].id#">Per</option><option value="#loc.users[4].id#">Raul</option><option value="#loc.users[5].id#">Joe</option></select>'>
	    <cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_first_non_numeric_property_default_text_field_on_query">
		<cfset loc.users = loc.user.findAll(returnAs="query", order="id")>
	    <cfset loc.r = loc.controller.select(objectName="user", property="firstname", options=loc.users, label=false)>
	    <cfset loc.e = '<select id="user-firstname" name="user[firstname]"><option value="#loc.users["id"][1]#">tonyp</option><option value="#loc.users["id"][2]#">chrisp</option><option value="#loc.users["id"][3]#">perd</option><option value="#loc.users["id"][4]#">raulr</option><option value="#loc.users["id"][5]#">joeb</option></select>'>
	    <cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_first_non_numeric_property_default_text_field_on_objects">
		<cfset loc.users = loc.user.findAll(returnAs="objects", order="id")>
	    <cfset loc.r = loc.controller.select(objectName="user", property="firstname", options=loc.users, label=false)>
	    <cfset loc.e = '<select id="user-firstname" name="user[firstname]"><option value="#loc.users[1].id#">tonyp</option><option value="#loc.users[2].id#">chrisp</option><option value="#loc.users[3].id#">perd</option><option value="#loc.users[4].id#">raulr</option><option value="#loc.users[5].id#">joeb</option></select>'>
	    <cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_with_array_of_structs_as_options">
		<cfset loc.options = []>
		<cfset loc.options[1] = {}>
		<cfset loc.options[2] = {}>
		<cfset loc.options[1].tp = "tony petruzzi">
		<cfset loc.options[2].pd = "per djurner">
	    <cfset loc.r = loc.controller.select(objectName="user", property="firstname", options=loc.options, label=false)>
	    <cfset loc.e = '<select id="user-firstname" name="user[firstname]"><option value="tp">tony petruzzi</option><option value="pd">per djurner</option></select>'>
	    <cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_with_array_of_structs_as_options_2">
		<cfset loc.options = []>
		<cfset loc.options[1] = {value="petruzzi", name="tony"}>
		<cfset loc.options[2] = {value="djurner", name="per"}>
	    <cfset loc.r = loc.controller.select(objectName="user", property="firstname", options=loc.options, valueField="value", textField="name", label=false)>
	    <cfset loc.e = '<select id="user-firstname" name="user[firstname]"><option value="petruzzi">tony</option><option value="djurner">per</option></select>'>
	    <cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_htmlsafe">
		<cfset loc.badValue = "<script>alert('hello');</script>">
		<cfset loc.badName = "<script>alert('tony');</script>">
		<cfset loc.goodValue = loc.controller.h(loc.badValue)>
		<cfset loc.goodName = loc.controller.h(loc.badName)>
		<cfset loc.options = []>
		<cfset loc.options[1] = {value="#loc.badValue#", name="#loc.badName#"}>
	    <cfset loc.r = loc.controller.select(objectName="user", property="firstname", options=loc.options, valueField="value", textField="name", label=false)>
	    <cfset assert('loc.r CONTAINS loc.goodValue AND loc.r CONTAINS loc.goodName')>
	</cffunction>

</cfcomponent>