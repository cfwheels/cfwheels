<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.controller = controller(name="dummy")>
		<cfset loc.values = StructNew()>
		<cfset loc.values.js = "JavaScript">
		<cfset loc.values.cfml = "ColdFusion">
		<cfset loc.values.css = "CSS">
		<cfset loc.values.html = "HTML">
	</cffunction>

	<cffunction name="test_checkBoxTagGroup_default_labels">
		<cfset loc.result = loc.controller.checkBoxTagGroup(name="test", values=loc.values)>
		<cfset loc.compare = '<label for="test-cfml">ColdFusion<input id="test-cfml" name="test" type="checkbox" value="cfml" /></label><label for="test-css">CSS<input id="test-css" name="test" type="checkbox" value="css" /></label><label for="test-html">HTML<input id="test-html" name="test" type="checkbox" value="html" /></label><label for="test-js">JavaScript<input id="test-js" name="test" type="checkbox" value="js" /></label>'>
		<cfset assert('loc.result EQ loc.compare')>
	</cffunction>

	<cffunction name="test_checkBoxTagGroup_nothing_checked">
		<cfset loc.result = loc.controller.checkBoxTagGroup(name="test", values=loc.values, label=false)>
		<cfset loc.compare = '<input id="test-cfml" name="test" type="checkbox" value="cfml" /><input id="test-css" name="test" type="checkbox" value="css" /><input id="test-html" name="test" type="checkbox" value="html" /><input id="test-js" name="test" type="checkbox" value="js" />'>
		<cfset assert('loc.result EQ loc.compare')>
	</cffunction>

	<cffunction name="test_checkBoxTagGroup_one_checked">
		<cfset loc.result = loc.controller.checkBoxTagGroup(name="test", values=loc.values, checkedValues="js", label=false)>
		<cfset loc.compare = '<input id="test-cfml" name="test" type="checkbox" value="cfml" /><input id="test-css" name="test" type="checkbox" value="css" /><input id="test-html" name="test" type="checkbox" value="html" /><input checked="checked" id="test-js" name="test" type="checkbox" value="js" />'>
		<cfset assert('loc.result EQ loc.compare')>
	</cffunction>

	<cffunction name="test_checkBoxTagGroup_multiple_checked">
		<cfset loc.result = loc.controller.checkBoxTagGroup(name="test", values=loc.values, checkedValues="cfml,css,js", label=false)>
		<cfset loc.compare = '<input checked="checked" id="test-cfml" name="test" type="checkbox" value="cfml" /><input checked="checked" id="test-css" name="test" type="checkbox" value="css" /><input id="test-html" name="test" type="checkbox" value="html" /><input checked="checked" id="test-js" name="test" type="checkbox" value="js" />'>
		<cfset assert('loc.result EQ loc.compare')>
	</cffunction>

</cfcomponent>