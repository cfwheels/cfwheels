component extends="wheels.tests.Test" {

	include "/wheels/view/functions.cfm";

	function setup() {
		set(functionName="checkBoxTag", encode=false);
		set(functionName="textField", encode=false);
		set(functionName="textFieldTag", encode=false);
	}

	function teardown() {
		set(functionName="checkBoxTag", encode=true);
		set(functionName="textField", encode=true);
		set(functionName="textFieldTag", encode=true);
	}

	/* plain helpers */

	function test_label_to_the_left() {
		actual = checkBoxTag(name="the-name", label="The Label:");
		expected = '<label for="the-name-1">The Label:<input id="the-name-1" name="the-name" type="checkbox" value="1"></label>';
		assert('actual eq expected');
		actual = checkBoxTag(name="the-name", label="The Label:", labelPlacement="around");
		assert('actual eq expected');
		actual = checkBoxTag(name="the-name", label="The Label:", labelPlacement="aroundLeft");
		assert('actual eq expected');
	}

	function test_label_to_the_right() {
		actual = checkBoxTag(name="the-name", label="The Label", labelPlacement="aroundRight");
		expected = '<label for="the-name-1"><input id="the-name-1" name="the-name" type="checkbox" value="1">The Label</label>';
		assert('actual eq expected');
	}

	function test_custom_label_on_plain_helper() {
		actual = checkBoxTag(name="the-name", label="The Label:");
		expected = '<label for="the-name-1">The Label:<input id="the-name-1" name="the-name" type="checkbox" value="1"></label>';
		assert('actual eq expected');
	}

	function test_custom_label_on_plain_helper_and_overriding_id() {
		actual = checkBoxTag(name="the-name", label="The Label:", id="the-id");
		expected = '<label for="the-id">The Label:<input id="the-id" name="the-name" type="checkbox" value="1"></label>';
		assert('actual eq expected');
	}

	function test_blank_label_on_plain_helper() {
		actual = textFieldTag(name="the-name", label="");
		expected = '<input id="the-name" name="the-name" type="text" value="">';
		assert('actual eq expected');
	}


	/* object based helpers */

	function test_custom_label_on_object_helper() {
		tag = model("tag").findOne(order="id");
		actual = textField(objectName="tag", property="name", label="The Label:");
		expected = '<label for="tag-name">The Label:<input id="tag-name" maxlength="50" name="tag[name]" type="text" value="releases"></label>';
		assert('actual eq expected');
	}

	function test_custom_label_on_object_helper_and_overriding_id() {
		tag = model("tag").findOne(order="id");
		actual = textField(objectName="tag", property="name", label="The Label:", id="the-id");
		expected = '<label for="the-id">The Label:<input id="the-id" maxlength="50" name="tag[name]" type="text" value="releases"></label>';
		assert('actual eq expected');
	}

	function test_blank_label_on_object_helper() {
		tag = model("tag").findOne(order="id");
		actual = textField(objectName="tag", property="name", label="");
		expected = '<input id="tag-name" maxlength="50" name="tag[name]" type="text" value="releases">';
		assert('actual eq expected');
	}

	function test_automatic_label_on_object_helper_with_around_placement() {
		tag = model("tag").findOne(order="id");
		actual = textField(objectName="tag", property="name", labelPlacement="around");
		expected = '<label for="tag-name">Tag name<input id="tag-name" maxlength="50" name="tag[name]" type="text" value="releases"></label>';
		assert('actual eq expected');
	}

	function test_automatic_label_on_object_helper_with_before_placement() {
		tag = model("tag").findOne(order="id");
		actual = textField(objectName="tag", property="name", labelPlacement="before");
		expected = '<label for="tag-name">Tag name</label><input id="tag-name" maxlength="50" name="tag[name]" type="text" value="releases">';
		assert('actual eq expected');
	}

	function test_automatic_label_on_object_helper_with_after_placement() {
		tag = model("tag").findOne(order="id");
		actual = textField(objectName="tag", property="name", labelPlacement="after");
		expected = '<input id="tag-name" maxlength="50" name="tag[name]" type="text" value="releases"><label for="tag-name">Tag name</label>';
		assert('actual eq expected');
	}

	function test_automatic_label_on_object_helper_with_non_persisted_property() {
		tag = model("tag").findOne(order="id");
		actual = textField(objectName="tag", property="virtual");
		expected = '<label for="tag-virtual">Virtual property<input id="tag-virtual" name="tag[virtual]" type="text" value=""></label>';
		assert('actual eq expected');
	}

	function test_automatic_label_in_error_message() {
		tag = Duplicate(model("tag").new()); /* use a deep copy so as not to affect the cached model */
		tag.validatesPresenceOf(property="name");
		tag.valid();
		errors = tag.errorsOn(property="name");
		assert('ArrayLen(errors) eq 1 and errors[1].message is "Tag name can''t be empty"');
	}

	function test_automatic_label_in_error_message_with_non_persisted_property() {
		tag = Duplicate(model("tag").new());
		tag.validatesPresenceOf(property="virtual");
		tag.valid();
		errors = tag.errorsOn(property="virtual");
		assert('ArrayLen(errors) eq 1 and errors[1].message is "Virtual property can''t be empty"');
	}

}
