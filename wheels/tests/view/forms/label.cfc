<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="/wheelsMapping/view/functions.cfm">

	<!--- plain helpers --->
	
	<cffunction name="test_label_to_the_left">
		<cfset loc.actual = checkBoxTag(name="the-name", label="The Label:")>
		<cfset loc.expected = '<label for="the-name-1">The Label:<input id="the-name-1" name="the-name" type="checkbox" value="1" /></label>'>
		<cfset assert('loc.actual eq loc.expected')>
		<cfset loc.actual = checkBoxTag(name="the-name", label="The Label:", labelPlacement="around")>
		<cfset assert('loc.actual eq loc.expected')>
		<cfset loc.actual = checkBoxTag(name="the-name", label="The Label:", labelPlacement="aroundLeft")>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>

	<cffunction name="test_label_to_the_right">
		<cfset loc.actual = checkBoxTag(name="the-name", label="The Label", labelPlacement="aroundRight")>
		<cfset loc.expected = '<label for="the-name-1"><input id="the-name-1" name="the-name" type="checkbox" value="1" />The Label</label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>

	<cffunction name="test_custom_label_on_plain_helper">
		<cfset loc.actual = checkBoxTag(name="the-name", label="The Label:")>
		<cfset loc.expected = '<label for="the-name-1">The Label:<input id="the-name-1" name="the-name" type="checkbox" value="1" /></label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>

	<cffunction name="test_custom_label_on_plain_helper_and_overriding_id">
		<cfset loc.actual = checkBoxTag(name="the-name", label="The Label:", id="the-id")>
		<cfset loc.expected = '<label for="the-id">The Label:<input id="the-id" name="the-name" type="checkbox" value="1" /></label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>

	<cffunction name="test_blank_label_on_plain_helper">
		<cfset loc.actual = textFieldTag(name="the-name", label=true)>
		<cfset loc.expected = '<label for="the-name"><input id="the-name" name="the-name" type="text" value="" /></label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>

	<cffunction name="test_no_label_on_plain_helper">
		<cfset loc.actual = textFieldTag(name="the-name", label="")>
		<cfset loc.expected = '<input id="the-name" name="the-name" type="text" value="" />'>
		<cfset assert('loc.actual eq loc.expected')>
		<cfset loc.actual = textFieldTag(name="the-name", label=false)>
		<cfset loc.expected = '<input id="the-name" name="the-name" type="text" value="" />'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>


	<!--- object based helpers --->

	<cffunction name="test_custom_label_on_object_helper">
		<cfset tag = model("tag").findOne(order="id")>
		<cfset loc.actual = textField(objectName="tag", property="name", label="The Label:")>
		<cfset loc.expected = '<label for="tag-name">The Label:<input id="tag-name" maxlength="50" name="tag[name]" type="text" value="releases" /></label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>

	<cffunction name="test_custom_label_on_object_helper_and_overriding_id">
		<cfset tag = model("tag").findOne(order="id")>
		<cfset loc.actual = textField(objectName="tag", property="name", label="The Label:", id="the-id")>
		<cfset loc.expected = '<label for="the-id">The Label:<input id="the-id" maxlength="50" name="tag[name]" type="text" value="releases" /></label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>

	<cffunction name="test_blank_label_on_object_helper">
		<cfset tag = model("tag").findOne(order="id")>
		<cfset loc.actual = textField(objectName="tag", property="name", label="")>
		<cfset loc.expected = '<input id="tag-name" maxlength="50" name="tag[name]" type="text" value="releases" />'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>
	
	<cffunction name="test_automatic_label_on_object_helper_with_around_placement">
		<cfset tag = model("tag").findOne(order="id")>
		<cfset loc.actual = textField(objectName="tag", property="name", labelPlacement="around")>
		<cfset loc.expected = '<label for="tag-name">Tag name<input id="tag-name" maxlength="50" name="tag[name]" type="text" value="releases" /></label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>	

	<cffunction name="test_automatic_label_on_object_helper_with_before_placement">
		<cfset tag = model("tag").findOne(order="id")>
		<cfset loc.actual = textField(objectName="tag", property="name", labelPlacement="before")>
		<cfset loc.expected = '<label for="tag-name">Tag name</label><input id="tag-name" maxlength="50" name="tag[name]" type="text" value="releases" />'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>

	<cffunction name="test_automatic_label_on_object_helper_with_after_placement">
		<cfset tag = model("tag").findOne(order="id")>
		<cfset loc.actual = textField(objectName="tag", property="name", labelPlacement="after")>
		<cfset loc.expected = '<input id="tag-name" maxlength="50" name="tag[name]" type="text" value="releases" /><label for="tag-name">Tag name</label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>	
	
	<cffunction name="test_automatic_label_on_object_helper_with_non_persisted_property">
		<cfset tag = model("tag").findOne(order="id")>
		<cfset loc.actual = textField(objectName="tag", property="virtual")>
		<cfset loc.expected = '<label for="tag-virtual">Virtual property<input id="tag-virtual" name="tag[virtual]" type="text" value="" /></label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>
	
	<cffunction name="test_automatic_label_in_error_message">
		<cfset tag = Duplicate(model("tag").new())> <!--- use a deep copy so as not to affect the cached model --->
		<cfset tag.validatesPresenceOf(property="name")>
		<cfset tag.valid()>
		<cfset loc.errors = tag.errorsOn(property="name")>
		<cfset assert('ArrayLen(loc.errors) eq 1 and loc.errors[1].message is "Tag name can''t be empty"')>
	</cffunction>
	
	<cffunction name="test_automatic_label_in_error_message_with_non_persisted_property">
		<cfset tag = Duplicate(model("tag").new())>
		<cfset tag.validatesPresenceOf(property="virtual")>
		<cfset tag.valid()>
		<cfset loc.errors = tag.errorsOn(property="virtual")>
		<cfset assert('ArrayLen(loc.errors) eq 1 and loc.errors[1].message is "Virtual property can''t be empty"')>
	</cffunction>
	
	<cffunction name="test_label_tag">
		<cfset tag = model("tag").findOne()>
		<cfset loc.actual = labelTag(for="tag", value="Virtual")>
		<cfset loc.expected = '<label for="tag">Virtual</label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>
	
	<cffunction name="test_label">
		<cfset tag = model("tag").findOne()>
		<cfset loc.actual = label(objectName="tag", property="name")>
		<cfset loc.expected = '<label for="tag-name">Tag name</label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>
	
	<cffunction name="test_label_attributes">
		<cfset tag = model("tag").findOne()>
		<cfset loc.actual = label(objectName="tag", property="name", class="blah")>
		<cfset loc.expected = '<label class="blah" for="tag-name">Tag name</label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>
	
	<cffunction name="test_make_sure_that_labels_respect_case">
		<cfset author = model("author").findOne()>
		<cfset loc.actual = label(objectName="author", property="firstname")>
		<cfset loc.expected = '<label for="author-firstname">First Name(s)</label>'>
		<cfset assert('loc.actual eq loc.expected')>
		<cfset loc.actual = label(objectName="author", property="lastname")>
		<cfset loc.expected = '<label for="author-lastname">Last name</label>'>
		<cfset assert('loc.actual eq loc.expected')>
	</cffunction>
	
</cfcomponent>