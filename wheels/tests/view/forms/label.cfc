<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">
	<cfinclude template="/wheelsMapping/view/functions.cfm">

	<cffunction name="test_for_attribute_on_plain_helper">
		<cfset loc.result = checkBoxTag(name="the-name", label="The Label:")>
		<cfset loc.compare = '<label for="the-name-1">The Label:<input id="the-name-1" name="the-name" type="checkbox" value="1" /></label>'>
		<cfset assert('loc.result IS loc.compare')>
	</cffunction>

	<cffunction name="test_for_attribute_on_plain_helper_and_overriding_id">
		<cfset loc.result = checkBoxTag(name="the-name", label="The Label:", id="the-id")>
		<cfset loc.compare = '<label for="the-id">The Label:<input id="the-id" name="the-name" type="checkbox" value="1" /></label>'>
		<cfset assert('loc.result IS loc.compare')>
	</cffunction>

	<cffunction name="test_for_attribute_on_object_helper">
		<cfset tag = model("tag").findOne()>
		<cfset loc.result = textField(objectName="tag", property="name", label="The Label:")>
		<cfset loc.compare = '<label for="tag-name">The Label:<input id="tag-name" maxlength="50" name="tag[name]" type="text" value="releases" /></label>'>
		<cfset assert('loc.result IS loc.compare')>
	</cffunction>

	<cffunction name="test_for_attribute_on_object_helper_and_overriding_id">
		<cfset tag = model("tag").findOne()>
		<cfset loc.result = textField(objectName="tag", property="name", label="The Label:", id="the-id")>
		<cfset loc.compare = '<label for="the-id">The Label:<input id="the-id" maxlength="50" name="tag[name]" type="text" value="releases" /></label>'>
		<cfset assert('loc.result IS loc.compare')>
	</cffunction>

</cfcomponent>