<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
	</cffunction>

	<cffunction name="test_radioButtonTagGroup">
		<cfset loc.values = StructNew()>
		<cfset loc.values.banana = "Banana">
		<cfset loc.values.apple = "Apple">
		<cfset loc.values.lemon = "Lemon">
		<cfset loc.result = loc.controller.radioButtonTagGroup(name="fruit", values=loc.values, label=false)>
		<cfset loc.compare = '<input id="fruit-apple" name="fruit" type="radio" value="apple" /><input id="fruit-banana" name="fruit" type="radio" value="banana" /><input id="fruit-lemon" name="fruit" type="radio" value="lemon" />'>
		<cfset assert('loc.result EQ loc.compare')>
	</cffunction>

	<cffunction name="test_radioButtonTagGroup_checked">
		<cfset loc.values = StructNew()>
		<cfset loc.values.banana = "Banana">
		<cfset loc.values.apple = "Apple">
		<cfset loc.values.lemon = "Lemon">
		<cfset loc.result = loc.controller.radioButtonTagGroup(name="fruit", values=loc.values, checkedValue="apple", label=false)>
		<cfset loc.compare = '<input checked="checked" id="fruit-apple" name="fruit" type="radio" value="apple" /><input id="fruit-banana" name="fruit" type="radio" value="banana" /><input id="fruit-lemon" name="fruit" type="radio" value="lemon" />'>
		<cfset assert('loc.result EQ loc.compare')>
	</cffunction>

	<cffunction name="test_radioButtonTagGroup_replace_value_in_label">
		<cfset loc.values = StructNew()>
		<cfset loc.values.banana = "Banana">
		<cfset loc.values.apple = "Apple">
		<cfset loc.values.lemon = "Lemon">
		<cfset loc.result = loc.controller.radioButtonTagGroup(name="fruit", values=loc.values, label="1 [value]")>
		<cfset loc.compare = '<label for="fruit-apple">1 Apple<input id="fruit-apple" name="fruit" type="radio" value="apple" /></label><label for="fruit-banana">1 Banana<input id="fruit-banana" name="fruit" type="radio" value="banana" /></label><label for="fruit-lemon">1 Lemon<input id="fruit-lemon" name="fruit" type="radio" value="lemon" /></label>'>
		<cfset assert('loc.result EQ loc.compare')>
	</cffunction>

	<cffunction name="test_radioButtonTagGroup_multiple_appends">
		<cfset loc.values = StructNew()>
		<cfset loc.values.banana = "Banana">
		<cfset loc.values.apple = "Apple">
		<cfset loc.values.lemon = "Lemon">
		<cfset loc.r = loc.controller.radioButtonTagGroup(name="fruit", values=loc.values, append="1,2,3", label=false)>
		<cfset loc.c = '<input id="fruit-apple" name="fruit" type="radio" value="apple" />1<input id="fruit-banana" name="fruit" type="radio" value="banana" />2<input id="fruit-lemon" name="fruit" type="radio" value="lemon" />3'>
		<cfset assert('loc.r EQ loc.c')>
	</cffunction>

	<cffunction name="test_radioButtonTagGroup_append_prepend_to_group">
		<cfset loc.values = StructNew()>
		<cfset loc.values.banana = "Banana">
		<cfset loc.values.apple = "Apple">
		<cfset loc.values.lemon = "Lemon">
		<cfset loc.result = loc.controller.radioButtonTagGroup(name="fruit", values=loc.values, appendToGroup="apptgr", prependToGroup="preptgr", append="app", prepend="prep", label=false)>
		<cfset loc.compare = 'preptgrprep<input id="fruit-apple" name="fruit" type="radio" value="apple" />appprep<input id="fruit-banana" name="fruit" type="radio" value="banana" />appprep<input id="fruit-lemon" name="fruit" type="radio" value="lemon" />appapptgr'>
		<cfset assert('loc.result EQ loc.compare')>
	</cffunction>

	<cffunction name="test_radioButtonTagGroup_order">
		<cfset loc.values = StructNew()>
		<cfset loc.values.banana = "Banana">
		<cfset loc.values.apple = "Apple">
		<cfset loc.values.lemon = "Lemon">
		<cfset loc.r = loc.controller.radioButtonTagGroup(name="fruit", values=loc.values, order="lemon,apple,banana", label=false)>
		<cfset loc.c = '<input id="fruit-lemon" name="fruit" type="radio" value="lemon" /><input id="fruit-apple" name="fruit" type="radio" value="apple" /><input id="fruit-banana" name="fruit" type="radio" value="banana" />'>
		<cfset assert('loc.r EQ loc.c')>
	</cffunction>

</cfcomponent>