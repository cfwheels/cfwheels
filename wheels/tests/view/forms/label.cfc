<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/view/functions.cfm">

	<!--- plain helpers --->
	
	<cffunction name="test_for_custom_label_on_plain_helper">
		<cfset loc.actual = checkBoxTag(name="the-name", label="The Label:")>
		<cfset loc.expected = '<label for="the-name-1">The Label:<input id="the-name-1" name="the-name" type="checkbox" value="1" /></label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>

	<cffunction name="test_for_custom_label_on_plain_helper_and_overriding_id">
		<cfset loc.actual = checkBoxTag(name="the-name", label="The Label:", id="the-id")>
		<cfset loc.expected = '<label for="the-id">The Label:<input id="the-id" name="the-name" type="checkbox" value="1" /></label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>

	<cffunction name="test_for_blank_label_on_plain_helper">
		<cfset loc.actual = textFieldTag(name="the-name", label="")>
		<cfset loc.expected = '<input id="the-name" name="the-name" type="text" value="" />'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>


	<!--- object based helpers --->

	<cffunction name="test_for_custom_label_on_object_helper">
		<cfset tag = model("tag").findOne()>
		<cfset loc.actual = textField(objectName="tag", property="name", label="The Label:")>
		<cfset loc.expected = '<label for="tag-name">The Label:<input id="tag-name" maxlength="50" name="tag[name]" type="text" value="releases" /></label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>

	<cffunction name="test_for_custom_label_on_object_helper_and_overriding_id">
		<cfset tag = model("tag").findOne()>
		<cfset loc.actual = textField(objectName="tag", property="name", label="The Label:", id="the-id")>
		<cfset loc.expected = '<label for="the-id">The Label:<input id="the-id" maxlength="50" name="tag[name]" type="text" value="releases" /></label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>

	<cffunction name="test_for_blank_label_on_object_helper">
		<cfset tag = model("tag").findOne()>
		<cfset loc.actual = textField(objectName="tag", property="name", label="")>
		<cfset loc.expected = '<input id="tag-name" maxlength="50" name="tag[name]" type="text" value="releases" />'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>
	
	<cffunction name="test_for_automatic_label_on_object_helper_with_around_placement">
		<cfset tag = model("tag").findOne()>
		<cfset loc.actual = textField(objectName="tag", property="name", labelPlacement="around")>
		<cfset loc.expected = '<label for="tag-name">Name<input id="tag-name" maxlength="50" name="tag[name]" type="text" value="releases" /></label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>	

	<cffunction name="test_for_automatic_label_on_object_helper_with_before_placement">
		<cfset tag = model("tag").findOne()>
		<cfset loc.actual = textField(objectName="tag", property="name", labelPlacement="before")>
		<cfset loc.expected = '<label for="tag-name">Name</label><input id="tag-name" maxlength="50" name="tag[name]" type="text" value="releases" />'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>

	<cffunction name="test_for_automatic_label_on_object_helper_with_after_placement">
		<cfset tag = model("tag").findOne()>
		<cfset loc.actual = textField(objectName="tag", property="name", labelPlacement="after")>
		<cfset loc.expected = '<input id="tag-name" maxlength="50" name="tag[name]" type="text" value="releases" /><label for="tag-name">Name</label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>	

</cfcomponent>